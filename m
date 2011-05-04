Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1EDJFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:05:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37567 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1EDJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o/JDGNT52TsIOmTqPi8p5n4LDMIBTbfwShDJsbtPGgSzfsPnkuW8/qGpsjPwGKe76u
         gIyeFyGGHASTKcHgxDkDcbOH6RzgDeGadjLTNYQawAz2DjcaEYJr4aZgCNkqpSlMZf9M
         wlpgPh051K/JXPw/2Ot5r+C5a5vSdipMKRjBw=
Date: Wed, 4 May 2011 11:05:09 +0200
From: Tejun Heo <htejun@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        jaxboe@fusionio.com, jgarzik@pobox.com, hch@infradead.org,
        djwong@us.ibm.com
Subject: Re: [patch v2 1/3] block: add a non-queueable flush flag
Message-ID: <20110504090509.GC8007@htj.dyndns.org>
References: <20110504081725.946950281@sli10-conroe.sh.intel.com>
 <20110504082115.093981766@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504082115.093981766@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 04, 2011 at 04:17:26PM +0800, shaohua.li@intel.com wrote:
> flush request isn't queueable in some drives. Add a flag to let driver
> notify block layer about this. We can optimize flush performance with the
> knowledge.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  include/linux/blkdev.h |   11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h	2011-05-04 14:23:42.000000000 +0800
> +++ linux/include/linux/blkdev.h	2011-05-04 14:24:40.000000000 +0800
> @@ -364,6 +364,7 @@ struct request_queue
>  	 * for flush operations
>  	 */
>  	unsigned int		flush_flags;
> +	unsigned int		flush_not_queueable:1;
>  	unsigned int		flush_pending_idx:1;
>  	unsigned int		flush_running_idx:1;
>  	unsigned long		flush_pending_since;
> @@ -549,6 +550,16 @@ static inline void blk_clear_queue_full(
>  		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
>  }
>  
> +static inline void blk_set_queue_flush_queueable(struct request_queue *q,
> +		bool queueable)
> +{
> +	q->flush_not_queueable = !queueable;
> +}
> +
> +static inline bool blk_queue_flush_queueable(struct request_queue *q)
> +{
> +	return !q->flush_not_queueable;
> +}

In the block layer, these setters live in block/blk-settings.c and
usually don't have _set in their names.

Also, negation in the interface is slightly bothering but I can't
think of better name meaning !queueable either, so unless someone can
come up with better name, it should do, I think.

Thank you.

-- 
tejun
