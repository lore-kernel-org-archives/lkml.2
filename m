Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1H2FLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 01:11:34 -0400
Received: from ozlabs.org ([203.10.76.45]:59214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab1H2FLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 01:11:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Wang Sheng-Hui <shhuiw@gmail.com>, wanlong.gao@gmail.com
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: fix size computation according to the definition of struct vring_used in vring_size
In-Reply-To: <4E58BE42.8030700@gmail.com>
References: <4E584365.1010806@gmail.com> <1314413399.1913.1.camel@Allen> <4E58BA41.6050503@gmail.com> <4E58BE42.8030700@gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 29 Aug 2011 12:23:12 +0930
Message-ID: <87fwkl2ajr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011 17:52:02 +0800, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> On 2011年08月27日 17:34, Wang Sheng-Hui wrote:
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index 4a32cb6..300af76 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -135,13 +135,13 @@ static inline void vring_init(struct vring *vr, unsigned int num, void *p,
>  	vr->num = num;
>  	vr->desc = p;
>  	vr->avail = p + num*sizeof(struct vring_desc);
> -	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + align-1)
> -			    & ~(align - 1));
> +	vr->used = (void *)(((unsigned long)&vr->avail->ring[num] + 16
> +		+ align-1) & ~(align - 1));
>  }

This + 16 should be + sizeof(__u16), right?  It's just the
used_event_idx which has been added:

 *	__u16 available[num];
 *	__u16 used_event_idx;
 *
 *	// Padding to the next align boundary.
 *	char pad[];
 *
 * [USED]

>  static inline unsigned vring_size(unsigned int num, unsigned long align)
>  {
> -	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
> +	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (3 + num)
>  		 + align - 1) & ~(align - 1))
>  		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;

This is correct.

And, yes, since align is always 4096, it's currently just a cleanup, but
it makes things much less confusing!

Thanks,
Rusty.
