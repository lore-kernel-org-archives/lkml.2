Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0FNPSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:18:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab0FNPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:18:15 -0400
Date: Mon, 14 Jun 2010 11:18:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 1/5] fsfreeze: Prevent emergency thaw from looping
 infinitely
Message-ID: <20100614151815.GA32354@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276154395-24766-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 05:19:50PM +1000, Dave Chinner wrote:
> Return -EINVAL when the filesystem is already unfrozen to avoid this
> problem.


This includes some additional changes in addition to the description,
and at least one of them seems incorrect.

> -	error = 0;
> -	if (--bdev->bd_fsfreeze_count > 0)
> +	if (!sb)
>  		goto out;
>  
> -	if (!sb)
> +	error = 0;
> +	if (--bdev->bd_fsfreeze_count > 0)
>  		goto out;

Here you reorder the sb check to be before the counter decrement.  But
we do support calling freeze_bdev on a device without a superblock, and
you would leak bd_fsfreeze_count for that case and wrongly return
-EINVAL on unthaw for these now.

>  	error = thaw_super(sb);
> -	if (error) {
> +	if (error)
>  		bdev->bd_fsfreeze_count++;
> -		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -		return error;
> -	}

Ok, useful cleanup.

>  out:
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -	return 0;
> +	return error;

And this is the actual fix of course, also looks good.

