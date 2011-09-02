Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab1IBSXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:23:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33831 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1IBSXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:23:15 -0400
Date: Fri, 2 Sep 2011 11:22:14 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Message-ID: <20110902182214.GC12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 10:15:27AM -0400, Greg Freemyer wrote:
> On Wed, Aug 31, 2011 at 8:30 PM, Darrick J. Wong <djwong@us.ibm.com> wrote:
> > Hi all,
> >
> > This patchset adds crc32c checksums to most of the ext4 metadata objects.  A
> > full design document is on the ext4 wiki[1] but I will summarize that document here.
> >
> > As much as we wish our storage hardware was totally reliable, it is still
> > quite possible for data to be corrupted on disk, corrupted during transfer over
> > a wire, or written to the wrong places.  To protect against this sort of
> > non-hostile corruption, it is desirable to store checksums of metadata objects
> > on the filesystem to prevent broken metadata from shredding the filesystem.
> >
> > The crc32c polynomial was chosen for its improved error detection capabilities
> > over crc32 and crc16, and because of its hardware acceleration on current and
> > upcoming Intel and Sparc chips.
> >
> > Each type of metadata object has been retrofitted to store a checksum as follows:
> >
> > - The superblock stores a crc32c of itself.
> > - Each inode stores crc32c(fs_uuid + inode_num + inode + slack_space_after_inode)
> > - Block and inode bitmaps each get their own crc32c(fs_uuid + group_num +
> >  bitmap), stored in the block group descriptor.
> > - Each extent tree block stores a crc32c(fs_uuid + inode_num + extent_entries)
> >  in unused space at the end of the block.
> > - Each directory leaf block has an unused-looking directory entry big enough to
> >  store a crc32c(fs_uuid + inode_num + block) at the end of the block.
> > - Each directory htree block is shortened to contain a crc32c(fs_uuid +
> >  inode_num + block) at the end of the block.
> > - Extended attribute blocks store crc32c(fs_uuid + block_no + ea_block) in the
> >  header.
> > - Journal commit blocks can be converted to use crc32c to checksum all blocks
> >  in the transaction, if journal_checksum is given.
> >
> > The first four patches in the kernel patchset fix existing bugs in ext4 that
> > cause incorrect checkums to be written.  I think Ted already took them, but
> > with recent instability I'm resending them to be cautious.  The subsequent 12
> > patches add the necessary code to support checksumming in ext4 and jbd2.
> >
> > I also have a set of three patches that provide a faster crc32c implementation
> > based on Bob Pearson's earlier crc32 patchset.  This will be sent under
> > separate cover to the crypto list and to lkml/linux-ext4.
> >
> > The patchset for e2fsprogs will be sent under separate cover only to linux-ext4
> > as it is quite lengthy (~36 patches).
> >
> > As far as performance impact goes, I see nearly no change with a standard mail
> > server ffsb simulation.  On a test that involves only file creation and
> > deletion and extent tree modifications, I see a drop of about 50 percent with
> > the current kernel crc32c implementation; this improves to a drop of about 20
> > percent with the enclosed crc32c implementation.  However, given that metadata
> > is usually a small fraction of total IO, it doesn't seem like the cost of
> > enabling this feature is unreasonable.
> >
> > There are of course unresolved issues:
> >
> > - What to do when the block group descriptor isn't big enough to hold 2 crc32s
> >  (which is the case with 32-bit ext4 filesystems, sadly).  I'm not quite
> >  convinced that truncating a 32-bit checksum to 16-bits is a safe idea.  Right
> >  now, one has to enable the 64bit feature to enable any bitmap checksums.
> >  I'm not sure how effective crc16 is at checksumming 32768-bit bitmaps.
> >
> > - Using the journal commit hooks to delay crc32c calculation until dirty
> >  buffers are actually being written to disk.
> >
> > - Can we get away with using a (hw accelerated) LE crc32c for jbd2, which
> >  stores its data in BE order?
> >
> > - Interaction with online resize code.  Yongqiang seems to be in the process of
> >  rewriting this, so I haven't looked at it very closely yet.
> >
> > - If block group descriptors can now exceed 32 bytes (when 64bit filesystem
> >  support is enabled), should we use crc32c instead of crc16?  From what I've
> >  read of the literature, crc16 is not very effective on datasets exceeding 256
> >  bytes.
> >
> > Please have a look at the design document and patches, and please feel free to
> > suggest any changes.  I will be at LPC next week if anyone wishes to discuss,
> > debate, or protest.
> >
> > --D
> >
> > [1] https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums
> 
> Derrick,
> 
> Brainstorming only:
> 
> Another thing you might consider is to somehow tie into the data
> integrity patches that went into the kernel a couple years ago.  Those
> are tied to specialized storage devices (typically scsi) that can
> actually have the checksum live on the disk, but not in the normal
> data area.  ie. in the sector header / footer or some other out of
> band area.
> 
> At a minimum, it may make sense to use the same CRC which that API
> does.  Then you could calculate the CRC once and put it both in-band
> in the inode and out-of-band in the dedicated integrity area of
> supporting storage devices.

If you have the necessary DIF/DIX hardware and kernel support then every block
in the FS is already checksummed and you don't need metadata_csum at all.  This
patchset was really intended for setups where we don't have DIF/DIX.

Furthermore, the nice thing about the in-filesystem checksum is that we bake in
other things like the FS UUID and the inode number, which gives you a somewhat
better assurance that the data block belongs to the fs and the file that the
code think it belongs to.  The DIX interface allows for a 32-bit block number
and a 16-bit application tag ... which is unfortunately small given 64-bit
block numbers and 32-bit inode numbers.

I guess there's also an argument that from a layering perspective it's
desirable to have a FS image whose integrity features remain intact even if you
copy the image to a different device that doesn't support the hardware feature.

As a side note, the crc-t10dif implementation is quite slow -- the hardware
accelerated crc32c is 15x faster, and the sw implementation is usually 3-6x
faster.  I suspect somebody will want to fix that before DIF becomes more
widespread...

> That if the data is corrupted on the wire as an example, the
> controller itself may be able to verify its a bad crc and ask for a
> re-read without even involving the kernel.
> 
> I believe supporting hardware is rare, but if the kernel is going to
> have a data integrity API to support it at all, then code like this is
> exactly the kind of code that should layer on top of it.

The good news is that if you're really worried about integrity, metadata_csum
and DIF/DIX aren't mutually exclusive features.  Rejecting corrupted write
commands at write time seems like a useful feature. :)

--D
