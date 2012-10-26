Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab2JZMs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:48:56 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:46589 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932708Ab2JZMsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:48:52 -0400
Message-ID: <1351255718.2605.28.camel@slavad-ubuntu>
Subject: RE: [PATCH 02/16 v2] f2fs: add on-disk layout
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Fri, 26 Oct 2012 16:48:38 +0400
In-Reply-To: <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
	 <001201cdb0c5$bdf728f0$39e57ad0$%kim@samsung.com>
	 <1351077945.2097.9.camel@slavad-ubuntu>
	 <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 178.177.91.176 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 12:31 +0900, Jaegeuk Kim wrote:
> [snip]
> > > +#define F2FS_SUPER_MAGIC	0xF2F52010
> > > +#define F2FS_SUPER_OFFSET	0		/* start sector # for sb */
> > 
> > Does f2fs superblock really haven't any offset from the volume begin?
> 
> The reason that I changed this from 1 to 0 is due to the failure during android
> recovery. I don't know why the recovery is failed when the offset is 1, but it
> works fine after the offset is changed to 0.
> I suspect that mount procedure inspects the 0'th offset to figure out what file
> system is installed by checking some kind of magic numbers.
> Sometimes, we've seen that the mount program tries to load previously installed
> file system even though mkfs.f2fs was conducted.
> Would you recommend something?
> 

I thought that superblock's placement is defined always from design
point of view. :-)

As I understand, usually many filesystems places first superblock on
1024 bytes distance from a volume beginning. It reserves some place for
possibility to have volume boot record.

I am afraid that Android recovery failure takes place because of
in-proper configuration or, maybe, some special Android recovery code's
modification. Does it means that it is not possible to use, for example,
ext4 or nilfs2 under Android?

Yes, you are right, the mount procedure try to detect a filesystem type.
But superblock can place in different locations. For example, FAT's
superblock hasn't any offset from the volume begin; hfs+ superblock is
located on 1024 bytes from volume begin; reiserfs superblock is located
on 64 KB from volume begin. The situation when mount utility tries to
load another filesystem instead of f2fs is a symptom of mkfs.f2fs bug,
from my point of view.

I think that it makes sense to have as minimum 1024 bytes superblock's
offset from a volume begin.

[snip]
> > > +
> > > +/*
> > > + * For superblock
> > > + */
> > > +struct f2fs_super_block {
> > > +	__le32 magic;		/* Magic Number */
> > > +	__le16 major_ver;	/* Major Version */
> > > +	__le16 minor_ver;	/* Minor Version */
> > > +	__le32 log_sectorsize;	/* log2 (Sector size in bytes) */
> > > +	__le32 log_sectors_per_block;	/* log2 (Number of sectors per block */
> > > +	__le32 log_blocksize;	/* log2 (Block size in bytes) */
> > > +	__le32 log_blocks_per_seg; /* log2 (Number of blocks per segment) */
> > 
> > From my point of view, __le32 is big data type for log2 (<value>). What
> > do you think?
> > 
> 
> Right, but it is superblock. Should we have to consider space overhead?
> 

I simply think that __le16 can be enough. So, all four fields
(log_sectorsize, log_sectors_per_block, log_blocksize,
log_blocks_per_seg) will occupy 8 bytes instead of 16. And this place (8
bytes) can be used for volume serial number field.

With the best regards,
Vyacheslav Dubeyko.


