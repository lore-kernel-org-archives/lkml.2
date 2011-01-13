Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1AMFi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:38:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62590 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1AMFi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:38:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Pc4Xp+kP/oOlYE7x6kOqfh4IufR7srXFRAbuiTsmu8SQ4ilWYOqbulb2D6hsoRj024
         R63M9ZpIi34FBP8CLK2AAuCvDizHlMF8zLxWS4NGDx3/6Jhk5QuU0mVgAVUHMYgyQ6f4
         IEu5nr/FWxWAL3CvO25Ii9RRgko0p+EeEMCD8=
MIME-Version: 1.0
In-Reply-To: <20110113025646.GB27381@tux1.beaverton.ibm.com>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
Date: Thu, 13 Jan 2011 13:38:55 +0800
X-Google-Sender-Auth: 948wE7vH_KLFYSQ7wwnAIg6GR1E
Message-ID: <AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
From: Shaohua Li <shli@kernel.org>
To: djwong@us.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/13 Darrick J. Wong <djwong@us.ibm.com>:
> On certain types of storage hardware, flushing the write cache takes a
> considerable amount of time.  Typically, these are simple storage systems with
> write cache enabled and no battery to save that cache during a power failure.
> When we encounter a system with many I/O threads that try to flush the cache,
> performance is suboptimal because each of those threads issues its own flush
> command to the drive instead of trying to coordinate the flushes, thereby
> wasting execution time.
>
> Instead of each thread initiating its own flush, we now try to detect the
> situation where multiple threads are issuing flush requests.  The first thread
> to enter blkdev_issue_flush becomes the owner of the flush, and all threads
> that enter blkdev_issue_flush before the flush finishes are queued up to wait
> for the next flush.  When that first flush finishes, one of those sleeping
> threads is woken up to perform the next flush and then wake up the other
> threads which are asleep waiting for the second flush to finish.
>
> In the single-threaded case, the thread will simply issue the flush and exit.
>
> To test the performance of this latest patch, I created a spreadsheet
> reflecting the performance numbers I obtained with the same ffsb fsync-happy
> workload that I've been running all along:  http://tinyurl.com/6xqk5bs
>
> The second tab of the workbook provides easy comparisons of the performance
> before and after adding flush coordination to the block layer.  Variations in
> the runs were never more than about 5%, so the slight performance increases and
> decreases are negligible.  It is expected that devices with low flush times
> should not show much change, whether the low flush times are due to the lack of
> write cache or the controller having a battery and thereby ignoring the flush
> command.
>
> Notice that the elm3b231_ipr, elm3b231_bigfc, elm3b57, elm3c44_ssd,
> elm3c44_sata_wc, and elm3c71_scsi profiles showed large performance increases
> from flush coordination.  These 6 configurations all feature large write caches
> without battery backups, and fairly high (or at least non-zero) average flush
> times, as was discovered when I studied the v6 patch.
>
> Unfortunately, there is one very odd regression: elm3c44_sas.  This profile is
> a couple of battery-backed RAID cabinets striped together with raid0 on md.  I
> suspect that there is some sort of problematic interaction with md, because
> running ffsb on the individual hardware arrays produces numbers similar to
> elm3c71_extsas.  elm3c71_extsas uses the same type of hardware array as does
> elm3c44_sas, in fact.
>
> FYI, the flush coordination patch shows performance improvements both with and
> without Christoph's patch that issues pure flushes directly.  The spreadsheet
> only captures the performance numbers collected without Christoph's patch.
Hi,
can you explain why there is improvement with your patch? If there are
multiple flush, blk_do_flush already has queue for them (the
->pending_flushes list).

Thanks,
Shaohua
