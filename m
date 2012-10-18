Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab2JRRVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:21:01 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:4243 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2JRRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:20:57 -0400
Message-ID: <1350580854.2680.31.camel@lorien2>
Subject: Re: [PATCH] lib/dma-debug.c: fix __hash_bucket_find
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Ming Lei <ming.lei@canonical.com>, Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Kicinski <kubakici@wp.pl>, shuahkhan@gmail.com
Date: Thu, 18 Oct 2012 11:20:54 -0600
In-Reply-To: <CACVXFVMHiamXLk8eJr7SgMZRaYt=JdmseG35iQZAJ5=BsHTXgA@mail.gmail.com>
References: <1350574699-6419-1-git-send-email-ming.lei@canonical.com>
	 <CACVXFVMHiamXLk8eJr7SgMZRaYt=JdmseG35iQZAJ5=BsHTXgA@mail.gmail.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 23:53 +0800, Ming Lei wrote:
> Hi,
> 
> Below v1 should be more efficient and simper, sorry for the noise.
> 
> 
> Thanks,
> --
> Ming Lei
> 
> --
> From d275d195794ff80e018145f2fae714b35ddc49e2 Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@canonical.com>
> Date: Thu, 18 Oct 2012 23:30:57 +0800
> Subject: [PATCH v1] lib/dma-debug.c: fix __hash_bucket_find
> 
> If there is only one match, the unique matched entry should be returned.
> 
> Without the fix, the commit f62566214fe31c9f9b3218a42f1b19e6a9e6844a
> 
> 	dma-debug: new interfaces to debug dma mapping errors
> 
> can't work reliably because only device and dma_addr are passed to
> dma_mapping_error().
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Shuah Khan <shuah.khan@hp.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jakub Kicinski <kubakici@wp.pl>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  lib/dma-debug.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 94aa94e..59f4a1a 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -277,7 +277,7 @@ static struct dma_debug_entry
> *__hash_bucket_find(struct hash_bucket *bucket,
>  						  match_fn match)
>  {
>  	struct dma_debug_entry *entry, *ret = NULL;
> -	int matches = 0, match_lvl, last_lvl = 0;
> +	int matches = 0, match_lvl, last_lvl = -1;
> 
>  	list_for_each_entry(entry, &bucket->list, list) {
>  		if (!match(ref, entry))
> @@ -306,7 +306,7 @@ static struct dma_debug_entry
> *__hash_bucket_find(struct hash_bucket *bucket,
>  		} else if (match_lvl > last_lvl) {
>  			/*
>  			 * We found an entry that fits better then the
> -			 * previous one
> +			 * previous one or it is the 1st match.
>  			 */
>  			last_lvl = match_lvl;
>  			ret      = entry;

Thanks for finding and fixing the problem. This fixes the problem
Fengguang Wu reported: adding him to the thread.

https://lkml.org/lkml/2012/10/14/233

I have a reliable test case and test system that reproduces the problem.
Re-tested it with and without patch and didn't see the warning with your
patch.

That said, this patch is malformed and didn't apply cleanly.
You have my

Tested-by: Shuah Khan <shuah.khan@hp.com>

Thanks,
-- Shuah


