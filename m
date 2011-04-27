Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab1D0KQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:16:10 -0400
Received: from smtp.nokia.com ([147.243.1.47]:29529 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773Ab1D0KQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:16:08 -0400
Date: Wed, 27 Apr 2011 13:11:30 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Never return a pointer you didn't 'get'
Message-ID: <20110427101129.GA5763@esdhcp04044.research.nokia.com>
References: <1303385972-2518-1-git-send-email-ext-phil.2.carmody@nokia.com> <1303896680.15101.1.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303896680.15101.1.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/04/11 10:31 +0100, ext Catalin Marinas wrote:
> On Thu, 2011-04-21 at 12:39 +0100, Phil Carmody wrote:
> > Old - If you don't get the last pointer that you looked at, then it will
> > still be put, as there's no way of knowing you didn't get it.
> > 
> > New - If you didn't get it, then it refers to something deleted, and
> > your work is done, so return NULL.
> > 
> > Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> Good catch. But I think the code may look slightly simpler as below:
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index c1d5867..aacee45 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1414,9 +1414,12 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>  	++(*pos);
>  
>  	list_for_each_continue_rcu(n, &object_list) {
> -		next_obj = list_entry(n, struct kmemleak_object, object_list);
> -		if (get_object(next_obj))
> +		struct kmemleak_object *obj =
> +			list_entry(n, struct kmemleak_object, object_list);
> +		if (get_object(obj)) {
> +			next_obj = obj;
>  			break;
> +		}
>  	}
>  
>  	put_object(prev_obj);

I did consider that way too, but had no strong preference. I think I now
prefer yours, so please add:

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Cheers,
Phil
