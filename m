Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0JMLTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:19:49 -0400
Received: from verein.lst.de ([213.95.11.210]:45395 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab0JMLTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:19:48 -0400
Date: Wed, 13 Oct 2010 13:19:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH 4/5] tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
Message-ID: <20101013111920.GB26366@lst.de>
References: <1286959700-3489-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286959700-3489-1-git-send-email-nab@linux-iscsi.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int iblock_do_discard(struct se_task *task, enum blk_discard_type type)
> +{
> +	struct iblock_dev *ibd = task->se_dev->dev_ptr;
> +	struct block_device *bd = ibd->ibd_bd;
> +	struct se_cmd *cmd = TASK_CMD(task);
> +
> +	if (type == DISCARD_UNMAP)
> +		return transport_generic_unmap(cmd, bd);	
> +	else if (type == DISCARD_WRITE_SAME_UNMAP)
> +		return iblock_emulate_write_same_unmap(task);	
> +	else {
> +		printk(KERN_ERR "Unsupported discard_type_t: %d\n", type);
> +		return -ENOSYS;
> +	}
> +
> +	return -ENOSYS;
> +}
> +

I don't think the discard code is quite, nor nicely structured.

The parsing of the WRITE SAME and UNMAP CDBs is something the generic
CDB parsing code should do, and just give a range of lists of lba/len
pairs to the ->discard method in the backed.  Also your generic
discard helpers aren't actually generic - they require a block device
and thus should be only in iblock.c.  While your hack in the file
backend to use it if we're using a block device as backing file
works it's rather gross.  Having the file backend general enough to
work with a block devices is fine, but adding special hacks that
only work on block device while having a fully working bio based backed
is a bit gross.  Btw, at least on XFS you can implement discard using
hole punch operations, although that can lead to quite bad fragmentation
in cases.  Just as block-level discards can lead to quite bad
performance - I'd suggest to not enable them by default.

One other thing I noticed is that you use igrab a lot.  In general
drivers have absolutely no need for a igrab.  If you have a reference
to the file behind an inode you keep the inode in core and there's no
need at all to grab a second reference to it.
