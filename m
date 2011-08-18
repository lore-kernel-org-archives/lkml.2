Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1HRPtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:49:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278Ab1HRPtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:49:23 -0400
Date: Thu, 18 Aug 2011 17:49:12 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        achender@linux.vnet.ibm.com, Jens Axboe <jaxboe@fusionio.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: add discard support for loop devices
In-Reply-To: <x497h6aspj1.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1108181743440.3957@dhcp-27-109.brq.redhat.com>
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com> <x497h6aspj1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Aug 2011, Jeff Moyer wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> >> @@ -484,6 +485,29 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
> >>  			}
> >>  		}
> >>  
> >> +		/*
> >> +		 * We use punch hole to reclaim the free space used by the
> >> +		 * image a.k.a. discard. However we do support discard if
> >> +		 * encryption is enabled, because it may give an attacker
> >> +		 * useful information.
> >> +		 */
> >> +		if (bio->bi_rw & REQ_DISCARD) {
> >> +			struct file *file = lo->lo_backing_file;
> >> +			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
> >> +
> >> +			if ((!file->f_op->fallocate) ||
> >> +			    lo->lo_encrypt_key_size) {
> >> +				ret = -EOPNOTSUPP;
> >> +				goto out;
> >> +			}
> >> +			ret = file->f_op->fallocate(file, mode, pos,
> >> +						    bio->bi_size);
> >> +			if (unlikely(ret && ret != -EINVAL &&
> >> +				     ret != -EOPNOTSUPP))
> >> +				ret = -EIO;
> >> +			goto out;
> >> +		}
> >> +
> 
> Seems you missed the bizarre case of configuring a loop device over top
> of a block device.

Wow, that is a bizarre case I did not think about at all. But since it
is so bizarre, do we even care ? The thing is that the only case where
it would make a difference is if the loop device is put on top of block
device which actually supports discard.

In order to fix that I would need to dig out the actual limits for that
device and set that appropriately for the loop device. Is that worth it
? It is not like someone will ever do that (or should) :).

Thanks!
-Lukas

> 
> Cheers,
> Jeff
> 
