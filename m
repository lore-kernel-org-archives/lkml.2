Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1CHKaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:30:00 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:58590 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1CHK35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:29:57 -0500
Message-ID: <4D76051E.5060303@linux.vnet.ibm.com>
Date: Tue, 08 Mar 2011 11:29:50 +0100
From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>,
        akpm@linux-foundation.org, dm-devel@redhat.com
CC: cotte@de.ibm.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        ehrhardt@linux.vnet.ibm.com
Subject: Re: [PATCH v3] dm stripe: implement merge method
References: <201012271219.56476.mume@linux.vnet.ibm.com> <20101227225459.5a5150ab@notabene.brown> <201012271323.13406.mume@linux.vnet.ibm.com> <4D74AEF9.7050108@linux.vnet.ibm.com> <20110308022158.GA663@redhat.com>
In-Reply-To: <20110308022158.GA663@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 03:21 AM, Mike Snitzer wrote:
> Hello Mustafa,
>
> On Mon, Mar 07 2011 at  5:10am -0500,
> Mustafa Mesanovic<mume@linux.vnet.ibm.com>  wrote:
>
>> On 12/27/2010 01:23 PM, Mustafa Mesanovic wrote:
>>> On Mon December 27 2010 12:54:59 Neil Brown wrote:
>>>> On Mon, 27 Dec 2010 12:19:55 +0100 Mustafa Mesanovic
>>>>
>>>> <mume@linux.vnet.ibm.com>   wrote:
>>>>> From: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
>>>>>
>>>>> A short explanation in prior: in this case we have "stacked" dm devices.
>>>>> Two multipathed luns combined together to one striped logical volume.
>>>>>
>>>>> I/O throughput degradation happens at __bio_add_page when bio's get
>>>>> checked upon max_sectors. In this setup max_sectors is always set to 8
>>>>> ->   what is 4KiB.
>>>>> A standalone striped logical volume on luns which are not multipathed do
>>>>> not have the problem: the logical volume will take over the max_sectors
>>>> >from luns below.
>> [...]
>>
>>>>> Using the patch improves read I/O up to 3x. In this specific case from
>>>>> 600MiB/s up to 1800MiB/s.
>>>> and using this patch will cause IO to fail sometimes.
>>>> If an IO request which is larger than a page crosses a device boundary in
>>>> the underlying e.g. RAID0, the RAID0 will return an error as such things
>>>> should not happen - they are prevented by merge_bvec_fn.
>>>>
>>>> If merge_bvec_fn is not being honoured, then you MUST limit requests to a
>>>> single entry iovec of at most one page.
>>>>
>>>> NeilBrown
>>>>
>>> Thank you for that hint, I will try to write a merge_bvec_fn for dm-stripe.c
>>> which solves the problem, if that is ok?
>>>
>>> Mustafa Mesanovic
>>>
>> Now here my new suggestion to fix this issue, what is your opinion?
>> I tested this with different setups, and it worked fine and I had
>> very good performance improvements.
>>
>> [RFC][PATCH] dm: improve read performance - v2
>>
>> This patch adds a merge_fn for the dm stripe target. This merge_fn
>> prevents dm_set_device_limits() setting the max_sectors to 4KiB
>> (PAGE_SIZE). (As in a prior patch already mentioned.)
>>
>> Now the read performance improved up to 3x higher compared to before.
>>
>> What happened before:
>> I/O throughput degradation happened at __bio_add_page() when bio's got checked
>> at the very beginning upon max_sectors. In this setup max_sectors is always
>> set to 8. So bio's entered the dm target with a max of 4KiB.
> So to recap:
> - you are stacking dm-stripe on DM multipath devices
> - dm_set_device_limits() will set max_hw_sectors to PAGE_SIZE if:
>    1) q->merge_bvec_fn is defined (as is the case for all DM devices)
>    2) target does not define a merge_fn (as was the case for dm-stripe)
> - dm_merge_bvec (aka DM's q->merge_bvec_fn) will only allow a single
>    page for the situation described in the previous point.
>
>> Now dm-stripe target will have its own merge_fn so max_sectors will not
>> pushed down to 8 (4KiB), and bio's can get bigger than 4KiB.
>>
>> Signed-off-by: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
> Here is a revised version of your patch that uses the relatively new
> stripe_map_sector(), removes an unnecessary cast, and a few other
> cleanups.
>
> This v3 should work as well as your v2 but should be suitable for
> upstream inclusion -- authorship of the change is still attributed to
> you as I only updated the code slightly.  I'd appreciate it if you could
> verify your config still performs as expected.
>
> Thanks,
> 	Mike
>
>
> From: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
>
> When the stripe target's underlying devices provide a merge_bvec_fn
> (e.g. DM) it is important to call down to them when building a biovec
> that doesn't span a stripe boundary.
>
> Without the merge method, a striped DM device stacked on DM devices
> would cause bios with a single page to be submitted.  The small bios
> that were built resulted in unnecessary overhead that hurt performance.
>
> In one setup, striped DM multipath devices, read performance was
> improved from 600MB/s to 1800MB/s.
>
> Signed-off-by: Mustafa Mesanovic<mume@linux.vnet.ibm.com>
> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
> ---
>   drivers/md/dm-stripe.c |   23 ++++++++++++++++++++++-
>   1 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index dddfa14..fdfc1c6 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -396,9 +396,29 @@ static void stripe_io_hints(struct dm_target *ti,
>   	blk_limits_io_opt(limits, chunk_size * sc->stripes);
>   }
>
> +static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
> +			struct bio_vec *biovec, int max_size)
> +{
> +	struct stripe_c *sc = ti->private;
> +	sector_t bvm_sector = bvm->bi_sector;
> +	uint32_t stripe;
> +	struct request_queue *q;
> +
> +	stripe_map_sector(sc, bvm_sector,&stripe,&bvm_sector);
> +
> +	q = bdev_get_queue(sc->stripe[stripe].dev->bdev);
> +	if (!q->merge_bvec_fn)
> +		return max_size;
> +
> +	bvm->bi_bdev = sc->stripe[stripe].dev->bdev;
> +	bvm->bi_sector = sc->stripe[stripe].physical_start + bvm_sector;
> +
> +	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
> +}
> +
>   static struct target_type stripe_target = {
>   	.name   = "striped",
> -	.version = {1, 3, 1},
> +	.version = {1, 3, 2},
>   	.module = THIS_MODULE,
>   	.ctr    = stripe_ctr,
>   	.dtr    = stripe_dtr,
> @@ -407,6 +427,7 @@ static struct target_type stripe_target = {
>   	.status = stripe_status,
>   	.iterate_devices = stripe_iterate_devices,
>   	.io_hints = stripe_io_hints,
> +	.merge  = stripe_merge,
>   };
>
>   int __init dm_stripe_init(void)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Mike,

your changes are working well and performing even a bit better.

Are there any further comments from others, or can consider putting it
upstream.

Regards,
Mustafa

