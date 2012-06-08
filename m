Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2FHCSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:18:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47383 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab2FHCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:18:13 -0400
Date: Fri, 8 Jun 2012 03:18:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, "J. Bruce Fields" <bfields@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608021809.GM30000@ZenIV.linux.org.uk>
References: <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607193607.GI30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 08:36:07PM +0100, Al Viro wrote:

> Other callers of d_move():
> 	* debugfs_rename() - imitates what vfs_rename() is doing.  Same
> locking environment.  BTW,
>         trap = lock_rename(new_dir, old_dir);
>         /* Source or destination directories don't exist? */
>         if (!old_dir->d_inode || !new_dir->d_inode)
>                 goto exit;
> is bogus - lock_rename() is taking ->i_mutex on these inodes, for fsck sake!
> If this can be called with old_dir or new_dir negative, it's buggered.

It's worse, actually.  If we _ever_ do cross-directory debugfs_rename()
without external serialization, we are in trouble.  It does imitate
vfs_rename() (actually - its callers), but there's an unpleasant difference:
instead of "lock parents with lock_rename(), then do lookups and we are
guaranteed nobody will change ->d_parent of children we are working with"
it's "lock the new parent and whatever happens to be the current parent
of the object given to us; do lookup for target, pray that the old parent
still was the parent of our object by the time we got the locks".

AFAICS, there's only one caller doing cross-directory moves (__clk_reparent())
and currently all callers are serialized by a mutex in there, but that's
not documented anywhere - not for __clk_reparent(), not for debugfs_rename().
