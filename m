Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1KATvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:51:16 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:51784 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab1KATvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:51:13 -0400
Date: Tue, 1 Nov 2011 15:51:11 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com
Subject: Re: [PATCH 6/6 V2] Add age out of guest paused flag
Message-ID: <20111101195111.GA9852@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
 <1320091650-24682-7-git-send-email-emunson@mgebm.net>
 <4EB049C3.7080206@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <4EB049C3.7080206@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011, Anthony Liguori wrote:

> On 10/31/2011 03:07 PM, Eric B Munson wrote:
> >The KVM_GUEST_PAUSED flag will prevent a guest from compaining about a s=
oft
> >lockup but it can mask real soft lockups if the flag isn't cleared when =
it is
> >no longer relevant.  This patch adds a kvm ioctl that the hypervisor wil=
l use
> >when it resumes a guest to start a timer for aging out the flag.  The ti=
me out
> >will be specified by the hypervisor in the ioctl call.
> >
> >Signed-off-by: Eric B Munson<emunson@mgebm.net>
>=20
> Why not have the guest clear the flag when it acknowledges it?
>=20
> The hypervisor would unconditionally set the bit, and the guest
> would do a testandclear to check if the bit is set.  I think that
> avoids the whole aging business.
>=20
> Regards,
>=20
> Anthony Liguori

If you have a look at patch 5 of this series, the flag is cleared when the
guest checks the validity of a soft lockup.  However, the aging is meant to
cover the case where the guest never sees a soft lockup.  We don't want this
flag to be stored for ever and end up delaying real soft lockup messages.  =
With
that case in mind, I thought this was a good/simple compramise.

Eric

>=20
> >---
> >Cahnges from V1:
> >  Add host functions for flag management to arch/x86/kvm/x86.c instead of
> >kvmclock.c
> >
> >  arch/x86/include/asm/pvclock.h |    2 ++
> >  arch/x86/kvm/x86.c             |   32 ++++++++++++++++++++++++++++++++
> >  include/linux/kvm.h            |    2 ++
> >  include/linux/kvm_host.h       |    2 ++
> >  4 files changed, 38 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclo=
ck.h
> >index 9312814..e8460b9 100644
> >--- a/arch/x86/include/asm/pvclock.h
> >+++ b/arch/x86/include/asm/pvclock.h
> >@@ -18,6 +18,8 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
> >
> >  bool kvm_check_and_clear_host_stopped(int cpu);
> >
> >+void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length);
> >+
> >  /*
> >   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fractio=
n,
> >   * yielding a 64-bit result.
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index 592ac3b..fb0132a 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -46,6 +46,7 @@
> >  #include<linux/hash.h>
> >  #include<linux/pci.h>
> >  #include<trace/events/kvm.h>
> >+#include<linux/timer.h>
> >
> >  #define CREATE_TRACE_POINTS
> >  #include "trace.h"
> >@@ -3300,6 +3301,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >  		kvm_set_host_stopped(vcpu);
> >  		break;
> >  	}
> >+	case KVM_CLEAR_GUEST_PAUSED: {
> >+		unsigned int length;
> >+		r =3D -EFAULT;
> >+		if (copy_from_user(&length, argp, sizeof length))
> >+			goto out;
> >+		r =3D 0;
> >+		kvm_clear_guest_paused(vcpu, length);
> >+		break;
> >+	}
> >  	default:
> >  		r =3D -EINVAL;
> >  	}
> >@@ -6133,6 +6143,28 @@ void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
> >
> >+static void kvm_timer_clear_guest_paused(unsigned long vcpu_addr)
> >+{
> >+	struct kvm_vcpu *vcpu =3D (struct kvm_vcpu *)vcpu_addr;
> >+	struct pvclock_vcpu_time_info *src =3D&vcpu->arch.hv_clock;
> >+	src->flags =3D src->flags&  (~PVCLOCK_GUEST_STOPPED);
> >+}
> >+
> >+/*
> >+ * Host has resumed the guest, we need to clear the guest paused flag s=
o we
> >+ * don't mask any real soft lockups.
> >+ */
> >+void kvm_clear_guest_paused(struct kvm_vcpu *vcpu, unsigned int length)
> >+{
> >+	if (!timer_pending(&vcpu->flag_timer))
> >+		setup_timer(&vcpu->flag_timer,
> >+			    kvm_timer_clear_guest_paused,
> >+			    (unsigned long)vcpu);
> >+	mod_timer(&vcpu->flag_timer,
> >+		  jiffies + (length * HZ));
> >+}
> >+EXPORT_SYMBOL_GPL(kvm_clear_guest_paused);
> >+
> >  int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> >  				  struct kvm_sregs *sregs)
> >  {
> >diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> >index 87cab0d..bd9724c 100644
> >--- a/include/linux/kvm.h
> >+++ b/include/linux/kvm.h
> >@@ -765,6 +765,8 @@ struct kvm_clock_data {
> >  #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
> >  /* VM is being stopped by host */
> >  #define KVM_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
> >+/* Start the timer to clear the paused flag */
> >+#define KVM_CLEAR_GUEST_PAUSED	  _IO(KVMIO,   0xab)
> >
> >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1<<  0)
> >
> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >index d526231..043af4d 100644
> >--- a/include/linux/kvm_host.h
> >+++ b/include/linux/kvm_host.h
> >@@ -19,6 +19,7 @@
> >  #include<linux/slab.h>
> >  #include<linux/rcupdate.h>
> >  #include<linux/ratelimit.h>
> >+#include<linux/timer.h>
> >  #include<asm/signal.h>
> >
> >  #include<linux/kvm.h>
> >@@ -154,6 +155,7 @@ struct kvm_vcpu {
> >  #endif
> >
> >  	struct kvm_vcpu_arch arch;
> >+	struct timer_list flag_timer;
> >  };
> >
> >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>=20

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsE2vAAoJEKhG9nGc1bpJ2zkP/1CWDzbL43s5qV1urTP+ILA3
IQCoyTgD8VxGFQWmKaW6aCk9s1r66JVUb91YRHDLquIGTFI8wISoC9XmODAGq74t
rbGx6TUsQiT4Zz/CemFIGZzpYMmG6wDzeDmYvdpNqn0ENkrfqNvZvMQfg6KpXf1v
qVtK7+icgxeC0Z8pgOYdPoQO/U4IFPlyeoS244yC0A45+peURrUgZXrLcCD9zMoV
9EuHFqMzfCXK5nmz8QVHdPZkAbUnyTH37sMT4nozt2z+EK4F9kJfWDtO3u0wDiv0
777XSUiBGFTPN2OL3y+e1EZdqpSoYpKqq+Wx9nY9jA/X01M2WRWChazo/loPSv2m
sXu3JGSsDDCzNcFwoqfej2/AxLlyyehh4369Vl1P7jm8zOwYdEz2fnTsGNK5uWX9
wUpEEoXlSO/GFzeFiiXacJlk6js+kj4bWrmDd2vpWTc2WS8XD9jAcvbURLZA/oQS
xAsHaumOs1lXCmjkHJ3A4U7QfyU3/ETlSAN21aW4NjSjX/tsRophz5c6AW9VI89M
9epzWQpQirk35RFce0c/of+tpXXiI0WBb47scN1SahoRw73JojT66kICLuomMrgd
EETRbiBF075IpgWAdJCTJ+nDcwEnMFzc3LJoPipqzoQCDh/6/WssSDoErxzLFAqj
/mQ+kyar5oOYimK5LO9u
=Auba
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
