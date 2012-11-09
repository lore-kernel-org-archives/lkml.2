Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2KIQAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:00:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2KIQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:00:07 -0500
Date: Fri, 9 Nov 2012 17:00:02 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Clark <robdclark@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] drm: Add NVIDIA Tegra20 support
Message-ID: <20121109160002.GA6474@avionic-0098.mockup.avionic-design.de>
References: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
 <1352469579-3337-2-git-send-email-thierry.reding@avionic-design.de>
 <CAF6AEGs4bk3umkbQmJmB+Gf4UctKWa2Rj9GEi=DZSqU8MUd+9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <CAF6AEGs4bk3umkbQmJmB+Gf4UctKWa2Rj9GEi=DZSqU8MUd+9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TyEwqUR3jfhgDu3Tb+Fz6WAOoux1m+LRL1PtKyEHOfr
 3o2Z6FF44rGkSG19fwXfhO+SImBsM8ECrdnJ6q4WOcaqpcUzpP
 QckEieWSyzsw/w9WGSnpbdjglR3Y4SiDqAWVcdrpppAcvGlXJA
 6Wbu83LPyMwzXqWlnxOaCCc4qzu4JE7MTfgkp+oht6WSp71cKe
 tCpjDFiL9Cd9FyUd2YUWESQwHxihgKUEfYQTpkMYvu96ZXwvPi
 ZBVUN+BRtX47a4fFO83VOE/aJQK08W4cFVAKjACxSoMiYWbFFY
 VgGNhC63OMMgsxGa5qi4hcFa8OFPVOp3xICfIij9Z5Tn0aWbFO
 nM1YdK1FWYYVVDhjPlRy4TxloeoaoY97gWbfBuU65+1Hcvqw8e
 1jj+7mB34GCMA2IKhl+flXY+0ib4MUMUHs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 09:18:58AM -0600, Rob Clark wrote:
> On Fri, Nov 9, 2012 at 7:59 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
[...]
> > +static int regs_open(struct inode *inode, struct file *file)
> > +{
> > +       return single_open(file, regs_show, inode->i_private);
> > +}
> > +
> > +static const struct file_operations regs_fops =3D {
> > +       .open =3D regs_open,
> > +       .read =3D seq_read,
> > +       .llseek =3D seq_lseek,
> > +       .release =3D single_release,
> > +};
> > +
> > +static int tegra_dc_debugfs_init(struct tegra_dc *dc, struct dentry *p=
arent)
> > +{
> > +       char *name;
> > +
> > +       name =3D kasprintf(GFP_KERNEL, "dc.%d", dc->pipe);
> > +       dc->debugfs =3D debugfs_create_dir(name, parent);
> > +       kfree(name);
> > +
> > +       debugfs_create_file("regs", 0400, dc->debugfs, dc, &regs_fops);
> > +
>=20
> note that drm already has it's own debugfs helpers, see
> drm_debugfs_create_files() and drm_debugfs_remove_files()
>=20
> And also see debugfs_init/debugfs_cleanup in 'struct drm_driver'.
>=20
> You probably want to be using that rather than rolling your own.  You
> can have a look at omapdrm for a quite simple example, or i915 for a
> more complex example.

I actually tried to make use of those functions, but unfortunately it's
not possible to hook it up properly. The reason is that I need to pass
in some reference to the tegra_dc structure in order to read the
registers, but the DRM debugfs support doesn't allow to do that. Or
maybe it can. There's the void *arg argument that I could possibly use.
Then again it won't allow the creation of separate directories for each
of the display controllers. Or maybe I'm missing something.

> > +static const struct file_operations tegra_drm_fops =3D {
> > +       .owner =3D THIS_MODULE,
> > +       .open =3D drm_open,
> > +       .release =3D drm_release,
> > +       .unlocked_ioctl =3D drm_ioctl,
> > +       .mmap =3D drm_gem_cma_mmap,
> > +       .poll =3D drm_poll,
> > +       .fasync =3D drm_fasync,
> > +       .read =3D drm_read,
> > +#ifdef CONFIG_COMPAT
> > +       .compat_ioctl =3D tegra_compat_ioctl,
>=20
> is tegra_compat_ioctl() supposed to be in this patch?  Anyways, I
> guess you probably just want to use drm_compat_ioctl(), and make sure
> when you start adding any tegra specific ioctls that they are defined
> properly so compat isn't needed when we get to armv8..

Yeah, I overlooked that. I'll fix it.

> > +/* synchronization points */
> > +#define SYNCPT_VBLANK0 26
> > +#define SYNCPT_VBLANK1 27
>=20
> maybe these should be in dc.h?  Seems like these are related to the dc hw=
 block?

Yes, they could go into dc.h. This is one of the things that is likely
to change at some point as more of the host1x support is added, which is
where those syncpts are actually used.

> > +int host1x_unregister_client(struct host1x *host1x,
> > +                            struct host1x_client *client)
> > +{
> > +       struct host1x_drm_client *drm, *tmp;
> > +       int err;
> > +
> > +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
> > +               if (drm->client =3D=3D client) {
> > +                       err =3D host1x_drm_exit(host1x);
> > +                       if (err < 0) {
> > +                               dev_err(host1x->dev, "host1x_drm_exit()=
: %d\n",
> > +                                       err);
> > +                               return err;
> > +                       }
> > +
> > +                       host1x_remove_drm_client(host1x, drm);
> > +                       break;
> > +               }
> > +       }
> > +
> > +       mutex_lock(&host1x->clients_lock);
> > +       list_del_init(&client->list);
> > +       mutex_unlock(&host1x->clients_lock);
> > +
> > +       return 0;
> > +}
>=20
> btw, if I understand the register/unregister client stuff, I think
> there can be some potential issues.  If I understand correctly, you
> will create the crtc's in register.  But unregister doesn't destroy
> them, drm_mode_config_cleanup() when the container drm device is
> unloaded does.  So if there is any possibility to unregister a client
> without tearing down everything, you might get into some problems
> here.
>=20
> Also, you might be breaking some assumptions about when the crtc's are
> created.. at least if there is some possibility for userspace to sneak
> in and do a getresources ioctl between the first and second client.
> That might be easy enough to solve by adding some event for userspace
> to get notified that it should getresources again.  The unregister is
> what I worry about more.
>=20
> In general drm isn't set up to well for drivers that are a collection
> of sub-devices.  It is probably worth trying to improve this, although
> I am still a bit skittish about the edge cases, like what happens when
> you unload a sub-device mid-modeset.  The issue comes up again for
> common panel/display framework.
>=20
> But for now you might just want to do something to ensure that all the
> sub-devices are loaded/unloaded together as a whole.

The way that the above is supposed to work is that the DRM relevant
host1x clients are kept in a separate list and only if all of them have
successfully been probed is the DRM portion initialized. Upon
unregistration, as soon as the first of these clients is unregistered,
all of the DRM stuff is torn down.

I don't believe there's an issue here. It's precisely what I've been
testing for a while, always making sure that when built as a module it
can properly be unloaded.

That said it probably won't matter very much since on Tegra all drivers
are usually builtin, so none of this may even be used in the end.

Thanks for the quick review.

Thierry

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnSiCAAoJEN0jrNd/PrOhwFkP/Rg57pDJb9pCA4UMjD2ce+90
p0B/2b3FeJoy8pZG4VJpDR89qEzLkACklFLBIifrS/PsZXWJg4ilBIkIaxnIazCC
TJLTe29l58tD/YRUKNWmqxr6puDO+DzBxgW3nlV8yCoxw3awsNpr3/5vCMmF7Zf/
vvKqeYo8xiMb1PJ+Pjj2m10CPb61eaxYHF7s6TIk2rwVkjI719N9Uxbhs8OtRp0o
EVsmsesV1ipQV8Of029+t0OlM/3XCj/VrIE9OOtnftpcTgwGnPrHiWTiZZ2Sekpz
GdT7O7QMzmdmAbHQPJ83J5DwEPR1QYSBJg/dzzx6qtgDtE+vO47UF1+a0eBBOa6G
6MAvweMiaz784MpFANn3B3FFLg/XkTQtYTDfAiu4BmIUjarypX3F36tf/WZoZbJG
8pug705Do0sp8rZLy9tf09NqozR0DDI12lDzhly9dsmfBu2pCuHT+NsdNGDKJHW5
13Zy6Kk3Om+MjMIanTnitD2yFl6ji8xK4QCwF95mElynFMqoDa1+r33tJR4vlmik
8kczxpWBN3OI16zTP3nGxBEFNgDn5J4wzWzLtNS/KAnjGYcc3CLmo1cpKm2c+Odz
ZA+qdE9SSGfmXcVYbMvafY7khYAIANETT/ldZBCGNoeIYan7itrCXRgCTIPaOV4b
C095pSvU4nrrDofGQNVk
=AlDA
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
