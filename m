Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2BHHcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 02:32:53 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:55444 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2BHHcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 02:32:52 -0500
Date: Wed, 8 Feb 2012 11:35:59 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
Message-ID: <20120208073559.GA3163@tugrik.mns.mnsspb.ru>
References: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
 <CAPXgP11N=8NULMH-o0Us0OuqYpP9sKe9uUKWzE35h1AiRP1Cjg@mail.gmail.com>
 <20120207075553.GB8632@tugrik.mns.mnsspb.ru>
 <CAPXgP10K0umgZco-T37nBsbnKznb6oP4e_k82af7sdvpPNeQJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP10K0umgZco-T37nBsbnKznb6oP4e_k82af7sdvpPNeQJQ@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 11:05:42AM +0100, Kay Sievers wrote:
> On Tue, Feb 7, 2012 at 08:55, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > On Mon, Feb 06, 2012 at 08:45:24PM +0100, Kay Sievers wrote:
> >> On Mon, Feb 6, 2012 at 12:18, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> >> > Recently I've reworked my system not to use udev, but use devtmpfs
> >> > instead and discovered there is no /dev/root symlink in devtmpfs case.
> >> >
> >> > My setup uses /dev/root early to know what is the boot device and then
> >> > do some operations on it like checksumming, etc...
> >> >
> >> > Now when /dev/root is gone the best workaround I could come up with is
> >> > to   grep /proc/partitions for '[hs]d[a-z]1'  but it's ugly and will
> >> > break when there are several block devices attached.
> >> >
> >> > Is it somehow possible to add /dev/root to devtmpfs?
> >>
> >> No, devtmpfs has no business in knowing anything about the rootfs or
> >> who mounted what ans where. I can not create such links.
> >>
> >> The entire concept of /dev/root is flawed anyway, and nothing should
> >> really depend on that.
> >>
> >> Modern filesystems will not offer a direct relation to a single block
> >> device, they allocate an superblock which has a major == 0, so there
> >> can be by definition never such a link. Better get rid of all uses of
> >> /dev/root, it will just fail in the future.
> >
> > Kay, thanks for explanation.
> >
> > Though now I'm confused about how to know on what "place" root
> > filesystem was mounted... To me the question makes sense, but you say
> > with modern filesystems there by definition is no answer (or did I
> > misunderstood you?) Strange...
> 
> The root filesystem will still be mounted at /, but you can not
> identify by a device. Check the difference between:
>   $ mountpoint -d /
>   8:1
> which is a classic ext4 sda1 device behind "/".
> 
> With 'btrfs' it will just look like 'tmpfs' looks today:
>   $ mountpoint -d /dev/shm
>   0:17
> 
> and while the 'btrfs' file system is surely backed by a
> disk/partition, just like ext4 is, there can still never be a symlink
> to the disk device.

Kay, thanks again for explanation.

I understand that in case filesystems allocate major 0 there could not
be a well-defined /dev/root, but I don't understand the rationale for
doing so.

Maybe allocating major=0 is a good thing, but look at it this way:

"On what disk/partition was / mounted?" is a well-defined question for
cases when backing store is local hdd, so there should be well-defined
answer.

Previously it was /dev/root, but if /dev/root is not good there should be
some other way for getting the answer. With ext2 I've switched to
`mountpoint -d /` and then grepping major/minor in /proc/partitions, but
with major=0 case I suspect this won't work.


My use case is to check md5 sum of mbr + bootloader area +
root-partition early right after the boot, to verify whether software is
not corrupt, and for doing so it was useful to know / -> root-partition
-> whole block device. It's not tivo, just checking for medium damage. (I
understand this would be better done in the early bootloader but that
part is out of my control)



Sorry for maybe repeating myself and thanks again,
Kirill
