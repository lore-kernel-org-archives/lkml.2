Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2ECN6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 09:58:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46680 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab2ECN6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 09:58:21 -0400
Message-ID: <4FA28EFD.5070002@vflare.org>
Date: Thu, 03 May 2012 09:58:21 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-4-git-send-email-minchan@kernel.org>
In-Reply-To: <1336027242-372-4-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/12 2:40 AM, Minchan Kim wrote:
> It's a overkill to align pool size with PAGE_SIZE to avoid
> false-sharing. This patch aligns it with just cache line size.
>
> Signed-off-by: Minchan Kim<minchan@kernel.org>
> ---
>   drivers/staging/zsmalloc/zsmalloc-main.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 51074fa..3991b03 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -489,14 +489,14 @@ fail:
>
>   struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
>   {
> -	int i, error, ovhd_size;
> +	int i, error;
>   	struct zs_pool *pool;
>
>   	if (!name)
>   		return NULL;
>
> -	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
> -	pool = kzalloc(ovhd_size, GFP_KERNEL);
> +	pool = kzalloc(ALIGN(sizeof(*pool), cache_line_size()),
> +				GFP_KERNEL);

a basic question:
  Is rounding off allocation size to cache_line_size enough to ensure 
that the object is cache-line-aligned? Isn't it possible that even 
though the object size is multiple of cache-line, it may still not be 
properly aligned and end up sharing cache line with some other 
read-mostly object?

Thanks,
Nitin


>   	if (!pool)
>   		return NULL;
>

