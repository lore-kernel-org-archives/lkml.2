Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1J1NMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 09:12:01 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:39116 "EHLO
	ozymandias.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752613Ab1J1NL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 09:11:59 -0400
Date: Fri, 28 Oct 2011 09:11:57 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com
Subject: Re: [PATCH 3/6] Add ioctl for KVM_GUEST_STOPPED
Message-ID: <20111028131157.GA5795@mgebm.net>
References: <1319570779-8907-1-git-send-email-emunson@mgebm.net>
 <1319570779-8907-4-git-send-email-emunson@mgebm.net>
 <20111028015248.GA13000@amt.cnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20111028015248.GA13000@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Oct 2011, Marcelo Tosatti wrote:

> On Tue, Oct 25, 2011 at 03:26:16PM -0400, Eric B Munson wrote:
> > Now that we have a flag that will tell the guest it was suspended, crea=
te an
> > interface for that communication using a KVM ioctl.
> >=20
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> > ---
> >  arch/x86/include/asm/pvclock.h |    3 +++
> >  arch/x86/kernel/kvmclock.c     |   12 ++++++++++++
> >  arch/x86/kvm/x86.c             |    5 +++++
> >  include/linux/kvm.h            |    2 ++
> >  4 files changed, 22 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvcl=
ock.h
> > index 7d3ba41..9312814 100644
> > --- a/arch/x86/include/asm/pvclock.h
> > +++ b/arch/x86/include/asm/pvclock.h
> > @@ -3,6 +3,7 @@
> > =20
> >  #include <linux/clocksource.h>
> >  #include <asm/pvclock-abi.h>
> > +#include <linux/kvm_host.h>
> > =20
> >  /* some helper functions for xen and kvm pv clock sources */
> >  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> > @@ -13,6 +14,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock=
 *wall,
> >  			    struct timespec *ts);
> >  void pvclock_resume(void);
> > =20
> > +void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
> > +
> >  bool kvm_check_and_clear_host_stopped(int cpu);
> > =20
> >  /*
> > diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> > index 8ddcfaf..f4fff3d 100644
> > --- a/arch/x86/kernel/kvmclock.c
> > +++ b/arch/x86/kernel/kvmclock.c
> > @@ -22,6 +22,7 @@
> >  #include <asm/msr.h>
> >  #include <asm/apic.h>
> >  #include <linux/percpu.h>
> > +#include <linux/kvm_host.h>
> > =20
> >  #include <asm/x86_init.h>
> >  #include <asm/reboot.h>
> > @@ -113,6 +114,17 @@ static void kvm_get_preset_lpj(void)
> >  	preset_lpj =3D lpj;
> >  }
> > =20
> > +/*
> > + * kvm_set_host_stopped() indicates to the guest kernel that it has be=
en
> > + * stopped by the hypervisor.  This function will be called from the h=
ost only.
> > + */
> > +void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
> > +{
> > +	struct pvclock_vcpu_time_info *src =3D &vcpu->arch.hv_clock;
> > +	src->flags |=3D PVCLOCK_GUEST_STOPPED;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
> > +
> >  bool kvm_check_and_clear_host_stopped(int cpu)
> >  {
> >  	bool ret =3D false;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 84a28ea..16e029e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3264,6 +3264,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > =20
> >  		goto out;
> >  	}
> > +	case KVM_PAUSE_GUEST: {
>=20
> Pause guest?? :)

GUEST_PAUSED for the next version.

>=20
> > +		r =3D 0;
> > +		kvm_set_host_stopped(vcpu);
> > +		break;
> > +	}
> >  	default:
> >  		r =3D -EINVAL;
> >  	}
>=20

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOqqodAAoJEKhG9nGc1bpJedcP/0MUpDx3d2B0h15XeZ7r1br1
TWvmYNVK0a1Qt1XCMEfu+imyIu3D1WqN23GUpoU/tTE/G+ZvZ+FSWP+Q44kJDemi
WFcQzM4VPM4HSAELh6fAyt+g0HVhiQFdWE4qjViy9+jexd6J3ho2IaEMXHtDS7nK
4vYfVN4eS3ONzoZTc6vkMJSeCRVPmjXThKOT3eqZII5CLi2drB/rI8ecBj+8xkD+
vAvy4J1XeBasJAGZ13vyd5ndnlbLTBJFYkD835PnD3bC65gRLUzIA5ZB44cPCFly
VMMTryOzgbI3Yxyey1+Ks86+L230VAvpA4zkoI/HWg0q/TcGeHs0vWoOwtxDuQo4
vk/c3C+prlHSsKYTbKVFNhBjdGagG0d11P+3RAJVqBaGa0gR9rqwMlTmnkuszseT
ff/6nsRGyj5WJigIds4sSg8wmRiNOmKu5eS2yZOZaZ2WGdQ6CUd2tObGHhgvsGUf
lkmn8eZLYfQVvAaD6/s7D4k5JIS9n4T6HQKdsxa29HyvGki8n4bTAv/cS5wq8jNl
OfEG04XV9kEoUfu71JcZCAvrZmu1YaQbxPplyldNEpIseH0Or/mHd8dj4KjG7ZHk
nCLMsBjRc/GtOj9ulRtkF01dHXm/s85+HIKpb1U9OWvjcVKHQO6inabot0l+pmwq
sra3r5O1bh4fzdr1Kb7b
=grzC
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
