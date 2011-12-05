Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1LESzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:55:47 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51312 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1LESzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:55:45 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <201112051718.48324.arnd@arndb.de>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
	<201112051718.48324.arnd@arndb.de>
Date: Mon, 5 Dec 2011 19:55:44 +0100
X-Google-Sender-Auth: yfvb63aFJQ9a0_ULvxRtr_YSOhU
Message-ID: <CAKMK7uE-ZJ-VQRWy+zJJWsvr9nARWuf-4nupXhTJ0CLqC88CEw@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: Daniel Vetter <daniel@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux@arm.linux.org.uk,
        jesse.barker@linaro.org, m.szyprowski@samsung.com, rob@ti.com,
        daniel@ffwll.ch, t.stanislaws@samsung.com,
        Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 05:18:48PM +0000, Arnd Bergmann wrote:
> On Friday 02 December 2011, Sumit Semwal wrote:
> > +	/* allow allocator to take care of cache ops */
> > +	void (*sync_sg_for_cpu) (struct dma_buf *, struct device *);
> > +	void (*sync_sg_for_device)(struct dma_buf *, struct device *);
>
> I don't see how this works with multiple consumers: For the streaming
> DMA mapping, there must be exactly one owner, either the device or
> the CPU. Obviously, this rule needs to be extended when you get to
> multiple devices and multiple device drivers, plus possibly user
> mappings. Simply assigning the buffer to "the device" from one
> driver does not block other drivers from touching the buffer, and
> assigning it to "the cpu" does not stop other hardware that the
> code calling sync_sg_for_cpu is not aware of.
>
> The only way to solve this that I can think of right now is to
> mandate that the mappings are all coherent (i.e. noncachable
> on noncoherent architectures like ARM). If you do that, you no
> longer need the sync_sg_for_* calls.

Woops, totally missed the addition of these. Can somebody explain to used
to rather coherent x86 what we need these for and the code-flow would look
like in a typical example. I was kinda assuming that devices would bracket
their use of a buffer with the attachment_map/unmap calls and any cache
coherency magic that might be needed would be somewhat transparent to
users of the interface?

The map call gets the dma_data_direction parameter, so it should be able
to do the right thing. And because we keep the attachement around, any
caching of mappings should be possible, too.

Yours, Daniel

PS: Slightly related, because it will make the coherency nightmare worse,
afaict: Can we kill mmap support?
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
