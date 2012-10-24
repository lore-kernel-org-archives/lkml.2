Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab2JXMDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:03:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab2JXMDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:03:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 24 Oct 2012 12:02:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210171250.12130.arnd@arndb.de> <20121024024920.GS4291@dastard>
In-Reply-To: <20121024024920.GS4291@dastard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241202.40599.arnd@arndb.de>
X-Provags-ID: V02:K0:ssK4iggJtFJO5z8UDoGfup8srqW7hfpcYUGJi2yzjSu
 Q8DJc1Kvk+bGb1P4uUWOYOC8FAbIum3KreZsiW2yLMG1Ydy7rZ
 6JRh5t6uPJCUs30XrNLaxe5A7yXR90CvyaK7VbLQaHaX86grIu
 Lp1IgLnjrq19oqxMnp+D0VjjyNWNp4Wc02uOYgt/fS2PRegm+m
 UEhgjhfJaOG16attbfaPOwvaavb2ryGxpFXuy/wwgcXgAwr3Si
 Tb736I98GdgXMUc1nYd4M1ZwE1eHg6LQj4z9a3qKfp2e/DejNB
 43XWAMZPo7Emv2rTnrphPvPDnggpKvp7eGVJPm748yTy8Gwxl8
 P6Fr2U3aXSFsv+ktFlvc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Dave Chinner wrote:
> On Wed, Oct 17, 2012 at 12:50:11PM +0000, Arnd Bergmann wrote:
> > On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > > > IIRC, fs2fs uses 4k inodes, so IMO per-inode xattr tress with
> > > > internal storage before spilling to an external block is probably
> > > > the best approach to take...
> > > 
> > > Yes, indeed this is the best approach to f2fs's xattr.
> > > Apart from giving fs hints, it is worth enough to optimize later.
> > 
> > I've thought a bit more about how this could be represented efficiently
> > in 4KB nodes. This would require a significant change of the way you
> > represent inodes, but can improve a number of things at the same time.
> > 
> > The idea is to replace the fixed area in the inode that contains block
> > pointers with an extensible TLV (type/length/value) list that can contain
> > multiple variable-length fields, like this.
> 
> You've just re-invented inode forks... ;)

Ah, good to know the name for it. I didn't really expect that it was a
new idea.

> The main issue with supporting an arbitrary number of forks is space
> management of the inode literal area.  e.g. one fork is in inline
> format (e.g.  direct file contents) and then we add an attribute.
> The attribute won't fit inline, nor will an extent form fork header,
> so the inline data fork has to be converted to extent format before
> the xattr can be added. Now scale that problem up to an arbitrary
> number of forks....

Right. Obviously this is a solveable problem, but I agree that solving
it is nontrivial and requires some code complexity that would be nice
to avoid.

> > As a variation of this, it would also be nice to turn around the order
> > in which the pointers are walked, to optimize for space and for growing
> > files, rather than for reading the beginning of a file. With this, you
> > can represent a 9 KB file using a list of two block pointers, and 1KB
> > of direct data, all in the inode. When the user adds another byte, you
> > only need to rewrite the inode. Similarly, a 5 MB file would have a
> > single indirect node (covering block pointers for 4 MB), plus 256
> > separate block pointers (covering the last megabyte), and a 5 GB file
> > can be represented using 1 double-indirect node and 256 indirect nodes,
> > and each of them can still be followed by direct "tail" data and
> > extended attributes.
> 
> I'm not sure that the resultant code complexity is worth saving an
> extra block here and there.

The space overhead may be noticeable for lots of small files but the
part that worries me more is the overhead for writing (and cleaning up)
data in multiple locations. Any write to file data or extended attributes
requires an update of the inode (mtime, ctime, size, ...) and one or
more other blocks (data, pointers, xattr). In order for the garbage
collection to work best, we want to split those writes into separate logs,
which later have to be cleaned up again. In particular for the inode
but also for the block pointers, we create a lot of garbage from
copy-on-write. Storing as much as possible in the inode itself therefore
saves us from writing the data multiple times rather than just the
actual update.

	Arnd
