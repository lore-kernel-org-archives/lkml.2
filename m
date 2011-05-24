Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1EXJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab1EXJZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:25:25 -0400
Date: Tue, 24 May 2011 11:25:11 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
cc: Kyungmin Park <kmpark@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <87mxick0zj.fsf@devron.myhome.or.jp>
Message-ID: <alpine.LFD.2.00.1105241102200.5457@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de> <AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com> <201103301706.36214.arnd@arndb.de> <BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com> <87wrhgk8lp.fsf@devron.myhome.or.jp>
 <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> <87r57ok3fp.fsf@devron.myhome.or.jp> <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> <87mxick0zj.fsf@devron.myhome.or.jp>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1240518882-1306229114=:5457"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1240518882-1306229114=:5457
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 24 May 2011, OGAWA Hirofumi wrote:

> Kyungmin Park <kmpark@infradead.org> writes:
> 
> >>> It's handled at trim implementation. It just trim the fat aware block.
> >>> Not trim the blocks which fat doesn't know.
> >>> As fat don't use the block 0, 1, it adjust the start block at kernel.
> >>>
> >>> +       if (start < FAT_START_ENT)
> >>> +               start = FAT_START_ENT;
> >>>
> >>> and don't exceed the max cluster size.
> >>>
> >>> +       len = (len > sbi->max_cluster) ? sbi->max_cluster : len;
> >>>
> >>> +       for (count = start; count <= len; count++) {
> >>
> >> Yes. We _adjust_ from 0 to 2 here, so, the end of block also have to be
> >> _adjusted_.
> >>
> >> From other point of view, if userland specified 0 - max-length
> >> (i.e. number of blocks), what happens? It would trim block of 2 -
> >> (max-length - 2), right?
> >
> > No, length is not changed. so max-length is used.
> 
> No, no. Userland will know max-length from statvfs, right? So, let's
> assume it is 100 (->f_blocks) * 1024 (->f_bsize).

You do not need to know the filesystem size to do the discard, it should
be adjusted within the kernel. Just specify ULLONG_MAX as a length. See
fstrim tool in util-linux-ng.

> 
> Now, userland know about max length, 102400, ok? Let's start to trim.
> 
> Assume, userland want to trim whole. So, userland will specify like
> 
> 	trim(0, 102400).
> 
> What happen in kernel actually?
> 
> Current implement doesn't map blocks. So, in the case of FAT, it adjusts
> from 0 to 2 * 1024.
> 
> So, it trims between 2048 and 102400. The problem is here. FS layout is
> actually, 2048 and (102400 + 2048). I.e. actually userland has to do
> 
> 	trim(2048, 102400 + 2048)
> 
> to specify whole. How to know 2048?

You do not need to know anything in userspace. If you want to trim the
whole filesystem you just do trim(0, ULLONG_MAX) - which is what fstrim
does when you do not specify range. And you just skip the filesystem
metadata obviously, regardless if they are at the beginning of the
filesystem or in the middle. Just do whatever you need to do within your
filesystem.

What we do in ext4 is, that we convert length and start passed in struct
fstrim_range into filesystem block units and then get the last
allocation group and block offset within that group (we do the same for
the start block) and we try to discard free block ranges in from staring
block to the last block.

It is really not a rocket science and since every filesystem is
different and has different internal data structures it is up to you how
to do this. And if you shift a block or two, it really does not matter
as much since user-land does not know about how the filesystem block are
laid out anyway, nor user land knows which are free and which are not.

I agree that the interface is a little bit fuzzy, but that is mainly
because it is intended to be filesystem independent and we do have a lot
of various filesystems, so I wanted it to be as flexibile as it should,
hence the start, len in Bytes.

Hope it helped.

Thanks!
-Lukas

> 
> See what I'm saying?
> 
> FAT has liner block space, so the problem is small against mapping. But
> other FSes has bigger problem.
> 
> Thanks.
> 

-- 
--8323328-1240518882-1306229114=:5457--
