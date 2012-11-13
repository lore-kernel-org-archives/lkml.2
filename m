Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2KMHsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:48:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50170 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2KMHs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:48:29 -0500
Date: Tue, 13 Nov 2012 08:48:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Zhang <markz@nvidia.com>
Cc: Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
Message-ID: <20121113074822.GA8409@avionic-0098.mockup.avionic-design.de>
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
 <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de>
 <50A1F3A3.40905@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <50A1F3A3.40905@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:sn8iOyFo/IGuLdTNA/G1z1GtB2bDQvlueZDcAHnBJSC
 Io5h9Ejzl4xHTq2MRgU6xqMAtFCm3QZzjW8HQGkQcNUp7Saehp
 HrOG9cO5UJT4mjDYygu0/CoWtTb8URnBDidmlSgURQBb7trd9y
 /N/V4d76vYHwVKDU958YMsrSBPz+bhs1tE5ICtM8w8v9cFAtnI
 GWZQ7iwInPcuUjFwQDeKZFu69HU2938XRcYeFH6ZWejBHB+Nct
 /+rYULLpDBZbIOx3bbBVrlpoFjNRwdmPQbdCuazwd5EB6Irc9Q
 J+49swWGlZ0Ds8UvJrLNkZXMByGrAxPUIRr6Zx9GuXlG6ooham
 MPjfXWWJpdzM2YOBwJnFPx4lqzYXBjUfkVoFvY8ahnVxCspCzv
 sngkhKfHtdlqLgf9vGjZx5mLEKASIW8Ybo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 13, 2012 at 03:15:47PM +0800, Mark Zhang wrote:
> On 11/13/2012 05:55 AM, Thierry Reding wrote:
> > This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> > support for host1x and the two display controllers found on the Tegra20
> > SoC. Each display controller can drive a separate RGB/LVDS output.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> > Changes in v2:
> > - drop Linux-specific drm subdirectory for DT bindings documentation
> > - remove display helper leftovers that belong in a later patch
> > - reuse debugfs infrastructure provided by the DRM core
> > - move vblank syncpoint defines to dc.h
> > - use drm_compat_ioctl()
> >=20
> [...]
> > diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kcon=
fig
> > new file mode 100644
> > index 0000000..be1daf7
> > --- /dev/null
> > +++ b/drivers/gpu/drm/tegra/Kconfig
> > @@ -0,0 +1,23 @@
> > +config DRM_TEGRA
> > +       tristate "NVIDIA Tegra DRM"
> > +       depends on DRM && OF && ARCH_TEGRA
> > +       select DRM_KMS_HELPER
> > +       select DRM_GEM_CMA_HELPER
> > +       select DRM_KMS_CMA_HELPER
>=20
> Just for curious, according to my testing, why the "CONFIG_CMA" is not
> enabled while DRM_GEM_CMA_HELPER & DRM_KMS_CMA_HELPER are enabled here?

The reason is that CMA doesn't actually provide any API for drivers to
use and in fact unless you use very large buffers you could indeed run
this code on top of a non-CMA kernel and it will likely even work.

> > +static struct of_device_id tegra_dc_of_match[] =3D {
> > +       { .compatible =3D "nvidia,tegra20-dc", },
> > +       { .compatible =3D "nvidia,tegra30-dc", },
>=20
> If you don't want add Tegra 3 support in this patch set, remove
> { .compatible =3D "nvidia,tegra30-dc", } here.

Good catch! I'll move that into the Tegra30 support patch.

> > +static int host1x_activate_drm_client(struct host1x *host1x,
> > +                                     struct host1x_drm_client *drm,
> > +                                     struct host1x_client *client)
> > +{
> > +       mutex_lock(&host1x->drm_clients_lock);
> > +       list_del_init(&drm->list);
> > +       list_add_tail(&drm->list, &host1x->drm_active);
>=20
> Why we need this "drm_active" list? We can combine this function and
> function "host1x_remove_drm_client" and free the drm client just here.
> It's useless after host1x clients registered themselves.

The list is used to properly remove all clients and resources when the
module is unloaded. Granted, this code isn't executed if you don't build
the driver as a loadable module, but it should still be a supported use-
case.

> > +int host1x_unregister_client(struct host1x *host1x,
> > +                            struct host1x_client *client)
> > +{
> > +       struct host1x_drm_client *drm, *tmp;
> > +       int err;
> > +
> > +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
> > +               if (drm->client =3D=3D client) {
> > +                       err =3D host1x_drm_exit(host1x);
>=20
> Although this code works but I think it looks confusing.
> "host1x_drm_exit" calls every client's "drm_exit" callback then free all
> the host1x clients, but this function is placed inside a loop.
>=20
> I think the better way is, free this host1x_client first, then remove it
> from host1x's "clients" list, finally free the host1x(call
> host1x_drm_exit) when the "clients" list get empty.

But that would be the same thing, only slightly more explicit. I find
that the above reads quite well as: look through the list of active
clients and if the client to be removed is in that list, teardown the
DRM part.

I suppose I could add a comment to explain this and avoid confusion.

> > +int tegra_output_init(struct drm_device *drm, struct tegra_output *out=
put)
> > +{
> > +       int connector, encoder, err;
> > +       enum of_gpio_flags flags;
> > +       struct device_node *ddc;
> > +       size_t size;
> > +
> > +       if (!output->of_node)
> > +               output->of_node =3D output->dev->of_node;
> > +
> > +       output->edid =3D of_get_property(output->of_node, "nvidia,edid"=
, &size);
> > +
> > +       ddc =3D of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus",=
 0);
> > +       if (ddc) {
> > +               output->ddc =3D of_find_i2c_adapter_by_node(ddc);
>=20
> The i2c adapter may not be ready at this time. For Tegra 2, the I2C bus
> for HDMI is not dedicated and we need the i2cmux driver loaded before
> this i2c can be used. It proved that sometimes i2cmux driver loads after
> drm driver.
>=20
> So we need to add some logics to support driver probe deferral here.
> Anyway, I'm just want you know about this and we can improve this later.

Good point. Unfortunately tegra_output_init() isn't always used from
within .probe(), so it isn't quite easy to handle deferred probe here.
I'll have to take a look at how to solve this properly.

> > +int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
> > +{
> > +       struct device_node *np;
> > +       struct tegra_rgb *rgb;
> > +       int err;
> > +
> > +       np =3D of_get_child_by_name(dc->dev->of_node, "rgb");
> > +       if (!np || !of_device_is_available(np))
> > +               return -ENODEV;
> > +
> > +       rgb =3D devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
> > +       if (!rgb)
> > +               return -ENOMEM;
> > +
> > +       rgb->clk =3D devm_clk_get(dc->dev, NULL);
> > +       if (IS_ERR_OR_NULL(rgb->clk))
> > +               return PTR_ERR(rgb->clk);
> > +
> > +       rgb->clk_parent =3D devm_clk_get(dc->dev, "parent");
> > +       if (IS_ERR_OR_NULL(rgb->clk_parent))
> > +               return PTR_ERR(rgb->clk_parent);
> > +
> > +       err =3D clk_set_parent(rgb->clk, rgb->clk_parent);
> > +       if (err < 0) {
> > +               dev_err(dc->dev, "failed to set parent clock: %d\n", er=
r);
> > +               return err;
> > +       }
>=20
> Okay, seems this works with the "CLK_DUPLICATE" in tegra20_clocks_data.c.
> I think the purpose of all these is to make sure the dc has a correct
> parent clock. Hm... But I feel this may bring confusing to do dc clock
> settings in a drm output component.

How do you think this would be confusing?

Thierry

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQoftGAAoJEN0jrNd/PrOhwFQQAKKkqlzWjY370pXUcxNllDRW
OWGHSWunnx75BeZMJK9XAMjNSLcT9CXdJbUu53HiSUrBZRyX5xX4i5EBD9nC77pf
qDJbHvqXuI4BgINixZzpGAEzeZ//1dczdIwm6YGr2XNbyYt45QSJ+bDGSBf11sig
AKSulhp0ECjjhJ7jm4o975clYVN3W6xxEoJLa0gJfbEU0f/CGS6eQ8UxSmMGbejq
nm1mR+1NfP3WwGv2BSDrqjsErdFGUZHyns8f/pkhbpLAVFn9KgTBT2aQzBlytaHQ
2NEl5h7gTstwjEBzAV5yKZYFvzLaDOrBJs8xqX9oTB6OHIDkrk+dQRCnUOTgE6J3
jOi5w39g4pRNdI/X/ryJjhoeEUJczxT2AziM81h7esryo1RqQRmS36YR3t023OkT
VlWQLS/FyhS7t+/knFfC992a/pvaHilaxXtu0/3b+dUmO2//hZKBlLJk5QqHJ15V
2M5/eGFNwuPPF6QcD8H4s9/0Ok+045zWjMfCBTkG8xAG4tntlTsGt5V7ItP+248/
yh+neYVHD3dtE4FZh3LwrWWSZpfIiD9i3QFA74Z/jKHEUj1dm6pYJT/fo1KdpTRZ
xMcVmNmzPC9lbaOciBmnwhMDuOA2xPJH+jz6sBxJxfiNMH7LC6P2vWpHq6HJpIEG
+uMmtSYlxTBeKh/+6A+M
=QCV3
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
