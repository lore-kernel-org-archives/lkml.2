Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1HRPdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:33:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475Ab1HRPdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:33:39 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, achender@linux.vnet.ibm.com,
        Jens Axboe <jaxboe@fusionio.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] loop: add discard support for loop devices
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 18 Aug 2011 11:33:22 -0400
In-Reply-To: <alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com>
	(Lukas Czerner's message of "Wed, 17 Aug 2011 15:13:31 +0200 (CEST)")
Message-ID: <x497h6aspj1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

>> @@ -484,6 +485,29 @@ static int do_bio_filebacked(struct loop_device *lo, struct bio *bio)
>>  			}
>>  		}
>>  
>> +		/*
>> +		 * We use punch hole to reclaim the free space used by the
>> +		 * image a.k.a. discard. However we do support discard if
>> +		 * encryption is enabled, because it may give an attacker
>> +		 * useful information.
>> +		 */
>> +		if (bio->bi_rw & REQ_DISCARD) {
>> +			struct file *file = lo->lo_backing_file;
>> +			int mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
>> +
>> +			if ((!file->f_op->fallocate) ||
>> +			    lo->lo_encrypt_key_size) {
>> +				ret = -EOPNOTSUPP;
>> +				goto out;
>> +			}
>> +			ret = file->f_op->fallocate(file, mode, pos,
>> +						    bio->bi_size);
>> +			if (unlikely(ret && ret != -EINVAL &&
>> +				     ret != -EOPNOTSUPP))
>> +				ret = -EIO;
>> +			goto out;
>> +		}
>> +

Seems you missed the bizarre case of configuring a loop device over top
of a block device.

Cheers,
Jeff
