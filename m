Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0KFD1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 23:27:00 -0400
Received: from phunq.net ([64.81.85.152]:45792 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752347Ab0KFD06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 23:26:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] introduce dm-snap-mv
Date: Fri, 5 Nov 2010 20:24:38 -0700
User-Agent: KMail/1.9.9
Cc: Cong Meng <mcpacino@gmail.com>, linux-fsdevel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@kernel.dk>
References: <20101006083150.GA15758@zhongling> <Pine.LNX.4.64.1010191551540.19443@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1010191551540.19443@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011052024.39587.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

Whoops, I didn't notice this mail for ages.  Yes, the Zumastor front end is a very flexible and effective piece of code, never mind that it is entirely written in Bash.  I'm not proud of that fact by any means, but managers at Google vetoed a rewrite to a more sensible language such as Python.  Regardless, it worked fine then and is working now perfectly well in Bash, and is largely decoupled from the details of the underlying block device replication scheme.  Adapting it to, say, DRBD or one of the efforts to improve LVM snapshots would just be a few lines.  Oh, and I did rewrite it in Python anyway, mostly, which took about a day.  If anybody wants that code I can point them at it.

/me makes the sign of the beast in the general direction of Google management.

Regards,

Daniel

On Tuesday 19 October 2010, Mikulas Patocka wrote:
> Hi
> 
> Thanks for the development!
> 
> I'm already developing something similar 
> paper: http://people.redhat.com/mpatocka/papers/shared-snapshots.pdf
> kernel code: http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r22/
> user code: http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.73/
> 
> Please change your code to conform to the existing interface. My kernel 
> code is extendible, you can plug arbitrary on-disk formats to it, there's 
> another example of Daniel Phillips' zumastore snapshots. Use this 
> interface so that it could be used with the existing userspace 
> infrastructure.
> 
> Mikulas
> 
> On Wed, 6 Oct 2010, Cong Meng wrote:
> 
> > Hello everyone,
> > 
> > I am very glad to introduce my work dm-snap-mv here.
> > 
> > 
> > what is dm-snap-mv
> > -------------------
> > The dm-snap-mv is a target module for device-mapper, which can take
> > multiple snapshots against an existing block device(origin device).
> > 
> > All snapshots are saved in an independent block device(COW device).
> > 
> > The copy-on-write is used, so only diff-data will be saved in the COW device.
> > 
> > 
> > features
> > --------
> > 1. snapshot of origin
> > 2. snapshot of snapshot
> > 3. instant snapshot creation and deletion
> > 4. origin and snapshots are concurrent readable/writable
> > 5. rollback snapshot to origin
> > 6. multiple origin devices share a COW device
> > 7. multiple COW devices are supported
> > 
> > 
> > diagram
> > -------
> > 
> >            +---------------------+    +---------------+     +--------------+
> >    read <--|                     |-----               |     |              |
> >            |    origin dm_dev    |    |   origin_dev  | COW |              |
> >   write ---|                     |---->               |----->  snapshot-1  |
> >            +---------------------+    +--|------------+     |     ...      | 
> >                                          |                  |     ...      |        
> >            +---------------------+    +--|------------------+     ...      |
> >    read <--|                     |-------?-                    snapshot-N  |
> >            |  snapshot-X dm_dev  |    |         cow_dev                    |
> >   write ---|                     |---->                                    |
> >            +---------------------+    +------------------------------------+
> > 
> >   dm_dev: device-mapper device, created by "dmsetup create ..."
> >      COW: copy-on-write
> > 
> > 
> > download the source
> > -----------------------
> > http://github.com/mcpacino/dm-snap-mv
> > 
> > git clone git://github.com/mcpacino/dm-snap-mv.git
> > 
> > 
> > a kernel patch
> > --------------
> > Now, dm-snap-mv highly depends on a kernel patch below, which make __getblk()
> > can get a 4K buffer head while block size of the disk is NOT 4K.
> > 
> > Signed-off-by: Cong Meng <mcpacino@gmail.com>
> > ---
> >  fs/buffer.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 3e7dca2..f7f9d33 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
> >  	pgoff_t index;
> >  	int sizebits;
> >  
> > -	sizebits = -1;
> > -	do {
> > -		sizebits++;
> > -	} while ((size << sizebits) < PAGE_SIZE);
> > +	sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
> >  
> >  	index = block >> sizebits;
> >  
> > @@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
> >  	 */
> >  	bio = bio_alloc(GFP_NOIO, 1);
> >  
> > -	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> > +	bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
> >  	bio->bi_bdev = bh->b_bdev;
> >  	bio->bi_io_vec[0].bv_page = bh->b_page;
> >  	bio->bi_io_vec[0].bv_len = bh->b_size;
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> 
> 


