Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab2AECrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:47:18 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40243 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2AECrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:47:17 -0500
MIME-Version: 1.0
In-Reply-To: <87y5tnat2g.fsf@rustcorp.com.au>
References: <20120104225223.18184.1537.stgit@mike2.sea.corp.google.com>
 <20120104225237.18184.71853.stgit@mike2.sea.corp.google.com> <87y5tnat2g.fsf@rustcorp.com.au>
From: Mike Waychison <mikew@google.com>
Date: Wed, 4 Jan 2012 18:46:55 -0800
Message-ID: <CAGTjWtB3PjWDfaunXjF-KQwKYg-bPgrn-8N=8iwL0EPvviXMuw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/2] virtio_net: Don't disable napi on low memory.
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 4:31 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Wed, 04 Jan 2012 14:52:38 -0800, Mike Waychison <mikew@google.com> wrote:
>> Currently, the virtio_net driver deals with low memory memory by kicking
>> off delayed work in process context to try and refill the rx queues.
>> This process-context filling is synchronized against the receive
>> bottom-half by serially:
>>
>>   - disabling NAPI polling on the device,
>>   - allocating buffers,
>>   - enqueueing the buffers,
>>   - re-enabling napi.
>>
>> Disabling NAPI just to synchronize virtio_add_buf calls is a bit
>> overkill, and there isn't any reason we shouldn't be able to continue
>> processing received packets as they come in.  In the simple case, this
>> does not involve allocating any memory, and in fact allows memory to be
>> released as the guest system receives and processes packets.
>
> Adding a spinlock to the fastpath for a weird case in the slow path is
> bad too.
>
> I dislike several things about this patch:
> 1) You seem to leak memory if you allocate a batch then don't add it all.
> 2) You have a module parameter, which I guarantee noone else will ever use.
> 3) You've made three changes at once: allocating outside the lock,
>   batching, and replacing the napi lock with a spinlock.
> 4) You use the skb data for the linked list; use the skb head's list.
>
> Instead, here's how I think it should be done:
>
> 1) Split alloc and add, but make alloc return the skb.
> 2) Make try_fill_recv() only called in the receive path, keep it
>   basically the same (no batching).
> 3) Add a new try_fill_recv_batch() for the workqueue and init paths.
>   This should try to allocate max - num, though in practice the
>   first alloc would probably kick off reclaim and take forever,
>   then by the time it's done, the problem is solved.  Since it's
>   reading max and num outside the lock, write this loop carefully!
> 4) try_fill_recv_batch() should then stop napi and add as many as it
>   can, then restart it, then free any remainder.

This sounds reasonable to me.  I'll see what I can muster together this week.

Thanks for taking a look :)

>
> Cheers,
> Rusty.
