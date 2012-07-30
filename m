Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2G3VBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:01:20 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58094 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2G3VBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:01:19 -0400
Message-ID: <5016F5CD.4080508@us.ibm.com>
Date: Mon, 30 Jul 2012 13:59:57 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhouping Liu <zliu@redhat.com>
Subject: Re: boot panic regression introduced in 3.5-rc7
References: <1971950954.1278169.1343620316300.JavaMail.root@redhat.com>
In-Reply-To: <1971950954.1278169.1343620316300.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073021-7606-0000-0000-0000026CB5D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2012 08:51 PM, CAI Qian wrote:
> The bisecting pointed out this patch caused one of dell servers boot panic.
>
>    5baefd6d84163443215f4a99f6a20f054ef11236
>    hrtimer: Update hrtimer base offsets each hrtimer_interrupt
>
> [    2.971092] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x10a/0x120()
> [    2.971092] Hardware name: PowerEdge M605
> [    2.971092] Modules linked in:
Looking at the dmesg:

[    0.000000] Extended CMOS year: 8200


I'm working with Prarit to try to debug the issue on the affected 
machine. He noticed part of the problem is that the offs_real was set 
to  0x7FFFFFFFFFFFFFFF, which is the same as KTIME_MAX.

I suspect from the dmesg above we're getting bad data from the CMOS 
clock, and that's then causing an overflow converting to a ktime_t 
(64bits of nanoseconds can only hold ~584 years).

I've still not quite narrowed down why this hasn't bit you earlier, 
since the same wall_to_monotonic -> ktime conversion was done in 
retrigger_next_event before the change.  Maybe something called 
settimeofday(), fixing crazy time value before you switched to highres mode?

Once I sort out this last question,  I'll try to see where we can add 
some sanity checking for this sort of thing.

thanks
-john

