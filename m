Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab0IFLQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:16:02 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:64980 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab0IFLP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:15:59 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=WmGn_9qA2HUA:10 a=VphdPIyG4kEA:10 a=kj9zAlcOel0A:10
 a=xqWC_Br6kY4A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VwQbUJbxAAAA:8
 a=vGfRG_00iZch5qZIXHAA:9 a=E0i9NoyfmMIpKASjyOsA:7
 a=Vuty1Q72ZS78fkjJD6upDRGVAuUA:4 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10
Subject: Re: [PATCH 24.5/30] jbd2: Modify ASYNC_COMMIT code to not rely on queue draining on barrier
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4C762476.2020802@suse.de>
Date: Mon, 6 Sep 2010 13:15:52 +0200
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com
Content-Transfer-Encoding: 8BIT
Message-Id: <08ADE50E-9B33-4834-B08A-AD342D63D1F9@dilger.ca>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <4C762476.2020802@suse.de>
To: Tejun Heo <teheo@suse.de>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-26, at 10:23, Tejun Heo wrote:
> From 49f4cef00a1bd3c79fb2fe1f982c5157f0792867 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> 
> Currently JBD2 relies blkdev_issue_flush() draining the queue when ASYNC_COMMIT
> feature is set. This property is going away so make JBD2 wait for buffers it
> needs on its own before submitting the cache flush.

I finally had a chance to look at this patch more closely, and I think it may be breaking the ASYNC_COMMIT functionality, by forcing a wait for all of the data blocks _before_ the journal commit block is even submitted, even though ASYNC_COMMIT is enabled.

When ASYNC_COMMIT is enabled, it means that the journal transaction coherency is handled by the commit block checksum of the transaction data blocks, so the commit block can be submitted to the journal at the same time as the transaction data blocks.  The flush on the journal device (and the filesystem device, if they are separate) should happen after both are submitted.

However, if ASYNC_COMMIT is NOT enabled, then the transaction data blocks should be submitted and flushed before the journal commit block is submitted, and then there should be a second cache flush afterward.

---
> This patch is necessary before enabling flush/fua support in jbd2.
> The flush-fua git tree has been udpated to included this between patch
> 24 and 25.
> 
> Thanks.
> 
> fs/jbd2/commit.c |   29 ++++++++++++++++-------------
> 1 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 7c068c1..8797fd1 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -701,6 +701,16 @@ start_journal_io:
> 		}
> 	}
> 
> +	err = journal_finish_inode_data_buffers(journal, commit_transaction);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"JBD2: Detected IO errors while flushing file data "
> +		       "on %s\n", journal->j_devname);
> +		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
> +			jbd2_journal_abort(journal, err);
> +		err = 0;
> +	}
> +
> 	/*
> 	 * If the journal is not located on the file system device,
> 	 * then we must flush the file system device before we issue
> @@ -719,19 +729,6 @@ start_journal_io:
> 						 &cbh, crc32_sum);
> 		if (err)
> 			__jbd2_journal_abort_hard(journal);
> -		if (journal->j_flags & JBD2_BARRIER)
> -			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
> -				BLKDEV_IFL_WAIT);
> -	}
> -
> -	err = journal_finish_inode_data_buffers(journal, commit_transaction);
> -	if (err) {
> -		printk(KERN_WARNING
> -			"JBD2: Detected IO errors while flushing file data "
> -		       "on %s\n", journal->j_devname);
> -		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
> -			jbd2_journal_abort(journal, err);
> -		err = 0;
> 	}
> 
> 	/* Lo and behold: we have just managed to send a transaction to
> @@ -845,6 +842,12 @@ wait_for_iobuf:
> 	}
> 	if (!err && !is_journal_aborted(journal))
> 		err = journal_wait_on_commit_record(journal, cbh);
> +	if (JBD2_HAS_INCOMPAT_FEATURE(journal,
> +				      JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT) &&
> +	    journal->j_flags & JBD2_BARRIER) {
> +			blkdev_issue_flush(journal->j_dev, GFP_KERNEL, NULL,
> +				BLKDEV_IFL_WAIT);
> +	}
> 
> 	if (err)
> 		jbd2_journal_abort(journal, err);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





