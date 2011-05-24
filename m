Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab1EXKoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab1EXKog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:44:36 -0400
Date: Tue, 24 May 2011 12:44:22 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Lukas Czerner <lczerner@redhat.com>, Kyungmin Park <kmpark@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <874o4kjtsy.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1105241211100.4028@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com> <201103301706.36214.arnd@arndb.de> <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> <87wrhgk8lp.fsf@devron.myhome.or.jp>
 <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> <87r57ok3fp.fsf@devron.myhome.or.jp> <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> <87mxick0zj.fsf@devron.myhome.or.jp> <alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
 <874o4kjtsy.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, OGAWA Hirofumi wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> >> No, no. Userland will know max-length from statvfs, right? So, let's
> >> assume it is 100 (->f_blocks) * 1024 (->f_bsize).
> >
> > You do not need to know the filesystem size to do the discard, it should
> > be adjusted within the kernel. Just specify ULLONG_MAX as a length. See
> > fstrim tool in util-linux-ng.
> >
> >> 
> >> Now, userland know about max length, 102400, ok? Let's start to trim.
> >> 
> >> Assume, userland want to trim whole. So, userland will specify like
> >> 
> >> 	trim(0, 102400).
> >> 
> >> What happen in kernel actually?
> >> 
> >> Current implement doesn't map blocks. So, in the case of FAT, it adjusts
> >> from 0 to 2 * 1024.
> >> 
> >> So, it trims between 2048 and 102400. The problem is here. FS layout is
> >> actually, 2048 and (102400 + 2048). I.e. actually userland has to do
> >> 
> >> 	trim(2048, 102400 + 2048)
> >> 
> >> to specify whole. How to know 2048?
> >
> > You do not need to know anything in userspace. If you want to trim the
> > whole filesystem you just do trim(0, ULLONG_MAX) - which is what fstrim
> > does when you do not specify range. And you just skip the filesystem
> > metadata obviously, regardless if they are at the beginning of the
> > filesystem or in the middle. Just do whatever you need to do within your
> > filesystem.
> >
> > What we do in ext4 is, that we convert length and start passed in struct
> > fstrim_range into filesystem block units and then get the last
> > allocation group and block offset within that group (we do the same for
> > the start block) and we try to discard free block ranges in from staring
> > block to the last block.
> >
> > It is really not a rocket science and since every filesystem is
> > different and has different internal data structures it is up to you how
> > to do this. And if you shift a block or two, it really does not matter
> > as much since user-land does not know about how the filesystem block are
> > laid out anyway, nor user land knows which are free and which are not.
> >
> > I agree that the interface is a little bit fuzzy, but that is mainly
> > because it is intended to be filesystem independent and we do have a lot
> > of various filesystems, so I wanted it to be as flexibile as it should,
> > hence the start, len in Bytes.
> >
> > Hope it helped.
> 
> No. If you want to trim whole with some chunk like 1GB and periodically
> (IIRC in xfstest), what do? We have to trim until ULLONG_MAX for each
> 1GB?
> 
> Thanks.
> 

What ? No, of course not. As I said, just go through 1G worth of filesystem
blocks skipping metadata. However we do have a special case when we
adjust start and len according to the first data block (which is only
the case of 1024B blocksize).

	if (start < first_data_blk) {
		len -= first_data_blk - start;
		start = first_data_blk;
	}

Which means that we just skip the first block (or whatever first data
block is). And this is the same as skipping metadata.

-Lukas
