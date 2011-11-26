Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1KZOAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 09:00:34 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38975 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1KZOAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 09:00:32 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CAPM=9txtWiQuF+jNZXDogCMy+nsM=00Bv3uxAiu5oKnn-KxjAA@mail.gmail.com>
References: <1318325033-32688-1-git-send-email-sumit.semwal@ti.com>
	<1318325033-32688-2-git-send-email-sumit.semwal@ti.com>
	<CAPM=9tzjO7poyz_uYFFgONxzuTB86kKej8f2XBDHLGdUPZHvjg@mail.gmail.com>
	<CAPM=9txtWiQuF+jNZXDogCMy+nsM=00Bv3uxAiu5oKnn-KxjAA@mail.gmail.com>
Date: Sat, 26 Nov 2011 15:00:31 +0100
X-Google-Sender-Auth: YwDD44a8Nk_fdUs0M_y5wnt0ltI
Message-ID: <CAKMK7uE14gOsTUYZknmSArkzG2zSSbpDeU0dxqAtLVUmvh-5bA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 17:28, Dave Airlie <airlied@gmail.com> wrote:
> I've rebuilt my PRIME interface on top of dmabuf to see how it would work,
>
> I've got primed gears running again on top, but I expect all my object
> lifetime and memory ownership rules need fixing up (i.e. leaks like a
> sieve).
>
> http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-prime-dmabuf
>
> has the i915/nouveau patches for the kernel to produce the prime interface.

I've noticed that your implementations for get_scatterlist (at least
for the i915 driver) doesn't return the sg table mapped into the
device address space. I've checked and the documentation makes it
clear that this should be the case (and we really need this to support
certain insane hw), but the get/put_scatterlist names are a bit
misleading. Proposal:

- use struct sg_table instead of scatterlist like you've already done
in you branch. Simply more consistent with the dma api.

- rename get/put_scatterlist into map/unmap for consistency with all
the map/unmap dma api functions. The attachement would then serve as
the abstract cookie to the backing storage, similar to how struct page
* works as an abstract cookie for dma_map/unmap_page. The only special
thing is that struct device * parameter because that's already part of
the attachment.

- add new wrapper functions dma_buf_map_attachment and
dma_buf_unmap_attachement to hide all the pointer/vtable-chasing that
we currently expose to users of this interface.

Comments?

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
