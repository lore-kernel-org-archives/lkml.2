Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1HSSUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 14:20:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab1HSSUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 14:20:11 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=aKKvsJ_FXZsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=zTRFPHxZr17IY7xQE4AA:9 a=KuQYQUEAPkiVNIDZ9LkA:7 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] x86: jump_label: arch_jump_label_text_poke_early: add
 missing __init
From: Steven Rostedt <rostedt@goodmis.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: jbaron@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1313539478-30303-1-git-send-email-kjwinchester@gmail.com>
References: <1313539478-30303-1-git-send-email-kjwinchester@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 19 Aug 2011 14:20:07 -0400
Message-ID: <1313778007.15704.106.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 21:04 -0300, Kevin Winchester wrote:
> arch_jump_label_text_poke_early calls text_poke_early, which is
> an __init function.  Thus arch_jump_label_text_poke_early should
> be the same.

but text_poke_early is not __init but instead __init_or_module. Your
patch just caused this bug:

                Welcome to Fedora 
                Press 'I' to enter interactive startup.^M
Starting udev: kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffffff81de7b5d
IP: [<ffffffff81de7b5d>] native_init_IRQ+0x352/0x352
PGD 1c06067 PUD 1c0a063 PMD 78520063 PTE 8000000001de7163
Oops: 0011 [#1] PREEMPT SMP 
CPU 0 
Modules linked in: snd_page_alloc

Pid: 943, comm: modprobe Not tainted 3.1.0-rc1-test+ #3                  /DG965MQ
RIP: 0010:[<ffffffff81de7b5d>]  [<ffffffff81de7b5d>] native_init_IRQ+0x352/0x352^M
RSP: 0018:ffff880077187dd0  EFLAGS: 00010296
RAX: 0000000000000000 RBX: ffffffffa0012700 RCX: ffff88007e200000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffffa00080e1
RBP: ffff880077187de8 R08: 0000000000000005 R09: 0000000000000008
R10: 0000000000000002 R11: ffffc90019853060 R12: ffffffffa0012748
R13: ffffc90019800000 R14: ffffc900198530e0 R15: ffffc900198524a0
FS:  00007fb2d8111700(0000) GS:ffff88007e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffff81de7b5d CR3: 0000000077154000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 943, threadinfo ffff880077186000, task ffff880077188000)
Stack:
 ffffffff81076a25 ffffc900198527e0 ffffc90019852420 ffff880077187e58
 ffffffff8102d76f 00001fffe0000000 0000000000000000 ffffc900198529e0
 ffffc90019852247 ffffffffa0012750 ffffc90019852250 ffffffffa0012768
Call Trace:
 [<ffffffff81076a25>] ? jump_label_apply_nops+0x34/0x3e
 [<ffffffff8102d76f>] module_finalize+0x14c/0x15d
 [<ffffffff8108dd8c>] load_module+0xf92/0x183a
 [<ffffffff8108e684>] sys_init_module+0x50/0x1f0
 [<ffffffff817f3d02>] system_call_fastpath+0x16/0x1b
Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
 00 00 00 00 00 00 bf 82 dd 92 00 00 00 00 00 00 00 00 00 00 ^M
RIP  [<ffffffff81de7b5d>] native_init_IRQ+0x352/0x352


I'll update it to __init_or_module and see if that fixes things.

Thanks,

-- Steve

> 
> Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
> ---
>  arch/x86/kernel/jump_label.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 3fee346..5b3dbf7 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -42,7 +42,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  	put_online_cpus();
>  }
>  
> -void arch_jump_label_text_poke_early(jump_label_t addr)
> +void __init arch_jump_label_text_poke_early(jump_label_t addr)
>  {
>  	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
>  			JUMP_LABEL_NOP_SIZE);


