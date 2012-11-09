Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2KIBMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:12:06 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:57690 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab2KIBME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:12:04 -0500
Date: Thu, 8 Nov 2012 17:11:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Cyberman Wu <cypher.w@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is this a kernel bug?
Message-ID: <20121109011158.GE9672@htj.dyndns.org>
References: <CADCVGbSC-T=W08xcf9rDynS8Uf9yq=KKTNUn33g-O_FqyQkU_A@mail.gmail.com>
 <20121107162840.GA2660@mtj.dyndns.org>
 <CADCVGbR-39diiMA-C2cEn315r916HMprt6Lx4s8qN8jHC_e8FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADCVGbR-39diiMA-C2cEn315r916HMprt6Lx4s8qN8jHC_e8FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 09, 2012 at 08:53:49AM +0800, Cyberman Wu wrote:
> A lot of these message on many CPU:

What I'm really curious about is the *first* exception.

Is the following the first one?  Some lines (why the stackdump is
happening) are missing at the top.

>  Pid: 906, comm:         kworker/16:1, CPU: 16
...
>  pc : 0xfffffff7002fc488 ex1: 1     faultnum: 17
> 
> Starting stack dump of tid 906, pid 906 (kworker/16:1) on cpu 16 at
> cycle 416925425702833
>   frame 0: 0xfffffff7002fc488 worker_enter_idle+0x1c8/0x2e8 (sp
> 0xfffffe00f9fbfe78)
>   frame 1: 0xfffffff7002750c8 worker_thread+0x4c8/0x898 (sp 0xfffffe00f9fbfea0)
>   frame 2: 0xfffffff7000f0530 kthread+0xe0/0xe8 (sp 0xfffffe00f9fbff80)
>   frame 3: 0xfffffff7000bab38 start_kernel_thread+0x18/0x20 (sp

Is it triggering one of BUG_ON() in worker_enter_idle()?  Can you map
the pc to the source line number using addr2line?

> The first exception is platform specific and should be a hardware error:
> fffffff7002fc480:       180906cfc0128d82        { addi r2, sp, 40 ;
> addi r31, sp, 32 }
> fffffff7002fc488:       87b886ca04218d95        { addi r21, sp, 24 ;
> addi r20, sp, 16 ; ld lr, r2 }
> While 'ld lr, r2' executed, r2 should be sp+40, but it value is 2.
> I've analysis the execute
> snap shot and:
> 1. r2 should be 2 before 'addi r2, sp, 40' executed.
> 2. r0's value is sp+40 when exception ocurred, but it shouldn't be
> that value following
>     executing flow in that function.
> So it seems while 'addi r2, sp 40' be executed, what it really
> executed is 'addi r0, sp, 40',
> maybe the instruction was load with a bit reverted for memory error,
> or cache error or
> problem of CPU? I'm not sure since it never occurred again.

So, the first exception wasn't a software bug?

> What I thought maybe a kernel bug is that second exception. I've
> simulated it try to
> generate a exception in kworker, and it occurred again. Then I checked
> the code and

After a fatal exception in kernel space, nothing is guaranteed to
work.  It's usually in the realm of "if it limps along, great;
otherwise, too bad", so it isn't really a bug.  There are only so many
things you can do after a program segfaults after all.  That said, it
might be a good idea to clear PF_WQ_WORKER from do_exit() so that at
least we can avoid oops from irq context after a work item messes up.

Thanks.

-- 
tejun
