Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760421Ab2CUVUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:20:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757757Ab2CUVSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:18:50 -0400
Date: Wed, 21 Mar 2012 21:18:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Joe Perches <joe@perches.com>,
        greg@kroah.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321211835.GQ6589@ZenIV.linux.org.uk>
References: <20120316121829.GA12685@ioremap.net>
 <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 02:02:43PM -0700, Linus Torvalds wrote:

> I can't really say that I tend to care deeply about the innards of
> some unusual filesystem that hopefully cannot possibly impact anything
> else. So as long as you keep people like Al happy (or at least not
> overly unhappy), I'm unlikely to worry too much.

As far as I can see, it's still suffering the same problems it used to;
in particular, the games it plays with d_path() are completely bogus.
Take a look at this:

static int pohmelfs_construct_path_string(struct pohmelfs_inode *pi, void *data
 int len)
{
	struct path path;
	struct dentry *d;
	char *ptr;
	int err = 0, strlen, reduce = 0;

	d = d_find_alias(&pi->vfs_inode);
	if (!d) {
		err = -ENOENT;
		goto err_out_exit;
	}

	spin_lock(&current->fs->lock);
	path.mnt = mntget(current->fs->root.mnt);
	spin_unlock(&current->fs->lock);

	path.dentry = d;

	if (!IS_ROOT(d) && d_unhashed(d))
		reduce = 1;

	ptr = d_path(&path, data, len);
	if (IS_ERR(ptr)) {
		err = PTR_ERR(ptr);
		goto err_out_put;
	}

	if (reduce && len >= UNHASHED_OBSCURE_STRING_SIZE) {
		char *end = data + len - UNHASHED_OBSCURE_STRING_SIZE;
		*end = '\0';
	}

	strlen = len - (ptr - (char *)data);
	memmove(data, ptr, strlen);
	ptr = data;

	err = strlen - 1; /* no including 0-byte */

	pr_debug("%s: dname: '%s', len: %u, maxlen: %u, name: '%s', strlen: %d.\n",
		__func__, d->d_name.name, d->d_name.len, len, ptr, strlen);

err_out_put:
	dput(d);
	mntput(path.mnt);
err_out_exit:
	return err;
}

For Nth time: what happens to poor sod that happens to be chrooted
into that animal?  We get pathname relative to process' root or to fs
root, whichever's closer.  And no, it's used not just for debugging 
printks...

I think I've asked that question at least 3 times.  Never got anything
resembling an answer...  Is that misspelled dentry_path()?  Or is something
subtle going on and we really want different strings generated for
chrooted processes here?
