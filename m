Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab0HCQId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:08:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:39946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010Ab0HCQIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:08:32 -0400
Message-ID: <4C583EE6.4030203@kernel.org>
Date: Tue, 03 Aug 2010 18:08:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
        Karel Zak <kzak@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH RFC] efi: add and expose efi_partition_by_guid
References: <1280776623-1337-1-git-send-email-wad@chromium.org>
In-Reply-To: <1280776623-1337-1-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 16:07:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Kay and quoting whole message for him)

Kay, you were talking about using GUID in GPT for finding out root
device and so on.  Does this fit your use case too?  If not it would
be nice to find out something which can be shared.

On 08/02/2010 09:17 PM, Will Drewry wrote:
> EFI's GPT partitioning scheme expects that all partitions have a unique
> identifiers.  After initial partition scanning, this information is
> completely lost to the rest of the kernel.
> 
> efi_partition_by_guid exposes GPT parsing support in a limited fashion
> to allow other portions of the kernel to map a partition from GUID to
> map.
> 
> An alternate implementation (and more generic) would be to expose a function
> (efi_partition_walk) that iterates over the partition table providing access to
> each partitions information to a callback, much like device class iterators.
> 
> The motivation for this change is the ability to have device mapper targets
> resolve backing devices by GUID instead of specifically by partition number.
> This could also be used in the init boot path (root=GUID) quite simply by
> modeling scanning code on printk_all_partitions(), or with another patchset
> allowing dm="" in the boot path: http://lkml.org/lkml/2010/6/7/418
> 
> [ Additional context: http://codereview.chromium.org/3026039/show ]
> 
> Would a change like this or something that exposes the GPT information via a
> walking function be something that would be of any interest, or is it explicitly
> against the current design/access goals with respect to partition information?
> 
> Any and all feedback is truly appreciated.
> 
> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  fs/partitions/efi.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h |    5 ++++
>  2 files changed, 66 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
> index 9efb2cf..4f642c5 100644
> --- a/fs/partitions/efi.c
> +++ b/fs/partitions/efi.c
> @@ -633,3 +633,64 @@ int efi_partition(struct parsed_partitions *state)
>  	printk("\n");
>  	return 1;
>  }
> +
> +/**
> + * efi_partition_by_guid
> + * @bdev:	Whole block device to scan for a GPT.
> + * @guid:	Unique identifier for the partition to find.
> + *
> + * N.b., returns on the first match since it should be unique.
> + *
> + * Returns:
> + * -1 if an error occurred
> + *  0 if there was no match (or not GPT)
> + *  >=1 is the index of the partition found.
> + *
> + */
> +int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {
> +	gpt_header *gpt = NULL;
> +	gpt_entry *ptes = NULL;
> +	u32 i;
> +	struct parsed_partitions *state;
> +	int part = 0;
> +
> +	if (!bdev || !guid)
> +		return -1;
> +
> +	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
> +	if (!state)
> +		return -1;
> +
> +	state->limit = disk_max_parts(bdev->bd_disk);
> +	pr_debug(KERN_WARNING "efi_find_partition looking for gpt\n");
> +
> +	state->bdev = bdev;
> +	if (!find_valid_gpt(state,  &gpt, &ptes) || !gpt || !ptes) {
> +		pr_debug(KERN_WARNING "efi_find_partition no GPT\n");
> +		kfree(gpt);
> +		kfree(ptes);
> +		kfree(state);
> +		return 0;
> +	}
> +
> +	pr_debug("GUID Partition Table is valid!  Yea!\n");
> +	pr_debug(KERN_WARNING "efi_find_partition: 0 -> %d (limit:%d)\n",
> +		 le32_to_cpu(gpt->num_partition_entries),
> +		 state->limit);
> +	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
> +		    i < state->limit-1; i++) {
> +		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
> +			continue;
> +
> +		/* Bails on first hit so duped "unique" GUIDs will be FCFS. */
> +		if (!efi_guidcmp(ptes[i].unique_partition_guid,
> +				 *guid)) {
> +			part = i + 1;
> +			break;
> +		}
> +	}
> +	kfree(ptes);
> +	kfree(gpt);
> +	kfree(state);
> +	return part;
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index fb737bc..1a77259 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -301,6 +301,11 @@ extern unsigned long efi_get_time(void);
>  extern int efi_set_rtc_mmss(unsigned long nowtime);
>  extern struct efi_memory_map memmap;
>  
> +#ifdef CONFIG_EFI_PARTITION
> +struct block_device;
> +extern int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid);
> +#endif
> +
>  /**
>   * efi_range_is_wc - check the WC bit on an address range
>   * @start: starting kvirt address

-- 
tejun
