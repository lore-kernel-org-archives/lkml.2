Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab2JGQbe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:31:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JGQb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:31:28 -0400
Message-ID: <5071AE5A.7050204@canonical.com>
Date: Sun, 07 Oct 2012 18:31:22 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: jakob@vmware.com, thellstrom@vmware.com, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] fence: dma-buf cross-device synchronization (v9)
References: <20120928124148.14366.21063.stgit@patser.local> <20120928124224.14366.27842.stgit@patser.local>
In-Reply-To: <20120928124224.14366.27842.stgit@patser.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 28-09-12 14:42, Maarten Lankhorst schreef:
> A fence can be attached to a buffer which is being filled or consumed
> by hw, to allow userspace to pass the buffer without waiting to another
> device.  For example, userspace can call page_flip ioctl to display the
> next frame of graphics after kicking the GPU but while the GPU is still
> rendering.  The display device sharing the buffer with the GPU would
> attach a callback to get notified when the GPU's rendering-complete IRQ
> fires, to update the scan-out address of the display, without having to
> wake up userspace.
>
> A fence is transient, one-shot deal.  It is allocated and attached
> to one or more dma-buf's.  When the one that attached it is done, with
> the pending operation, it can signal the fence:
>   + fence_signal()
>
> To have a rough approximation whether a fence is fired, call:
>   + fence_is_signaled()
>
> The dma-buf-mgr handles tracking, and waiting on, the fences associated
> with a dma-buf.
>
> The one pending on the fence can add an async callback:
>   + fence_add_callback()
>
> The callback can optionally be cancelled with:
>   + fence_remove_callback()
>
> To wait synchronously, optionally with a timeout:
>   + fence_wait()
>   + fence_wait_timeout()
>
...

Implementing this makes the locking feel weird, instead of abusing
fence->event_queue.lock I think it would make sense to remove this part entirely,
and have a simply linked list plus a pointer to a spinlock.

enable_signaling should be called with this spinlock held. This way,
the enable_signaling callback would be easier to implement
and doesn't have to double check for races as much in there.

Also __fence_signal should be exported which would be the
same as fence_signal, but without taking the spinlock as separate
step, so it can be called with the spinlock held.

How do you feel about these proposed changes?

~Maarten

