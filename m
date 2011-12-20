Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1LTW0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:26:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59186 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LTW0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:26:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzi5MyCBMJhWBM_ouL=QOaxX3K6KZ8K+t7dUYJLQrF+yA@mail.gmail.com>
References: <1324283611-18344-1-git-send-email-sumit.semwal@ti.com>
	<20111220193117.GD3883@phenom.ffwll.local>
	<CAPM=9tzi5MyCBMJhWBM_ouL=QOaxX3K6KZ8K+t7dUYJLQrF+yA@mail.gmail.com>
Date: Tue, 20 Dec 2011 16:26:05 -0600
X-Google-Sender-Auth: JWu3p4Ej1AuWVxhS6NoiNUtp5hM
Message-ID: <CAF6AEGt9Ae_zVmhBmmtfyKrqC4EyBgAAO1RWdK_UhY-1RLfOSQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v3 0/2] Introduce DMA buffer sharing mechanism
From: Rob Clark <rob@ti.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        jesse.barker@linaro.org, m.szyprowski@samsung.com,
        t.stanislaws@samsung.com, patches@linaro.org, daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 2:20 PM, Dave Airlie <airlied@gmail.com> wrote:
>>>
>>> This is RFC v3 for DMA buffer sharing mechanism - changes from v2 are in the
>>> changelog below.
>>>
>>> Various subsystems - V4L2, GPU-accessors, DRI to name a few - have felt the
>>> need to have a common mechanism to share memory buffers across different
>>> devices - ARM, video hardware, GPU.
>>>
>>> This need comes forth from a variety of use cases including cameras, image
>>> processing, video recorders, sound processing, DMA engines, GPU and display
>>> buffers, and others.
>>>
>>> This RFC is an attempt to define such a buffer sharing mechanism- it is the
>>> result of discussions from a couple of memory-management mini-summits held by
>>> Linaro to understand and address common needs around memory management. [1]
>>>
>>> A new dma_buf buffer object is added, with operations and API to allow easy
>>> sharing of this buffer object across devices.
>>>
>>> The framework allows:
>>> - a new buffer-object to be created with fixed size.
>>> - different devices to 'attach' themselves to this buffer, to facilitate
>>>   backing storage negotiation, using dma_buf_attach() API.
>>> - association of a file pointer with each user-buffer and associated
>>>    allocator-defined operations on that buffer. This operation is called the
>>>    'export' operation.
>>> - this exported buffer-object to be shared with the other entity by asking for
>>>    its 'file-descriptor (fd)', and sharing the fd across.
>>> - a received fd to get the buffer object back, where it can be accessed using
>>>    the associated exporter-defined operations.
>>> - the exporter and user to share the scatterlist using map_dma_buf and
>>>    unmap_dma_buf operations.
>>>
>>> Documentation present in the patch-set gives more details.
>>>
>>> This is based on design suggestions from many people at the mini-summits,
>>> most notably from Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
>>> Daniel Vetter <daniel@ffwll.ch>.
>>>
>>> The implementation is inspired from proof-of-concept patch-set from
>>> Tomasz Stanislawski <t.stanislaws@samsung.com>, who demonstrated buffer sharing
>>> between two v4l2 devices. [2]
>>>
>>> References:
>>> [1]: https://wiki.linaro.org/OfficeofCTO/MemoryManagement
>>> [2]: http://lwn.net/Articles/454389
>>>
>>> Patchset based on top of 3.2-rc3, the current version can be found at
>>>
>>> http://git.linaro.org/gitweb?p=people/sumitsemwal/linux-3.x.git
>>> Branch: dma-buf-upstr-v2
>>>
>>> Earlier versions:
>>> v2 at: https://lkml.org/lkml/2011/12/2/53
>>> v1 at: https://lkml.org/lkml/2011/10/11/92
>>>
>>> Best regards,
>>> ~Sumit Semwal
>>
>> I think this is a really good v1 version of dma_buf. It contains all the
>> required bits (with well-specified semantics in the doc patch) to
>> implement some basic use-cases and start fleshing out the integration with
>> various subsystem (like drm and v4l). All the things still under
>> discussion like
>> - userspace mmap support
>> - more advanced (and more strictly specified) coherency models
>> - and shared infrastructure for implementing exporters
>> are imo much clearer once we have a few example drivers at hand and a
>> better understanding of some of the insane corner cases we need to be able
>> to handle.
>>
>> And I think any risk that the resulting clarifications will break a basic
>> use-case is really minimal, so I think it'd be great if this could go into
>> 3.3 (maybe as some kind of staging/experimental infrastructure).
>>
>> Hence for both patches:
>> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>
> Yeah I'm with Daniel, I like this one, I can definitely build the drm
> buffer sharing layer on top of this.
>
> How do we see this getting merged? I'm quite happy to push it to Linus
> if we don't have an identified path, though it could go via a Linaro
> tree as well.
>
> so feel free to add:
> Reviewed-by: Dave Airlie <airlied@redhat.com>

fwiw, patches to share buffers between drm and v4l2 are here:

https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf

(need a bit of cleanup before the vb2 patches are submitted.. but that
is unrelated to the dmabuf patches)

so,

Reviewed-and-Tested-by: Rob Clark <rob.clark@linaro.org>

> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
