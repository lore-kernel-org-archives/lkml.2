Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2JZNUG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:20:06 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1262 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab2JZNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:20:05 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <508A8DF9.4080607@broadcom.com>
Date: Fri, 26 Oct 2012 15:19:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Peter Zijlstra" <peterz@infradead.org>
cc: "Ingo Molnar" <mingo@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep info message
References: <508A62DC.50805@broadcom.com>
 <1351250734.16863.26.camel@twins>
In-Reply-To: <1351250734.16863.26.camel@twins>
X-WSS-ID: 7C94521A3OW10681275-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 01:25 PM, Peter Zijlstra wrote:
> On Fri, 2012-10-26 at 12:15 +0200, Arend van Spriel wrote:
>> Hi Peter and/or Ingo,
>>
>> I am working on a driver (brcmfmac) and when unloading it or unplugging
>> the device I get this info message (see below) upon calling
>> cancel_work_sync(). Just wondering if there is something I need to do in
>> the driver or should it be done in workqueue code.
>
> Your driver, as that's the one allocating the struct work_struct thingy.
>
> You've either failed to use INIT_WORK() or need to use
> INIT_WORK_ONSTACK() if that's appropriate. It looks like you could have
> used DECLARE*_WORK inside a function or something similar.
>
> Anyway, without the driver code present I can't really say much more.
>

I assume INIT_WORK_ONSTACK() can only be used when scheduling process 
waits for the work to complete. The work_struct is located inside a 
driver structure that is allocated upon device probe.

struct brcmf_fweh_info {
	struct work_struct event_work;
};

and it is initialized in that context using:

	INIT_WORK(&fweh->event_work, brcmf_fweh_event_worker);

and used in another context:

	schedule_work(&fweh->event_work);

When cleaning up I do:

	cancel_work_sync(&fweh->event_work);

I can also submit the patch with the entire code as RFC if you do not 
object digging through a couple of hundred lines.

Gr. AvS

