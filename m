Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab0HWOGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:06:25 -0400
Received: from verein.lst.de ([213.95.11.210]:40131 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab0HWOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:06:22 -0400
Date: Mon, 23 Aug 2010 16:05:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net,
        jack@suse.cz, rwheeler@redhat.com, hare@suse.de
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Message-ID: <20100823140551.GA23051@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C726B55.80503@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C726B55.80503@kernel.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0.001 () BAYES_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is an updated version of the documentation.  It fixes several
typos Zach Brown noticed and replaces all references to a physical
medium with the term non-volatile storage.  I haven't added any examples
yet as I need to figure how they fit into the rest of the document.

---

Explicit volatile write cache control
=====================================

Introduction
------------

Many storage devices, especially in the consumer market, come with volatile
write back caches.  That means the devices signal I/O completion to the
operating system before data actually has hit the non-volatile storage.  This
behavior obviously speeds up various workloads, but it means the operating
system needs to force data out to the non-volatile storage when it performs
a data integrity operation like fsync, sync or an unmount.

The Linux block layer provides two simple mechanism that lets filesystems
control the caching behavior of the storage device.  These mechanisms are
a forced cache flush, and the Force Unit Access (FUA) flag for requests.


Explicit cache flushes
----------------------

The REQ_FLUSH flag can be OR ed into the r/w flags of a bio submitted from
the filesystem and will make sure the volatile cache of the storage device
has been flushed before the actual I/O operation is started.  This explicitly
guarantees that previously completed write requests are on non-volatile
storage before the flagged bio starts. In addition the REQ_FLUSH flag can be
set on an otherwise empty bio structure, which causes only an explicit cache
flush without any dependent I/O.  It is recommend to use
the blkdev_issue_flush() helper for a pure cache flush.


Forced Unit Access
-----------------

The REQ_FUA flag can be OR ed into the r/w flags of a bio submitted from the
filesystem and will make sure that I/O completion for this requests is only
signaled after the data has been commited to non-volatile storage.


Implementation details for filesystems
--------------------------------------

Filesystem can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
worry if the underlying devices need any explicit cache flushing and how
the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
may both be set on a single bio.


Implementation details for make_request_fn based block drivers
--------------------------------------------------------------

These drivers will always see the REQ_FLUSH and REQ_FUA bits as they sit
directly below the submit_bio interface.  For remapping drivers the REQ_FUA
bits need to be propagated to underlying devices, and a global flush needs
to be implemented for bios with the REQ_FLUSH bit set.  For real device
drivers that do not have a volatile cache the REQ_FLUSH and REQ_FUA bits
on non-empty bios can simply be ignored, and REQ_FLUSH requests without
data can be completed successfully without doing any work.  Drivers for
devices with volatile caches need to implement the support for these
flags themselves without any help from the block layer.


Implementation details for request_fn based block drivers
--------------------------------------------------------------

For devices that do not support volatile write caches there is no driver
support required, the block layer completes empty REQ_FLUSH requests before
entering the driver and strips off the REQ_FLUSH and REQ_FUA bits from
requests that have a payload.  For devices with volatile write caches the
driver needs to tell the block layer that it supports flushing caches by
doing:

	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH);

and handle empty REQ_FLUSH requests in its prep_fn/request_fn.  Note that
REQ_FLUSH requests with a payload are automatically turned into a sequence
of empty REQ_FLUSH and the actual write by the block layer.  For devices
that also support the FUA bit the block layer needs to be told to pass
through that bit using:

	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH | REQ_FUA);

and handle write requests that have the REQ_FUA bit set properly in its
prep_fn/request_fn.  If the FUA bit is not natively supported the block
layer turns it into an empty REQ_FLUSH request after the actual write.
