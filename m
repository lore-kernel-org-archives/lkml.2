Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0D1JkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 05:40:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab0D1Jj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 05:39:58 -0400
Message-ID: <4BD80260.3050501@redhat.com>
Date: Wed, 28 Apr 2010 12:39:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
References: <1271118255-21070-1-git-send-email-david@fromorbit.com> <1271118255-21070-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1271118255-21070-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 03:24 AM, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The current shrinker implementation requires the registered callback
> to have global state to work from. This makes it difficult to shrink
> caches that are not global (e.g. per-filesystem caches). Add a
> context argument to the shrinker callback so that it can easily be
> used in such situations.
>    

> @@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>    * querying the cache size, so a fastpath for that case is appropriate.
>    */
>   struct shrinker {
> -	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> +	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> +	void *ctx;	/* user callback context */
>   	int seeks;	/* seeks to recreate an obj */
>    


It's nicer (and slightly cheaper) to have

   int (*shrink)(struct shrinker *shrinker, int nr_to_scan, gfp_t gfp_mask);
   /* no void *ctx; */

Clients can use container_of() to reach their context from the shrinker 
argument.

-- 
error compiling committee.c: too many arguments to function

