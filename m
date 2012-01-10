Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2AJJTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:19:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47289 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2AJJTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <CAAQKjZPH10a0-yjyUrqPYWv2nyZ9m2KJ6nm2d+pAqRb2CxRwsQ@mail.gmail.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
	<CAAQKjZPFh6666JKc-XJfKYePQ_F0MNF6FkY=zKypWb52VVX3YQ@mail.gmail.com>
	<20120109081030.GA3723@phenom.ffwll.local>
	<CAAQKjZMEsuib18RYE7OvZPUqhKnvrZ8i3+EMuZSXr9KPVygo_Q@mail.gmail.com>
	<CAF6AEGsTGOxyTX6Xijvm8UXGjtVTtYg5X5xfJo8D+47o+xU+bA@mail.gmail.com>
	<CAAQKjZNM51Oenhi-S-9kyq_mLYHBEsMQA3M6=6L_XNnKu5pLbA@mail.gmail.com>
	<CAF6AEGsQdd+K6-OOsdyFi_VVnMCniZFk2QvYqv8m8GgU7bd7zQ@mail.gmail.com>
	<CAB2ybb-vZuriqE+KeBAkbc33y8YvNkT+f0xnMUeOdXmJH0dSag@mail.gmail.com>
	<CAAQKjZPH10a0-yjyUrqPYWv2nyZ9m2KJ6nm2d+pAqRb2CxRwsQ@mail.gmail.com>
Date: Tue, 10 Jan 2012 18:19:08 +0900
Message-ID: <CAAQKjZOxMR-s3Fc9toXspN_a7azj==4mzAnCffWio8oEXyC9pQ@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: InKi Dae <daeinki@gmail.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Cc: Rob Clark <rob@ti.com>, t.stanislaws@samsung.com, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, m.szyprowski@samsung.com,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/10 InKi Dae <daeinki@gmail.com>:
> 2012/1/10 Semwal, Sumit <sumit.semwal@ti.com>:
>> On Tue, Jan 10, 2012 at 7:44 AM, Rob Clark <rob@ti.com> wrote:
>>> On Mon, Jan 9, 2012 at 7:34 PM, InKi Dae <daeinki@gmail.com> wrote:
>>>> 2012/1/10 Rob Clark <rob@ti.com>:
>>>> at least with no IOMMU, the memory information(containing physical
>>>> memory address) would be copied to vb2_xx_buf object if drm gem
>>>> exported its own buffer and vb2 wants to use that buffer at this time,
>>>> sg table is used to share that buffer. and the problem I pointed out
>>>> is that this buffer(also physical memory region) could be released by
>>>> vb2 framework(as you know, vb2_xx_buf object and the memory region for
>>>> buf->dma_addr pointing) but the Exporter(drm gem) couldn't know that
>>>> so some problems would be induced once drm gem tries to release or
>>>> access that buffer. and I have tried to resolve this issue adding
>>>> get_shared_cnt() callback to dma-buf.h but I'm not sure that this is
>>>> good way. maybe there would be better way.
>> Hi Inki,
>> As also mentioned in the documentation patch, importer (the user of
>> the buffer) - in this case for current RFC patches on
>> v4l2-as-a-user[1] vb2 framework - shouldn't release the backing memory
>> of the buffer directly - it should only use the dma-buf callbacks in
>> the right sequence to let the exporter know that it is done using this
>> buffer, so the exporter can release it if allowed and needed.
>
> thank you for your comments.:) and below are some tables about dmabuf
> operations with ideal use and these tables indicate reference count of
> when buffer is created, shared and released. so if there are any
> problems, please let me know. P.S. these are just simple cases so
> there would be others.
>
>
> in case of using only drm gem and dmabuf,
>
> operations                       gem refcount    file f_count   buf refcount
> ------------------------------------------------------------------------------------------------
> 1. gem create                   A:1                                   A:0
> 2. export(handle A -> fd)    A:2                A:1              A:0
> 3. import(fd -> handle B)    A:2, B:1         A:2              A:1
> 4. file close(A)                  A:2, B:1         A:1              A:1
> 5. gem close(A)                A:1, B:1         A:1              A:1
> 6. gem close(B)                A:1, B:0         A:1              A:0
> 7. file close(A)                  A:0                A:0
> -----------------------------------------------------------------------------------------------
> 3. handle B shares the buf of handle A.
> 6. release handle B but its buf.
> 7. release gem handle A and dmabuf of file A and also physical memory region.
>
>
> and in case of using drm gem, vb2 and dmabuf,
>
> operations                  gem, vb2 refcount    file f_count   buf refcount
> ------------------------------------------------------------------------------------------------
> 1. gem create                   A:1                 A:0
>   (GEM side)
> 2. export(handle A -> fd)    A:2                 A:1              A:0
>   (GEM side)
> 3. import(fd -> handle B)    A:2, B:1          A:2              A:1
>   (VB2 side)
> 4. file close(A)                  A:2, B:1          A:1              A:1
>   (VB2 side)
> 5. vb2 close(B)                 A:2, B:0          A:1              A:0
>   (VB2 side)
> 6. gem close(A)                A:1                A:1              A:0
>   (GEM side)
> 7. file close(A)                  A:0                A:0
>   (GEM side)
> ------------------------------------------------------------------------------------------------
> 3. vb2 handle B is shared with the buf of gem handle A.
> 5. release vb2 handle B and decrease refcount of the buf pointed by it.
> 7. release gem handle A and dmabuf of file A and also physical memory region.
>

Ah, sorry, it seems that file close shouldn't be called because
file->f_count of the file would be dropped by Importer and if f_count
is 0 then the file would be released by fput() so I'm not sure but
again:

in case of using only drm gem and dmabuf,

operations                       gem refcount      file f_count   buf refcount
--------------------------------------------------------------------------------------------------
1. gem create(A)               A:1                                     A:0
2. export(handle A -> fd)    A:2                  A:1              A:0
3. import(fd -> handle B)    A:2, B:1           A:2              A:1
4. gem close(B)                A:2, B:release  A:1              A:0
5. gem close(A)                A:1,                 A:1              A:0
6. gem close(A)                A:release         A:release     A:release
-------------------------------------------------------------------------------------------------

and in case of using drm gem, vb2 and dmabuf,

operations                  gem, vb2 refcount    file f_count   buf refcount
------------------------------------------------------------------------------------------------
1. gem create                   A:1                 A:0              A:0
  (GEM side)
2. export(handle A -> fd)    A:2                 A:1              A:0
  (GEM side)
3. import(fd -> handle B)    A:2, B:1          A:2              A:1
  (VB2 side)
5. vb2 close(B)                 A:2, B:release  A:1              A:0
  (VB2 side)
6. gem close(A)                A:1                A:1              A:0
  (GEM side)
6. gem close(A)                A:release       A:release      A:release
  (GEM side)
------------------------------------------------------------------------------------------------

>>>
>>> the exporter (in this case your driver's drm/gem bits) shouldn't
>>> release that mapping / sgtable until the importer (in this case v4l2)
>>> calls dma_buf_unmap fxn..
>>>
>>> It would be an error if the importer did a dma_buf_put() without first
>>> calling dma_buf_unmap_attachment() (if currently mapped) and then
>>> dma_buf_detach() (if currently attached).  Perhaps somewhere there
>>> should be some sanity checking debug code which could be enabled to do
>>> a WARN_ON() if the importer does the wrong thing.  It shouldn't really
>>> be part of the API, I don't think, but it actually does seem like a
>>> good thing, esp. as new drivers start trying to use dmabuf, to have
>>> some debug options which could be enabled.
>>>
>>> It is entirely possible that something was missed on the vb2 patches,
>>> but the way it is intended to work is like this:
>>> https://github.com/robclark/kernel-omap4/blob/0961428143cd10269223e3d0f24bc3a66a96185f/drivers/media/video/videobuf2-core.c#L92
>>>
>>> where it does a detach() before the dma_buf_put(), and the vb2-contig
>>> backend checks here that it is also unmapped():
>>> https://github.com/robclark/kernel-omap4/blob/0961428143cd10269223e3d0f24bc3a66a96185f/drivers/media/video/videobuf2-dma-contig.c#L251
>>
>> The proposed RFC for V4L2 adaptation at [1] does exactly the same
>> thing; detach() before dma_buf_put(), and check in vb2-contig backend
>> for unmapped() as mentioned above.
>>
>>>
>>> BR,
>>> -R
>>>
>> BR,
>> Sumit.
>>
>> [1]: V4l2 as a dma-buf user RFC:
>> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/42966
