Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0KIKfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:35:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:45565 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab0KIKf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:35:28 -0500
Message-ID: <4CD9239E.2080209@kernel.org>
Date: Tue, 09 Nov 2010 11:34:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, petero2@telia.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, joel.becker@oracle.com, aelder@sgi.com,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com, neilb@suse.de,
        leochen@broadcom.com, sbranden@broadcom.com, chris.mason@oracle.com,
        swhiteho@redhat.com, shaggy@linux.vnet.ibm.com, joern@logfs.org,
        konishi.ryusuke@lab.ntt.co.jp, reiserfs-devel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 4/5] block: make blkdev_get/put() handle exclusive access
References: <1288628129-12811-1-git-send-email-tj@kernel.org> <1288628129-12811-5-git-send-email-tj@kernel.org> <20101103161059.GA13621@infradead.org>
In-Reply-To: <20101103161059.GA13621@infradead.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Nov 2010 10:34:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/03/2010 05:10 PM, Christoph Hellwig wrote:
> On Mon, Nov 01, 2010 at 05:15:28PM +0100, Tejun Heo wrote:
>> * blkdev_get() is extended to include exclusive access management.
>>   @holder argument is added and, if is @FMODE_EXCL specified, it will
>>   gain exclusive access atomically w.r.t. other exclusive accesses.
>>
>> * blkdev_put() is similarly extended.  It now takes @mode argument and
>>   if @FMODE_EXCL is set, it releases an exclusive access.  Also, when
>>   the last exclusive claim is released, the holder/slave symlinks are
>>   removed automatically.
> 
> Could we get rid of FMODE_EXCL and just make a non-NULL holder field
> mean to open it exlusively (and pass a holder to the blkdev_put to
> release it)?

Yeah, I agree it's a bit awkward.  I'd really like to force one way or
the other tho.  ie. if non-NULL holder is gonna be required, I'll add
WARN_ON_ONCE(mode & FMODE_EXCL).  There are several issues to
consider.

* As Jan suggested, @mode in blkdev_put() isn't too useful.  I decided
  to keep it and use FMODE_EXCL for exclusive releases as that it is
  at least useful for something.  If we're gonna add @holder to
  blkdev_put(), it would make more sense to drop @mode.  It's not like
  there's a way to enforce restrictions according to open @mode during
  device access if there are mixed r/w opens.

* Some users don't keep @holder easily accessible until blkdev_put()
  is called, so the conversion will take a bit more effort.  No big
  deal in itself.

* What if @holder on blkdev_put() mismatches the current holder?
  Probably WARN_ON_ONCE() is the only recourse.  At that point, it's a
  bit silly to have to keep @holder around till blkdev_put().  Holders
  and opners counting already provide meaningful warning mechanism
  against spurious or missing exclusive releases.  Maybe we can have
  blkdev_put() and blkdev_put_exclusive()?  Or make it take boolean
  @excl?

So, after the above points, I decided to keep @mode.  It is a bit
awkward but the other way didn't seem too hip either.  Any better
ideas?

>> * bd_link_disk_holder() remains the same but bd_unlink_disk_holder()
>>   is no longer necessary and removed.
> 
> That's a rather asymetric interface.  What about having
> blkdev_get_stacked that require a gendisk as holder and set up the
> links underneath?

That will make the number of functions multiplied by two -
blkdev_get_by_path_stacked() and blkdev_get_by_dev_stacked().  The
symlinking for stacked drivers is an oddball feature which is and will
be only used by md and dm.  So, I think it's better to keep it
separate and oddball.

>> open_bdev_exclusive() and open_by_devnum() can use further cleanup -
>> rename to blkdev_get_by_path() and blkdev_get_by_devt() and drop
>> special features.  Well, let's leave them for another day.
> 
> s/blkdev_get_by_devt/blkdev_get_by_dev/
> 
> And yes, that rename is a good idea and should go in ASAP after this
> patch.

Alright, will do it.

Thanks.

-- 
tejun
