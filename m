Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1J1NVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:21:25 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:39169 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755369Ab1J1NVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:21:23 -0400
Date: Fri, 28 Oct 2011 09:21:22 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com
Subject: Re: [PATCH 6/6] Add age out of guest paused flag
Message-ID: <20111028132122.GB5795@mgebm.net>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
 <1319570779-8907-7-git-send-email-emunson@mgebm.net>
 <20111028021458.GB13000@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <20111028021458.GB13000@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks for the review.

On Fri, 28 Oct 2011, Marcelo Tosatti wrote:

> On Tue, Oct 25, 2011 at 03:26:19PM -0400, Eric B Munson wrote:
> > The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a =
soft
> > lockup but it can mask real soft lockups if the flag isn't cleared when=
 it is
> > no longer relevant.  This patch adds a kvm ioctl that the hypervisor wi=
ll use
> > when it resumes a guest to start a timer for aging out the flag.  The t=
ime out
> > will be specified by the hypervisor in the ioctl call.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > ---
> >  arch/x86/include/asm/pvclock.h |    2 ++
> >  arch/x86/kernel/kvmclock.c     |   24 ++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c             |    9 +++++++++
> >  include/linux/kvm.h            |    2 ++
> >  include/linux/kvm_host.h       |    2 ++
> >  5 files changed, 39 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvcl=
ock.h
> > index 9312814..e8460b9 100644
> > --- a/arch/x86/include/asm/pvclock.h
> > +++ b/arch/x86/include/asm/pvclock.h
> > @@ -18,6 +18,8 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
> > =20
> >  bool kvm_check_and_clear_host_stopped(int cpu);
> > =20
> > +void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length=
);
> > +
> >  /*
> >   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fractio=
n,
> >   * yielding a 64-bit result.
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index f4fff3d..f3f3935 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -23,6 +23,8 @@
> >  #include <asm/apic.h>
> >  #include <linux/percpu.h>
> >  #include <linux/kvm_host.h>
> > +#include <linux/kobject.h>
> > +#include <linux/sysfs.h>
> > =20
> >  #include <asm/x86_init.h>
> >  #include <asm/reboot.h>
> > @@ -144,6 +146,28 @@ bool kvm_check_and_clear_host_stopped(int cpu)
> >  	return ret;
> >  }
> > =20
> > +static void kvm_timer_clear_guest_paused(unsigned long vcpu_addr)
> > +{
> > +	struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *)vcpu_addr;
> > +	struct pvclock_vcpu_time_info *src =3D &vcpu->arch.hv_clock;
> > +	src->flags =3D src->flags & (!PVCLOCK_GUEST_STOPPED);
> > +}
> > +
> > +/*
> > + * Host has resumed the guest, we need to clear the guest paused flag =
so we
> > + * don't mask any real soft lockups.
> > + */
> > +void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length)
> > +{
> > +	if (!timer_pending(&vcpu->flag_timer))
> > +		setup_timer(&vcpu->flag_timer,
> > +			    kvm_timer_clear_guest_paused,
> > +			    (unsigned long)vcpu);
> > +	mod_timer(&vcpu->flag_timer,
> > +		  jiffies + (length * HZ));
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_clear_guest_paused);
>=20
> So this is why the scheme could become awkward. You can't determine a  =
=20
> value for length that will guarantee that _no_ genuine softlockup is   =
=20
> omitted.
>=20
> Can you think of a way to achieve this?

Given the way this set works now, I don't see a way to completely avoid the
chance of covering the first notification of a soft lockup.  But, if I
understand the way this code works, the watchdog will come back and complain
if the CPU is still soft locked on the next pass.  Unless I am not reading =
the
watchdog code correctly, this will only delay the warning of a real soft lo=
ckup.

>=20
> Also note, all host code is located in arch/x86/kvm, guest=20
> code in arch/x86/kernel/kvmclock.c.

I will reshuffle for the next revision.
>=20

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOqqxSAAoJEKhG9nGc1bpJTkYQAJQybvsPfJQZilfrpIZbpJWy
ASpdjyJz4cO65gyzlfohbQbHLvdDLORNNgSEoBDrXFObWL/5gX1KDe75dUYRZPeA
OvJgcCzsIJk5F/mljJrQnwnksEJiI8KZho3Gxvu4/GNWOBupBdIjee2TlRkZGy0M
WnncTyq96xECik+fd/FOzmf1dhpzelXIuarKRwfktTQ8MBnexvJjIP5Sn0EY1SdW
8b09Z7gFXK2ytk6YXE+XxYcr44IgC8MYhIB08BeNQ/VBq+xgjB6mOqafDG8XwIUT
2I3GfqtFsa/6l3omvqPWItz5KfSFCGCmYXkwovTd2At7OEBhM4uVl1EsAmSfAc5T
FdPnkn5ZEF8+Yq2ojTCbwIgjg1R4I4DVdCzVrSOPOd8oU9Ep42IpSfaXT5i4G6gQ
pLSmbMfl46c82r5OO9hD9ZuzboqK39E7lT+RHEIa8UV3ipBEncyhTHwuSdAa1tKe
0rnMXLz339sJdRMaAkN6DeL/2bfEkm2xzyNtZP2Cw68vIBBkvPyEbUrQPhRb7FqM
XmTMihjxCMk1otQxFMaiJ+6c8D4ryD2qDKjnS+aD3wlh7Iesd95AultojX91zQlw
+tAWHuVnYi4rtQyvd8QmsoWMZstpIPE/Oko96zZo6DKel5dzYoPrdQhT2cCuAh8S
qqETj+rz7lAJGOabI0M0
=7Wdq
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
