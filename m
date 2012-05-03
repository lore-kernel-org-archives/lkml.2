Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2ECVDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:03:43 -0400
Received: from websrv.saout.de ([78.46.99.52]:47619 "EHLO websrv.saout.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2ECVDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:03:41 -0400
Message-ID: <1336079020.7467.0.camel@localhost>
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
From: Jana Saout <jana@saout.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 03 May 2012 23:03:40 +0200
In-Reply-To: <1336077035.3676.5.camel@localhost>
References: <1335788867.29087.19.camel@localhost>
	 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
	 <1335875321.26671.15.camel@localhost>
	 <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
	 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
	 <20120503064722.GN6871@ZenIV.linux.org.uk>
	 <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com>
	 <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
	 <4FA2CAD9.6010808@zytor.com>
	 <CA+55aFxrBghonjRvS=KK=5Oqw_Wj9PDh2wkDtVh7U9jw8=uTsA@mail.gmail.com>
	 <1336077035.3676.5.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

sorry for the addendum: This was actually the first patch - my mistake -
copied the new kernel into the wrong place... don't know if this makes a
difference.  Running the latest patch now, just to make sure.

	Jana


> > Jana - never mind that patch. It will avoid the page fault, but try to
> > use the wrong (truncated) name due to the extraneous left-shift of the
> > loaded value.
> > 
> > So use the attached one instead. It just removes the extra shift that
> > Peter noticed, and also allows the use of the word-at-a-time code with
> > DEBUG_PAGEALLOC so that I can test it myself too.
> 
> Ok, I have been running with that patch for slightly over an hour and
> didn't get that oops anymore.
> 
> Instead, now I got an oops on __d_lookup (fs/dcache.c line 155) (kernel
> log excerpt below):
> 
> > #ifdef CONFIG_DCACHE_WORD_ACCESS
> >         unsigned long a,b,mask;
> > 
> >         if (unlikely(scount != tcount))
> >                 return 1;
> > 
> >         for (;;) {
> >                 a = *(unsigned long *)cs;
> >     ->          b = *(unsigned long *)ct;  
> >                 if (tcount < sizeof(unsigned long))
> >                         break;
> 
> Similar issue, ct is pointing at 0xffff880115a59ffb
> 
> 	Jana
> 
> 
> BUG: unable to handle kernel paging request at ffff880115a5a000
> IP: [<ffffffff81146850>] __d_lookup+0xe0/0x170
> PGD 180c067 PUD bf3f4067 PMD bf4a2067 PTE 0
> Oops: 0000 [#1] PREEMPT SMP 
> CPU 0 
> Modules linked in: nfs lockd auth_rpcgss nfs_acl sunrpc autofs4 ocfs2
> jbd2 ocfs2_dlmfs ocfs2_stack_o2cb ocfs2_dlm ocfs2_nodemanager
> ocfs2_stackglue configfs
> 
> Pid: 10310, comm: apache2 Not tainted 3.4.0-js1-test #1  
> RIP: e030:[<ffffffff81146850>]  [<ffffffff81146850>] __d_lookup
> +0xe0/0x170
> RSP: e02b:ffff880095cc9bf8  EFLAGS: 00010293
> RAX: 0000000000006461 RBX: ffff88009d3ef248 RCX: 0000000000000002
> RDX: 0000000000000006 RSI: 0000000000000000 RDI: ffff88009d3ef29c
> RBP: 0000000000007374 R08: 0000000000000002 R09: ffff88009d3ef278
> R10: ffff88009d3ef240 R11: 0000000000000000 R12: ffff88009d3ef29c
> R13: ffff880065148e40 R14: ffff880115a59ffb R15: ffff880095cc9e78
> FS:  00007fcb26ffe6d0(0000) GS:ffff8800bff0c000(0000)
> knlGS:0000000000000000
> CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff880115a5a000 CR3: 0000000095cc2000 CR4: 0000000000000660
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process apache2 (pid: 10310, threadinfo ffff880095cc8000, task
> ffff8800b3de1800)
> Stack:
>  ffffffff814268da 000000000000e030 0000000000010257 0000000000000002
>  000000000000e02b ffff880095cc9d10 ffff880095cc9d40 ffff880095cc9e68
>  0000000000000001 0000000000000000 ffff8800b3de1800 ffffffff8113c135
> Call Trace:
>  [<ffffffff814268da>] ? bad_gs+0xa34/0x197a
>  [<ffffffff8113c135>] ? do_lookup+0x165/0x340
>  [<ffffffff8113c7ba>] ? link_path_walk+0x4aa/0x890
>  [<ffffffff81036c52>] ? pvclock_clocksource_read+0x52/0xf0
>  [<ffffffff8113cd02>] ? path_lookupat+0x52/0x740
>  [<ffffffff8104bad1>] ? sys_gettimeofday+0x31/0x80
>  [<ffffffff8101a2eb>] ? emulate_vsyscall+0x31b/0x350
>  [<ffffffff8113d41c>] ? do_path_lookup+0x2c/0xc0
>  [<ffffffff8113aa2d>] ? getname_flags+0xed/0x260
>  [<ffffffff8113ebde>] ? user_path_at_empty+0x5e/0xb0
>  [<ffffffff8104c912>] ? local_bh_enable_ip+0x22/0xb0
>  [<ffffffff81325eeb>] ? sock_setsockopt+0x8b/0x870
>  [<ffffffff8112e981>] ? sys_faccessat+0xa1/0x1c0
>  [<ffffffff814241f9>] ? system_call_fastpath+0x16/0x1b
> Code: 8d 53 f8 44 8b 43 1c 4c 8b 4b 20 75 4e 48 8b 4c 24 18 4d 63 c0 4c
> 39 c1 75 b0 31 f6 0f 1f 80 00 00 00 00 48 83 f9 07 49 8b 04 31 <49> 8b
> 14 36 76 5a 48 39 d0 75 94 48 83 c6 08 48 83 e9 08 75 e3 
> RIP  [<ffffffff81146850>] __d_lookup+0xe0/0x170
>  RSP <ffff880095cc9bf8>
> CR2: ffff880115a5a000
> ---[ end trace b53471b6e52caa9d ]---
> 
> (followed by note: apache2[10310] exited with preempt_count 1
> BUG: scheduling while atomic: apache2/10310/0x10000002)
> 


