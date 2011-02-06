Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1BFRrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:47:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:42338 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1BFRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:47:11 -0500
Message-ID: <4D4EDE69.9060200@kernel.org>
Date: Sun, 06 Feb 2011 09:46:17 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] memblock: Fix error path in memblock_add_region()
References: <1296999075-8022-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1296999075-8022-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D4EDE99.00DB,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2011 05:31 AM, Namhyung Kim wrote:
> @type->regions should be restored if memblock_double_array() fails.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
>  mm/memblock.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index bdba245d8afd..49284f9f99a6 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -379,6 +379,10 @@ static long __init_memblock memblock_add_region(struct memblock_type *type, phys
>  	 */
>  	if (type->cnt == type->max && memblock_double_array(type)) {
>  		type->cnt--;
> +		for (++i; i < type->cnt; i++) {
> +			type->regions[i].base = type->regions[i+1].base;
> +			type->regions[i].size = type->regions[i+1].size;
> +		}
>  		return -1;
>  	}
>  

we can skip the restoring.

Thanks

Yinghai

diff --git a/mm/memblock.c b/mm/memblock.c
index bdba245..3231657 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -374,13 +374,9 @@ static long __init_memblock memblock_add_region(struct memblock_type *type, phys
 	}
 	type->cnt++;
 
-	/* The array is full ? Try to resize it. If that fails, we undo
-	 * our allocation and return an error
-	 */
-	if (type->cnt == type->max && memblock_double_array(type)) {
-		type->cnt--;
+	/* The array is full ? Try to resize it  */
+	if (type->cnt == type->max && memblock_double_array(type))
 		return -1;
-	}
 
 	return 0;
 }
