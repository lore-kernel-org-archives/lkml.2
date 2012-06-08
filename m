Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab2FHChs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:37:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41717 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab2FHChq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:37:46 -0400
Date: Fri, 8 Jun 2012 03:37:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608023742.GN30000@ZenIV.linux.org.uk>
References: <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
 <20120608003604.GK30000@ZenIV.linux.org.uk>
 <87mx4eimij.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mx4eimij.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 07:08:04PM -0700, Eric W. Biederman wrote:
> > +	dentry->d_fsdata = sysfs_get(sd);
> > +	ret = d_materialise_unique(dentry, inode);
> 
> I have a small problem with d_materialise_unique.  For renames of files
> d_materialise_unique calls __d_instantiate_unique. __d_instantiate_unique
> does not detect renames of files.  Which at least misses the rename
> of sysfs symlinks.

Er... yes, but why do we care?  It's not as if you had a hardwired
reference to dentry from your objects, after all (can't, with multiple
superblocks).  So you get old stale dentry at the old location and
a new one where we'd moved that sucker.  They have the same inode
and each holds a reference to the same sd; ->d_revalidate() at the
old location must invalidate the old instance anyway, since you are
not guaranteed that lookup at the new one will happen before repeated
lookup at the old one.

Directories *are* special in that respect, but symlinks are trivial...
VFS doesn't care if you have extra dentries for those and neither does
sysfs, AFAICS.

It's not that we couldn't teach d_materialise_unique() about those (e.g.
introduce a new dentry flag and treat dentries with it as directories
for d_materialise_unique() purposes); I would like to understand the
reasons for doing that, though.
