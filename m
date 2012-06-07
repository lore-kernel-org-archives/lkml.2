Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FGXjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:39:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2FGXjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:39:16 -0400
Date: Fri, 8 Jun 2012 00:39:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607233909.GJ30000@ZenIV.linux.org.uk>
References: <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873966n2c2.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 04:12:45PM -0700, Eric W. Biederman wrote:
> We take the approprate dentry locks in the approparite order so d_move
> and the dcache should not care in the slightest about the inode
> mutecies.
> 
> If we need the inode mutecies to make the dcache bits safe then
> something really is insane.  There may be subtle insanities in the
> vfs that require the inode muticies of the parents in d_move but I am
> certainly not seeing them.  At least as I read it the code in __d_move
> only touches and modifies dentry fields.

Yes.  Now, go take a look at e.g. the locking order on ->d_lock.  No,
I'm not saying that I like it.  Not at all.  But we do rely on the
non-local protections for tree topology, just to make sure that the
damn thing has the locking order consistent - not changing between
the moments you take locks you've ordered, for starters.

I realize that "serialize all operations on a single per-machine mutex" is a
solution.  It's just not something feasible when we are talking about all
directory tree modifications on a general-purpose filesystem.  So no,
sysfs approach to that kind of problems is not usable here.

I doubt that we have something sysfs-related in the deadlocks davej is seeing,
but I seriously suspect that I can cook one based on sysfs_rename() setting
the things up for silent topology changes on ->lookup().  I would suggest
using d_materialise_unique() there - that one *does* take care to take
locks needed.

BTW, looking at the code in sysfs_lookup()... why bother with d_set_d_op()
instead of just sb->s_d_op = &sysfs_dentry_ops; once during sysfs_fill_super()?
In the worst case you need to do that after you've allocated the root
dentry, depending on whether you are willing or not to make ->d_revalidate()
return 1 whenever it's called on the root dentry...
