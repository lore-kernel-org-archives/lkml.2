Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260Ab2JXCtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:49:25 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6717 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934056Ab2JXCtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:49:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooYAA9Wh1B5LNyp/2dsb2JhbABEhSu2VIRyAoEQgQmCHgEBBAE6HCMFCwgDGC4UJQMhE4d+BbsZFItMIIFihFwDkkCDMZA6gwOBRx8
Date: Wed, 24 Oct 2012 13:49:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Message-ID: <20121024024920.GS4291@dastard>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <20121016204412.GF2864@dastard>
 <1350426621.1958.119.camel@kjgkr>
 <201210171250.12130.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210171250.12130.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:50:11PM +0000, Arnd Bergmann wrote:
> On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > > IIRC, fs2fs uses 4k inodes, so IMO per-inode xattr tress with
> > > internal storage before spilling to an external block is probably
> > > the best approach to take...
> > 
> > Yes, indeed this is the best approach to f2fs's xattr.
> > Apart from giving fs hints, it is worth enough to optimize later.
> 
> I've thought a bit more about how this could be represented efficiently
> in 4KB nodes. This would require a significant change of the way you
> represent inodes, but can improve a number of things at the same time.
> 
> The idea is to replace the fixed area in the inode that contains block
> pointers with an extensible TLV (type/length/value) list that can contain
> multiple variable-length fields, like this.

You've just re-invented inode forks... ;)

> All TLVs together with the
> fixed-length inode data can fill a 4KB block.
> 
> The obvious types would be:
> 
> * Direct file contents if the file is less than a block
> * List of block pointers, as before, minimum 1, maximum until the end
>   of the block
> * List of indirect pointers, now also a variable length, similar to the
>   list of block pointers
> * List of double-indirect block pointers
> * direct xattr: zero-terminated attribute name followed by contents
> * indirect xattr: zero-terminated attribute name followed by up to
>   16 block pointers to store a maximum of 64KB sized xattrs
> 
> This could be extended later to cover additional types, e.g. a list
> of erase block pointers, triple-indirect blocks or extents.

An inode fork doesn't care about the data in it - it's just an
independent block mapping index. i.e. inline, direct,
indirect, double indirect. The data in the fork is managed
externally to the format of the fork. e.g. XFS has two forks - one
for storing data (file data, directory contents, etc) and the other
for storing attributes.

The main issue with supporting an arbitrary number of forks is space
management of the inode literal area.  e.g. one fork is in inline
format (e.g.  direct file contents) and then we add an attribute.
The attribute won't fit inline, nor will an extent form fork header,
so the inline data fork has to be converted to extent format before
the xattr can be added. Now scale that problem up to an arbitrary
number of forks....

> As a variation of this, it would also be nice to turn around the order
> in which the pointers are walked, to optimize for space and for growing
> files, rather than for reading the beginning of a file. With this, you
> can represent a 9 KB file using a list of two block pointers, and 1KB
> of direct data, all in the inode. When the user adds another byte, you
> only need to rewrite the inode. Similarly, a 5 MB file would have a
> single indirect node (covering block pointers for 4 MB), plus 256
> separate block pointers (covering the last megabyte), and a 5 GB file
> can be represented using 1 double-indirect node and 256 indirect nodes,
> and each of them can still be followed by direct "tail" data and
> extended attributes.

I'm not sure that the resultant code complexity is worth saving an
extra block here and there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
