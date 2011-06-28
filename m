Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1F1VmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:42:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54422 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1F1Vl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:41:57 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.136.221]
In-Reply-To: <20110627204958.GB20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-2-git-send-email-ohad@wizery.com> <20110627204958.GB20865@ponder.secretlab.ca>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 00:41:35 +0300
Message-ID: <BANLkTi=ruzQsiYGnug1fVV13tPPYcfBNVg@mail.gmail.com>
Subject: Re: [RFC 1/8] drivers: add generic remoteproc framework
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Thanks a lot for the exhaustive review and comments !

On Mon, Jun 27, 2011 at 11:49 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
>> +     my_rproc = rproc_get("ipu");
>
> I tend to be suspicious of apis whose primary interface is by-name
> lookup.  It works fine when the system is small, but it can get
> unwieldy when the client driver doesn't have a direct relation to the
> setup code that chooses the name.  At some point I suspect that there
> will need to be different lookup mechanism, such as which AMP
> processor is currently available (if there are multiple of the same
> type).

Yeah, this might be too limiting on some systems. I gave this a little
thought, but decided to wait until those systems show up first, so I
we can better understand them/their requirements/use-cases. For now,
I've just followed this simple name-based API model (which still seem
a bit popular in several SoC drivers I've looked at, probably due to
the general simplicity of it and its use cases).

> It also leaves no option for drivers to obtain a reference to the
> rproc instance, and bring it up/down as needed (without the name
> lookup every time).
..
> That said, it looks like only the rproc_get() api is using by-name
> lookup, and everything else is via the structure.  Can (should) the
> by-name lookup part be factored out into a rproc_get_by_name()
> accessor?

I think you are looking for a different set of API here, probably
something that is better implemented using runtime PM.

When a driver calls rproc_get(), not only does it power on the remote
processor, but it also makes sure the underlying implementation cannot
go away (i.e. platform-specific remoteproc module cannot be removed,
and the rproc cannot be unregistered).

After it calls rproc_put(), it cannot rely anymore on the remote
processor to stick around (the rproc can be unregistered at this
point), so the next time it needs it, it must go through the full
get-by-name (or any other get API we will come up with eventually)
getter API.

If drivers need to hold onto the rproc instance, but still explicitly
allow it to power off at times, they should probably call something
like pm_runtime_put(rproc->dev).
(remoteproc runtime PM support is not implemented yet, but is
definitely planned, so we can suspend remote processors on
inactivity).

> Since rproc_register is allocating a struct rproc instance that
> represent the device, shouldn't the pointer to that device be returned
> to the caller?

Yes, it definitely should. We will have the underlying implementation
remember it, and then pass it to rproc_unregister when needed.

>> +  int rproc_unregister(const char *name);
>
> I definitely would not do this by name.  I think it is better to pass
> the actual instance pointer to rproc_unregister.

Much better, yeah.

> Naive question: Why is bootaddr an argument?  Wouldn't rproc drivers
> keep track of the boot address in their driver private data?

Mark already got that one, but basically the boot address comes from
the firmware image: we need to let the implementation know the
physical address where the text section is mapped. This is ignored on
implementations where that address is fixed (e.g. OMAP's M3).

> Other have commented on the image format, so I'll skip this bit other
> than saying that I agree it would be great to have a common format.

We are evaluating now moving to ELF; let's see how it goes. Using a
standard format is an advantage (as long as it's not overly
complicated), but I wonder if achieving a common format is really
feasible and whether eventually different platforms will need
different binary formats anyway, and we'll have to abstract this out
of remoteproc (guess that as usual, we just need to start off with
something, and then evolve as requirements show up).

>> +Most likely this kind of static allocations of hardware resources for
>> +remote processors can also use DT, so it's interesting to see how
>> +this all work out when DT materializes.
>
> I imagine that it will be quite straight forward.  There will probably
> be a node in the tree to represent each slave AMP processor, and other
> devices attached to it could be represented using 'phandle' links
> between the nodes.  Any configuration of the AMP process can be
> handled with arbitrary device-specific properties in the AMP
> processor's node.

That sounds good. The dilemma is bigger, though.

The kind of stuff we need to synchronize about are not really
describing the hardware; it's more a runtime policy/configuration than
a hardware description.

As Brian mentioned in the other thread:

> The resource information is a description of
> what resources the firmware requires to work properly (it needs
> certain amounts of working memory, timers, peripheral interfaces like
> i2c to control camera hw, etc), which will be specific to a given
> firmware build.

Some of those resources will be allocated dynamically using an rpmsg
driver (developed by Fernando Guzman Lugo), but some must be supplied
before booting the firmware (memory ?). We're also using the existing
resource table today to announce the boot address and the trace buffer
address.

So the question is whether/if DT can help here.

On one hand, we're not describing the hardware here. it's pure
configuration, but that seem fine, as DT seem to be taking runtime
configuration, too (e.g. bootargs, initrd addresses, etc..). Moreover,
some of those remoteproc configurations should handed early to the
host, too (e.g. we might need to reserve specific physical memory that
must be used by the remote processor, and this can't wait until the
firmware is loaded).

OTOH, as Brian mentioned, it does make sense to couple those
configurations with the specific firmware image, so risk of breaking
stuff when the firmware is changed is minimized. Maybe we can have a
secondary .dts file as part of the firmware sources, and have it
included in the primary .dts (and let the remoteproc access that
respective secondary .dtb) ?

These are just raw ideas - I never tried working with DT yet myself.

>> +source "drivers/remoteproc/Kconfig"
>> +
>
> Hmmm, I wonder if the end of the drivers list is the best place for
> this.  The drivers menu in kconfig is getting quite unwieldy.

We can arbitrarily choose a better location in that file but I'm not
sure I can objectively justify it :)

(alternatively, we can source that Kconfig from the relevant
platform's Kconfig, like virtio does).

>> +     /*
>> +      * find the end of trace buffer (does not account for wrapping).
>> +      * desirable improvement: use a ring buffer instead.
>> +      */
>> +     for (i = 0; i < size && buf[i]; i++);
>
> Hmmm, I wonder if this could make use of the ftrace ring buffer.

I thought about it, but I'm not sure we want to.

To do that, we'd need the remote processor to send us a message (via
rpmsg probably...) for every trace log we want to write into that ring
buffer. That would mean significant overhead for every remote trace
message, but would also mean you can't debug low level issues with
rpmsg, because you need it to deliver the debug messages themselves.

Instead, we just use a 'dumb' non-cacheable memory region into which
the remote processor unilaterally writes its trace messages. If/when
we're interested in the last remote log messages, we just read that
shared buffer (e.g. cat /debug/remoteproc/omap-rproc.1/trace0).

This means zero overhead on the host, and the ability to debug very
low level remote issues: all you need is a shared memory buffer and
remote traces work.

Currently this shared buffer is really dumb: we just dump its entire
content when asked. One nice improvement we can do is handling the
inevitable wrapping, by maintaining a shared "head" offset into the
buffer.

>> +     switch (state) {
..
>> +     }
>
> Me thinks this is asking for a lookup table.

sounds good.

>> +static ssize_t rproc_state_read(struct file *filp, char __user *userbuf,
>> +                                             size_t count, loff_t *ppos)
>> +{
>> +     struct rproc *rproc = filp->private_data;
>> +     int state = rproc->state;
>> +     char buf[100];
>
> 100 bytes?  I count at most ~30.

30 it is.

>> +#define DEBUGFS_ADD(name)                                            \
>> +     debugfs_create_file(#name, 0400, rproc->dbg_dir,                \
>> +                     rproc, &name## _rproc_ops)
>
> You might want to split the debug stuff off into a separate patch,
> just to keep the review load down.  (up to you though).

Sure. I thought maybe to even split it to a separate file as well.

>> +     spin_unlock(&rprocs_lock);
>
> Unless you're going to be looking up the device at irq time, a mutex
> is probably a better choice here.

mutex it is.

We can also completely remove the lock and just use RCU, as the list
is rarely changed. Since it's so short today, and rarely accessed at
all (even read access is pretty rare), it probably won't matter too
much.

>> +     dev_info(dev, "remote processor %s is now up\n", rproc->name);
>
> How often are remote processors likely to be brought up/down?

Very rarely. Today we bring it up on boot, and keep it loaded (it will
then be suspended on inactivity and won't consume power when we don't
need it to do anything).

> However, it may be non-zero here, but drop to zero by the time you
> take the lock.  Best be safe and put it inside the mutex.  Having it
> under the mutex shouldn't be a performance hit since only buggy code
> will get this test wrong.  In fact, it is probably appropriate to
> WARN_ON() on the !rproc->count condition.

good points, thanks.

> Actually, using a hand coded reference count like this shouldn't be
> done.

yeah, i planned to switch to an atomic variable here.

> Looking at the code, I
> suspect you'll want separate reference counting for object references
> and power up/down count so that clients can control power to a device
> without giving up the pointer to the rproc instance.

Eventually the plan is to use runtime PM for the second refcount, so
we get all this plumbing for free.

>> +             /* iounmap normal memory, so make sparse happy */
>> +             iounmap((__force void __iomem *) rproc->trace_buf1);
>
> Icky casting!  That suggests that how the trace buffer pointer is
> managed needs work.

The plan is to replace those ioremaps with dma coherent memory, and
then we don't need no casting. We just need the generic dma API (which
is in the works) to handle omap's iommu transparently (in the works
too), and then tell the remoteproc where to write logs to. It might
take some time, but it sounds very clean.

>> +#define RPROC_MAX_NAME       100
>
> I wouldn't even bother with this.  The only place it is used is in one
> of the debugfs files, and you can protect against too large a static
> buffer by using %100s (or whatever) in the snprintf().

cool, thanks!

Again, many thanks for the review,
Ohad.
