Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1KWPfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 10:35:14 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39207 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1KWPfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 10:35:11 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.4.235]
In-Reply-To: <4ECC6838.1010009@codeaurora.org>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-2-git-send-email-ohad@wizery.com> <4ECC6838.1010009@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 23 Nov 2011 17:34:50 +0200
Message-ID: <CAK=WgbbzLKA_D85vOR02fuoCeGugS-rDUup9RihN+Q6TaSudnQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] amp/remoteproc: add framework for controlling remote processors
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Saravana Kannan <skannan@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for the review !

On Wed, Nov 23, 2011 at 5:27 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> How big are the images you're loading? I had to split the memcpy up into
> megabyte chunks because I was running out of virtual memory to map in
> two huge chunks (one for the firmware and one for the image's resting
> place). This may work for now, but I think it will fail for limited
> virtual memory environments. Unless CMA solves this problem?

It definitely should.

The images we specifically load aren't that big (~5MB) but some of the
use cases we have do require around a whopping 100MB, and with CMA
things just work (we do have to reserve a private CMA pool obviously,
but it's a no brainer).

> Also, this code assumes the firmware is actually as big as the elf
> header says it is. It should be checking to make sure the elf_data is
> actually big enough to copy from.

Good point, thanks.

> This is a bit odd. If I understand correctly, you load the firmware at
> least twice. Once to see if the firmware has any virtio devices in the
> resource table, and again when the image is actually loaded into RAM.

Right; the firmware is loaded once at boot time, and then every time
the remote processor is powered up.

The former is required since we publish the remote services and their
configurations (i.e. virtio devices, features and configurations) in
the firmware, as a separate section (i.e. the "resource table"). We
could use a separate file for this table, but we chose to couple it
with the firmware in order to eliminate potential problems where the
wrong resource table is loaded for a given firmware. It really makes
sense since the resource table reflects the capabilities/requirements
of the firmware.

> Is
> there any way to avoid loading it twice? I ask because we have something
> like a 20Mb image that needs to be loaded and I'd like to avoid loading
> it twice just to read a section out of it the first time.

Sure, we could think of several approaches to optimize this, e.g.
either keep the firmware loaded after boot (possibly to some limited
period of time) or just allow platforms to provide their resource
table as a separate file.

Though frankly I'd just prefer to trust the page cache to eliminate
any redundant overhead (at least when the rproc is powered up close
enough to boot time), or just ignore this issue completely: since this
overhead happens only once on boot, and users tend not to really power
off their devices so much, i'm not sure how painful it really is ?

> What do you do if dev goes away?

Call rproc_unregister(), which blocks if request_firmware_nowait()
didn't complete yet.

> What do you think about making remoteproc into a bus?

That's a really interesting idea, with some nice properties.

But I'm not sure if the bus model fits our use cases: buses
exclusively couple a single driver to any given hardware instance
(i.e. device), and I think that a remote processor is more like an
IOMMU: it's a hardware device that is being used by many drivers, and
not exclusively driven by a single one. So we really end up having
several (completely different) drivers that depend on this hardware
block, and need some API to power it up, rather than having a single
driver that manipulates it exclusively.

> I imagine this function
> would allocate a struct device and then rproc_register() would actually
> hook it into the device layer. Then we could use the device we allocate
> here for the firmware requests and we also have a nice namespace for all
> remote processors in the system. Plus all the management code for
> refcounting would come for free with the device layer (modulo the
> rproc_boot() count).

We can probably still do this even without turning remoteproc into a
bus (i.e. by creating this device inside rproc_register()). I
originally pondered whether to do this or not, as many other kernel
frameworks do this too when their ->register() API is invoked, but I
couldn't think of any strong advantages in doing so. Sounds like it
does worth exploring thought, thanks for the comment.

> What is RSC_VIRTIO_CFG?

Sorry, that's an undocumented (and unused) resource entry that is going away.

It was supposed to specify virtio device features for a given virtio
device, but I'm removing it as part of the resource table overhaul I'm
doing: once the resource entries will have a variable length, the
virtio header will just be an inherent part of the virtio device
resource entry.

> For MSM I see two main pain points:
>
>  * CMA is new and untested on MSM. I imagine in MSM's situation we would
> carve out the memory chunks early on for each processor and then only
> remove that memory if the processor is booted? I hope that just works
> somehow.

For ARM v6+, CMA just works. It's really simple and straight forward to use.

>  * rproc is tied to virtio fairly closely.

Only for firmwares that supports virtio. If yours doesn't, you can
probably just ignore the virtio parts (though I really recommend to
think of supporting it in the next relevant generation of chipsets of
yours. It really is great.)

> We probably won't be using
> virtio anytime soon on MSM, unless we can do smd over virtio or
> something. I'm not particularly knowledgeable about that though. Would
> something like that be possible?

Virtio today is highly coupled with its vring transport, which defines
the shared memory "wire" protocol. Using it as-is pretty much means
replacing smd completely (I assume that by smd you mostly care about
keeping your firmware images as-is, which pretty much means using the
smd's shared memory transport).

But there's another way: virtio was originally designed to support
several different transports, and actually had pluggable virtqueue ops
which allowed several different transport implementations to co-exist.
Since virtio_ring was the only transport that anyone ever used for a
few years, the virtqueue ops were squashed and today virtio directly
calls virtio_vring (see 7c5e9ed0c84e7d70d887878574590638d5572659).

By reverting the aforementioned commit, you can potentially do virtio
over smd, where smd will plug as another virtqueue_ops implementation.
This is probably worth exploring, as you could then use rpmsg and the
plethora of virtio drivers without really changing your firmware.

> We would also have to keep using the rproc_get_by_name() approach until
> we can actually start tying rproc devices to other devices in the kernel.

I kept rproc_get_by_name() mainly for you guys :)

I'd really want us to scrutinize its use cases though and see if we
can get rid of it, as explained in the commentary.

Thanks again for your review,
Ohad.
