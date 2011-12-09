Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1LIONW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:13:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1LIONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:13:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Fri, 9 Dec 2011 14:13:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112071340.35267.arnd@arndb.de> <CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
In-Reply-To: <CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112091413.03736.arnd@arndb.de>
X-Provags-ID: V02:K0:DAJta6GsaS9TeOqzNGCM2NR4CnwIuOX+UB92NWai6DO
 blFNAPCwmiBqTPi8caUeZXrA6pfdYHMl0b4i/3osKKO4ykziGF
 mqQVleDgldlOiomBAah/vwI80wwJ2cKHSp0MQVVhuttgGbAqWm
 k5f9hA4O2oFSz0dW6VVwkYz1pwQIdldGQFB+FWRt5O0Te0zd0q
 7yUp/mv6eszoCGAY3CC8v1d9hlSFaMcTRz73lza/OgyTNYK5Pe
 b06tOuSwVqG1i6oGYR66b9x/50PPOHyUW5Rb3P1JWme8+h0OUi
 TFM2uBPcy87TJKbrLfwR4MhUA8+sC5rC+6K80UUiT1CmF+qniH
 07R9g5DqKbqu4JhJfaOo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 December 2011, Daniel Vetter wrote:
> > c) only allowing streaming mappings, even if those are non-coherent
> > (requiring strict serialization between CPU (in-kernel) and dma users of
> > the buffer)
> 
> I think only allowing streaming access makes the most sense:
> - I don't see much (if any need) for the kernel to access a dma_buf -
> in all current usecases it just contains pixel data and no hw-specific
> things (like sg tables, command buffers, ..). At most I see the need
> for the kernel to access the buffer for dma bounce buffers, but that
> is internal to the dma subsystem (and hence does not need to be
> exposed).
> - Userspace can still access the contents through the exporting
> subsystem (e.g. use some gem mmap support). For efficiency reason gpu
> drivers are already messing around with cache coherency in a platform
> specific way (and hence violated the dma api a bit), so we could stuff
> the mmap coherency in there, too. When we later on extend dma_buf
> support so that other drivers than the gpu can export dma_bufs, we can
> then extend the official dma api with already a few drivers with
> use-patterns around.
> 
> But I still think that the kernel must not be required to enforce
> correct access ordering for the reasons outlined in my other mail.

I still don't think that's possible. Please explain how you expect
to change the semantics of the streaming mapping API to allow multiple
mappers without having explicit serialization points that are visible
to all users. For simplicity, let's assume a cache coherent system
with bounce buffers where map() copies the buffer to a dma area
and unmap() copies it back to regular kernel memory. How does a driver
know if it can touch the buffer in memory or from DMA at any given
point in time? Note that this problem is the same as the cache coherency
problem but may be easier to grasp.

	Arnd
