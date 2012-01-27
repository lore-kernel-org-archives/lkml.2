Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2A0Ifq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:35:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2A0Ifp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:35:45 -0500
Message-ID: <4F2261BF.8040206@redhat.com>
Date: Fri, 27 Jan 2012 09:35:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, mmarek@suse.cz
Subject: Re: Ioctl warning for a partition
References: <20120126223037.GE28368@quack.suse.cz> <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
In-Reply-To: <CA+55aFwkRhsdAYwP-S5_qPkRX=dMSnxv5Ow1ULaSJjKe3aTy2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 12:01 AM, Linus Torvalds wrote:
> I suspect we can just remove the warning entirely - once we've gotten
> enough coverage with the -rc kernels that people (me in particular)
> are happy that no normal load really needs it, and returning an error
> is fine.
>
> So I don't really consider the warning to be something long-term - I
> wanted it to make sure that some random binary in some odd
> distribution wouldn't break in mysterious ways that would take a lot
> of debugging to find. And so that we really know what we end up
> blocking in practice.
>
> I'm not sure how good the -rc kernel coverage is, but I think it's
> good enough that we can drop the warning before doing a real 3.3
> release. And I don't think the stable kernel versions ever got that
> warning printout, did they? That would be great for coverage, of
> course, if they did.

They did.

Here is the list I put together from people who contacted me about the 
warning:

BLKFLSBUF, BLKROSET:
	These two can be passed down to ops->ioctl even though
	they are generic block layer ioctls.  Nothing overrides them
	*and* calls scsi_verify_blk_ioctl so we aren't breaking
	anything.  However, these ioctls are obviously good for
	partitions so we should add them to the whitelist.

CDROM_DRIVE_STATUS, FDGETPRM, MTIOCGET32:
	These three are used for detection of devices that do not
	support	partitions.  They can be handled the same as
	CDROM_GET_CAPABILITY, i.e. we can fail them and not break
	anything.

RAID_VERSION:
	Also used for detection, however (unlike floppies and CD-ROMs)
	RAID devices do have partitions.  RAID partitions do not
	support SCSI ioctls and thus do not call scsi_verify_blk_ioctl,
	which means we can fail this one right away too.

I was preparing a patch to update the whitelist, but I think I will wait 
a couple more weeks and remove the warning altogether.

Paolo
