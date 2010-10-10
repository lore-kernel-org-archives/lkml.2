Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0JJPL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:11:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab0JJPL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:11:28 -0400
Message-ID: <4CB1D79A.6070805@redhat.com>
Date: Sun, 10 Oct 2010 17:11:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk>
In-Reply-To: <4CAC9CD1.2050601@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/06/2010 05:59 PM, Ian Molton wrote:
> This patch implements a virtio-based transport for use by a 
> virtualised OpenGL passthrough implementation.
>
> The libGL and qemu-gl code to support this patch are available here:
>
> http://gitorious.org/vm-gl-accel/qemu-gl
> http://gitorious.org/vm-gl-accel/qemu-libgl
>
>
> Comments please!

1. copy qemu-devel an virtualization@, many virtio developers live there.

2. should start with a patch to the virtio-pci spec to document what 
you're doing


> +static int put_data(struct virtio_gl_data *gldata)
> +{
> +	struct scatterlist *sg, *sg_list;
> +	unsigned int count, ret, o_page, i_page, sg_entries;
> +	struct virtio_gl_header *header =
> +				(struct virtio_gl_header *)gldata->buffer;
> +
> +	ret = header->buf_size;
> +
> +	o_page = (header->buf_size + PAGE_SIZE-1)>>  PAGE_SHIFT;

...

> +	sg_init_table(sg_list, sg_entries);
> +
> +	sg = vmalloc_to_sg(sg_list, gldata->buffer, o_page);
> +	sg = vmalloc_to_sg(sg, gldata->buffer, i_page);
> +
> +	if (!sg) {
> +		ret = -EIO;
> +		goto out_free;
> +	}
> +
> +	/* Transfer data */
> +	if (virtqueue_add_buf(vq, sg_list, o_page, i_page, (void *)1)>= 0) {
> +		virtqueue_kick(vq);
> +		/* Chill out until it's done with the buffer. */
> +		while (!virtqueue_get_buf(vq,&count))
> +			cpu_relax();
> +	}
> +

This is pretty gross, and will burn lots of cpu if the hypervisor 
processes the queue asynchronously.

-- 
error compiling committee.c: too many arguments to function

