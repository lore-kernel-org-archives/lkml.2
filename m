Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2HOHLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:11:19 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:41613 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab2HOHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:11:17 -0400
Date: Wed, 15 Aug 2012 10:07:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] iommu/tegra: smmu: Use __debugfs_create_dir
Message-ID: <20120815070726.GJ23637@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344407073-12030-1-git-send-email-hdoyu@nvidia.com>
 <1344407073-12030-3-git-send-email-hdoyu@nvidia.com>
 <20120808151128.GC9091@arwen.pp.htv.fi>
 <20120808153100.GE9091@arwen.pp.htv.fi>
 <20120815093421.c08fdbbf4d7ce6c3986861f2@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Content-Disposition: inline
In-Reply-To: <20120815093421.c08fdbbf4d7ce6c3986861f2@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 15, 2012 at 09:34:21AM +0300, Hiroshi Doyu wrote:
> > > @@ -892,6 +909,164 @@ static struct iommu_ops smmu_iommu_ops =3D {
> > >       .pgsize_bitmap  =3D SMMU_IOMMU_PGSIZES,
> > >  };
> > >
> > > +/* Should be in the order of enum */
> > > +static const char * const smmu_debugfs_mc[] =3D { "mc", };
> > > +static const char * const smmu_debugfs_cache[] =3D {  "tlb", "ptc", =
};
> > > +
> > > +static ssize_t smmu_debugfs_stats_write(struct file *file,
> > > +                                     const char __user *buffer,
> > > +                                     size_t count, loff_t *pos)
> > > +{
> > > +     struct smmu_device *smmu;
> > > +     struct dentry *dent;
> > > +     int i, cache, mc;
> > > +     enum {
> > > +             _OFF =3D 0,
> > > +             _ON,
> > > +             _RESET,
> > > +     };
> > > +     const char * const command[] =3D {
> > > +             [_OFF]          =3D "off",
> > > +             [_ON]           =3D "on",
> > > +             [_RESET]        =3D "reset",
> > > +     };
> > > +     char str[] =3D "reset";
> > > +     u32 val;
> > > +     size_t offs;
> > > +
> > > +     count =3D min_t(size_t, count, sizeof(str));
> > > +     if (copy_from_user(str, buffer, count))
> > > +             return -EINVAL;
> > > +
> > > +     for (i =3D 0; i < ARRAY_SIZE(command); i++)
> > > +             if (strncmp(str, command[i],
> > > +                         strlen(command[i])) =3D=3D 0)
> > > +                     break;
> > > +
> > > +     if (i =3D=3D ARRAY_SIZE(command))
> > > +             return -EINVAL;
> > > +
> > > +     dent =3D file->f_dentry;
> > > +     cache =3D (int)dent->d_inode->i_private;
> >=20
> > cache you can figure out by the filename. In fact, it would be much
> > better to have tlc and ptc directories with a "status" filename which
> > you write ON/OFF/RESET or enable/disable/reset to trigger what you need.
>=20
> Actually I also considered {ptc,tlb} directories, but I thought that
> those might be residual, or nested one more unnecessarily.
>=20
> The current usage is:
>=20
>   $ echo "reset" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
>   $ echo "on" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
>   $ echo "off" > /sys/kernel/debug/smmu/mc/{tlb,ptc}
>   $ cat /sys/kernel/debug/smmu/mc/{tlb,ptc}
>   hit:0014910c miss:00014d22
>=20
>   The above format is:
>   hit:<HIT count><SPC>miss:<MISS count><SPC><CR+LF>

if you're just printing hit and miss count, wouldn't it be a bit more
human-friendly to print it in decimal rather than hex ? no strong
feelings against either way, just thought I'd mention it.

>   fscanf(fp, "hit:%lx miss:%lx", &hit, &miss);
>=20
>=20
> If {ptc,tlb} was dir, the usage would be:
>=20
>   $ echo "reset" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
>   $ echo "on" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
>   $ echo "off" > /sys/kernel/debug/smmu/mc/{tlb,ptc}/status
>   $ cat /sys/kernel/debug/smmu/mc/{tlb,ptc}/data
>   hit:0014910c miss:00014d22
>=20
> One advantage of dirs could be, you may be able to check the current
> status by reading "status". It might be less likely read back
> practically because if writing succeeded, the state should be what was
> written.

sure.

> > For that to work, you should probably hold tlb and ptc on an array of
> > some sort, and pass those as data to their respective "status" files as
> > the data field. If tlb and ptc are properly defined structures which can
> > point back to smmu, then you have everything you need.
>=20
> I also considered to introduce new structure like what you suggested
> below, but I felt that the parent<-chile relationships are already in
> directory hierarchy, and I wanted to avoid the residual data with
> introducing new structures. Instead of introducing new structure,
> those parent<-child relationships are always gotton from debugfs
> directory hierarchy on demand. That was why I wanted to put data in
> debugfs dir. With debugfs directories having private data, the
> connections between entities would be kept in filesystem.

fair enough.

> I've already sent another version of patch(v2, *1), which passes all
> necessary data to a file, put in a structure. This v2 patch may be a
> little bit simliear to what Felipe suggested below.

I looked over that, but I'm not sure you should introduce that
smmu_debugfs_info structure. Look at what we do on
drivers/usb/dwc3/debugfs.c, we don't add any extra structures for
debugfs, we use what the driver already has (struct dwc3-only,
currently).

If we were to add debgufs support for each USB endpoint, I would pass
struct dwc3_ep as data for the files. See that I would still be able to
access struct dwc3, should I need it, because struct dwc3_ep knows which
struct dwc3 it belongs to.

That's what I meant when I suggested adding more structures, not
something for debugfs-only, but something for the whole driver to use.
Just re-design the driver a little bit and you won't need to allocate
memory when creating debugfs directories, because the data you need is
already available.

--=20
balbi

--n83H03bbH672hrlY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQK0qtAAoJEIaOsuA1yqREyq4QAI1/HLlG+m3J+eaGich00rVn
et0VshltvNA/cTs+C8oYRsqYXzMMDZG/noOFa2OGNZDJ9/wrhCS3qNECStctzY5Z
o5dvA4DBVHEZy7F1ZmLd//ksacNc7eGAIuFXY9/kkG4QANmFlfXIpZatV0SLVjem
s/IdHl8jYhycZZ707kZMANM9rJpZSBkoec0PQ2nQgjNoPJYsNX2Kov6bjXkbmvzg
SVkqPIm+ozBx63qyRDHHZvRjzNMbXKTgOvbJwXIWhwYMygXhZU/MYw8nds/wVUjW
Y0MZlfHndDrVA/7mVbs46q8b6sKObcXC5jCq7T40H+SGRN+MsrhAroPO5s+rCQeT
FDt1HlIdv36s+6trbHwz9FB00o08odZS/iyQwJWF6XKBM3MP1ppOSWoaW5APHscx
YL3T+EhJl0SQRz7nJ0tU4r4MQZMpNDwUEvljgj1qzwywlTDWM2tz6hX3tKpON7aM
lVm55QfnU6Rt0hM99Qtgc9V+KZFNSdSNC02IDP0E+qKHa20P7Rv1FGwDm/xEqrFJ
g2xsM9rpGhsDacVIaiJuQ15lxY41HbMjOx0hGjkaCWNUgqHPpTPUHaApXhSHkyzz
wgedJgxnx4MzomYViAaXtY27f1Xva0z9raLRM9CyFbJx3ET6zztSvD7u/KD4ns+g
4JjjxcI58f1MEOjY86Hr
=PTiI
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
