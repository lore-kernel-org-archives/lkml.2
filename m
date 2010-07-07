Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0GGWWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:22:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38657 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab0GGWWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:22:01 -0400
Date: Thu, 8 Jul 2010 08:21:43 +1000
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, david@fromorbit.com,
       aneesh.kumar@linux.vnet.ibm.com, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100708082143.3701bfc7@notabene.brown>
In-Reply-To: <20100707144511.GA24360@fieldses.org>
References: <20100706161002.GD7387@fieldses.org>
	<87eifgfsez.fsf@linux.vnet.ibm.com>
	<20100706232351.GD25018@dastard>
	<20100707093629.10c2feab@notabene.brown>
	<20100707021150.GF25018@dastard>
	<20100707125726.3695587a@notabene.brown>
	<20100707125701.GA19872@fieldses.org>
	<E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu>
	<20100707131721.GB19872@fieldses.org>
	<E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu>
	<20100707144511.GA24360@fieldses.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jul 2010 10:45:11 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Wed, Jul 07, 2010 at 03:35:50PM +0200, Miklos Szeredi wrote:
> > On Wed, 7 Jul 2010, J. Bruce Fields wrote:
> > > > > If you use sys or proc, is it possible to get the uuid from a file
> > > > > descriptor or pathname without races?
> > > > 
> > > > You can do stat/fstat to find out the device number (which is unique,
> > > > but not persistent)
> > > 
> > > Is it really unique over time? (Can't a given st_dev value map to one
> > > filesystem now, and another later?) 
> > 
> > It's unique at a single point in time.  But if you have a reference
> > (e.g. open file descriptor) on the mount then that's not a problem.
> > 
> >    fd = open(path, ...);
> >    fstat(fd, &st);
> >    search st.st_dev in mountinfo
> >    close(fd)
> > 
> > is effectively the same as an getuuid(path) syscall (lazy unmounted
> > filesystems will not be found in mountinfo, but the reference is still
> > there so st_dev will not be reused for other filesystems).
> 
> OK, cool.
> 
> That still leaves the problem that there isn't always an underlying
> block device, and/or when there is it doesn't always uniquely specify
> the filesystem.

It doesn't matter if there is an underlying block device, or if it is shared
among subvolmes.
st_dev is *the* primary key for filesystems.  Every "struct super_block" has a
unquie s_dev and that is returned in st_dev.

For "traditional" filesystem, this is the major/minor number of the block
device.
For NFS and btrfs and other filesystems which don't have exclusive use of a
block device, 'set_anon_super' is used to get a unique s_dev based on a major
number of '0'.

So you can *always* use st_dev as an identifier for the filesystem which is
stable and unique as long as you hold an active reference to the filesystem
(open file descriptor, cwd in fs, etc).

If you poll(2) /proc/mounts to get notifications of changes to the mount
table, then it should be quite easy to cache st-dev -> uuid mappings in a
race-free way.

There might be value in getting name_to_handle to return the st_dev of the
target file to ensure that you haven't unexepected crossed into a different
filesystem.  I would prefer that to returning a uuid:  st_dev is guaranteed
to be unique, a uuid is only supposed to be unique (i.e. that is not
enforced).

NeilBrown
