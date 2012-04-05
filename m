Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2DEOoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:44:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50296 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2DEOoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:44:23 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/6] vfs: reorganize do_lookup
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
	<1332759264-23533-6-git-send-email-miklos@szeredi.hu>
	<20120330190526.GA29050@ZenIV.linux.org.uk>
	<87hax1s069.fsf@tucsk.pomaz.szeredi.hu>
	<20120404031629.GB6589@ZenIV.linux.org.uk>
Date: Thu, 05 Apr 2012 16:44:47 +0200
In-Reply-To: <20120404031629.GB6589@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 4 Apr 2012 04:16:29 +0100")
Message-ID: <87aa2qb5ls.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Apr 03, 2012 at 10:13:18AM +0200, Miklos Szeredi wrote:
>
>> The do_last() reorganization in the atomic-open series needs to be split
>> up, I realize.  Do you have any other high level comments about that
>> series?
>
> Yes.
> 	a) Please, pull removal of open-from-d_revalidate() as far in front
> of the queue as possible, *along* *with* -EOPENSTALE stuff.  Without the
> latter the former is simply broken - we might have hit -ESTALE before and
> LOOKUP_REVAL might have already been set, so just failing ->open() with
> ESTALE may end up not repeating it.
> 	TBH, had that thing been in front of the queue, I would've put
> it into the last pull request; that particular idiocy (NFS4 doing open
> from all methods involved, except for ->open()) had been a serious source
> of annoyance for a long time.  It really needs killing...

Will post updated series in a minute.

>
> 	b) opendata is simply bogus.  You need to pass caller-allocated
> struct file in any case, right?  So why not use it to pass what you
> need to pass?  We want to be able to tell "it's a symlink, here's the
> vfsmount/dentry, now sod off and handle it yourself"?

My concern is about the visibility of a half cooked file pointer to the
filesystem.  The compiler won't notice anything wrong with the
following, neither will casual testing, but it will go boom at
inopportune times:

foo_atomic_open(..., struct file *filp, ...)
{
	/* ... */

        if (unlikely error)
		goto cleanup;

	filp = finish_open(filp, dentry, NULL);

	/* ... */

	if (some other error)
		goto cleanup;

	return filp;

cleanup:
	fput(filp);
        return ERR_PTR(error);
}


Thanks,
Miklos

