Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab1LFIIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 03:08:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43140 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989Ab1LFIIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 03:08:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EDDCD6D.1010907@jp.fujitsu.com>
Date: Tue, 06 Dec 2011 17:08:13 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI fixes
References: <20111123144417.2da5958c@jbarnes-desktop> <CA+55aFyaiJBYmgVCLfPA7q3hqtPHYh9wwsmVTCewbBoxMsDE8A@mail.gmail.com> <20111205112256.68e59434@jbarnes-desktop>
In-Reply-To: <20111205112256.68e59434@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/06 4:22), Jesse Barnes wrote:
> On Wed, 23 Nov 2011 15:02:01 -0800
> Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>> On Wed, Nov 23, 2011 at 2:44 PM, Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>>>
>>> Nothing too exciting this time, mostly some minor fixes for things
>>> normal people don't really hit.  Happy Thanksgiving.
>>
>> Ugh. This looks bogus:
>>
>>> Kenji Kaneshige (2):
>>>       PCI: pciehp: wait 1000 ms before Link Training check
>>
>> Look at that patch more closely. After the patch, the code looks like this:
>>
>>
>>           if (ctrl->link_active_reporting)
>>                   pcie_wait_link_active(ctrl);
>>           else
>>                   msleep(1000);
>>
>> +	/*
>> +	 * Need to wait for 1000 ms after Data Link Layer Link Active
>> +	 * (DLLLA) bit reads 1b before sending configuration request.
>> +	 * We need it before checking Link Training (LT) bit becuase
>> +	 * LT is still set even after DLLLA bit is set on some platform.
>> +	 */
>> +	msleep(1000);
>>
>> and I'm pretty sure you should remove the "else msleep(1000)" there.
>> Doing the 1s wait *twice* seems entirely bogus, even if you are
>> missing link_active_reporting. No?
>>
>> I pulled it since I can't test it, but it really smells fishy to me.
>
> Sure looks like it... Kenji-san, you went back and forth on this one a
> little, can you confirm (and preferably test)?
>
> Thanks,

I'm very sorry for the long delay.

Each 1000 ms wait has defferent meaning. But as Linus pointed out, the
first one ("else msleep(1000)") can be removed. I'll work on this.
Though the patch is not clean, I tested it from the regression point of
view. And Yinghai also confirmed it fix his problem.

Here are explanation for each 1000 ms with history.

>>           if (ctrl->link_active_reporting)
>>                   pcie_wait_link_active(ctrl);
>>           else
>>                   msleep(1000);

This chunk is to wait for Link Active. After PCIe specification 1.1,
downstream port with hotplug slots needs to support link active reporting.
But older specification PCIe 1.0a doesn't have link active reporting. The
"else msleep(1000)" is for PCIe 1.0a. It wait for 1 sec instead of polling
data link layer link active bit. In PCIe 1.0a spec, the bit corresponding
to the data link layer link active bit in PCIe 1.1 or later is defined
reserved zero. So as Linus pointed out, we can remove "else msleep(1000)".
The reason why I added "if (crtl->link_active_reporting)" here was that I
didn't want to change the behavior for old hot-plug controller (PCIe 1.0a),
but I think it was too much.

>> +	/*
>> +	 * Need to wait for 1000 ms after Data Link Layer Link Active
>> +	 * (DLLLA) bit reads 1b before sending configuration request.
>> +	 * We need it before checking Link Training (LT) bit becuase
>> +	 * LT is still set even after DLLLA bit is set on some platform.
>> +	 */
>> +	msleep(1000);

In the past, pciehp waits 100 ms instead of 1 sec after checking the link
state. This 100 ms was based on PCIe spec. But we encountered the problem
that configuration access to some HBA card doesn't return the proper value.
To fix this problem, we replaced this 100 ms wait with 1 sec wait. This is
based on the PCIe description "software must allow 1 second after the Data
Link Layer Link Active bit reads 1b before it is permitted to determine
that a hot plugged device which fails to return a Successful Completion for
a Valid Configuration Request is a broken device". Then, another problem
was reported by Yinghai Lu. The problem is that LT bit is still set even
after DLLLA bit is set on his platform. To fix the problem 1 sec wait was
moved to before LT check, which was placed after LT check.

Regards,
Kenji Kaneshige
