Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab0FQS6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756976Ab0FQS6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:58:54 -0400
Date: Thu, 17 Jun 2010 14:58:29 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Dillow <dillowda@ornl.gov>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] d_ino considered harmful
Message-ID: <20100617185828.GC14389@shell>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <1276721084.13788.53.camel@lap75545.ornl.gov> <30568.1276797848@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30568.1276797848@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 03:04:08AM +0900, J. R. Okajima wrote:
> 
> David Dillow:
> > For example, our main Lustre scratch space has over 285 million files in
> > it, and using find -inum takes over 72 hours to walk the tree using
> 	:::
> > Using ne2scan -- which uses libext2fs and combines the inode scan and
> > the name lookup -- takes over 48 hours to generate a list of candidate
> > files for the purge example. With an optimized inode scan and the custom
> 	:::
> 
> While I've never heard of ne2scan, I am interested in this simplified
> problem such as "find the pathname(s) from an inum in a huge fs."
> Is ne2scan essentially equivalent to "debugfs ncheck inum"?
> 
> About Valeris's patch, as long as "ls -i" is useful/helpful,
> > +	/* Use of d_ino without st_dev is always buggy. */
> is not true.

What I'm hearing again and again is that d_ino is useful to improve
performance.  As Andreas put it to me, if d_ino is the same, the
referenced file may or may not be the same, but if it's different, the
files are definitely different.  Only in well-controlled environments
known not to have submounts or bind mounts do people trust d_ino to be
from the same file system as the other entries in a directory.

I only submitted this patch half-seriously - mainly I wanted to find
out how people are using d_ino, and therefore what I need to do for
fallthru directory entries in union mounts.

In order to get the correct inode number for a directory entry
referring to a lower layer file or directory, we have to do a
->lookup() from the fs-specific readdir code (or else require that
fallthrus store an arbitrarily sized integer - which seriously
restricts the implementation).  Now, doing a ->lookup() to get d_ino
makes no sense if we are using d_ino as a way to avoid the cost
stat(), which is mainly the ->lookup().  And you definitely can't use
d_ino by itself in a union mount.

I'm inclined to save the trouble and just return 1 in d_ino for
fallthru directory entries, especially now that I've tested it
system-wide and had no obvious problems.

-VAL
