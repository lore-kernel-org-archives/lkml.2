Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2DRTg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:36:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2DRTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:36:25 -0400
Date: Wed, 18 Apr 2012 21:36:20 +0200
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: jbd: NULL dereference on chown()
Message-ID: <20120418193620.GA3059@quack.suse.cz>
References: <1334762158.5922.3.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334762158.5922.3.camel@lappy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Wed 18-04-12 17:15:58, Sasha Levin wrote:
> I've stumbled on the following after some fuzzing inside a KVM guest,
> guest was running -next from today:
  Something really strange must have happened in your system. Instructions
preceeding the faulting one look like (I've added some annotation):
  15:	f0 80 4b 01 40       	lock orb $0x40,0x1(%rbx)
	set_buffer_jbd(bh);
  1a:	4c 89 7b 40          	mov    %r15,0x40(%rbx)
	bh->b_private = jh;
  1e:	49 89 1f             	mov    %rbx,(%r15)
	jh->b_bh = bh;
  21:	f0 ff 43 60          	lock incl 0x60(%rbx)
	get_bh(bh);
  25:	4c 89 f8             	mov    %r15,%rax
  28:	45 31 ff             	xor    %r15d,%r15d
  2b:*	ff 40 08             	incl   0x8(%rax)     <-- trapping instruction
	jh->b_jcount++;

RAX at the moment of the fault is 0 (and also r15 from which we got the
value is 0). The relevant chunk of the function looks like:
        jbd_lock_bh_journal_head(bh);
        if (buffer_jbd(bh)) {
                jh = bh2jh(bh);
        } else {
                J_ASSERT_BH(bh,
                        (atomic_read(&bh->b_count) > 0) ||
                        (bh->b_page && bh->b_page->mapping));

                if (!new_jh) {
                        jbd_unlock_bh_journal_head(bh);
                        goto repeat;
                }

                jh = new_jh;
                new_jh = NULL;          /* We consumed it */
                set_buffer_jbd(bh);
                bh->b_private = jh;
                jh->b_bh = bh;
                get_bh(bh);
                BUFFER_TRACE(bh, "added journal_head");
        }
        jh->b_jcount++;
        jbd_unlock_bh_journal_head(bh);

So we apparently saw buffer_jbd(), went through jh = bh2jh(bh) and oopsed
on jh->b_jcount++. But I don't see how buffer_jbd() with bh->b_private == NULL
can happen - we set and clear both together under bh_journal_head() lock.
So either it was some random memory corruption or something really strange.
But I'm afraid that unless you are able to reproduce the problem, I'm
unable to debug this...

									Honza

> [   73.117530] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [   73.117534] IP: [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
> [   73.117543] PGD 32327067 PUD 33d32067 PMD 0 
> [   73.117548] Oops: 0002 [#1] PREEMPT SMP 
> [   73.117551] CPU 3 
> [   73.117555] Pid: 6964, comm: trinity Tainted: G        W    3.4.0-rc3-next-20120418-sasha-dirty #85  
> [   73.117559] RIP: 0010:[<ffffffff81313a5e>]  [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
> [   73.117563] RSP: 0018:ffff880032195cf8  EFLAGS: 00010202
> [   73.117565] RAX: 0000000000000000 RBX: ffff88003d0026c0 RCX: 0000000000000000
> [   73.117568] RDX: 0000000000000000 RSI: ffff88003d0026c0 RDI: ffffffff8130cc6c
> [   73.117570] RBP: ffff880032195d28 R08: 0000000000000000 R09: 0000000000000000
> [   73.117572] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880032194000
> [   73.117574] R13: 000000000000000e R14: ffff880032194000 R15: 0000000000000000
> [   73.117577] FS:  00007f7615d4b700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
> [   73.117580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   73.117582] CR2: 0000000000000008 CR3: 0000000031bb0000 CR4: 00000000000406e0
> [   73.117590] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   73.117596] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   73.117598] Process trinity (pid: 6964, threadinfo ffff880032194000, task ffff880033cf8000)
> [   73.117600] Stack:
> [   73.117602]  00000000000003ff ffffffff82848140 ffff880035026000 ffff880035026000
> [   73.117606]  0000000000000000 ffff880035026000 ffff880032195d48 ffffffff8130cc6c
> [   73.117611]  ffffffff82848140 ffff88003d0026c0 ffff880032195d88 ffffffff812c5278
> [   73.117615] Call Trace:
> [   73.117621]  [<ffffffff8130cc6c>] journal_get_write_access+0x1c/0x50
> [   73.117624]  [<ffffffff812c5278>] __ext3_journal_get_write_access+0x28/0x60
> [   73.117629]  [<ffffffff812b7141>] ext3_reserve_inode_write+0x51/0xb0
> [   73.117633]  [<ffffffff812b71df>] ext3_mark_inode_dirty+0x3f/0x60
> [   73.117636]  [<ffffffff812b91bd>] ext3_setattr+0x12d/0x310
> [   73.117642]  [<ffffffff811fa3d9>] notify_change+0x209/0x330
> [   73.117647]  [<ffffffff811da0d8>] chown_common+0x98/0xc0
> [   73.117650]  [<ffffffff811dacdc>] sys_chown+0x5c/0x90
> [   73.117657]  [<ffffffff826a00bd>] system_call_fastpath+0x1a/0x1f
> [   73.117659] Code: a8 08 0f 84 95 fe ff ff e8 d0 98 38 01 e9 8b fe ff ff 0f 1f 00 f0 80 4b 01 40 4c 89 7b 40 49 89 1f f0 ff 43 60 4c 89 f8 45 31 ff <ff> 40 08 48 8b 03 a9 00 00 20 00 75 05 0f 0b 0f 1f 00 f0 80 63 
> [   73.117697] RIP  [<ffffffff81313a5e>] journal_add_journal_head+0x1be/0x220
> [   73.117701]  RSP <ffff880032195cf8>
> [   73.117702] CR2: 0000000000000008
> [   73.117706] ---[ end trace a307b3ed40206b4c ]---
> 
