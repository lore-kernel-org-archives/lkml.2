Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2AYUHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 15:07:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2AYUHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 15:07:04 -0500
Date: Wed, 25 Jan 2012 21:07:01 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, arnd@arndb.de, airlied@redhat.com,
        linux@arm.linux.org.uk, jesse.barker@linaro.org,
        m.szyprowski@samsung.com, rob@ti.com, daniel@ffwll.ch,
        patches@linaro.org, Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH 1/3] dma-buf: Introduce dma buffer sharing mechanism
Message-ID: <20120125200701.GH3896@phenom.ffwll.local>
Mail-Followup-To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, arnd@arndb.de, airlied@redhat.com,
	linux@arm.linux.org.uk, jesse.barker@linaro.org,
	m.szyprowski@samsung.com, rob@ti.com, patches@linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>
References: <1324891397-10877-1-git-send-email-sumit.semwal@ti.com>
 <1324891397-10877-2-git-send-email-sumit.semwal@ti.com>
 <4F2035B1.4020204@samsung.com>
MIME-Version: 1.0
In-Reply-To: <4F2035B1.4020204@samsung.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 06:02:41PM +0100, Tomasz Stanislawski wrote:
> Hi Sumit,
> 
> On 12/26/2011 10:23 AM, Sumit Semwal wrote:
> >This is the first step in defining a dma buffer sharing mechanism.
> >
> >A new buffer object dma_buf is added, with operations and API to allow easy
> >sharing of this buffer object across devices.
> >
> >The framework allows:
> >- creation of a buffer object, its association with a file pointer, and
> >    associated allocator-defined operations on that buffer. This operation is
> >    called the 'export' operation.
> >- different devices to 'attach' themselves to this exported buffer object, to
> >   facilitate backing storage negotiation, using dma_buf_attach() API.
> >- the exported buffer object to be shared with the other entity by asking for
> >    its 'file-descriptor (fd)', and sharing the fd across.
> >- a received fd to get the buffer object back, where it can be accessed using
> >    the associated exporter-defined operations.
> >- the exporter and user to share the scatterlist associated with this buffer
> >    object using map_dma_buf and unmap_dma_buf operations.
> >
> 
> [snip]
> 
> >+/**
> >+ * struct dma_buf_attachment - holds device-buffer attachment data
> >+ * @dmabuf: buffer for this attachment.
> >+ * @dev: device attached to the buffer.
> >+ * @node: list of dma_buf_attachment.
> >+ * @priv: exporter specific attachment data.
> >+ *
> >+ * This structure holds the attachment information between the dma_buf buffer
> >+ * and its user device(s). The list contains one attachment struct per device
> >+ * attached to the buffer.
> >+ */
> >+struct dma_buf_attachment {
> >+	struct dma_buf *dmabuf;
> >+	struct device *dev;
> >+	struct list_head node;
> >+	void *priv;
> >+};
> >+
> >+#ifdef CONFIG_DMA_SHARED_BUFFER
> >+struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> >+							struct device *dev);
> >+void dma_buf_detach(struct dma_buf *dmabuf,
> >+				struct dma_buf_attachment *dmabuf_attach);
> >+struct dma_buf *dma_buf_export(void *priv, struct dma_buf_ops *ops,
> >+			size_t size, int flags);
> >+int dma_buf_fd(struct dma_buf *dmabuf);
> >+struct dma_buf *dma_buf_get(int fd);
> >+void dma_buf_put(struct dma_buf *dmabuf);
> >+
> >+struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
> >+					enum dma_data_direction);
> >+void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *);
> 
> I think that you should add enum dma_data_direction as an argument
> unmap function. It was mentioned that the dma_buf_attachment should keep
> cached and mapped sg_table for performance reasons. The field
> dma_buf_attachment::priv seams to be a natural place to keep this sg_table.
> To map a buffer the exporter calls dma_map_sg. It needs dma direction
> as an argument. The problem is that dma_unmap_sg also needs this
> argument but dma direction is not available neither in
> dma_buf_unmap_attachment nor in unmap callback. Therefore the exporter
> is forced to embed returned sg_table into a bigger structure where
> dma direction is remembered. Refer to function vb2_dc_dmabuf_ops_map
> at

Oops, makes sense. I've totally overlooked that we need to pass in the dma
direction also for the unmap call to the dma subsystem. Sumit, can you
stitch together that small patch?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
