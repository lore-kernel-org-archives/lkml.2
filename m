Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1CGKKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:10:08 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57410 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1CGKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:10:05 -0500
Message-ID: <4D74AEF9.7050108@linux.vnet.ibm.com>
Date: Mon, 07 Mar 2011 11:10:01 +0100
From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>, akpm@linux-foundation.org, snitzer@redhat.com
CC: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, cotte@de.ibm.com,
        ehrhardt@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] dm: improve read performance
References: <201012271219.56476.mume@linux.vnet.ibm.com> <20101227225459.5a5150ab@notabene.brown> <201012271323.13406.mume@linux.vnet.ibm.com>
In-Reply-To: <201012271323.13406.mume@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2010 01:23 PM, Mustafa Mesanovic wrote:
> On Mon December 27 2010 12:54:59 Neil Brown wrote:
>> On Mon, 27 Dec 2010 12:19:55 +0100 Mustafa Mesanovic
>>
>> <mume@linux.vnet.ibm.com>  wrote:
>>> From: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
>>>
>>> A short explanation in prior: in this case we have "stacked" dm devices.
>>> Two multipathed luns combined together to one striped logical volume.
>>>
>>> I/O throughput degradation happens at __bio_add_page when bio's get
>>> checked upon max_sectors. In this setup max_sectors is always set to 8
>>> ->  what is 4KiB.
>>> A standalone striped logical volume on luns which are not multipathed do
>>> not have the problem: the logical volume will take over the max_sectors
>>> from luns below.
[...]

>>> Using the patch improves read I/O up to 3x. In this specific case from
>>> 600MiB/s up to 1800MiB/s.
>> and using this patch will cause IO to fail sometimes.
>> If an IO request which is larger than a page crosses a device boundary in
>> the underlying e.g. RAID0, the RAID0 will return an error as such things
>> should not happen - they are prevented by merge_bvec_fn.
>>
>> If merge_bvec_fn is not being honoured, then you MUST limit requests to a
>> single entry iovec of at most one page.
>>
>> NeilBrown
>>
> Thank you for that hint, I will try to write a merge_bvec_fn for dm-stripe.c
> which solves the problem, if that is ok?
>
> Mustafa Mesanovic
>
Now here my new suggestion to fix this issue, what is your opinion?
I tested this with different setups, and it worked fine and I had
very good performance improvements.

[RFC][PATCH] dm: improve read performance - v2

This patch adds a merge_fn for the dm stripe target. This merge_fn
prevents dm_set_device_limits() setting the max_sectors to 4KiB
(PAGE_SIZE). (As in a prior patch already mentioned.)
Now the read performance improved up to 3x higher compared to before.

What happened before:
I/O throughput degradation happened at __bio_add_page() when bio's got checked
at the very beginning upon max_sectors. In this setup max_sectors is always
set to 8. So bio's entered the dm target with a max of 4KiB.

Now dm-stripe target will have its own merge_fn so max_sectors will not
pushed down to 8 (4KiB), and bio's can get bigger than 4KiB.

Signed-off-by: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
---

  dm-stripe.c |   24 ++++++++++++++++++++++++
  1 file changed, 24 insertions(+)

Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2011-02-28 10:23:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-stripe.c	2011-02-28 10:24:29.000000000 +0100
@@ -396,6 +396,29 @@
  	blk_limits_io_opt(limits, chunk_size * sc->stripes);
  }

+static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	sector_t offset, chunk;
+	uint32_t stripe;
+	struct request_queue *q;
+
+	offset = bvm->bi_sector - ti->begin;
+	chunk = offset>>  sc->chunk_shift;
+	stripe = sector_div(chunk, sc->stripes);
+
+	if (!bdev_get_queue(sc->stripe[stripe].dev->bdev)->merge_bvec_fn)
+			return max_size;
+
+	bvm->bi_bdev = sc->stripe[stripe].dev->bdev;
+	q = bdev_get_queue(bvm->bi_bdev);
+	bvm->bi_sector = sc->stripe[stripe].physical_start +
+			(chunk<<  sc->chunk_shift) + (offset&  sc->chunk_mask);
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
  static struct target_type stripe_target = {
  	.name   = "striped",
  	.version = {1, 3, 1},
@@ -403,6 +426,7 @@
  	.ctr    = stripe_ctr,
  	.dtr    = stripe_dtr,
  	.map    = stripe_map,
+	.merge  = stripe_merge,
  	.end_io = stripe_end_io,
  	.status = stripe_status,
  	.iterate_devices = stripe_iterate_devices,




