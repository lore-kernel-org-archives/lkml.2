Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2KLXe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:34:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2KLXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:34:55 -0500
Date: Mon, 12 Nov 2012 15:34:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com, aquini@redhat.com,
        yongjun_wei@trendmicro.com.cn,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] virtio: balloon: fix missing unlock on error in
 fill_balloon()
Message-Id: <20121112153453.fa3edc3d.akpm@linux-foundation.org>
In-Reply-To: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
References: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 21:50:40 +0800
Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing unlock before return from function fill_balloon()
> in the error handling case.
> 
> Introduced by 9864a8(virtio_balloon: introduce migration primitives
> to balloon pages)
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/virtio/virtio_balloon.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index f70151b..72e8dcb 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -152,8 +152,10 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
>  	}
>  
>  	/* Didn't get any?  Oh well. */
> -	if (vb->num_pfns == 0)
> +	if (vb->num_pfns == 0) {
> +		mutex_unlock(&vb->balloon_lock);
>  		return;
> +	}
>  
>  	tell_host(vb, vb->inflate_vq);
>  	mutex_unlock(&vb->balloon_lock);

Well.  Why did this bug occur in the first place?  Because
fill_balloon() has multiple return points and one of those was
overlooked when adding new locking.

This (and the addition of memory leaks) is quite common.  It is part of
the reason why so much kernel code uses goto's to avoid multiple return
points.  A maintainability thing.

And we can fix this shortcoming in fill_balloon() without even needing a
goto:

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix
+++ a/drivers/virtio/virtio_balloon.c
@@ -151,13 +151,9 @@ static void fill_balloon(struct virtio_b
 		totalram_pages--;
 	}
 
-	/* Didn't get any?  Oh well. */
-	if (vb->num_pfns == 0) {
-		mutex_unlock(&vb->balloon_lock);
-		return;
-	}
-
-	tell_host(vb, vb->inflate_vq);
+	/* Did we get any? */
+	if (vb->num_pfns != 0)
+		tell_host(vb, vb->inflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 }
 
_

