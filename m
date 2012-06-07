Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab2FGBTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:19:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab2FGBTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:19:46 -0400
Date: Wed, 6 Jun 2012 21:19:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607011915.GA17566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>
References: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:42:35PM -0700, Linus Torvalds wrote:

 > So Al meant you to test mutex_is_locked(dentry->d_inode->i_mutex) of
 > the parents.

ok, I ended up with..

        WARN_ON_ONCE(!mutex_is_locked(&target->d_parent->d_inode->i_mutex));

        if (dentry->d_parent != NULL)
                WARN_ON_ONCE(!mutex_is_locked(&dentry->d_inode->i_mutex));

but..
 
 > And I'd suggest making it just a WARN_ON_ONCE(), because if you make
 > it a BUG_ON() and it triggers, your system will likely be dead. And
 > ONCE is all that matters - it should never happen.

I hit the second WARN very early on, before I even get out of the initramfs.

[    6.365556] WARNING: at fs/dcache.c:2350 d_move+0xaf/0xc0()
[    6.365793] Modules linked in:
[    6.365909] Pid: 134, comm: mount Not tainted 3.5.0-rc1+ #69
[    6.366030] Call Trace:
[    6.366147]  [<ffffffff8104910f>] warn_slowpath_common+0x7f/0xc0
[    6.366271]  [<ffffffff8104916a>] warn_slowpath_null+0x1a/0x20
[    6.366396]  [<ffffffff811c5c4f>] d_move+0xaf/0xc0
[    6.366521]  [<ffffffff811b9654>] vfs_rename+0x3c4/0x4e0
[    6.366647]  [<ffffffff811bd741>] sys_renameat+0x201/0x230
[    6.366773]  [<ffffffff8132e59c>] ? debug_check_no_obj_freed+0x16c/0x210
[    6.366902]  [<ffffffff81171cfc>] ? vm_munmap+0x5c/0x80
[    6.367026]  [<ffffffff81086f91>] ? get_parent_ip+0x11/0x50
[    6.367148]  [<ffffffff81086f91>] ? get_parent_ip+0x11/0x50
[    6.367273]  [<ffffffff81651919>] ? sub_preempt_count+0x79/0xd0
[    6.367397]  [<ffffffff81655937>] ? sysret_check+0x1b/0x56
[    6.367521]  [<ffffffff810b7dd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[    6.367647]  [<ffffffff81326f4e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    6.367772]  [<ffffffff811bd78b>] sys_rename+0x1b/0x20
[    6.367891]  [<ffffffff81655912>] system_call_fastpath+0x16/0x1b

Did I screw up the test again ? I'm feeling a bit hard-of-thinking tonight.

 > > To be clear, do you want me to try that with or without the reverts ?
 >
 > I think either would be interesting. 

For now, I still have those two commits applied.

	Dave
