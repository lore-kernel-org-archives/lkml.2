Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2FJLLB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 07:11:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48016 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2FJLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 07:10:59 -0400
Date: Sun, 10 Jun 2012 12:10:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
Message-ID: <20120610111056.GD30000@ZenIV.linux.org.uk>
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
 <20120610034921.GB30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120610034921.GB30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 04:49:21AM +0100, Al Viro wrote:

> So the only remaining reason for having that thing is this: what if we
> call ->atomic_open(), but it doesn't call finish_open()?  Then we need
> to free that unused struct file.  If finish_open() failed, we wouldn't.
> Same if it succeeded and something *after* it in ->atomic_open() failed
> (then we need to fput() that file - your code in ceph leaks it, BTW).
> Fair enough.  So we need to add one more helper that would discard that
> half-set-up struct file as we want it to be discarded.  That's all.

Actually, I take that back - that code in ceph is unreachable when
finish_open() succeeds.

Anyway, see vfs.git#atomic_open; it's a port of your queue + COMPLETELY
UNTESTED followups massaging it along the following lines:
	* ->atomic_open() takes struct file * instead of struct opendata *
	* it return int instead of struct file * - 0 for succeess, -E...
for error, 1 for "here's your sodding dentry, do it yourself".  Said
dentry is returned via file->f_path.dentry.
	* the same had been done to atomic_open()/lookup_open()/do_last()
	* finish_open() takes struct file and returns an int
	* it *also* takes int * - used to keep track of whether we'd done
successful do_dentry_open(), instead of "has opendata->filp been cleared?"
as in your variant.  Said int * is what your bool *created of ->atomic_open()
and friends has been turned into.  So the check in path_openat() is
	if (!(opened & FILE_OPENED)) {
		BUG_ON(!error);
		put_filp(file);
	}
which is as explicit as it gets, IMO.

The forest of failure exits in do_last() got cleaned up a bit, BTW.  Probably
can be cleaned up some more...

WARNING: I haven't even tried to boot it.  It builds, but this is all I can
promise at the moment.  I'm about to fall down (it's 7am here already ;-/),
will give it some beating when I get up.  It almost certainly has bugs, so
consider that as call for review and not much more.
