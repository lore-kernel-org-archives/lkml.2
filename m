Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab0IBRUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:20:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:54169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab0IBRUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:20:02 -0400
Message-ID: <4C7FDCE4.1080703@kernel.org>
Date: Thu, 02 Sep 2010 19:20:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ida: fix up bitmap size calculation
References: <1283446829-24050-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1283446829-24050-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 02 Sep 2010 17:20:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/02/2010 07:00 PM, Namhyung Kim wrote:
> ida chunk should consist of 128 bytes (= 1024 bits) by definition
> but because of wrong calculation of IDA_BITMAP_LONGS it only contained
> 992 on 32-bit machines, 960 on 64-bit machines. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  include/linux/idr.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/idr.h b/include/linux/idr.h
> index e968db7..13c7296 100644
> --- a/include/linux/idr.h
> +++ b/include/linux/idr.h
> @@ -119,8 +119,8 @@ void idr_init(struct idr *idp);
>   * pointer isn't necessary.
>   */
>  #define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
> -#define IDA_BITMAP_LONGS	(128 / sizeof(long) - 1)
> -#define IDA_BITMAP_BITS		(IDA_BITMAP_LONGS * sizeof(long) * 8)
> +#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long))
> +#define IDA_BITMAP_BITS 	(IDA_CHUNK_SIZE * 8)

The -1 when calculating IDA_BITMAP_LONGS is intentional.  Please see
below.

struct ida_bitmap {
	long			nr_busy;
	unsigned long		bitmap[IDA_BITMAP_LONGS];
};

With the -1, sizeof(struct ida_bitmap) becomes 128 bytes but if you
remove the -1, it becomes 132 bytes.  Because ida_bitmap doesn't use
dedicated slab (doesn't make sense as it's not a very hot data
structure), with 132 bytes, it's gonna be allocated from 256 byte slot
wasting ~50% of memory.  Adding a comment there to clarify why -1 is
there would be nice tho.

Thanks.

-- 
tejun
