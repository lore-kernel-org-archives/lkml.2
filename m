Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1FEObg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:31:36 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:20407 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1FEObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:31:35 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DEB933C.1070900@die-jansens.de>
Date: Sun, 05 Jun 2011 16:31:24 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <20110605081747.GA17920@elte.hu> <4DEB4FA7.3050400@die-jansens.de> <20110605095555.GA22058@elte.hu> <4DEB58D8.4000805@die-jansens.de> <20110605110132.GB23463@elte.hu> <20110605111933.GA24592@elte.hu> <20110605113627.GA25724@elte.hu> <4DEB6F3A.3000109@die-jansens.de> <20110605133958.GA27812@elte.hu> <4DEB8A93.30601@die-jansens.de> <20110605141003.GB29338@elte.hu>
In-Reply-To: <20110605141003.GB29338@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 16:10, Ingo Molnar wrote:
>
> * Arne Jansen<lists@die-jansens.de>  wrote:
>
>> Here we go:
>>
>> http://eischnee.de/lockup.txt
>>
>> Now it's your turn :)
>
> So the lockup is in:
>
>   [<ffffffff813af2d9>] do_raw_spin_lock+0x129/0x170
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff8185ce71>] _raw_spin_lock+0x51/0x70
>   [<ffffffff81092df6>] ? vprintk+0x76/0x4a0
>   [<ffffffff81092df6>] vprintk+0x76/0x4a0
>   [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff81859e19>] printk+0x63/0x65
>   [<ffffffff8108a4bd>] ? try_to_wake_up+0x29d/0x350
>   [<ffffffff81091f98>] warn_slowpath_common+0x38/0xb0
>   [<ffffffff81092025>] warn_slowpath_null+0x15/0x20
>   [<ffffffff8108a4bd>] try_to_wake_up+0x29d/0x350
>   [<ffffffff8108a5a0>] wake_up_process+0x10/0x20
>   [<ffffffff8185c071>] __up+0x41/0x50
>   [<ffffffff810b937c>] up+0x3c/0x50
>   [<ffffffff81092a36>] console_unlock+0x1a6/0x200
>   [<ffffffff81092f86>] vprintk+0x206/0x4a0
>   [<ffffffff810c5f8d>] ? trace_hardirqs_off+0xd/0x10
>   [<ffffffff810ba6db>] ? local_clock+0x4b/0x60
>   [<ffffffffa0012000>] ? 0xffffffffa0011fff
>   [<ffffffff81859e19>] printk+0x63/0x65
>   [<ffffffffa001201d>] test_init+0x1d/0x2b [test]
>   [<ffffffff810001ce>] do_one_initcall+0x3e/0x170
>
> Somehow we end up generating a WARN_ON() within a printk()'s
> try_to_wake_up() and predictably we lock up on that ...
>
> Peter?
>
> Arne, mind helping a bit with:
>
>   [<ffffffff81091f98>] warn_slowpath_common+0x38/0xb0
>   [<ffffffff81092025>] warn_slowpath_null+0x15/0x20
>   [<ffffffff8108a4bd>] try_to_wake_up+0x29d/0x350
>
> which WARN_ON() does that correspond to in try_to_wake_up()?

(gdb) info line *0xffffffff8108a4bd
Line 934 of "kernel/sched.c" starts at address 0xffffffff8108a498 
<try_to_wake_up+632> and ends at 0xffffffff8108a4c8 <try_to_wake_up+680>.

sched.c:934: in function __task_rq_lock
         lockdep_assert_held(&p->pi_lock);

I'm currently testing on commit 0122ec5b02f766c355b3168d.

-Arne

>
> Thanks,
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

