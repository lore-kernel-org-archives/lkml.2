Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab2CUWon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:44:43 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42101 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2CUWoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:44:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120321222528.GA20712@phenom.ffwll.local>
References: <1332276785-1440-1-git-send-email-daniel.vetter@ffwll.ch>
	<CAF6AEGsBZ5BBBBGKZ5VSJOr70=9Qpp1pq+2m4d_vgsveW+3Atw@mail.gmail.com>
	<CALJcvx5+g2+tZPp-2PJg04AOzYuv0eZyih542M+ghjQLFeBmFg@mail.gmail.com>
	<20120321222528.GA20712@phenom.ffwll.local>
Date: Wed, 21 Mar 2012 15:44:38 -0700
X-Google-Sender-Auth: N-vAoYa8hvJIIyNNyNvG2UQVWCU
Message-ID: <CALJcvx422uZ4Wb346=bvDvp1iLGOdSwJ6qKc5nLwRO4NQbQK1Q@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] [RFC] dma-buf: mmap support
From: Rebecca Schultz Zavin <rebecca@android.com>
To: Rebecca Schultz Zavin <rebecca@android.com>,
        Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 3:25 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Mar 21, 2012 at 10:46:14AM -0700, Rebecca Schultz Zavin wrote:
>> I want to make sure I understand how this would work.  I've been planning
>> on making cache maintenance implicit, and most of the corresponding
>> userspace components I've seen for android expect to do implicit cache
>> maintenance on these buffers if they need cached mappings.  The android
>> framework has a logical place for this maintenance to take place.  I assume
>> that you'd detect a buffer leaving the cpu domain by using the
>> dma_data_direction passed to dma_buf_map_attachment?  We're definitely
>> pushing a bunch of complexity into the exporter, that at least on android
>> could easily be covered by an explicit api.  I'm not dead set against it, I
>> just want to make sure I get it right if we go down this road.
>
> Hm, you're talking about implicit cache management, which I read as: The
> kernel does some magic so that userspace doesn't have to care. But I guess
> you mean what I'd call explicit cache management, where userspace tells
> the kernel which ranges to invalidate/flush?

Sorry, yeah, I got that backwards :)  I definitely mean that I
intended to do all the cache maintenance explicitly.

>
> The idea is that the exporter would invalidate cpu caches at fault time.
> And when a dma-device wants to read from it (using the direction argument
> of dma_buf_map_attachement) it would shoot down the mappings, flush caches
> and then allow the dma op to happen. Note that this is obvously only
> required if the mapping is not coherent (uc/wc on arm).

This makes sense to me though I have to sort thought exactly how to
implement it.

>
> I agree that for cached mappings this will suck, but to get dma-buf of the
> ground I prefer a simpler interface at the beginning, which could get
> extended later on. The issue is that I expect that a few importers simply
> can't hanlde cache management with explicit flush/invalidate ioctl calls
> from userspace and we hence need coherently-looking mappings anyway.

Couldn't this just as easily be handled by not having those mappings
be mapped cached or write combine to userspace?  They'd be coherent,
just slow.  I'm not sure we can actually say that all these cpu access
are necessary slow path operations anyway.  On android we do sometimes
decide to software render things to eliminate the overhead of
maintaining a hardware context for context switching the gpu.   If you
want cached or writecombine mappings you'd have to manage them
explicitly.  If you can't manage them explicitly you have to settle
for slow.  That seems reasonable to me.

As far as I can tell with explicit operations I have to invalidate
before touching from mmap and clean after.  With these implicit ones,
I stil have to invalidate and clean, but now I also have to remap them
before and after.  I don't know what the performance hit of this
remapping step is, but I'd like to if you have any insight.

Rebecca

>
> Imo the best way to enable cached mappings is to later on extend dma-buf
> (as soon as we have some actual exporters/importers in the mainline
> kernel) with an optional cached_mmap interface which requires explict
> prepare_mmap_access/finish_mmap_acces calls. Then if both exporter and
> importer support this, it could get used - otherwise the dma-buf layer
> could transparently fall back to coherent mappings.
>
> Cheers, Daniel
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
