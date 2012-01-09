Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2AIIIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:08:42 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54664 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2AIIIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:08:41 -0500
Date: Mon, 9 Jan 2012 09:10:30 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: InKi Dae <daeinki@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, rob@ti.com,
        daniel@ffwll.ch, t.stanislaws@samsung.com,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Message-ID: <20120109081030.GA3723@phenom.ffwll.local>
Mail-Followup-To: InKi Dae <daeinki@gmail.com>,
	Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org, m.szyprowski@samsung.com, rob@ti.com,
	t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
 <1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
 <CAAQKjZPFh6666JKc-XJfKYePQ_F0MNF6FkY=zKypWb52VVX3YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAQKjZPFh6666JKc-XJfKYePQ_F0MNF6FkY=zKypWb52VVX3YQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 03:20:48PM +0900, InKi Dae wrote:
> I has test dmabuf based drm gem module for exynos and I found one problem.
> you can refer to this test repository:
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/exynos-drm-dmabuf
> 
> at this repository, I added some exception codes for resource release
> in addition to Dave's patch sets.
> 
> let's suppose we use dmabuf based vb2 and drm gem with physically
> continuous memory(no IOMMU) and we try to share allocated buffer
> between them(v4l2 and drm driver).
> 
> 1. request memory allocation through drm gem interface.
> 2. request DRM_SET_PRIME ioctl with the gem handle to get a fd to the
> gem object.
> - internally, private gem based dmabuf moudle calls drm_buf_export()
> to register allocated gem object to fd.
> 3. request qbuf with the fd(got from 2) and DMABUF type to set the
> buffer to v4l2 based device.
> - internally, vb2 plug in module gets a buffer to the fd and then
> calls dmabuf->ops->map_dmabuf() callback to get the sg table
> containing physical memory info to the gem object. and then the
> physical memory info would be copied to vb2_xx_buf object.
> for DMABUF feature for v4l2 and videobuf2 framework, you can refer to
> this repository:
> git://github.com/robclark/kernel-omap4.git drmplane-dmabuf
> 
> after that, if v4l2 driver want to release vb2_xx_buf object with
> allocated memory region by user request, how should we do?. refcount
> to vb2_xx_buf is dependent on videobuf2 framework. so when vb2_xx_buf
> object is released videobuf2 framework don't know who is using the
> physical memory region. so this physical memory region is released and
> when drm driver tries to access the region or to release it also, a
> problem would be induced.
> 
> for this problem, I added get_shared_cnt() callback to dma-buf.h but
> I'm not sure that this is good way. maybe there may be better way.
> if there is any missing point, please let me know.

The dma_buf object needs to hold a reference on the underlying
(necessarily reference-counted) buffer object when the exporter creates
the dma_buf handle. This reference should then get dropped in the
exporters dma_buf->ops->release() function, which is only getting called
when the last reference to the dma_buf disappears.

If this doesn't work like that currently, we have a bug, and exporting the
reference count or something similar can't fix that.

Yours, Daniel

PS: Please cut down the original mail when replying, otherwise it's pretty
hard to find your response ;-)
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
