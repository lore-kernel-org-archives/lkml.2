Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1KAUHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:07:50 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:51871 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1KAUHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:07:48 -0400
Date: Tue, 1 Nov 2011 16:07:46 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com
Subject: Re: [PATCH 2/6 V2] Add functions to check if the host has stopped
 the vm
Message-ID: <20111101200746.GC9852@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
 <1320091650-24682-3-git-send-email-emunson@mgebm.net>
 <4EB0485F.8010406@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <4EB0485F.8010406@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011, Anthony Liguori wrote:

> On 10/31/2011 03:07 PM, Eric B Munson wrote:
> >When a host stops or suspends a VM it will set a flag to show this.  The
> >watchdog will use these functions to determine if a softlockup is real, =
or the
> >result of a suspended VM.
> >
> >Signed-off-by: Eric B Munson<emunson@mgebm.net>
> >---
> >  arch/x86/include/asm/pvclock.h |    2 ++
> >  arch/x86/kernel/kvmclock.c     |   19 +++++++++++++++++++
> >  2 files changed, 21 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclo=
ck.h
> >index c59cc97..7d3ba41 100644
> >--- a/arch/x86/include/asm/pvclock.h
> >+++ b/arch/x86/include/asm/pvclock.h
> >@@ -13,6 +13,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock =
*wall,
> >  			    struct timespec *ts);
> >  void pvclock_resume(void);
> >
> >+bool kvm_check_and_clear_host_stopped(int cpu);
>=20
> A kvm-specific function shouldn't be declared in pvclock.h as this
> is shared code between KVM and Xen.

I'll move it for V3.

>=20
> >+
> >  /*
> >   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fractio=
n,
> >   * yielding a 64-bit result.
> >diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> >index c1a0188..8ddcfaf 100644
> >--- a/arch/x86/kernel/kvmclock.c
> >+++ b/arch/x86/kernel/kvmclock.c
> >@@ -113,6 +113,25 @@ static void kvm_get_preset_lpj(void)
> >  	preset_lpj =3D lpj;
> >  }
> >
> >+bool kvm_check_and_clear_host_stopped(int cpu)
> >+{
> >+	bool ret =3D false;
> >+	struct pvclock_vcpu_time_info *src;
> >+
> >+	/*
> >+	 * per_cpu() is safe here because this function is only called from
> >+	 * timer functions where preemption is already disabled.
> >+	 */
> >+	WARN_ON(!in_atomic());
> >+	src =3D&per_cpu(hv_clock, cpu);
> >+	if ((src->flags&  PVCLOCK_GUEST_STOPPED) !=3D 0) {
> >+		src->flags =3D src->flags&  (~PVCLOCK_GUEST_STOPPED);
> >+		ret =3D true;
> >+	}
>=20
> It would be helpful to separate out the patches for guest enablement
> from host enablement.  This is a guest function, correct?
>=20

Yes, this is guest only.

> Don't you need an atomic getandset here?  Can the host clear this
> flag or only set it?

I didn't think they needed to be atomic because an over-write of this means=
 that
a soft lockup message is delayed by the detector's timeout in the worst cas=
e.
If you disagree with that assessment, I can move to atomic get/set.

>=20
> It's ashame we don't have a proper pvclock spec in Documentation/.
> I would suggest at least adding a description of how this bit works
> in the first patch.
>=20



> Regards,
>=20
> Anthony Liguori
>=20
> >+
> >+	return ret;
> >+}
> >+
> >  static struct clocksource kvm_clock =3D {
> >  	.name =3D "kvm-clock",
> >  	.read =3D kvm_clock_get_cycles,
>=20

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsFGRAAoJEKhG9nGc1bpJUWEQAIWltrob08qVLLYtehS7UA7e
mtVR/8hWljtowPCw2II3p0ucoVIPBm16IQe4ba+xggH2RRBhP2Dus7tz4izjU2sH
Cwm7i5xLVuBJ4KrL/MbleDLsGDZ4iI8rNAHKtq3/2L3qmylyhXeLAmMWLjJ+xtFf
bs9r+essP+NmgWdIDz60fFRgae7UUbuaVH/+YOuZRv0sKCrveY/A3tPJhiZAAN8f
s9H6qZlBuvyiI/TnNfjnnBq20mcVGo23iMC/vcCqGS6EsLjRpfSf0a1O+FCZ2vE4
kMThtnw5OuDJljeZGuWc1nMcFjlPCYIvGzEDs6Xa/xQ/JaOPqGDOhpakv9ZCNXD9
eKOrB7mddhpN22olkRR6esWJDaWHk7+mscOPdQTlIDhmmrieoD1ojYy7oWdNZf0z
PtcwRCXKIjzuIyTxRzgvDctP0PDDoHThfmD5iJdSGgG+uBHUQeu2QdX2KiND3xyL
jNAQLHFQAtRV+Sn5TCqPKGIUVrdQGE46nPksSQ7NNsCdO4m3L9pV2XePcHhvFFxi
P1HaexMIdFLWrLQOJw/al9VC+TIYNHWtKkwPKnv9lp2X1rf+mZMOH9EB+MoPpuXJ
kbacYW8U8++nYYBBEI7WFdKuw9KscGG6POJTPW9KlO9JHL5nZ6VM9dUuI3SHwiBv
7YNO5YZVVt51EkN/S5Tv
=CXjV
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
