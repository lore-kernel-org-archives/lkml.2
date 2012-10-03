Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2JCMeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:34:06 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:50092 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab2JCMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:34:04 -0400
Message-ID: <506C30B6.5020403@vmware.com>
Date: Wed, 03 Oct 2012 14:33:58 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: jakob@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] reservation: cross-device reservation support
References: <20120928124148.14366.21063.stgit@patser.local> <20120928124313.14366.44686.stgit@patser.local>
In-Reply-To: <20120928124313.14366.44686.stgit@patser.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took a quick look on the fencing and added some thoughts on
shared fences:

On 09/28/2012 02:43 PM, Maarten Lankhorst wrote:
> This adds support for a generic reservations framework that can be
> hooked up to ttm and dma-buf and allows easy sharing of reservations
> across devices.
>
> The idea is that a dma-buf and ttm object both will get a pointer
> to a struct reservation_object, which has to be reserved before
> anything is done with the buffer.
>
> Some followup patches are needed in ttm so the lru_lock is no longer
> taken during the reservation step. This makes the lockdep annotation
> patch a lot more useful, and the assumption that the lru lock protects
> atomic removal off the lru list will fail soon, anyway.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>
> +
> +/**
> + * ticket_commit - commit a reservation with a new fence
> + * @ticket:	[in]	the reservation_ticket returned by
> + * ticket_reserve
> + * @entries:	[in]	a linked list of struct reservation_entry
> + * @fence:	[in]	the fence that indicates completion
> + *
> + * This function will call reservation_ticket_fini, no need
> + * to do it manually.
> + *
> + * This function should be called after a hardware command submission is
> + * completed succesfully. The fence is used to indicate completion of
> + * those commands.
> + */
> +void
> +ticket_commit(struct reservation_ticket *ticket,
> +		  struct list_head *entries, struct fence *fence)
> +{
> +	struct list_head *cur;
> +
> +	if (list_empty(entries))
> +		return;
> +
> +	if (WARN_ON(!fence)) {
> +		ticket_backoff(ticket, entries);
> +		return;
> +	}
> +
> +	list_for_each(cur, entries) {
> +		struct reservation_object *bo;
> +		bool shared;
> +
> +		reservation_entry_get(cur, &bo, &shared);
> +
> +		if (!shared) {
> +			int i;
> +			for (i = 0; i < bo->fence_shared_count; ++i) {
> +				fence_put(bo->fence_shared[i]);
> +				bo->fence_shared[i] = NULL;
> +			}
> +			bo->fence_shared_count = 0;
> +			if (bo->fence_excl)
> +				fence_put(bo->fence_excl);
> +
> +			bo->fence_excl = fence;
I assume here that the validation code has made sure that fences are
either ordered or expired so that "fence" signals *after* all other fences
have signaled.

> +		} else {
> +			if (WARN_ON(bo->fence_shared_count >=
> +				    ARRAY_SIZE(bo->fence_shared))) {
> +				continue;
> +			}
This is bad. Failure to fence a buffer is a catastrophic error that can lead
to pages being reused for other stuff while still being read by the GPU,
and the caller must be informed with an error code and sync on the fence.

I guess this has been discussed previously, but I think it might be more
appropriate with a list of pointers to fences. There is an allocation 
overhead,
for this, but allocation from a mem cache should really be fast enough, and
the list entries can be allocated during ticket_reserve to avoid errors in
the commit code.

> +
> +			bo->fence_shared[bo->fence_shared_count++] = fence;

It might be good if this function had access to a light version of a 
cross-device
struct fence * order_fences(struct fence *a, struct fence *b)
function that can quickly check two fences and determine whether 
signaling one means that the other
one also is signaled. In that case one or more of the shared fences can 
be unreferenced,
putting less pressure on the fence_shared array.
The lightweight version of order_fences is allowed to fail if there is 
no simple
and quick way of ordering them. Could perhaps be added to the fence API.

And (even though not part of the reservation API)
There is a heavyweight version of that cross-device function
int order_fence(struct fence *a, int gpu_engine) needed for the 
validation code
exclusive fencing that
*makes sure* fence a has signaled before the current gpu_engine executes 
its commands.
For some gpu - fence pairs the ordering is done implicitly since they 
share the same command
stream, for some it's possible to insert barriers in the gpu_engine 
command stream
(radeon and nouveau is doing that), and if there is no other way of 
doing it, the code will need to
wait for the fence.

> +		}
> +		fence_get(fence);

Hmm. Perhaps a fence_get(fence, NUM) to avoid a huge number of atomic incs?

> +
> +		object_unreserve(bo, ticket);
> +	}
> +	reservation_ticket_fini(ticket);
> +}
> +EXPORT_SYMBOL(ticket_commit);
>

Thomas

