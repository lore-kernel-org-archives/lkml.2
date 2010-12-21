Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab0LUQoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:44:13 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:44723 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0LUQoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:44:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xPPNL3KVQU+4LNhjfXufhM1YTlBDhOwSM7YvDwKM4wFeKsH/g4jO9CsjWJqJOUIw4o
         8FVwTfgcBMgc+MN5p0UYV+V+agYcTCYR8E9Y8NuhifZqfK25XOwbtbDXi0B7NvX+d/l1
         fRyLmI65H4sCY4GojfHXmN1g6WP0PDcwbhspI=
MIME-Version: 1.0
In-Reply-To: <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
Date: Tue, 21 Dec 2010 18:44:10 +0200
Message-ID: <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Tue, Dec 21, 2010 at 4:06 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Mon, Dec 20, 2010 at 8:43 PM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> We need to protect not only the dmm_map list, but the individual
>> map_obj's, otherwise, we might be building the scatter-gather list with
>> garbage.
>
> Thanks for reporting this !
>
>> So, use the existing proc_lock for that.
>
> I don't like this.
>
> You are taking this lock over the entire proc_begin_dma() and
> proc_end_dma() functions, and by that artificially imposing sequential
> behavior of their execution (system-wide).

Wouldn't you want the proc_*_dma() operations to finish before
unmaping the pages? I think this sequence is not artificial; it's
actually the desired behavior.

> I strongly prefer protecting the dmm map object itself, and not the
> code that uses it, in order to avoid redundant bottlenecks.
>
> Something like the patch below should fix the panics without globally
> locking the dma functions (UNTESTED! I still want to have a gst-dsp
> setup like yours so I can reproduce the issues you see. If needed,
> I'll get to it).

I have actually documented how I create it:
http://felipec.wordpress.com/2010/10/08/my-arm-development-notes/

I even provided a tarball with all the GStreamer stuff you can extract
to /opt/gst and use on any system (with a reasonable glibc):
http://people.freedesktop.org/~felipec/arm-gst-dev.tar.gz

The actual test I'm using to trigger this issue is way more
complicated, but I could try to simplify it.

> Please note: the code below assumes that applications calls
> proc_end_dma() for every proc_begin_dma().  This is anyway mandatory,
> because otherwise we are risking data corruptions, but we know older
> applications (e.g. probably TI samples) don't do that (since the
> dspbridge's DMA API is relatively new). If we want/need to support
> those older applications with this patch, it's a 2-liner change.

I analyzed this when you introduced the patches, and I found that at
least the OpenMAX code at that time wasn't even doing any DMA
operation; just mapping and unmapping. So it's not an issue for that.

> But there is another issue. I'm not quite sure how gst-dsp is using
> the bridge DMA API, but those panics may suggest that there are
> additional races here: if the application unmaps a memory region,
> before the DMA operation completes (i.e. proc_end_dma() completed
> execution), the application will face:

gst-dsp is so far using the old API.

> 1. errors: when proc_end_dma() does get invoked, the map_obj will
> already be destroyed, and find_containing_mapping() will simply fail

That's not a big issue; a mere warning (that wouldn't happen anyway
because user-space either calls proc_end_dma(), or it doesn't).

> 2. data corruptions: as a result of (1), dma_unmap_sg() will not be
> called, and that may result in data corruptions and generally is very
> bad

That depends on particular systems. My understanding is that unless
speculative pre-fetching is enabled, which TI suggests not to do on
OMAP3430 and OMAP3630, there's actually no issue.

Not to mention that gst-dsp is supposed to work on old kernels that
don't even do the proper flushes on dma_unmap_sg() (pre .34 I think).

> We can treat this as an application error, but we don't have to, and
> it will actually be very clean if we won't.
>
> Given the below patch, it should be quite easy to solve those
> additional races too, e.g., by adding a boolean 'dying' flag to each
> map_obj, which would (on un_map) mark an object as not available for a
> new DMA operation (proc_start_dma), but it'd still wait until all of
> its referenced are removed (proc_end_dma), and only then it will be
> finally removed from the list.

That sounds very dangerous. So basically you would be allowing to do
dma_unmap_sg() *after* the pages have been unmapped, and thus not
pinned (put_page()); I don't think you are supposed to do that.
Wouldn't it be possible that the pages get swapped out?

> Such a change will only work with applications that calls
> proc_end_dma() for each proc_start_dma(). How is gst-dsp in that
> respect ? do we want to keep supporting older applications which don't
> do that ? if we want, we can still support both old and new API with
> some ioctl games (introduce new ioctl commands which will work the new
> way, and keep the old ones around, maybe only mark them as
> deprecated).

IMO, as long as the old API is there (and not even deprecated), the
code should support that behavior. Once that API is removed, then we
can think about stopping that support.

I don't see what is the problem. Currently the bulk of DMA operations
are done through mapping/unmapping and thus the proc_lock is used _all
the time_ already (by both gst-dsp and TI OpenMAX). The problem is
that gst-dsp uses the flush/invalidate API for a few small chunks of
data (1 page), and this patch is just extending the lock for that.
Even if somebody uses this API for big chunks of data, the performance
can't be worst than the current mapping/unmapping of huge memory
areas.

Cheers.

-- 
Felipe Contreras
