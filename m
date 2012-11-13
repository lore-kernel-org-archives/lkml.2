Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2KMMsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:48:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab2KMMsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:48:06 -0500
Date: Tue, 13 Nov 2012 10:47:48 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, rusty@rustcorp.com.au, mst@redhat.com,
        yongjun_wei@trendmicro.com.cn,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] virtio: balloon: fix missing unlock on error in
 fill_balloon()
Message-ID: <20121113124748.GA1636@optiplex.redhat.com>
References: <CAPgLHd80RvvGdTKN3aR7dQ_b1S3_pAkMwmGjewc7zgf=4jafcg@mail.gmail.com>
 <20121112153453.fa3edc3d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121112153453.fa3edc3d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 03:34:53PM -0800, Andrew Morton wrote:
> On Mon, 12 Nov 2012 21:50:40 +0800
> Wei Yongjun <weiyj.lk@gmail.com> wrote:
> 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Add the missing unlock before return from function fill_balloon()
> > in the error handling case.
> > 
> > Introduced by 9864a8(virtio_balloon: introduce migration primitives
> > to balloon pages)
> > 
> > dpatch engine is used to auto generate this patch.
> > (https://github.com/weiyj/dpatch)
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/virtio/virtio_balloon.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> > index f70151b..72e8dcb 100644
> > --- a/drivers/virtio/virtio_balloon.c
> > +++ b/drivers/virtio/virtio_balloon.c
> > @@ -152,8 +152,10 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
> >  	}
> >  
> >  	/* Didn't get any?  Oh well. */
> > -	if (vb->num_pfns == 0)
> > +	if (vb->num_pfns == 0) {
> > +		mutex_unlock(&vb->balloon_lock);
> >  		return;
> > +	}
> >  
> >  	tell_host(vb, vb->inflate_vq);
> >  	mutex_unlock(&vb->balloon_lock);
> 
> Well.  Why did this bug occur in the first place?  Because
> fill_balloon() has multiple return points and one of those was
> overlooked when adding new locking.
> 
> This (and the addition of memory leaks) is quite common.  It is part of
> the reason why so much kernel code uses goto's to avoid multiple return
> points.  A maintainability thing.
> 
> And we can fix this shortcoming in fill_balloon() without even needing a
> goto:
> 
> --- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix
> +++ a/drivers/virtio/virtio_balloon.c
> @@ -151,13 +151,9 @@ static void fill_balloon(struct virtio_b
>  		totalram_pages--;
>  	}
>  
> -	/* Didn't get any?  Oh well. */
> -	if (vb->num_pfns == 0) {
> -		mutex_unlock(&vb->balloon_lock);
> -		return;
> -	}
> -
> -	tell_host(vb, vb->inflate_vq);
> +	/* Did we get any? */
> +	if (vb->num_pfns != 0)
> +		tell_host(vb, vb->inflate_vq);
>  	mutex_unlock(&vb->balloon_lock);
>  }
>

Your fix is far better, as it simplifies the code without loosing that test --
which only evaluates as true, if we fail to allocate a page right after getting
into the loop -- /me thinks driver folks place it there to not bother
tell_host() and the virt_queues if no pageframe is present at that pfns array.


