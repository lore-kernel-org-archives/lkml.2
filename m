Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964969Ab2CBWeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 17:34:13 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33914 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab2CBWeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 17:34:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of robdclark@gmail.com designates 10.52.68.206 as permitted sender) smtp.mail=robdclark@gmail.com; dkim=pass header.i=robdclark@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330616161-1937-4-git-send-email-daniel.vetter@ffwll.ch>
References: <1330616161-1937-1-git-send-email-daniel.vetter@ffwll.ch>
	<1330616161-1937-4-git-send-email-daniel.vetter@ffwll.ch>
Date: Fri, 2 Mar 2012 16:34:10 -0600
X-Google-Sender-Auth: 16LRUdgvipvGdal9hMQ_F6pGpbw
Message-ID: <CAF6AEGsOLcfMa4PKj0f8uhaEHSczpH0323xVhL41WAnaqAHfRw@mail.gmail.com>
Subject: Re: [PATCH 3/3] dma_buf: Add documentation for the new cpu access support
From: Rob Clark <rob.clark@linaro.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minor comments from the typo-police..

On Thu, Mar 1, 2012 at 9:36 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  Documentation/dma-buf-sharing.txt |  102 +++++++++++++++++++++++++++++++++++-
>  1 files changed, 99 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 225f96d..f12542b 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -32,8 +32,12 @@ The buffer-user
>  *IMPORTANT*: [see https://lkml.org/lkml/2011/12/20/211 for more details]
>  For this first version, A buffer shared using the dma_buf sharing API:
>  - *may* be exported to user space using "mmap" *ONLY* by exporter, outside of
> -   this framework.
> -- may be used *ONLY* by importers that do not need CPU access to the buffer.
> +  this framework.
> +- with this new iteration of the dma-buf api cpu access from the kernel has been
> +  enable, see below for the details.
> +
> +dma-buf operations for device dma only
> +--------------------------------------
>
>  The dma_buf buffer sharing API usage contains the following steps:
>
> @@ -219,7 +223,99 @@ NOTES:
>    If the exporter chooses not to allow an attach() operation once a
>    map_dma_buf() API has been called, it simply returns an error.
>
> -Miscellaneous notes:
> +Kernel cpu access to a dma-buf buffer object
> +--------------------------------------------
> +
> +The motivation to allow cpu access from the kernel to a dma-buf object from the
> +importers side are:
> +- fallback operations, e.g. if the devices is connected to a usb bus and the
> +  kernel needs to shuffle the data around first before sending it away.
> +- full transperancy for existing users on the importer side, i.e. userspace

s/transperancy/transparency/

> +  should not notice the difference between a normal object from that subsystem
> +  and an imported one backed by a dma-buf. This is really important for drm
> +  opengl drivers that expect to still use all the existing upload/download
> +  paths.
> +
> +Access to a dma_buf from the kernel context involves three steps:
> +
> +1. Prepare access, which invalidate any necessary caches and make the object
> +   available for cpu access.
> +2. Access the object page-by-page with the dma_buf map apis
> +3. Finish access, which will flush any necessary cpu caches and free reserved
> +   resources.
> +
> +1. Prepare acces
> +

s/acces/access/

> +   Before an importer can acces a dma_buf object with the cpu from the kernel

s/acces/access/

> +   context, it needs to notice the exporter of the access that is about to

s/notice/notify/ (I assume?)

> +   happen.
> +
> +   Interface:
> +      int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
> +                                  size_t start, size_t len,
> +                                  enum dma_data_direction direction)
> +
> +   This allows the exporter to ensure that the memory is actually available for
> +   cpu access - the exporter might need to allocate or swap-in and pin the
> +   backing storage. The exporter also needs to ensure that cpu access is
> +   coherent for the given range and access direction. The range and access
> +   direction can be used by the exporter to optimize the cache flushing, i.e.
> +   access outside of the range or with a different direction (read instead of
> +   write) might return stale or even bogus data (e.g. when the exporter needs to
> +   copy the data to temporaray storage).

s/temporaray/temporary/

> +
> +   This step might fail, e.g. in oom conditions.
> +
> +2. Accessing the buffer
> +
> +   To support dma_buf objects residing in highmem cpu access is page-based using
> +   an api similar to kmap. Accessing a dma_buf is done in aligned chunks of
> +   PAGE_SIZE size. Before accessing a chunk it needs to be mapped, which returns
> +   a pointer in kernel virtual address space. Afterwards the chunk needs to be
> +   unmapped again. There is no limit on how often a given chunk can be mapped
> +   and unmmapped, i.e. the importer does not need to call begin_cpu_access again

s/unmmapped/unmapped/

> +   before mapping the same chunk again.
> +
> +   Interfaces:
> +      void *dma_buf_kmap(struct dma_buf *, unsigned long);
> +      void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
> +
> +   There are also atomic variants of these interfaces. Like for kmap they
> +   facilitate non-blocking fast-paths. Neither the importer nor the exporter (in
> +   the callback) is allowed to block when using these.
> +
> +   Interfaces:
> +      void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
> +      void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
> +
> +   For importers all the restrictions of using kmap apply, like the limited
> +   supply of kmap_atomic slots. Hence an importer shall only hold onto at most 2
> +   atomic dma_buf kmaps at the same time (in any given process context).
> +
> +   dma_buf kmap calls outside of the range specified in begin_cpu_access are
> +   undefined. If the range is not PAGE_SIZE aligned, kmap needs to succeed on
> +   the partial chunks at the beginning and end but may return stale or bogus
> +   data outside of the range (in these partial chunks).
> +
> +   Note that these calls need to always succeed. The exporter needs to complete
> +   any preparations that might fail in begin_cpu_access.
> +
> +3. Finish access
> +
> +   When the importer is done accessing the range specified in begin_cpu_acces,

s/begin_cpu_acces/begin_cpu_access/


BR,
-R


> +   it needs to announce this to the exporter (to facilitate cache flushing and
> +   unpinning of any pinned resources). The result of of any dma_buf kmap calls
> +   after end_cpu_access is undefined.
> +
> +   Interface:
> +      void dma_buf_end_cpu_access(struct dma_buf *dma_buf,
> +                                 size_t start, size_t len,
> +                                 enum dma_data_direction dir);
> +
> +
> +Miscellaneous notes
> +-------------------
> +
>  - Any exporters or users of the dma-buf buffer sharing framework must have
>   a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
>
> --
> 1.7.7.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
