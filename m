Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2FNIIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:08:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41077 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab2FNIIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:08:09 -0400
Date: Thu, 14 Jun 2012 09:08:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        dhowells@redhat.com, mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120614080800.GA14898@ZenIV.linux.org.uk>
References: <20120613112112.GA10597@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613112112.GA10597@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 07:21:12AM -0400, Christoph Hellwig wrote:

> It also shows that were are really close to getting nameidata out of the
> filesystem.  The remaning issues are kern_path_parent usages in devtmpfs
> and audit_watch, as well as direct access to nd->path in
> proc_pid_follow_link.  A hacky patch to demonstrate this is below (not
> intended for submission).

Those are easily handled - kern_path_parent() ones are begging for
something like
int path_lookup_locked(char *name, struct path *path)
resulting in dentry/vfsmount pair stored in path, dentry possibly
negative and its parent known to have locked inode (i.e. path->dentry->d_parent
is stable until we unlock path->dentry->d_parent->d_inode->i_mutex).

And proc_pid_follow_link() is easier yet - explicit nd_jump_link(nd, path),
to be called by magical symlinks' ->follow_link().

Can do..  As for Miklos' objection re overlayfs - I'm tempted to make
path_openat() take struct file * as explicit argument, convert the
existing callers into path_openat(get_empty_filp(), ...) and let the
stacking ones use that.

My objection against opendata is that it's both an offense against Occam's
Razor (i.e. opaque object where none is needed) *and* not really opaque at
that - restrictions on the sequence of operations are non-trivial and
that has at least as high potential for bugs as bogus fput() done by broken fs.
