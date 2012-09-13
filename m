Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2IMARk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:17:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49986 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab2IMARg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:17:36 -0400
MIME-Version: 1.0
X-Originating-IP: [121.44.88.132]
In-Reply-To: <CAOzFzEhfoCpGCy0n5cu60xz+tSbB26g1f2ztcD1DwZOY-6aTwQ@mail.gmail.com>
References: <20120905100724.GA27527@soda.linbit>
	<20120906212952.GP29092@google.com>
	<20120907084221.GD7028@soda.linbit>
	<20120910225442.GE7677@google.com>
	<20120910230654.GF7677@google.com>
	<20120910233159.GE19739@google.com>
	<20120911155820.74f1f918@notabene.brown>
	<20120911082501.GH7028@soda.linbit>
	<20120912185824.GS7677@google.com>
	<CAOzFzEjCf7ZPbheq-tfhts-E=Ep1kvn0muksaaTFqJ=cMm772w@mail.gmail.com>
	<20120912232019.GW7677@google.com>
	<CAOzFzEhfoCpGCy0n5cu60xz+tSbB26g1f2ztcD1DwZOY-6aTwQ@mail.gmail.com>
Date: Thu, 13 Sep 2012 10:17:35 +1000
Message-ID: <CAOzFzEhU6Y2hbRKU9qdFbtx_A-+wgs14E8Xza107G+z7uHzs_w@mail.gmail.com>
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2012 09:53, Joseph Glanville
<joseph.glanville@orionvm.com.au> wrote:
> On 13 September 2012 09:20, Tejun Heo <tj@kernel.org> wrote:
>> On Thu, Sep 13, 2012 at 09:12:25AM +1000, Joseph Glanville wrote:
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index 4b4dbdf..68b5671 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -1809,6 +1809,9 @@ EXPORT_SYMBOL(generic_make_request);
>>>   * uses that function to do most of the work. Both are fairly rough
>>>   * interfaces; @bio must be presetup and ready for I/O.
>>>   *
>>> + * Ordering of requests is not guaranteed, callers should drain the queue
>>> + * and issue a flush before submission of any dependent bios.
>>
>> I think using "requests" here is confusing given that struct request
>> means something else in the block layer.  Also, the caller doesn't
>
> Agreed, my bad.
>
>> have to drain the whole queue but just the ones involved in the
>> dependency and flush doesn't really matter here although mentioning
>> that flush too doesn't have any ordering guarantee would be nice.
>
> Will do.
> Would you prefer it being added to the top of the file describing the
> semantics or the blkdev_issue_flush function itself?
>
>> Also, updating submit_bio() comment too would be nice - something
>> simple about lack of ordering and then reference to
>> generic_make_request().
>
> Will do.
>
>>
>> Thanks.
>>
>> --
>> tejun
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..b3559d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1749,6 +1749,11 @@ end_io:
  * bio happens to be merged with someone else, and may resubmit the bio to
  * a lower device by calling into generic_make_request recursively, which
  * means the bio should NOT be touched after the call to ->make_request_fn.
+ *
+ * Ordering is not guaranteed, callers of generic_make_request()
+ * that require ordering should ensure dependencies are first drained
+ * before submission of dependent bios.
+ *
  */
 void generic_make_request(struct bio *bio)
 {
@@ -1808,6 +1813,7 @@ EXPORT_SYMBOL(generic_make_request);
  * submit_bio() is very similar in purpose to generic_make_request(), and
  * uses that function to do most of the work. Both are fairly rough
  * interfaces; @bio must be presetup and ready for I/O.
+ * Note: submit_bio() doesn't ensure ordering, see generic_make_request()
  *
  */
 void submit_bio(int rw, struct bio *bio)

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
