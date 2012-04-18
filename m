Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2DROU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:20:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59136 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2DROU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <201204181406.14159.arnd@arndb.de>
References: <1334757146-28335-1-git-send-email-daniel.vetter@ffwll.ch>
	<201204181406.14159.arnd@arndb.de>
Date: Wed, 18 Apr 2012 09:20:26 -0500
X-Google-Sender-Auth: uObkf63SdNkvgDyix5ssy3jxgXQ
Message-ID: <CAF6AEGujx1oN-xoSduSxmZxWv-GmTyw2JCS3kpXSSGLDUgPM6A@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: mmap support
From: Rob Clark <rob.clark@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org,
        Rebecca Schultz Zavin <rebecca@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 9:06 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 18 April 2012, Daniel Vetter wrote:
>> +   Because existing importing subsystems might presume coherent mappings for
>> +   userspace, the exporter needs to set up a coherent mapping. If that's not
>> +   possible, it needs to fake coherency by manually shooting down ptes when
>> +   leaving the cpu domain and flushing caches at fault time. Note that all the
>> +   dma_buf files share the same anon inode, hence the exporter needs to replace
>> +   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
>> +   requred. This is because the kernel uses the underlying inode's address_space
>> +   for vma tracking (and hence pte tracking at shootdown time with
>> +   unmap_mapping_range).
>> +
>> +   If the above shootdown dance turns out to be too expensive in certain
>> +   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
>> +   for userspace mappings. But the current assumption is that using mmap is
>> +   always a slower path, so some inefficiencies should be acceptable.
>> +
>> +   Exporters that shoot down mappings (for any reasons) shall not do any
>> +   synchronization at fault time with outstanding device operations.
>> +   Synchronization is an orthogonal issue to sharing the backing storage of a
>> +   buffer and hence should not be handled by dma-buf itself. This is explictly
>> +   mentioned here because many people seem to want something like this, but if
>> +   different exporters handle this differently, buffer sharing can fail in
>> +   interesting ways depending upong the exporter (if userspace starts depending
>> +   upon this implicit synchronization).
>
> How do you ensure that no device can do DMA on the buffer while it's mapped
> into user space in a noncoherent manner?

you do unmap_mapping_range() before DMA..

if you have userspace accessing buffer simultaneously with DMA then
the results are undefined, as they always have been (even w/ uncached
mappings)

BR,
-R

>
>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
