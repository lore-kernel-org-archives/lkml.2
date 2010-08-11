Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HKN21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 09:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336Ab0HKN20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 09:28:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous requests
References: <4C5BE8DB.5030503@linux.vnet.ibm.com>
	<20100806120358.GA31601@infradead.org>
	<4C5D0BC2.1040706@linux.vnet.ibm.com>
	<x49ocdab9bt.fsf@segfault.boston.devel.redhat.com>
	<20100811015552.GC9349@dhcp231-156.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 11 Aug 2010 09:27:45 -0400
In-Reply-To: <20100811015552.GC9349@dhcp231-156.rdu.redhat.com> (Josef Bacik's
	message of "Tue, 10 Aug 2010 21:55:52 -0400")
Message-ID: <x49zkwtb7ou.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik <josef@redhat.com> writes:

> So say blocksize of 4k, we do dio to 12k, the first time around
> dio->block_in_file is 0, we set dio->cur_page, and move on to the next page, and
> bio->block_in_file is set to 1.  We find that dio->cur_page is set, so we do
> dio_send_cur_page().  Since !dio->bio we create a new bio, and set
> dio->logical_offset_in_bio to 0, since thats the offset of dio->cur_page.  Then
> we setup the next cur_page as the page for logical block 1, and
> dio->block_in_file gets bumped to 2.  We map the next block and come into
> dio_send_cur_page() again.  At this point cur_offset would be 8192...and shit I
> just realized what was wrong.  If you change
>
> loff_t cur_offset = dio->block_in_file << dio->blkbits;
>
> to
>
> loff_t cur_offset = dio->cur_page_fs_offset << dio->blkbits;

Sorry, I wasn't very clear in my description, but you figured it out.
;-)  Of course, cur_page_fs_offset is already in bytes, so that left
shift is not necessary.

> That should fix the problem.  Sorry guys, I screwed that up.  I'll look at this
> again tomorrow after I've had my 2 hours of sleep and see if this all still
> makes sense, but I think the above should fixe the performance thing.  As for
> the dio->boundary thing, dio_bio_submit() sets dio->boundary to 0, so the same
> bio won't be submitted twice.

While I don't doubt that you are right, I will sleep better at night if
we do an else if.  (To be fair, this ambiguity was not introduced by
you).

I've tested this patch, added printk's and watched blktrace to verify
that we don't split up I/Os.  So long as no one objects, I'll post this
for inclusion in a new thread.

Thanks for looking into it, Josef.

Cheers,
Jeff

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7600aac..445901c 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -632,7 +632,7 @@ static int dio_send_cur_page(struct dio *dio)
 	int ret = 0;
 
 	if (dio->bio) {
-		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t cur_offset = dio->cur_page_fs_offset;
 		loff_t bio_next_offset = dio->logical_offset_in_bio +
 			dio->bio->bi_size;
 
@@ -657,7 +657,7 @@ static int dio_send_cur_page(struct dio *dio)
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		if (dio->boundary)
+		else if (dio->boundary)
 			dio_bio_submit(dio);
 	}
 
