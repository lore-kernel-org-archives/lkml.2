Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab2KFCLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:11:37 -0500
Received: from ozlabs.org ([203.10.76.45]:42108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421Ab2KFCKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:10:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbr@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        dmitry.tarnyagin@stericsson.com
Subject: Re: [RFC virtio-next 0/4] Introduce CAIF Virtio and reversed Vrings
In-Reply-To: <CANHm3PgrsTD4uYuXN0AMuZFX794CJmmus4AST=G0+nP1ha3VyQ@mail.gmail.com>
References: <1351723614-4145-1-git-send-email-sjur@brendeland.net> <87wqy54vo0.fsf@rustcorp.com.au> <CANHm3PgrsTD4uYuXN0AMuZFX794CJmmus4AST=G0+nP1ha3VyQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 06 Nov 2012 12:39:14 +1030
Message-ID: <871ug75vp1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjurbr@gmail.com> writes:
> Hi Rusty,
>
>> So, this adds another host-side virtqueue implementation.
>>
>> Can we combine them together conveniently?  You pulled out more stuff
>> into vring.h which is a start, but it's a bit overloaded.
>> Perhaps we should separate the common fields into struct vring, and use
>> it to build:
>>
>>         struct vring_guest {
>>                 struct vring vr;
>>                 u16 last_used_idx;
>>         };
>>
>>         struct vring_host {
>>                 struct vring vr;
>>                 u16 last_avail_idx;
>>         };
>> I haven't looked closely at vhost to see what it wants, but I would
>> think we could share more code.
>
> I have played around with the code in vhost.c to explore your idea.
> The main issue I run into is that vhost.c is accessing user data while my new
> code does not. So I end up with some quirky code testing if the ring lives in
> user memory or not.  Another issue is sparse warnings when
> accessing user memory.

Sparse is a servant, not a master.  If that's the only thing stopping
us, we can ignore it (or hack around it).

> With your suggested changes I end up sharing about 100 lines of code.
> So in sum, I feel this add more complexity than what we gain by sharing.
>
> Below is an initial draft of the re-usable code. I added "is_uaccess" to struct
> virtio_ring in order to know if the ring lives in user memory.
>
> Let me know what you think.

Agreed, that's horrible...

Fortunately, recent GCCs will inline function pointers, so inlining this
and handing an accessor function gets optimized away.

I would really like this, because I'd love to have a config option to do
strict checking on the format of these things (similar to my recently
posted CONFIG_VIRTIO_DEVICE_TORTURE patch).

See below.

> int virtqueue_add_used(struct vring_host *vr, unsigned int head, int len,
> 		    struct vring_used_elem  **used)
> {
> 	/* The virtqueue contains a ring of used buffers.  Get a pointer to the
> 	 * next entry in that used ring. */
> 	*used = &vr->vring.used->ring[vr->last_used_idx % vr->vring.num];
> 	if (vr->is_uaccess) {
> 		if(unlikely(__put_user(head, &(*used)->id))) {
> 			pr_debug("Failed to write used id");
> 			return -EFAULT;
> 		}
> 		if (unlikely(__put_user(len, &(*used)->len))) {
> 			pr_debug("Failed to write used len");
> 			return -EFAULT;
> 		}
> 		smp_wmb();
> 		if (__put_user(vr->last_used_idx + 1,
> 			       &vr->vring.used->idx)) {
> 			pr_debug("Failed to increment used idx");
> 			return -EFAULT;
> 		}
> 	} else {
> 		(*used)->id = head;
> 		(*used)->len = len;
> 		smp_wmb();
> 		vr->vring.used->idx = vr->last_used_idx + 1;
> 	}
> 	vr->last_used_idx++;
> 	return 0;
> }

/* Untested! */
static inline bool in_kernel_put(u32 *dst, u32 v)
{
        *dst = v;
        return true;
}

static inline bool userspace_put(u32 *dst, u32 v)
{
	return __put_user(dst, v) == 0;
}

static inline struct vring_used_elem *vrh_add_used(struct vring_host *vr,
                                                   unsigned int head, u32 len,
                                                   bool (*put)(u32 *dst, u32 v))
{
        struct vring_used_elem *used;

	/* The virtqueue contains a ring of used buffers.  Get a pointer to the
	 * next entry in that used ring. */
	used = &vr->vring.used->ring[vr->last_used_idx % vr->vring.num];
        
	if (!put(&used->id, head) || !put(&used->len = len))
                return NULL;
	smp_wmb();
        if (!put(&vr->vring.used->idx, vr->last_used_idx + 1))
                return NULL;
	vr->last_used_idx++;
	return used;
}

Cheers,
Rusty.
