Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab2DDDQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:16:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41782 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2DDDQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:16:31 -0400
Date: Wed, 4 Apr 2012 04:16:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 5/6] vfs: reorganize do_lookup
Message-ID: <20120404031629.GB6589@ZenIV.linux.org.uk>
References: <1332759264-23533-1-git-send-email-miklos@szeredi.hu>
 <1332759264-23533-6-git-send-email-miklos@szeredi.hu>
 <20120330190526.GA29050@ZenIV.linux.org.uk>
 <87hax1s069.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hax1s069.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 10:13:18AM +0200, Miklos Szeredi wrote:

> The do_last() reorganization in the atomic-open series needs to be split
> up, I realize.  Do you have any other high level comments about that
> series?

Yes.
	a) Please, pull removal of open-from-d_revalidate() as far in front
of the queue as possible, *along* *with* -EOPENSTALE stuff.  Without the
latter the former is simply broken - we might have hit -ESTALE before and
LOOKUP_REVAL might have already been set, so just failing ->open() with
ESTALE may end up not repeating it.
	TBH, had that thing been in front of the queue, I would've put
it into the last pull request; that particular idiocy (NFS4 doing open
from all methods involved, except for ->open()) had been a serious source
of annoyance for a long time.  It really needs killing...

	b) opendata is simply bogus.  You need to pass caller-allocated
struct file in any case, right?  So why not use it to pass what you
need to pass?  We want to be able to tell "it's a symlink, here's the
vfsmount/dentry, now sod off and handle it yourself"?  Sure, but struct
file *already* contains struct path and that's not something that might
disappear on future kernel changes ;-)
