Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2K2KRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:17:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4982 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2K2KRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:17:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 29 Nov 2012 02:17:13 -0800
Message-ID: <50B73710.2040102@nvidia.com>
Date: Thu, 29 Nov 2012 12:21:04 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 23:23, Thierry Reding wrote:
> This could be problematic. Since drivers/video and drivers/gpu/drm are
> separate trees, this would entail a continuous burden on keeping both
> trees synchronized. While I realize that eventually it might be better
> to put the host1x driver in a separate place to accomodate for its use
> by other subsystems, I'm not sure moving it here right away is the best
> approach.

I understand your point, but I hope also that we'd end up with something
that can be used as basis for the downstream kernel to migrate to
upstream stack.

The key point here is to make the API between nvhost and tegradrm as
small and robust to changes as possible.

> I'm not sure drivers/video is the best location either. Perhaps
> drivers/bus would be better? Or maybe we need a new subdirectory for
> this kind of device.

This is a question I don't have an answer to. I'm perfectly ok moving it
wherever the public opinion leads it to.

> I think the general nowadays is to no longer use filenames in comments.

Ok, I hadn't noticed that. I'll remove them. It's redundant information
anyway.

>> +struct nvhost_chip_support *nvhost_chip_ops;
>> +
>> +struct nvhost_chip_support *nvhost_get_chip_ops(void)
>> +{
>> +     return nvhost_chip_ops;
>> +}
> 
> This seems like it should be more tightly coupled to the host1x device.
> And it shouldn't be a global variable.

Yeah, I will figure out a better way to handle the chip ops. I'm not too
happy with it. Give me a bit of time to come up with a good solution.

>> +struct output;
> 
> What's this? It doesn't seem to be used anywhere.

It's just a mistake. The struct is used in debug code, but not referred
to in this file so the forward declaration is not needed.

>> +struct nvhost_master;
> 
> Why do you suffix this with _master? The whole point of host1x is to be
> the "master" so you can just as well call it nvhost, right? Ideally
> you'd call it host1x, but I'm repeating myself. =)

Yes, the name is just a historic relict and I'm blind to them as I've
been staring at the code for so long. I think "host1x" would be a good
name for the struct.

>> +struct nvhost_syncpt_ops {
>> +     void (*reset)(struct nvhost_syncpt *, u32 id);
>> +     void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
>> +     void (*read_wait_base)(struct nvhost_syncpt *, u32 id);
>> +     u32 (*update_min)(struct nvhost_syncpt *, u32 id);
>> +     void (*cpu_incr)(struct nvhost_syncpt *, u32 id);
>> +     void (*debug)(struct nvhost_syncpt *);
>> +     const char * (*name)(struct nvhost_syncpt *, u32 id);
>> +};
> 
> Why are these even defined as ops structure? Tegra20 and Tegra30 seem to
> be compatible when it comes to handling syncpoints. I thought they would
> even be compatible in all other aspects as well, so why even have this?

Tegra20 and Tegra30 are compatible, but future chips are not. I was
hoping we would be ready in upstream kernel for future chips.

>> +#define syncpt_op()          (nvhost_get_chip_ops()->syncpt)
> 
> You really shouldn't be doing this, but rather use explicit accesses for
> these structures. If you're design doesn't scatter these definitions
> across several files then it isn't difficult to obtain the correct
> pointers and you don't need these "shortcuts".

Do you mean that I would move the ops to be part of f.ex. nvhost_syncpt
or nvhost_intr structs?

> This API looks odd. Should syncpoints not be considered as regular
> resources, much like interrupts? In that case it would be easier to
> abstract them away behind an opaque type. It looks like you already use
> the struct nvhost_syncpt to refer to the set of syncpoints associated
> with a host1x device.
> 
> How about you use nvhost/host1x_syncpt to refer to individual syncpoints
> instead. You could export an array of those from your host1x device and
> implement a basic resource allocation mechanism on top, similar to how
> other resources are handled in the kernel.
> 
> So a host1x client device could call host1x_request_syncpt() to allocate
> a syncpoint from it's host1x parent dynamically along with passing a
> name and a syncpoint handler to it.

That might work. I'll think about that - thanks.

>> +bool host1x_powered(struct platform_device *dev)
>> +{
> [...]
>> +}
>> +EXPORT_SYMBOL(host1x_powered);
>> +
>> +void host1x_busy(struct platform_device *dev)
>> +{
> [...]
>> +}
>> +EXPORT_SYMBOL(host1x_busy);
>> +
>> +void host1x_idle(struct platform_device *dev)
>> +{
> [...]
>> +}
>> +EXPORT_SYMBOL(host1x_idle);
> 
> These look like a reimplementation of the runtime power-management
> framework.

Yes, we at some point tried to move to use runtime PM. The first attempt
was thwarted by runtime PM and system suspend conflicting with each
other. I believe this is pretty much fixed in later versions of kernel.

Also, the problem was that runtime PM doesn't support multiple power
states. In downstream kernel, we support clock gating and power gating.
When we moved to runtime PM and implemented power gating on top of that,
we ended up with more code than just using the current ACM code.

I have a developer starting to look into how we could take runtime PM
again into use with proper power gating support. It'll take a while to
get that right. It might be best to rip the dynamic power management out
from this patch set, and introduce it later when we have a proper
runtime PM solution.

I'll skip the other comments about ACM because of this.

>> diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/tegra/host/host1x/host1x.c
> [...]
>> +struct nvhost_master *nvhost;
> Bad habbit. I know that this is a popular shortcut. However this also
> leads to very bad designs because you're allowed to reuse this pointer
> from wherever you like.
> 
> When I wrote the tegra-drm code I explicitly made sure to not use any
> such global variable. In the end it forces you to clean up the driver
> design.
> 
> As a bonus you automatically get support for any number of host1x
> devices on the same SoC. Now you will probably tell me that this is
> never going to happen. People also used to think that a computers would
> never use more than a single CPU...

I think this might get cleaned up at the same time with cleaning up the
auxdata/chip_ops design. We used to have this struct set as driver
private data, but as we started using that for another purpose, we moved
this variable out.

>> +
>> +static void nvhost_free_resources(struct nvhost_master *host)
>> +{
>> +}
> 
> This should be removed since it's empty.

True. I wonder how that happened - there was content since recently, but
I guess I deleted the code without noticing that the function needs to
go, too.

>> +     regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
>> +     intr0 = platform_get_resource(dev, IORESOURCE_IRQ, 0);
>> +     intr1 = platform_get_resource(dev, IORESOURCE_IRQ, 1);
>> +
>> +     if (!regs || !intr0 || !intr1) {
> 
> I prefer to have these checked for explicitly, one by one for
> readability and potentially more useful diagnostics.

Can do.

> Also you should be using platform_get_irq() for interrupts. Furthermore
> the host1x DT node (and the TRM) name the interrupts "syncpt" and
> "general", so maybe those would be more useful variable names than
> "intr0" and "intr1".
> 
> But since you don't use them anyway they shouldn't be part of this
> patch.

True. I might also as well delete the general interrupt altogether, as
we don't use it for any real purpose.

>> +     /* Copy host1x parameters. The private_data gets replaced
>> +      * by nvhost_master later */
> 
> Multiline comments should be in this format:
> 
>         /*
>          * foo
>          */

Ok.

>> +     host->aperture = devm_request_and_ioremap(&dev->dev, regs);
>> +     if (!host->aperture) {
> 
> aperture is confusing as it is typically used for GTT-type memory
> regions, so it may be mistaken for the GART found on Tegra 2. Why not
> call it "regs" instead?

Can do.

> 
>> +             dev_err(&dev->dev, "failed to remap host registers\n");
> 
> This is unnecessary. devm_request_and_ioremap() already prints an error
> message on failure.

I'll remove that, thanks.

> 
>> +     for (i = 0; i < pdata->num_clks; i++)
>> +             clk_prepare_enable(pdata->clk[i]);
>> +     nvhost_syncpt_reset(&host->syncpt);
>> +     for (i = 0; i < pdata->num_clks; i++)
>> +             clk_disable_unprepare(pdata->clk[i]);
> 
> Stephen already hinted at this when discussing the AUXDATA. You should
> explicitly request the clocks.

I'm not too happy about that idea. The clock management code is generic
for all modules, and that's why it's driven by a data structure. Now
Stephen and you ask me to unroll the loops and make copies of the code
to facilitate different modules and different SoCs.

>> +static int __exit nvhost_remove(struct platform_device *dev)
> 
> This should really be __devexit to allow the driver to be built as a
> module. However, __dev* are deprecated and in the process of being
> removed so you can just drop __exit as well.
>> +static struct of_device_id host1x_match[] __devinitdata = {
>
> __devinitdata can be dropped.
>> +     { .compatible = "nvidia,tegra20-host1x", },
>> +     { .compatible = "nvidia,tegra30-host1x", },
>> +     { },
>> +};
>> +
>> +static struct platform_driver platform_driver = {
>> +     .probe = nvhost_probe,
>> +     .remove = __exit_p(nvhost_remove),
>
> __exit_p also.

Ok.

>> +             .of_match_table = of_match_ptr(host1x_match),
> 
> No need for of_match_ptr().

Will remove.

>> +module_init(nvhost_mod_init);
>> +module_exit(nvhost_mod_exit);
> 
> Use module_platform_driver().

Ok.

> 
>> diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/tegra/host/host1x/host1x.h
> [...]
>> +#define TRACE_MAX_LENGTH     128U
>> +#define IFACE_NAME           "nvhost"
> 
> None of these seem to be used.

Will remove.

>> +static inline void *nvhost_get_private_data(struct platform_device *_dev)
>> +{
>> +     struct nvhost_device_data *pdata =
>> +             (struct nvhost_device_data *)platform_get_drvdata(_dev);
>> +     WARN_ON(!pdata);
>> +     return (pdata && pdata->private_data) ? pdata->private_data : NULL;
>> +}
>> +
>> +static inline void nvhost_set_private_data(struct platform_device *_dev,
>> +     void *priv_data)
>> +{
>> +     struct nvhost_device_data *pdata =
>> +             (struct nvhost_device_data *)platform_get_drvdata(_dev);
>> +     WARN_ON(!pdata);
>> +     if (pdata)
>> +             pdata->private_data = priv_data;
>> +}
> 
> You should need none of these. Instead put all the data you need into
> you struct host1x and associate that with the platform device using
> platform_set_drvdata().

I need to actually find a way to do this for both host1x itself, and the
2D module. But as said, I'll try to remove the auxdata and come up with
something better.

>> +static inline
>> +struct nvhost_master *nvhost_get_host(struct platform_device *_dev)
>> +{
>> +     struct platform_device *pdev;
>> +
>> +     if (_dev->dev.parent) {
>> +             pdev = to_platform_device(_dev->dev.parent);
>> +             return nvhost_get_private_data(pdev);
>> +     } else
>> +             return nvhost_get_private_data(_dev);
>> +}
>> +
>> +static inline
>> +struct platform_device *nvhost_get_parent(struct platform_device *_dev)
>> +{
>> +     return _dev->dev.parent ? to_platform_device(_dev->dev.parent) : NULL;
>> +}
> 
> These don't seem to be used.

nvhost_get_host() is used in a subsequent patch, but getting parent
doesn't seem to be.

> Usually you don't keep separate variables for subregions. This can
> equally well be done with just adding a corresponding offset.

Hmm, ok, I could do that, but it just sounds logical to have only one
piece of code that finds the sync reg base. I don't really understand
why it needs to be duplicate for every access.

>> +static void host1x_syncpt_debug(struct nvhost_syncpt *sp)
>> +{
>> +     u32 i;
>> +     for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++) {
>> +             u32 max = nvhost_syncpt_read_max(sp, i);
>> +             u32 min = nvhost_syncpt_update_min(sp, i);
>> +             if (!max && !min)
>> +                     continue;
>> +             dev_info(&syncpt_to_dev(sp)->dev->dev,
>> +                     "id %d (%s) min %d max %d\n",
>> +                     i, syncpt_op().name(sp, i),
>> +                     min, max);
>> +
>> +     }
>> +
>> +     for (i = 0; i < nvhost_syncpt_nb_bases(sp); i++) {
>> +             u32 base_val;
>> +             host1x_syncpt_read_wait_base(sp, i);
>> +             base_val = sp->base_val[i];
>> +             if (base_val)
>> +                     dev_info(&syncpt_to_dev(sp)->dev->dev,
>> +                                     "waitbase id %d val %d\n",
>> +                                     i, base_val);
>> +
>> +     }
>> +}
> 
> This should probably be integrated with debugfs.

I could move this to debug.c, but it's debugging aid when a command
stream is misbehaving and it spews this to UART when sync point wait is
timing out. So not debugfs stuff.

>> diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_sync.h b/drivers/video/tegra/host/host1x/hw_host1x01_sync.h
> 
> Autogenerated files are generally not acceptable. And I already
> mentioned before that you should be using #define instead of static
> inline functions for register and bit definitions.

What's the root cause for autogenerated files not being acceptable? I'm
autogenerating them from definitions I get from hardware, which makes
the results reliable.

I like static inline because I get the benefit of compiler type
checking, and gcov shows me which register definitions have been used in
different tests.

#defines are always messy and I pretty much hate them. But if the
general request is to use #define's, even though I don't agree, I can
accommodate. It's simple to write a sed script to do the conversion.

> This is a very funky way of creating sysfs attributes. What you probably
> want here are device attributes. See Documentation/filesystems/sysfs.txt
> and include/linux/sysfs.h.

Thanks for the pointers, looks like device attributes could be used.

>> +bool nvhost_syncpt_is_expired(
>> +     struct nvhost_syncpt *sp,
>> +     u32 id,
>> +     u32 thresh)
>> +{
>> +     u32 current_val;
>> +     u32 future_val;
>> +     smp_rmb();
> 
> What do you need a read memory barrier for?

I'll test without that. I can't see any valid reason, and I have a
couple of other similar problems.

>> +/* Displays the current value of the sync point via sysfs */
>> +static ssize_t syncpt_min_show(struct kobject *kobj,
>> +             struct kobj_attribute *attr, char *buf)
>> +{
>> +     struct nvhost_syncpt_attr *syncpt_attr =
>> +             container_of(attr, struct nvhost_syncpt_attr, attr);
>> +
>> +     return snprintf(buf, PAGE_SIZE, "%u",
>> +                     nvhost_syncpt_read(&syncpt_attr->host->syncpt,
>> +                             syncpt_attr->id));
>> +}
>> +
>> +static ssize_t syncpt_max_show(struct kobject *kobj,
>> +             struct kobj_attribute *attr, char *buf)
>> +{
>> +     struct nvhost_syncpt_attr *syncpt_attr =
>> +             container_of(attr, struct nvhost_syncpt_attr, attr);
>> +
>> +     return snprintf(buf, PAGE_SIZE, "%u",
>> +                     nvhost_syncpt_read_max(&syncpt_attr->host->syncpt,
>> +                             syncpt_attr->id));
>> +}
> 
> This looks like it belongs in debugfs.

This is actually the only interface to read the max value to user space,
which can be useful for doing some comparisons that take wrapping into
account. But we could just add IOCTLs and remove the sysfs entries.

>> diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
> [...]
>> +struct host1x_device_info {
>> +     int             nb_channels;    /* host1x: num channels supported */
>> +     int             nb_pts;         /* host1x: num syncpoints supported */
>> +     int             nb_bases;       /* host1x: num syncpoints supported */
>> +     u32             client_managed; /* host1x: client managed syncpts */
>> +     int             nb_mlocks;      /* host1x: number of mlocks */
>> +     const char      **syncpt_names; /* names of sync points */
>> +};
>> +
>> +struct nvhost_device_data {
>> +     int             version;        /* ip version number of device */
>> +     int             id;             /* Separates clients of same hw */
>> +     int             index;          /* Hardware channel number */
>> +     void __iomem    *aperture;      /* Iomem mapped to kernel */
>> +
>> +     u32             syncpts;        /* Bitfield of sync points used */
>> +     u32             modulemutexes;  /* Bit field of module mutexes */
>> +
>> +     u32             class;          /* Device class */
>> +     bool            serialize;      /* Serialize submits in the channel */
>> +
>> +     int             powergate_ids[NVHOST_MODULE_MAX_POWERGATE_IDS];
>> +     bool            can_powergate;  /* True if module can be power gated */
>> +     int             clockgate_delay;/* Delay before clock gated */
>> +     int             powergate_delay;/* Delay before power gated */
>> +     struct nvhost_clock clocks[NVHOST_MODULE_MAX_CLOCKS];/* Clock names */
>> +
>> +     struct delayed_work powerstate_down;/* Power state management */
>> +     int             num_clks;       /* Number of clocks opened for dev */
>> +     struct clk      *clk[NVHOST_MODULE_MAX_CLOCKS];
>> +     struct mutex    lock;           /* Power management lock */
>> +     int             powerstate;     /* Current power state */
>> +     int             refcount;       /* Number of tasks active */
>> +     wait_queue_head_t idle_wq;      /* Work queue for idle */
>> +
>> +     struct nvhost_channel *channel; /* Channel assigned for the module */
>> +     struct kobject *power_kobj;     /* kobj to hold power sysfs entries */
>> +     struct nvhost_device_power_attr *power_attrib;  /* sysfs attributes */
>> +     struct dentry *debugfs;         /* debugfs directory */
>> +
>> +     void *private_data;             /* private platform data */
>> +     struct platform_device *pdev;   /* owner platform_device */
>> +
>> +     /* Finalize power on. Can be used for context restore. */
>> +     void (*finalize_poweron)(struct platform_device *dev);
>> +
>> +     /* Device is busy. */
>> +     void (*busy)(struct platform_device *);
>> +
>> +     /* Device is idle. */
>> +     void (*idle)(struct platform_device *);
>> +
>> +     /* Device is going to be suspended */
>> +     void (*suspend_ndev)(struct platform_device *);
>> +
>> +     /* Device is initialized */
>> +     void (*init)(struct platform_device *dev);
>> +
>> +     /* Device is de-initialized. */
>> +     void (*deinit)(struct platform_device *dev);
>> +
>> +     /* Preparing for power off. Used for context save. */
>> +     int (*prepare_poweroff)(struct platform_device *dev);
>> +
>> +     /* Clock gating callbacks */
>> +     int (*prepare_clockoff)(struct platform_device *dev);
>> +     void (*finalize_clockon)(struct platform_device *dev);
>> +};
> 
> A lot of this can be removed if you use existing infrastructure and
> simplify the design a bit. Most of it can probably move into the main
> struct host1x to avoid needless indirections that make the code hard to
> follow and maintain.

Actually, this struct is generic for host1x and host1x clients, so they
cannot be moved to host1x. I do also realize that I'm not using them in
the patch sets I sent for 2D.

Terje
