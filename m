Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2HFK3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 06:29:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33197 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2HFK3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 06:29:39 -0400
Message-id: <501F9C8E.4080002@samsung.com>
Date: Mon, 06 Aug 2012 12:29:34 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: Rob Clark <rob.clark@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        patches@linaro.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, daniel@ffwll.ch,
        sumit.semwal@ti.com, maarten.lankhorst@canonical.com,
        Rob Clark <rob@ti.com>
Subject: Re: [PATCH 2/2] dma-buf: add helpers for attacher dma-parms
References: <1342715014-5316-1-git-send-email-rob.clark@linaro.org>
 <1342715014-5316-3-git-send-email-rob.clark@linaro.org>
In-reply-to: <1342715014-5316-3-git-send-email-rob.clark@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On 07/19/2012 06:23 PM, Rob Clark wrote:
> From: Rob Clark <rob@ti.com>
> 
> Add some helpers to iterate through all attachers and get the most
> restrictive segment size/count/boundary.
> 
> Signed-off-by: Rob Clark <rob@ti.com>
> ---
>  drivers/base/dma-buf.c  |   63 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h |   19 ++++++++++++++
>  2 files changed, 82 insertions(+)
> 
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 24e88fe..757ee20 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -192,6 +192,69 @@ void dma_buf_put(struct dma_buf *dmabuf)
>  EXPORT_SYMBOL_GPL(dma_buf_put);
>  
>  /**
> + * dma_buf_max_seg_size - helper for exporters to get the minimum of
> + * all attached device's max segment size
> + */
> +unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf)
> +{
> +	struct dma_buf_attachment *attach;
> +	unsigned int max = (unsigned int)-1;
> +
> +	if (WARN_ON(!dmabuf))
> +		return 0;

Maybe you should change return type to 'int' and return -EINVAL here?

> +
> +	mutex_lock(&dmabuf->lock);
> +	list_for_each_entry(attach, &dmabuf->attachments, node)
> +		max = min(max, dma_get_max_seg_size(attach->dev));
> +	mutex_unlock(&dmabuf->lock);
> +
> +	return max;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_max_seg_size);
> +
> +/**
> + * dma_buf_max_seg_count - helper for exporters to get the minimum of
> + * all attached device's max segment count
> + */
> +unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf)
> +{
> +	struct dma_buf_attachment *attach;
> +	unsigned int max = (unsigned int)-1;
> +
> +	if (WARN_ON(!dmabuf))
> +		return 0;

maybe return -EINVAL here?

> +
> +	mutex_lock(&dmabuf->lock);
> +	list_for_each_entry(attach, &dmabuf->attachments, node)
> +		max = min(max, dma_get_max_seg_count(attach->dev));

I think that there is a bug here.
Assume that there are two deices on the list, one using unlimited number of
segments (value 0), the second one needs a contiguous buffer (value 1).
The result of the function is 0 = min(0, 2).

The return value 0 indicates that the unlimited number of sg segments is
accepted what is *wrong* because the correct value should be 1.

I recommend to change the semantics for unlimited number of segments
from 'value 0' to:

#define DMA_SEGMENTS_COUNT_UNLIMITED ((unsigned long)INT_MAX)

Using INT_MAX will allow using safe conversions between signed and
unsigned integers.

> +	mutex_unlock(&dmabuf->lock);
> +
> +	return max;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_max_seg_count);
> +
> +/**
> + * dma_buf_get_seg_boundary - helper for exporters to get the most
> + * restrictive segment alignment of all the attached devices
> + */
> +unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf)
> +{
> +	struct dma_buf_attachment *attach;
> +	unsigned int mask = (unsigned int)-1;
> +
> +	if (WARN_ON(!dmabuf))
> +		return 0;
> +
> +	mutex_lock(&dmabuf->lock);
> +	list_for_each_entry(attach, &dmabuf->attachments, node)
> +		mask &= dma_get_seg_boundary(attach->dev);
> +	mutex_unlock(&dmabuf->lock);
> +
> +	return mask;
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_get_seg_boundary);
> +
> +/**
>   * dma_buf_attach - Add the device to dma_buf's attachments list; optionally,
>   * calls attach() of dma_buf_ops to allow device-specific attach functionality
>   * @dmabuf:	[in]	buffer to attach device to.
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index eb48f38..9533b9b 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -167,6 +167,10 @@ int dma_buf_fd(struct dma_buf *dmabuf, int flags);
>  struct dma_buf *dma_buf_get(int fd);
>  void dma_buf_put(struct dma_buf *dmabuf);
>  
> +unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf);
> +unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf);
> +unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf);

Instead of adding an army of new handlers you could provide a single helper:

int dma_buf_get_parameters(struct dma_buf *dmabuf,
	struct device_dma_parameters *params);

This function will fill *params with lowest common DMA requirements for
all devices on attachment list. Return value can be used to diagnose
errors like incorrectly initialized dma_buf pointer
(like no attachments on an attachment list).

Moreover, there will be no need to add a new handler every time
device_dma_parameters is extended.

Regards,
Tomasz Stanislawski

> +
>  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *,
>  					enum dma_data_direction);
>  void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *,
> @@ -220,6 +224,21 @@ static inline void dma_buf_put(struct dma_buf *dmabuf)
>  	return;
>  }
>  
> +static inline unsigned int dma_buf_max_seg_size(struct dma_buf *dmabuf)
> +{
> +	return 0;
> +}
> +
> +static inline unsigned int dma_buf_max_seg_count(struct dma_buf *dmabuf)
> +{
> +	return 0;
> +}
> +
> +static inline unsigned int dma_buf_get_seg_boundary(struct dma_buf *dmabuf)
> +{
> +	return 0;
> +}
> +
>  static inline struct sg_table *dma_buf_map_attachment(
>  	struct dma_buf_attachment *attach, enum dma_data_direction write)
>  {
> 

