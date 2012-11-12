Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2KLORL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:17:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2KLORK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:17:10 -0500
Date: Mon, 12 Nov 2012 12:16:54 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, mst@redhat.com,
        yongjun_wei@trendmicro.com.cn,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] virtio: balloon: fix missing unlock on error in
 fill_balloon()
Message-ID: <20121112141653.GA7228@optiplex.redhat.com>
References: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 09:50:40PM +0800, Wei Yongjun wrote:
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
>

I missed that one when rewriting v10 to v11. :(

Good catch, Wei! thanks!

Andrew, we need this pick for the virtio_balloon v12 patch, as well.

-- Rafael
