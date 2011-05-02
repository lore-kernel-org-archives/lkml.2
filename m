Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1EBRHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 13:07:25 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:36122 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab1EBRHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 13:07:23 -0400
X-ASG-Debug-ID: 1304353401-03d6a50f2b05640001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DBEDA78.7020502@fusionio.com>
Date: Mon, 2 May 2011 10:23:20 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 1/3] blkdev: Submit discard bio in batches in  blkdev_issue_discard()
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 1/3] blkdev: Submit discard bio in batches in  blkdev_issue_discard()
In-Reply-To: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail0.int.fusionio.com[10.101.1.20]
X-Barracuda-Start-Time: 1304353401
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.62573
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-02 08:17, Lukas Czerner wrote:
> Currently we are waiting for every submitted REQ_DISCARD bio separately,
> but it can have unwanted consequences of repeatedly flushing the queue,
> so we rather submit bios in batches and wait for the entire batch, hence
> narrowing the window of other ios going in.
> 
> Use bio_batch_end_io() and struct bio_batch for that purpose, the same
> is used by blkdev_issue_zeroout(). Also change bio_batch_end_io() so we
> always set !BIO_UPTODATE in the case of error and remove the check for
> bb, since we are the only user of this function and we always set this.
> 
> Remove bio_get()/bio_put() from the blkdev_issue_discard() since
> bio_alloc() and bio_batch_end_io() is doing the same thing, hence it is
> not needed anymore.
> 
> I have done simple dd testing with surprising results. The script I have
> used is:
> 
> for i in $(seq 10); do
>         echo $i
>         dd if=/dev/sdb1 of=/dev/sdc1 bs=4k &
>         sleep 5
> done
> /usr/bin/time -f %e ./blkdiscard /dev/sdc1
> 
> Running time of BLKDISCARD on the whole device:
> with patch              without patch
> 0.95                    15.58
> 
> So we can see that in this artificial test the kernel with the patch
> applied is approx 16x faster in discarding the device.

Good results. It'd be more efficient to add the vectored discard support
and use it for this too though, and it would get rid of the need to wait
on the batches since there'd be just one discard bio for the ranges.

-- 
Jens Axboe

