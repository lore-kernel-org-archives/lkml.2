Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1JKORM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:17:12 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:51783 "EHLO
	homiemail-a40.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753496Ab1JKORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=HuAZPcR4Lvz9y5DYx3vxRGmAjPzWd0ugdGSbeQOe9O4WazkJxY95H9vdHfXN7
	Y7gFD4wnpQIw98PyHvl5yDfzOkKOOQr92qs3/W9MpRCw83I8zIIifVMwnBsPsRHV
	AYWVBr8frAwiRECtBebC05Hp5N7nXy6N13qFa2/Of9hyA0=
Message-ID: <4E944FD1.8030302@shealevy.com>
Date: Tue, 11 Oct 2011 10:16:49 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alban Crequy <alban.crequy@collabora.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, netdev@vger.kernel.org
Subject: Re: Hang with "runaway loop modprobe net-pf-1" on Linux 3.0.4
References: <7ca3debde28dcc206c1f6f787df5c619.squirrel@webmail.shealevy.com> <4E877A22.6070605@shealevy.com>
In-Reply-To: <4E877A22.6070605@shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/11 4:37 PM, Shea Levy wrote:
> On 09/29/2011 08:38 AM, shea@shealevy.com wrote:
>> Hello,
>>
>> My initrd mounts /proc and /sys, puts a tmpfs at /dev, then loads 
>> ext4. On
>> 2.6.39 (and earlier), this works fine and the initrd init continues
>> happily. On 3.0.4, however, the kernel spits out
>>
>>> request_module: runaway loop modprobe net-pf-1
>> a few times then hangs. If I drop into a shell before loading ext4 
>> and run
>> modprobe unix, the same problem occurs. The modprobe used is dynamically
>> linked with glibc (which is included in the initrd), and it is the same
>> modprobe on the working and non-working systems. From my searches, it
>> appears that CONFIG_UNIX=y instead of =m would probably solve this
>> problem, but I'd rather keep it as a module if it's possible to get it
>> working. What's going wrong here? Why does it work on 2.6.39 but not
>> 3.0.4?
>>
>> Regards,
>> Shea Levy
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> CC'ing af_unix.c maintainers. Also, I had the same problem with 3.0.
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
This ended up being a problem with how my distro builds its initrd, 
sorry for the noise.

For the curious: The problem had to do with moving the depmod logic out 
of the main Makefile and into scripts/depmod.sh. My distro doesn't use a 
single global directory for all modules, so we needed to remove the '-b 
"$INSTALL_MOD_PATH"' from the depmod command that's run after module 
installation. We did this with a sed on the Makefile, which was a noop 
once that code was moved into a different file.
