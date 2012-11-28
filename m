Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2K1Ilg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:41:36 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33184 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2K1Ile (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:41:34 -0500
Message-ID: <1354092082.3054.19.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: 3.7-rc7: BUG: MAX_STACK_TRACE_ENTRIES too low!
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org
Date: Wed, 28 Nov 2012 16:41:22 +0800
In-Reply-To: <alpine.DEB.2.01.1211271916160.7378@trent.utfs.org>
References: <alpine.DEB.2.01.1211271824120.7378@trent.utfs.org>
	 <alpine.DEB.2.01.1211271916160.7378@trent.utfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12112808-2000-0000-0000-00000A0BF997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 19:22 -0800, Christian Kujau wrote:
> On Tue, 27 Nov 2012 at 19:06, Christian Kujau wrote:
> > the same thing[0] happened again in 3.7-rc7, after ~20h uptime:
> 
> I found the following on patchwork, but this seems to deal with powerpc64 
> only, while this PowerBook G4 of mine is powerpc32:
> 
>   http://patchwork.ozlabs.org/patch/193414/
> 
> It looks related, but then again, I fail to parse assember...

Hi Christian, 

Would you please help to try the following fix? I don't have a powerpc32
machine for test...

Thanks, Zhong

==============================================
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 9499385..cadebfd 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -439,6 +439,8 @@ ret_from_fork:
 ret_from_kernel_thread:
 	REST_NVGPRS(r1)
 	bl	schedule_tail
+	li	r3,0
+	stw	r3,0(r1)
 	mtlr	r14
 	mr	r3,r15
 	PPC440EP_ERR42
==============================================

> 
> Christian.
> 
> > [40007.339487] [sched_delayed] sched: RT throttling activated
> > [69731.388717] BUG: MAX_STACK_TRACE_ENTRIES too low!
> > [69731.390371] turning off the locking correctness validator.
> > [69731.391942] Call Trace:
> > [69731.393525] [c9a61c10] [c0009064] show_stack+0x70/0x1bc (unreliable)
> > [69731.395152] [c9a61c50] [c0077460] save_trace+0xfc/0x114
> > [69731.396735] [c9a61c60] [c007be20] __lock_acquire+0x1568/0x19b8
> > [69731.398296] [c9a61d00] [c007c2c0] lock_acquire+0x50/0x70
> > [69731.399857] [c9a61d20] [c0550e28] _raw_spin_lock_irq+0x5c/0x78
> > [69731.401419] [c9a61d40] [c054fb58] __schedule+0xd8/0x534
> > [69731.402972] [c9a61da0] [c0550094] _cond_resched+0x50/0x68
> > [69731.404527] [c9a61db0] [c0479908] dst_gc_task+0xbc/0x258
> > [69731.406070] [c9a61e40] [c004eeb8] process_one_work+0x1f4/0x49c
> > [69731.407585] [c9a61e80] [c004f644] worker_thread+0x14c/0x400
> > [69731.409075] [c9a61eb0] [c0057634] kthread+0xbc/0xc0
> > [69731.410521] [c9a61f40] [c0011ad4] ret_from_kernel_thread+0x5c/0x64
> > [...repeated 54 times...]
> > 
> > Anyone knows what this is about?
> > 
> > Thanks,
> > Christian.
> > 
> > [0] http://lkml.indiana.edu/hypermail/linux/kernel/1211.0/03025.html


