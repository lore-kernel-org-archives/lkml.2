Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0GHEbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:31:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50767 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0GHEbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:31:51 -0400
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <20100708082143.3701bfc7@notabene.brown>
Date: Wed, 7 Jul 2010 18:03:36 -0600
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <miklos@szeredi.hu>, david@fromorbit.com,
       aneesh.kumar@linux.vnet.ibm.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B5A5C6E8-0F5C-4649-8D72-D0E8989B67A8@oracle.com>
References: <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <20100706232351.GD25018@dastard> <20100707093629.10c2feab@notabene.brown> <20100707021150.GF25018@dastard> <20100707125726.3695587a@notabene.brown> <20100707125701.GA19872@fieldses.org> <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu> <20100707131721.GB19872@fieldses.org> <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu> <20100707144511.GA24360@fieldses.org> <20100708082143.3701bfc7@notabene.brown>
To: Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.1078)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C355493.01FA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-07, at 16:21, Neil Brown wrote:
> It doesn't matter if there is an underlying block device, or if it is shared
> among subvolmes.  st_dev is *the* primary key for filesystems.  Every "struct super_block" has a unique s_dev and that is returned in st_dev.
> 
> For "traditional" filesystem, this is the major/minor number of the block
> device.
> For NFS and btrfs and other filesystems which don't have exclusive use of a
> block device, 'set_anon_super' is used to get a unique s_dev based on a major
> number of '0'.

But the major/minor number returned is essentially random between different clients, so there is no way to use it on another node that is accessing the same filesystem.  Conversely, the UUID will be the same on all of the clients.

> So you can *always* use st_dev as an identifier for the filesystem which is
> stable and unique as long as you hold an active reference to the filesystem
> (open file descriptor, cwd in fs, etc).

Only on a single system.

> If you poll(2) /proc/mounts to get notifications of changes to the mount
> table, then it should be quite easy to cache st-dev -> uuid mappings in a
> race-free way.

This sounds unpleasant for any application to implement.  It might be OK for a user-space NFS/CIFS server, but it is complex and error-prone for any normal usage, and doesn't seem like a good API design to me.

> There might be value in getting name_to_handle to return the st_dev of the
> target file to ensure that you haven't unexepected crossed into a different
> filesystem.  I would prefer that to returning a uuid:  st_dev is guaranteed
> to be unique, a uuid is only supposed to be unique (i.e. that is not
> enforced).

UUID duplication (w.r.t. multiple mounts of the same underlying device) doesn't matter at all for regular file opens, where the only interest is getting a handle for the inode.  I wouldn't be against requiring the UUID be unique if that was needed, or failing regular opens in the rare case that there is a non-unique UUID pointing to different devices, or failing directory opens for the case of multiple mountpoints.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

