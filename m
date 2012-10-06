Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2JFTku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 15:40:50 -0400
Received: from mail-pb0-f66.google.com ([209.85.160.66]:50045 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2JFTks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 15:40:48 -0400
Message-ID: <1349552441.12699.115.camel@kjgkr>
Subject: Re: [PATCH 01/16] f2fs: add document
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 04:40:41 +0900
In-Reply-To: <20121006071905.GA28760@stefanha-thinkpad>
References: <20121006071905.GA28760@stefanha-thinkpad>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-06 (토), 09:19 +0200, Stefan Hajnoczi:
> > This adds a document describing the mount options, proc entries, usage, and
> > design of Flash-Friendly File System, namely F2FS.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim <at> samsung.com>
> > ---
> >  Documentation/filesystems/00-INDEX |    2 +
> >  Documentation/filesystems/f2fs.txt |  314 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 316 insertions(+)
> >  create mode 100644 Documentation/filesystems/f2fs.txt
> > 
> > diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
> > index 8c624a1..ce5fd46 100644
> > --- a/Documentation/filesystems/00-INDEX
> > +++ b/Documentation/filesystems/00-INDEX
> > @@ -48,6 +48,8 @@ ext4.txt
> >  	- info, mount options and specifications for the Ext4 filesystem.
> >  files.txt
> >  	- info on file management in the Linux kernel.
> > +f2fs.txt
> > +	- info and mount options for the F2FS filesystem.
> >  fuse.txt
> >  	- info on the Filesystem in User SpacE including mount options.
> >  gfs2.txt
> > diff --git a/Documentation/filesystems/f2fs.txt b/Documentation/filesystems/f2fs.txt
> > new file mode 100644
> > index 0000000..cd3f846
> > --- /dev/null
> > +++ b/Documentation/filesystems/f2fs.txt
> > @@ -0,0 +1,314 @@
> > +================================================================================
> > +WHAT IS Flash-Friendly File System (F2FS)?
> > +================================================================================
> > +
> > +NAND flash memory-based storage devices, such as SSD, eMMC, and SD cards, have
> > +been widely being used for ranging from mobile to server systems. Since they are
> > +known to have different characteristics from the conventional rotational disks,
> > +a file system, an upper layer to the storage device, should adapt to the changes
> > +from the sketch.
> > +
> > +F2FS is a file system exploiting NAND flash memory-based storage devices, which
> > +is based on Log-structured File System (LFS). The design has been focused on
> > +addressing the fundamental issues in LFS, which are snowball effect of wandering
> > +tree and high cleaning overhead.
> > +
> > +Since a NAND flash memory-based storage device shows different characteristic
> > +according to its internal geometry or flash memory management scheme aka FTL,
> > +F2FS and its tools support various parameters not only for configuring on-disk
> > +layout, but also for selecting allocation and cleaning algorithms.
> 
> This is pretty high-level, can you list the main F2FS design points that are
> optimized for NAND flash characteristics?

Ok, I'll summarize and supplement some major features in v2.

> 
> First I thought it's log-structured so it automatically performs write
> wear-leveling.  But F2FS is intended to be used on top of FTL? 

Yes, F2FS works on top of FTL. The main goal of f2fs is to produce IOs
optimized to FTL as a best effort. So, I expect that F2FS would mitigate
the wear-out problem in FTL helpfully.

>  So the FTL
> already handles that, and also it appears F2FS is a hybrid between append-only
> and write in-place.

Yes, F2FS is a hybrid, but in-place-writes will be occurred only when
there is not enough free space. So normally, it happens append-only.

Anyway, do you concern the trade-off between wear-leveling and
in-place-writes?
IMHO, for better wear-leveling in FTL, file system cannot help writing
data in append-only as much as possible and aligning management units
between fs and FTL. I think that would be sufficiently effective to
reduce the wear-leveling overhead.

> 
> Who will choose "various parameters" and select "allocation and cleaning
> algorithms" appropriate for the device? 

I think that the parameters will be determined mainly by system vendors.
They select flash chips for products so that they able to know also what
parameters are preferable from the chip vendor.
But, I think the default parameters are common enoughly for usual
environment.

On the other hand, configuring allocation and cleaning algorithms will
be useful to researchers. It is obivous that the default algorithms may
not be best according to various workloads, so I'd like to give a
facility to easily add any new algorithms.

> I wouldn't know what to parameter
> values to use.
> 

You can find the parameters from mount/format options in detail.

> > +Index Structure
> > +---------------
> > +
> > +The key data structure to manage the data locations is a "node". As similar as
> > +traditional file structures, F2FS has three types of node: inode, direct node,
> > +indirect node. F2FS assigns 4KB to an inode block where contains 929 data block
> > +indices, two direct node pointers, two indirect node pointers, and one double
> > +indirect node pointer as described below. One direct node block contains 1018
> > +data blocks, and one indirect node block contains also 1018 node blocks. Thus,
> > +One inode block (i.e., a file) covers:
> > +  4KB * (929 + 2 * 1018 + 2 * 1018 * 1018 + 1018 * 1018 * 1018) := 3.94TB.
> > +
> > +   Inode block (4KB)
> > +     |- data (929)
> > +     |- direct node (2)
> > +     |          `- data (1018)
> > +     |- indirect node (2)
> > +     |            `- direct node (1018)
> > +     |                       `- data (1018)
> > +     `- triple indirect node (1)
> > +                         `- indirect node (1018)
> > +			              `- direct node (1018)
> > +	                                         `- data (1018)
> 
> Earlier it says "one double indirect node pointer" but this diagram shows a
> "triple indirect node".  The diagram itself suggests this should really be
> "double indirect node" because it points to 1 indirect node.

Nice catch.
I'll correct this.
Thanks,

> 
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

