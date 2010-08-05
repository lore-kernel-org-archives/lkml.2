Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0HETyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab0HETyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:54:36 -0400
Date: Thu, 5 Aug 2010 15:54:15 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 27/38] union-mount: In-kernel file copyup routines
Message-ID: <20100805195415.GA30348@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-28-git-send-email-vaurora@redhat.com> <E1OgfrQ-0000sG-Jx@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OgfrQ-0000sG-Jx@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:26:28PM +0200, Miklos Szeredi wrote:
> On Tue, 15 Jun 2010, Valerie Aurora wrote:
> > When a file on the read-only layer of a union mount is altered, it
> > must be copied up to the topmost read-write layer.  This patch creates
> > union_copyup() and its supporting routines.
> > 
> > Thanks to Valdis Kletnieks for a bug fix.
> 
> What happens if there's a crash in the middle of the copyup?
> 
> Possible solution is using rename to atomically "replace" the
> underlying file.  That however introduces namespace issues: where to
> put the temporary file which then needs to be deleted on "fsck.union"?

This kind of problem is what makes union mounts so much fun to work
on!! </sarcasm>

So far this version of union mounts has kept the namespace clean, so
I'd like to keep it that way.  One of my ideas is to mark the new file
as "copy-in-progress" and if we encounter such a file, we restart the
copyup again.  But how to mark it?  A new inode flag?

This applies in some form to directory copyup too.  However, we
already have a flag we use to indicate that it's copied up - the
opaque flag.  I moved that to be set after the directory entries are
copied up.  If it crashes in the middle, it can be safely restarted
the next time we call readdir() on that directory.

I added a comment to the commit message describing the problem, so
it's at least documented.

-VAL
