Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3AJAxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 19:53:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3AJAxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 19:53:03 -0500
Date: Thu, 10 Jan 2013 01:53:02 +0100
From: David Sterba <dsterba@suse.cz>
To: zwu.kernel@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, david@fromorbit.com, darrick.wong@oracle.com,
        andi@firstfloor.org, hch@infradead.org, linuxram@linux.vnet.ibm.com,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND v1 06/16] vfs: add temp calculation function
Message-ID: <20130110005302.GZ20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1356014615-15073-1-git-send-email-zwu.kernel@gmail.com>
 <1356014615-15073-7-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356014615-15073-7-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 10:43:25PM +0800, zwu.kernel@gmail.com wrote:
> --- a/fs/hot_tracking.c
> +++ b/fs/hot_tracking.c
> @@ -25,6 +25,14 @@
>  static struct kmem_cache *hot_inode_item_cachep __read_mostly;
>  static struct kmem_cache *hot_range_item_cachep __read_mostly;
>  
> +static u64 hot_raw_shift(u64 counter, u32 bits, bool dir)
> +{
> +	if (dir)
> +		return counter << bits;
> +	else
> +		return counter >> bits;
> +}

I don't understand the purpose of this function, it obscures a simple
bitwise shift.

> +
>  /*
>   * Initialize the inode tree. Should be called for each new inode
>   * access or other user of the hot_inode interface.
> @@ -315,6 +323,72 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
>  }
>  
>  /*
> + * hot_temp_calc() is responsible for distilling the six heat
> + * criteria down into a single temperature value for the data,
> + * which is an integer between 0 and HEAT_MAX_VALUE.

I didn't find HEAT_MAX_VALUE defined anywhere.

> + */
> +static u32 hot_temp_calc(struct hot_freq_data *freq_data)
> +{
> +	u32 result = 0;
> +
> +	struct timespec ckt = current_kernel_time();
> +	u64 cur_time = timespec_to_ns(&ckt);
> +
> +	u32 nrr_heat = (u32)hot_raw_shift((u64)freq_data->nr_reads,
> +					NRR_MULTIPLIER_POWER, true);
> +	u32 nrw_heat = (u32)hot_raw_shift((u64)freq_data->nr_writes,
> +					NRW_MULTIPLIER_POWER, true);

So many typecasts, some of them unnecessary and in connection with
hot_raw_shift this is hard to read and understand.

	u32 nrr_heat = (u32)((u64)freq_data->nr_reads << NRR_MULTIPLIER_POWER);

is not much better without a comment why this is doing the right thing.

> +
> +	u64 ltr_heat =
> +	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_read_time)),
> +			LTR_DIVIDER_POWER, false);
> +	u64 ltw_heat =
> +	hot_raw_shift((cur_time - timespec_to_ns(&freq_data->last_write_time)),
> +			LTW_DIVIDER_POWER, false);
> +
> +	u64 avr_heat =
> +	hot_raw_shift((((u64) -1) - freq_data->avg_delta_reads),
> +			AVR_DIVIDER_POWER, false);
> +	u64 avw_heat =
> +	hot_raw_shift((((u64) -1) - freq_data->avg_delta_writes),
> +			AVW_DIVIDER_POWER, false);
> +
> +	/* ltr_heat is now guaranteed to be u32 safe */
> +	if (ltr_heat >= hot_raw_shift((u64) 1, 32, true))
> +		ltr_heat = 0;
> +	else
> +		ltr_heat = hot_raw_shift((u64) 1, 32, true) - ltr_heat;
> +
> +	/* ltw_heat is now guaranteed to be u32 safe */
> +	if (ltw_heat >= hot_raw_shift((u64) 1, 32, true))
> +		ltw_heat = 0;
> +	else
> +		ltw_heat = hot_raw_shift((u64) 1, 32, true) - ltw_heat;
> +
> +	/* avr_heat is now guaranteed to be u32 safe */
> +	if (avr_heat >= hot_raw_shift((u64) 1, 32, true))
> +		avr_heat = (u32) -1;
> +
> +	/* avw_heat is now guaranteed to be u32 safe */
> +	if (avw_heat >= hot_raw_shift((u64) 1, 32, true))
> +		avw_heat = (u32) -1;
> +
> +	nrr_heat = (u32)hot_raw_shift((u64)nrr_heat,
> +		(3 - NRR_COEFF_POWER), false);
> +	nrw_heat = (u32)hot_raw_shift((u64)nrw_heat,
> +		(3 - NRW_COEFF_POWER), false);
> +	ltr_heat = hot_raw_shift(ltr_heat, (3 - LTR_COEFF_POWER), false);
> +	ltw_heat = hot_raw_shift(ltw_heat, (3 - LTW_COEFF_POWER), false);
> +	avr_heat = hot_raw_shift(avr_heat, (3 - AVR_COEFF_POWER), false);
> +	avw_heat = hot_raw_shift(avw_heat, (3 - AVW_COEFF_POWER), false);
> +
> +	result = nrr_heat + nrw_heat + (u32) ltr_heat +
> +		(u32) ltw_heat + (u32) avr_heat + (u32) avw_heat;

Reading through the function up to here I've got lost in the shifts that
I don't see the meaning of the resulting value and how can I interpet it
if I watch it change over time. What are the expected weights of the
number and time factors? There are more details in the documentation, but
the big picture is blurred by talking implementation details.

Let's put the impl. details here and write a better user documentation
with a few examples to the docs. Is it possible to describe some common
access patterns and how they affect the temperature?

You've been benchmarking this patchset, I'm sure you can write up a few
examples based on that.

> +
> +	return result;
> +}

david
