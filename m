Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2BTBdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:33:08 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:41025 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab2BTBdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:33:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAO6gQU95LNkt/2dsb2JhbABEsiiBCIFzAQEEAScTHCMQCAMYLhQlAyETiAAJuHITi2wMBAoGFBYBCQIJARGDYgIcDxyCSmMElTaTAg
Date: Mon, 20 Feb 2012 12:33:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Nam-Jae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Message-ID: <20120220013301.GB3592@dastard>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
 <20120217191522.GB13870@infradead.org>
 <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDb1s35zgur9SGHR_9r=tSr8ZnC-+DTtTXYgc6H_K68Eb_QEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Just as an administritive note, please don't top-post. It's bad
form and makes it hard to follow threads.
http://idallen.com/topposting.html

There's also a lot of random control characters in your messages
that make quoting hard - can you make sure you are using clean 7-bit
ascii for your messages? ]

On Sat, Feb 18, 2012 at 10:00:11PM +0530, Amit Sahrawat wrote:
> On Sat, Feb 18, 2012 at 12:45 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> Whenever there is a mount/unmount failure - there is a chance of calling the
> >> callbacks functions once - transaction ail mount pointer is destroyed. So, it results
> >> in NULL pointer exception followed by hang. So, before unmount of the log - flush all
> >> the pending buffers.
> >
> >> void
> >> xfs_log_unmount(xfs_mount_t *mp)
> >> {
> >> +	int error = 0;
> >> +	/*
> >> +	 * Make sure all buffers have been flushed and completed before
> >> +	 * unmounting the log.
> >> +	 */
> >> +	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
> >> +	if (error)
> >> +		cmn_err(CE_WARN, "%d busy buffers during log unmount.", error);
> >> +	xfs_wait_buftarg(mp->m_ddev_targp);
> >> +

BTW, this won't compile - cmn_err() doesn't exist anymore.

> > We do exactly that sequence before the xfs_log_unmount_write call on
> > umount. Care to explain what code in xfs_log_unmount_write would
> > require this to be called again?
> 
> There are scenarios which results in the similar problem related
> to flushing. Both related to handling of buffer callbacks after the
> corresponding mount point passed in the transactions is destroyed.
> 
> The first one reported 2 months back (in umount path) which was
> related with the asynchronous callback of buf-iodone handlers being
> called after the freeing up of the mount point in:
> void xfs_log_unmount(xfs_mount_t *mp)
> {
> 	xfs_trans_ail_destroy(mp);
> 	xlog_dealloc_log(mp->m_log);
> }
.....

So the question is, why is the mount failure path leaving stuff
around in the AIL?

".....
XFS (sdb3): Failed to recover EFIs
XFS (sdb3): log mount finish failed
...."

Came from your crash log. So the problem is that the log recovery
code is not cleaning up after a failure and leaving stale recovery
items in the AIL. i.e. xlog_recover_process_efis() is just returning
an error after a recovery failure and not doing any cleanup at all.
EFI recovery uses the AIL, so it's guaranteed to have stuff in the
AIL at this point regardless of success or failure ofthe recovery.
IOWs, it is assuming that an error has caused the filesystem to shut
down and so none of the work it has done will get to disk.

In this case, however, we probably should be be flushing the log and
AIL list in xfs_log_mount_finish() regardless of the error state of
the function - we want all the items on disk and the recovery
process complete before we start doing real work.

Indeed, in the first phase of recovery (xlog_do_recover) we flush
the buftarg on before checking for a shutdown situation. I think we
need to do this flushing in both phases of log recovery regardless
of the error state, and the EFI recovery will also need a log force
before flushing to ensure that the extent free transactions that
recovery runs hit the disk so we can flush the modified metadata
from the AIL....

That then ensures that on either a successful or unsuccessful log
recovery we finish log recovery with an empty AIL and the entirity
of log recovery on disk.  This seems like a much better way to solve
the problem than to try to make the high level mount/unmount code
paper over problems caused by failed log recovery....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
