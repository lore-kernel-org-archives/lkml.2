Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2K2LrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:47:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2LrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:47:14 -0500
Date: Thu, 29 Nov 2012 12:47:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
 <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
 <50B73710.2040102@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <50B73710.2040102@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qZ4mnRsTuvtWQs1SPJB0+XJ5hH1lsXuan+5QgbarceW
 Z410xi/fJSkgMuxVW/6mz4Jj/5bZwvuGaJpm1fpUN6MDq8InaI
 p33bPl7B1ZO0hjK47S2+xd+Iy84iidnppXVz+drq4j25abeOA8
 UvY/0mTw8tHNf/vMSlDZ1mZ8aAnwBlgGtdi9uZBGNaW40TmlBG
 DXc75X8j9BQhX1r//3U+Usa7FiHw52FHiim6EpnjEhYrvUX1mK
 mroN+3y01oL+vF5Kmuwr0QVbjJkQpM464PgslsI3tKV3LZsXIF
 mMzSMvAqRzZZtRrIVYILu0wTisRdlM851m28teSu7hBzga5cj0
 mLUzjr39IWEl+IxeJcMSA3ckQBgyElJCf8lYcUG9iFQz+qFLBi
 nycRu+wg0LRgeSnF0rl4Y+6t3JSs36K9x0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergstr=C3=B6m wrote:
> On 28.11.2012 23:23, Thierry Reding wrote:
> > This could be problematic. Since drivers/video and drivers/gpu/drm are
> > separate trees, this would entail a continuous burden on keeping both
> > trees synchronized. While I realize that eventually it might be better
> > to put the host1x driver in a separate place to accomodate for its use
> > by other subsystems, I'm not sure moving it here right away is the best
> > approach.
>=20
> I understand your point, but I hope also that we'd end up with something
> that can be used as basis for the downstream kernel to migrate to
> upstream stack.
>=20
> The key point here is to make the API between nvhost and tegradrm as
> small and robust to changes as possible.

I agree. But I also fear that there will be changes eventually and
having both go in via different tree requires those trees to be merged
in a specific order to avoid breakage should the API change. This will
be particularly ugly in linux-next.

That's why I explicitly proposed to take this into drivers/gpu/drm/tegra
for the time being, until we can be reasonably sure that the API is
fixed. Then I'm fine with moving it wherever seems the best fit. Even
then there might be the occasional dependency, but they should get fewer
and fewer as the code matures.

> >> +struct nvhost_syncpt_ops {
> >> +     void (*reset)(struct nvhost_syncpt *, u32 id);
> >> +     void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
> >> +     void (*read_wait_base)(struct nvhost_syncpt *, u32 id);
> >> +     u32 (*update_min)(struct nvhost_syncpt *, u32 id);
> >> +     void (*cpu_incr)(struct nvhost_syncpt *, u32 id);
> >> +     void (*debug)(struct nvhost_syncpt *);
> >> +     const char * (*name)(struct nvhost_syncpt *, u32 id);
> >> +};
> >=20
> > Why are these even defined as ops structure? Tegra20 and Tegra30 seem to
> > be compatible when it comes to handling syncpoints. I thought they would
> > even be compatible in all other aspects as well, so why even have this?
>=20
> Tegra20 and Tegra30 are compatible, but future chips are not. I was
> hoping we would be ready in upstream kernel for future chips.

I think we should ignore that problem for now. Generally planning for
any possible combination of incompatibilities leads to overgeneralized
designs that require precisely these kinds of indirections.

Once some documentation for Tegra 40 materializes we can start thinking
about how to encapsulate the incompatible code.

> >> +#define syncpt_op()          (nvhost_get_chip_ops()->syncpt)
> >=20
> > You really shouldn't be doing this, but rather use explicit accesses for
> > these structures. If you're design doesn't scatter these definitions
> > across several files then it isn't difficult to obtain the correct
> > pointers and you don't need these "shortcuts".
>=20
> Do you mean that I would move the ops to be part of f.ex. nvhost_syncpt
> or nvhost_intr structs?

Not quite. What I'm saying is that unless there is a reason to
encapsulate the functions into an ops structure (for instance because of
incompatibilities across chip generations) they shouldn't be pointers in
a struct at all.

For that matter I don't think you need the nvhost_syncpt and nvhost_intr
structures either.

> >> +bool host1x_powered(struct platform_device *dev)
> >> +{
> > [...]
> >> +}
> >> +EXPORT_SYMBOL(host1x_powered);
> >> +
> >> +void host1x_busy(struct platform_device *dev)
> >> +{
> > [...]
> >> +}
> >> +EXPORT_SYMBOL(host1x_busy);
> >> +
> >> +void host1x_idle(struct platform_device *dev)
> >> +{
> > [...]
> >> +}
> >> +EXPORT_SYMBOL(host1x_idle);
> >=20
> > These look like a reimplementation of the runtime power-management
> > framework.
>=20
> Yes, we at some point tried to move to use runtime PM. The first attempt
> was thwarted by runtime PM and system suspend conflicting with each
> other. I believe this is pretty much fixed in later versions of kernel.
>=20
> Also, the problem was that runtime PM doesn't support multiple power
> states. In downstream kernel, we support clock gating and power gating.
> When we moved to runtime PM and implemented power gating on top of that,
> we ended up with more code than just using the current ACM code.
>=20
> I have a developer starting to look into how we could take runtime PM
> again into use with proper power gating support. It'll take a while to
> get that right. It might be best to rip the dynamic power management out
> from this patch set, and introduce it later when we have a proper
> runtime PM solution.

Okay, sounds like a plan. Even if it turns out that the current runtime
PM implementation doesn't provide every functionality that you need, we
should try to get these changes into the existing frameworks instead of
copying large chunks of code.

> >> +static void nvhost_free_resources(struct nvhost_master *host)
> >> +{
> >> +}
> >=20
> > This should be removed since it's empty.
>=20
> True. I wonder how that happened - there was content since recently, but
> I guess I deleted the code without noticing that the function needs to
> go, too.

I noticed that it was filled with content in one of the subsequent
patches. Depending on how this gets merged eventually you could postpone
adding the function until the later patch. But perhaps once the code has
been properly reviewed we can just squash the patches again. We'll see.

> > Also you should be using platform_get_irq() for interrupts. Furthermore
> > the host1x DT node (and the TRM) name the interrupts "syncpt" and
> > "general", so maybe those would be more useful variable names than
> > "intr0" and "intr1".
> >=20
> > But since you don't use them anyway they shouldn't be part of this
> > patch.
>=20
> True. I might also as well delete the general interrupt altogether, as
> we don't use it for any real purpose.

I think it might still be useful for diagnostics. It seems to be used
when writes time out. That could still be helpful information when
debugging problems.

> >> +     for (i =3D 0; i < pdata->num_clks; i++)
> >> +             clk_prepare_enable(pdata->clk[i]);
> >> +     nvhost_syncpt_reset(&host->syncpt);
> >> +     for (i =3D 0; i < pdata->num_clks; i++)
> >> +             clk_disable_unprepare(pdata->clk[i]);
> >=20
> > Stephen already hinted at this when discussing the AUXDATA. You should
> > explicitly request the clocks.
>=20
> I'm not too happy about that idea. The clock management code is generic
> for all modules, and that's why it's driven by a data structure. Now
> Stephen and you ask me to unroll the loops and make copies of the code
> to facilitate different modules and different SoCs.

Making this generic for all modules may not be what we want as it
doesn't allow devices to handle things themselves if necessary. Clock
management is just part of the boiler plate that every driver is
supposed to cope with. Also the number of clocks is usually not higher
than 2 or 3, so the pain is manageable. =3D)

Furthermore doing this in loops may not work for all modules. Some may
require additional delays between enabling the clocks, others may be
able to selectively disable one clock but not the other(s).

> >> +static inline void *nvhost_get_private_data(struct platform_device *_=
dev)
> >> +{
> >> +     struct nvhost_device_data *pdata =3D
> >> +             (struct nvhost_device_data *)platform_get_drvdata(_dev);
> >> +     WARN_ON(!pdata);
> >> +     return (pdata && pdata->private_data) ? pdata->private_data : NU=
LL;
> >> +}
> >> +
> >> +static inline void nvhost_set_private_data(struct platform_device *_d=
ev,
> >> +     void *priv_data)
> >> +{
> >> +     struct nvhost_device_data *pdata =3D
> >> +             (struct nvhost_device_data *)platform_get_drvdata(_dev);
> >> +     WARN_ON(!pdata);
> >> +     if (pdata)
> >> +             pdata->private_data =3D priv_data;
> >> +}
> >=20
> > You should need none of these. Instead put all the data you need into
> > you struct host1x and associate that with the platform device using
> > platform_set_drvdata().
>=20
> I need to actually find a way to do this for both host1x itself, and the
> 2D module. But as said, I'll try to remove the auxdata and come up with
> something better.

The existing host1x and DRM code could serve as an example since I
explicitly wrote them to behave properly.

> >> +static inline
> >> +struct nvhost_master *nvhost_get_host(struct platform_device *_dev)
> >> +{
> >> +     struct platform_device *pdev;
> >> +
> >> +     if (_dev->dev.parent) {
> >> +             pdev =3D to_platform_device(_dev->dev.parent);
> >> +             return nvhost_get_private_data(pdev);
> >> +     } else
> >> +             return nvhost_get_private_data(_dev);
> >> +}
> >> +
> >> +static inline
> >> +struct platform_device *nvhost_get_parent(struct platform_device *_de=
v)
> >> +{
> >> +     return _dev->dev.parent ? to_platform_device(_dev->dev.parent) :=
 NULL;
> >> +}
> >=20
> > These don't seem to be used.
>=20
> nvhost_get_host() is used in a subsequent patch, but getting parent
> doesn't seem to be.

Again, if you look at the existing tegra-drm code, the client modules
already use something a bit more explicit to obtain a reference to the
host1x:

	struct host1x *host1x =3D dev_get_drvdata(pdev->dev.parent);

The good thing about it is that it very clearly says where the host1x
pointer should be coming from. Explicitness is good.

> > Usually you don't keep separate variables for subregions. This can
> > equally well be done with just adding a corresponding offset.
>=20
> Hmm, ok, I could do that, but it just sounds logical to have only one
> piece of code that finds the sync reg base. I don't really understand
> why it needs to be duplicate for every access.

You wouldn't actually be duplicating it. Rather you'd just add another
offset. But I commented on this more explicitly in a reply to one of the
other patches.

> >> +static void host1x_syncpt_debug(struct nvhost_syncpt *sp)
> >> +{
> >> +     u32 i;
> >> +     for (i =3D 0; i < nvhost_syncpt_nb_pts(sp); i++) {
> >> +             u32 max =3D nvhost_syncpt_read_max(sp, i);
> >> +             u32 min =3D nvhost_syncpt_update_min(sp, i);
> >> +             if (!max && !min)
> >> +                     continue;
> >> +             dev_info(&syncpt_to_dev(sp)->dev->dev,
> >> +                     "id %d (%s) min %d max %d\n",
> >> +                     i, syncpt_op().name(sp, i),
> >> +                     min, max);
> >> +
> >> +     }
> >> +
> >> +     for (i =3D 0; i < nvhost_syncpt_nb_bases(sp); i++) {
> >> +             u32 base_val;
> >> +             host1x_syncpt_read_wait_base(sp, i);
> >> +             base_val =3D sp->base_val[i];
> >> +             if (base_val)
> >> +                     dev_info(&syncpt_to_dev(sp)->dev->dev,
> >> +                                     "waitbase id %d val %d\n",
> >> +                                     i, base_val);
> >> +
> >> +     }
> >> +}
> >=20
> > This should probably be integrated with debugfs.
>=20
> I could move this to debug.c, but it's debugging aid when a command
> stream is misbehaving and it spews this to UART when sync point wait is
> timing out. So not debugfs stuff.

Okay, in that case it should stay in. Perhaps convert dev_info() to
dev_dbg(). Perhaps wrapping it in some #ifdef CONFIG_TEGRA_HOST1X_DEBUG
guards would also be useful. Maybe not.

> >> diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_sync.h b/driv=
ers/video/tegra/host/host1x/hw_host1x01_sync.h
> >=20
> > Autogenerated files are generally not acceptable. And I already
> > mentioned before that you should be using #define instead of static
> > inline functions for register and bit definitions.
>=20
> What's the root cause for autogenerated files not being acceptable? I'm
> autogenerating them from definitions I get from hardware, which makes
> the results reliable.

The problem is not with autogenerated files in general. The means by
which they are generated are less important. However, autogenerated
files often contain a lot of unneeded definitions and contain things
such as "autogenerated - do not edit" lines.

So generally if you generate the content using some scripts to make sure
it corresponds to what engineering gave you, that's okay as long as you
make sure it has the correct form and doesn't contain any cruft.

> I like static inline because I get the benefit of compiler type
> checking, and gcov shows me which register definitions have been used in
> different tests.

Type checking shouldn't be necessary for simple defines. And I wasn't
aware that you could get the Linux kernel to write out data to be fed to
gcov.

> #defines are always messy and I pretty much hate them. But if the
> general request is to use #define's, even though I don't agree, I can
> accommodate. It's simple to write a sed script to do the conversion.

There are a lot of opportunities to abuse #defines but they are harmless
for register definitions. The Linux kernel is full of them and I haven't
yet seen any code that uses static inline functions for this purpose.

What you need to consider as well is that many people that work with the
Linux kernel expect code to be in a certain style. Register accesses of
the form

	writel(value, base + OFFSET);

are very common and expected to look a certain way, so if you write code
that doesn't comply with these guidelines you make it extra hard for
people to read the code. And that'll cost extra time, which people don't
usually have in excess.

> >> +/* Displays the current value of the sync point via sysfs */
> >> +static ssize_t syncpt_min_show(struct kobject *kobj,
> >> +             struct kobj_attribute *attr, char *buf)
> >> +{
> >> +     struct nvhost_syncpt_attr *syncpt_attr =3D
> >> +             container_of(attr, struct nvhost_syncpt_attr, attr);
> >> +
> >> +     return snprintf(buf, PAGE_SIZE, "%u",
> >> +                     nvhost_syncpt_read(&syncpt_attr->host->syncpt,
> >> +                             syncpt_attr->id));
> >> +}
> >> +
> >> +static ssize_t syncpt_max_show(struct kobject *kobj,
> >> +             struct kobj_attribute *attr, char *buf)
> >> +{
> >> +     struct nvhost_syncpt_attr *syncpt_attr =3D
> >> +             container_of(attr, struct nvhost_syncpt_attr, attr);
> >> +
> >> +     return snprintf(buf, PAGE_SIZE, "%u",
> >> +                     nvhost_syncpt_read_max(&syncpt_attr->host->syncp=
t,
> >> +                             syncpt_attr->id));
> >> +}
> >=20
> > This looks like it belongs in debugfs.
>=20
> This is actually the only interface to read the max value to user space,
> which can be useful for doing some comparisons that take wrapping into
> account. But we could just add IOCTLs and remove the sysfs entries.

Maybe you can explain the usefulness of this some more. Why would it be
easier to look at them in sysfs than in debugfs? You could be providing
a simple list of syncpoints along with min/max, name, requested status,
etc. in debugfs and it should be as easy to parse for both humans and
machines as sysfs. I don't think IOCTLs would be any gain as they tend
to have higher ABI stability requirements than debugfs (which doesn't
have very strong requirements) or sysfs (which is often considered as a
public ABI as well and therefore needs to be stable).

> >> diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
> > [...]
> >> +struct host1x_device_info {
> >> +     int             nb_channels;    /* host1x: num channels supporte=
d */
> >> +     int             nb_pts;         /* host1x: num syncpoints suppor=
ted */
> >> +     int             nb_bases;       /* host1x: num syncpoints suppor=
ted */
> >> +     u32             client_managed; /* host1x: client managed syncpt=
s */
> >> +     int             nb_mlocks;      /* host1x: number of mlocks */
> >> +     const char      **syncpt_names; /* names of sync points */
> >> +};
> >> +
> >> +struct nvhost_device_data {
> >> +     int             version;        /* ip version number of device */
> >> +     int             id;             /* Separates clients of same hw =
*/
> >> +     int             index;          /* Hardware channel number */
> >> +     void __iomem    *aperture;      /* Iomem mapped to kernel */
> >> +
> >> +     u32             syncpts;        /* Bitfield of sync points used =
*/
> >> +     u32             modulemutexes;  /* Bit field of module mutexes */
> >> +
> >> +     u32             class;          /* Device class */
> >> +     bool            serialize;      /* Serialize submits in the chan=
nel */
> >> +
> >> +     int             powergate_ids[NVHOST_MODULE_MAX_POWERGATE_IDS];
> >> +     bool            can_powergate;  /* True if module can be power g=
ated */
> >> +     int             clockgate_delay;/* Delay before clock gated */
> >> +     int             powergate_delay;/* Delay before power gated */
> >> +     struct nvhost_clock clocks[NVHOST_MODULE_MAX_CLOCKS];/* Clock na=
mes */
> >> +
> >> +     struct delayed_work powerstate_down;/* Power state management */
> >> +     int             num_clks;       /* Number of clocks opened for d=
ev */
> >> +     struct clk      *clk[NVHOST_MODULE_MAX_CLOCKS];
> >> +     struct mutex    lock;           /* Power management lock */
> >> +     int             powerstate;     /* Current power state */
> >> +     int             refcount;       /* Number of tasks active */
> >> +     wait_queue_head_t idle_wq;      /* Work queue for idle */
> >> +
> >> +     struct nvhost_channel *channel; /* Channel assigned for the modu=
le */
> >> +     struct kobject *power_kobj;     /* kobj to hold power sysfs entr=
ies */
> >> +     struct nvhost_device_power_attr *power_attrib;  /* sysfs attribu=
tes */
> >> +     struct dentry *debugfs;         /* debugfs directory */
> >> +
> >> +     void *private_data;             /* private platform data */
> >> +     struct platform_device *pdev;   /* owner platform_device */
> >> +
> >> +     /* Finalize power on. Can be used for context restore. */
> >> +     void (*finalize_poweron)(struct platform_device *dev);
> >> +
> >> +     /* Device is busy. */
> >> +     void (*busy)(struct platform_device *);
> >> +
> >> +     /* Device is idle. */
> >> +     void (*idle)(struct platform_device *);
> >> +
> >> +     /* Device is going to be suspended */
> >> +     void (*suspend_ndev)(struct platform_device *);
> >> +
> >> +     /* Device is initialized */
> >> +     void (*init)(struct platform_device *dev);
> >> +
> >> +     /* Device is de-initialized. */
> >> +     void (*deinit)(struct platform_device *dev);
> >> +
> >> +     /* Preparing for power off. Used for context save. */
> >> +     int (*prepare_poweroff)(struct platform_device *dev);
> >> +
> >> +     /* Clock gating callbacks */
> >> +     int (*prepare_clockoff)(struct platform_device *dev);
> >> +     void (*finalize_clockon)(struct platform_device *dev);
> >> +};
> >=20
> > A lot of this can be removed if you use existing infrastructure and
> > simplify the design a bit. Most of it can probably move into the main
> > struct host1x to avoid needless indirections that make the code hard to
> > follow and maintain.
>=20
> Actually, this struct is generic for host1x and host1x clients, so they
> cannot be moved to host1x. I do also realize that I'm not using them in
> the patch sets I sent for 2D.

I've said this before, and I think that this tries to be overly generic.
Display controllers for instance work quite well without an attached
nvhost_channel.

Thierry

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQt0s4AAoJEN0jrNd/PrOhrUQP/22vmbnU23tFhqzICRCPeY/I
DU8SYcwSn3XGUhtSmKauV8IvB+vutvnZUJFXCrxaWB5cRni1kydSsy0gyeaWZbwW
1ktzKtZluqLJ58HUJhDvQA4LWDfqB+JT9BeJT10gDZ4V68bCSli7ebjAhhCGaqt/
3f72AgJxBDu62I9wUmzJR4gllnHIlcrN6mmvckgqb9DVTktzUlPmOS7WMe896Lgz
t6XWMY74tybvUUm/ikpcUFJZhi2RwWzYfIDDyK+7pQNIn5I1frtVvJaj4E85xnut
qQTeQcK5gLGt9TIsV/Rd8AnHovRNDYD6eJTlwO0Ogc4AYdkiyNzjHpti9Ndp/g6B
I2kbHKigYLah0lcCT8gM3Io6WNszEG6RiYspGy2dn8uwJxXaeVW5NvgvtYiyib4y
polbYOrFFL31nA4Te+/lSp5Fj0338C91wgv0i/WEYJeWO5KogsIpUCWugIV+zJd/
1L5qfIId/rOfGsBPZFHo7iOykykmgQU6uLoxTApUMCPjPBvo32B+tJru07ZCQItg
DjfHu2wH7vKDcNO9E+4cHfHnCmcx3reA5ABzHAZ3FXW6MsW+Ho6pkpVCZ/9LFjVs
jufew6700gDg48myTw9pj6xhSmCjnQngcqJcim4BzanWHhVyZHf+i0k/3eeB1SjO
lrqrky8kkUyrinAv1MNu
=p0ip
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
