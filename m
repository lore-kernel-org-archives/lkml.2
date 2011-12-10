Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1LJECG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 23:02:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39804 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1LJECB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 23:02:01 -0500
MIME-Version: 1.0
X-Originating-IP: [12.185.155.194]
In-Reply-To: <20111209142405.6f371be6@pyramind.ukuu.org.uk>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<201112071340.35267.arnd@arndb.de>
	<CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
	<201112091413.03736.arnd@arndb.de>
	<20111209142405.6f371be6@pyramind.ukuu.org.uk>
Date: Sat, 10 Dec 2011 05:01:59 +0100
X-Google-Sender-Auth: Edwgl-o41On3LHHgY06oQX2VYvY
Message-ID: <CAKMK7uH+4uSYYjBLcvfhVC+iwGUZ09Z4p64fNBzh196aG+hqgg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer
 sharing mechanism
From: Daniel Vetter <daniel@ffwll.ch>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, "Semwal, Sumit" <sumit.semwal@ti.com>,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 15:24, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I still don't think that's possible. Please explain how you expect
>> to change the semantics of the streaming mapping API to allow multiple
>> mappers without having explicit serialization points that are visible
>> to all users. For simplicity, let's assume a cache coherent system

I think I understand the cache flushing issues on arm (we're doing a
similar madness with manually flushing caches for i915 because the gpu
isn't coherent with the cpu and other dma devices). And I also agree
that you cannot make concurrent mappings work without adding something
on top of the current streaming api/dma-buf proposal. I just think
that it's not the kernel's business (well, at least not dma_buf's
business) to enforce that. If userspace (through some driver calls)
tries to do stupid things, it'll just get garbage. See
Message-ID: <CAKMK7uHeXYn-v_8cmpLNWsFY14KtmuRZy8YRKR5Xst2-2WdFSQ@mail.gmail.com>
for my reasons why it think this is the right way to go forward. So in
essence I'm really interested in the reasons why you want the kernel
to enforce this (or I'm completely missing what's the contentious
issue here).

> I would agree. It's not just about barriers but in many cases where you
> have multiple mappings by hardware devices the actual hardware interface
> is specific to the devices. Just take a look at the fencing in TTM and
> the graphics drivers.
>
> Its not something the low level API can deal with, it requires high level
> knowledge.

Yes, we might want to add some form of in-kernel sync objects on top
of dma_buf, but I'm not really convinced that this will buy us much
above simply synchronizing access in userspace with the existing ipc
tools. In my experience the expensive part of syncing two graphics
engines with the cpu is that we wake up the cpu and prevent it from
going into low-power states if we do this too often. Adding some more
overhead by going through userspace doesn't really make it much worse.
It's a completely different story if there's a hw facility to
synchronize engines without the cpu's involvement (like there is on
every multi-pipe gpu) and there sync objects make tons of sense. But
I'm not aware of that existing on SoCs between different IP blocks.

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
