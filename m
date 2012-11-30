Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2K3Wkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 17:40:47 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25284 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab2K3Wkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 17:40:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloKAFA1uVB5LN4a/2dsb2JhbABEhUO0PoYAF3OCHgEBBScTHCMQCAMOCi4UJQMhE4gPv14UjCyDYGEDlX+QRYMG
Date: Sat, 1 Dec 2012 09:40:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Mason <clmason@fusionio.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] Do a proper locking for mmap and block size change
Message-ID: <20121130224041.GD12955@dastard>
References: <CA+55aFziCW_ywZACGoVyNSgy8mToAGhSbdo0VoUAaGvgSb2XxQ@mail.gmail.com>
 <CA+55aFxt655WfuhjOCnu3esg3gt=L37v=ofWfjs+qpXjn-F2uA@mail.gmail.com>
 <20121129191503.GB3490@shiny>
 <CA+55aFxaHuxaEezkpmGRi4kFGaQFTv9S89N-hJhxBjVa6ZwnbQ@mail.gmail.com>
 <20121129194840.GC3490@shiny>
 <CA+55aFwGLExQGhhzStMobWzLju0tVjKW9SZphrxp3AJ6w_ZH9g@mail.gmail.com>
 <20121129212931.GD3490@shiny>
 <CA+55aFzeq1HZvEZdmx=f8at2UOWcyp4oZv0RCX4dd0+dthuM1w@mail.gmail.com>
 <20121130024910.GF6434@dastard>
 <20121130163601.GA32238@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130163601.GA32238@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 11:36:01AM -0500, Christoph Hellwig wrote:
> On Fri, Nov 30, 2012 at 01:49:10PM +1100, Dave Chinner wrote:
> > > Ugh. That's a big violation of how buffer-heads are supposed to work:
> > > the block number is very much defined to be in multiples of b_size
> > > (see for example "submit_bh()" that turns it into a sector number).
> > > 
> > > But you're right. The direct-IO code really *is* violating that, and
> > > knows that get_block() ends up being defined in i_blkbits regardless
> > > of b_size.
> > 
> > Same with mpage_readpages(), so it's not just direct IO that has
> > this problem....
> 
> The mpage code may actually fall back to BHs.
> 
> I have a version of the direct I/O code that uses the iomap_ops from the
> multi-page write code that you originally started.  It uses the new op
> as primary interface for direct I/O and provides a helper for
> filesystems that still use buffer heads internally.  I'll try to dust it
> off and send out a version for the current kernel.

So it was based on this interface?

(I went looking for this code on google a couple of days ago so I
could point at it and say "we should be using an iomap structure,
not buffer heads", but it looks like I never posted it to fsdevel or
the xfs lists...)


diff --git a/include/linux/fs.h b/include/linux/fs.h
index 090f0ea..e247d62 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -522,6 +522,7 @@ enum positive_aop_returns {
 struct page;
 struct address_space;
 struct writeback_control;
+struct iomap;
 
 struct iov_iter {
 	const struct iovec *iov;
@@ -614,6 +615,9 @@ struct address_space_operations {
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
+
+	int (*iomap)(struct address_space *mapping, loff_t pos,
+			ssize_t length, struct iomap *iomap, int cmd);
 };
 
 /*
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
new file mode 100644
index 0000000..7708614
--- /dev/null
+++ b/include/linux/iomap.h
@@ -0,0 +1,45 @@
+#ifndef _IOMAP_H
+#define _IOMAP_H
+
+/* ->iomap a_op command types */
+#define IOMAP_READ	0x01	/* read the current mapping starting at the
+				   given position, trimmed to a maximum length.
+				   FS's should use this to obtain and lock
+				   resources within this range */
+#define IOMAP_RESERVE	0x02	/* reserve space for an allocation that spans
+				   the given iomap */
+#define IOMAP_ALLOCATE	0x03	/* allocate space in a given iomap - must have
+				   first been reserved */
+#define IOMAP_UNRESERVE	0x04	/* return unused reserved space for the given
+				   iomap and used space. This will always be
+				   called after a IOMAP_READ so as to allow the
+				   FS to release held resources. */
+
+/* types of block ranges for multipage write mappings. */
+#define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
+#define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
+#define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
+#define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
+
+struct iomap {
+	sector_t	blkno;	/* first sector of mapping */
+	loff_t		offset;	/* file offset of mapping, bytes */
+	ssize_t		length;	/* length of mapping, bytes */
+	int		type;	/* type of mapping */
+	void		*priv;	/* fs private data associated with map */
+};
+
+static inline bool
+iomap_needs_allocation(struct iomap *iomap)
+{
+	return iomap->type == IOMAP_HOLE;
+}
+
+/* multipage write interfaces use iomaps */
+typedef int (*mpw_actor_t)(struct address_space *mapping, void *src,
+			loff_t pos, ssize_t len, struct iomap *iomap);
+
+ssize_t multipage_write_segment(struct address_space *mapping, void *src,
+			loff_t pos, ssize_t length, mpw_actor_t actor);
+
+#endif /* _IOMAP_H */

Cheers,

Dave.
> 
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 
> 

-- 
Dave Chinner
david@fromorbit.com
