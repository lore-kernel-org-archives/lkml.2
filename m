Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab2CUMO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:14:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2CUMOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:14:51 -0400
Message-ID: <4F69C62C.7020604@kernel.org>
Date: Wed, 21 Mar 2012 20:14:36 +0800
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk
CC: linux-kernel@vger.kernel.org, neilb@suse.de, martin.petersen@oracle.com
Subject: [patch 1/2]block: handle merged discard request
References: <20120316073213.656519005@fusionio.com> <20120316073512.485027511@fusionio.com> <20120320162157.GE17071@redhat.com> <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
In-Reply-To: <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/12 9:22 AM, Shaohua Li wrote:
> 2012/3/21 Vivek Goyal<vgoyal@redhat.com>:
>> On Fri, Mar 16, 2012 at 03:32:15PM +0800, Shaohua Li wrote:
>>> Didn't allow discard request merge temporarily, as SCSI layer isn't ready
>>> for discard merge as Martin Petersen pointed out. This isn't fair for
>>> non-scsi device, but looks this is the only way I can do currently.
>>>
>>> We should have the same issue before, but maybe because discard merge is
>>> very rare case. But now raid0/10 makes the merge quite possible, so we need
>>> disable it explicitly.
>> I think you will need to do little more cleanup to make discard
>> unmergeable.
>>
>> - Change rq_mergeable(rq)
>> - Change attempt_merge() and get rid of special conditions of allowing
>>   discard merge.
>>
>> Martin had a bigger patch where he wanted to cleanup many discard specific
>> condition checks.
>>
>> As you are just focusing on disabling merging for discard requests, you
>> might as well just pick the relevant pieces from the patch.
>>
>> http://www.spinics.net/lists/linux-scsi/msg57779.html
> Thanks for pointing out the thread. I didn't think disabling discard merging
> permanently is a good idea. We can't do the merge because that code isn't
> ready (actually just for driver of SCSI). Enabling discard merge is required
> for device with slow discard (and very helpful for raid), so I just want a
> temporarily disabling for the merge. Just changing RQ_NOMERGE_FLAGS
> is an easy workaround for this goal.
I looked at the SCSI code for discard again, looks we can easily make 
discard
mergeable. It's a little hacky (the whole SCSI discard implementation is 
hacky
actually), but quite simple and end the trouble of discard merge 
immediately.

Thanks,
Shaohua


The SCSI discard implementation hacks the first bio of request to
add payload, which makes blk_update_request() can't correctly mark
bios finish.
The patch solves it. We set discard bio size to 0 and finish it after
the hacked payload finishes. The check in blk_update_request() should
make us safe.
It's a little hack here (but the whole discard implementation of SCSI
is hacky) and this makes us have discard request merge immediately,
which is great for some SSDs with slow discard.

Signed-off-by: Shaohua Li <shli@fusionio.com>

---
  block/blk-core.c |   11 +++++++++--
  1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2012-03-21 17:58:07.322320702 +0800
+++ linux/block/blk-core.c	2012-03-21 18:04:34.662320467 +0800
@@ -1177,7 +1177,7 @@ EXPORT_SYMBOL(blk_put_request);
  void blk_add_request_payload(struct request *rq, struct page *page,
  		unsigned int len)
  {
-	struct bio *bio = rq->bio;
+	struct bio *bio = rq->bio, *next = bio->bi_next;

  	bio->bi_io_vec->bv_page = page;
  	bio->bi_io_vec->bv_offset = 0;
@@ -1187,6 +1187,11 @@ void blk_add_request_payload(struct requ
  	bio->bi_vcnt = 1;
  	bio->bi_phys_segments = 1;

+	while (next) {
+		next->bi_size = 0;
+		next = next->bi_next;
+	}
+
  	rq->__data_len = rq->resid_len = len;
  	rq->nr_phys_segments = 1;
  	rq->buffer = bio_data(bio);
@@ -2185,8 +2190,10 @@ bool blk_update_request(struct request *
  		if (bio) {
  			/*
  			 * end more in this run, or just return 'not-done'
+			 * The discard check is a hack, see blk_add_request_payload
  			 */
-			if (unlikely(nr_bytes <= 0))
+			if (unlikely(nr_bytes <= 0 &&
+			   !((req->cmd_flags & REQ_DISCARD) && bio->bi_size == 0)))
  				break;
  		}
  	}
