Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab1KAULr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 16:11:47 -0400
Received: from oz.csail.mit.edu ([128.30.30.239]:51911 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab1KAULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 16:11:46 -0400
Date: Tue, 1 Nov 2011 16:11:44 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Anthony Liguori <aliguori@us.ibm.com>
Cc: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6 V2] Add ioctl for KVM_GUEST_STOPPED
Message-ID: <20111101201144.GE9852@mgebm.net>
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net>
 <1320091650-24682-4-git-send-email-emunson@mgebm.net>
 <4EB04940.2030506@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Content-Disposition: inline
In-Reply-To: <4EB04940.2030506@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 01 Nov 2011, Anthony Liguori wrote:

> On 10/31/2011 03:07 PM, Eric B Munson wrote:
> >Now that we have a flag that will tell the guest it was suspended, creat=
e an
> >interface for that communication using a KVM ioctl.
> >
> >Signed-off-by: Eric B Munson<emunson@mgebm.net>
> >---
> >Changes from V1:
> >  Add kvm_set_host_stopped to arch/x86/jvm/x86.c instead of kvmclock.c
> >  Rename KVM_PAUSE_GUEST to KVM_GUEST_PAUSED
> >
> >  arch/x86/include/asm/pvclock.h |    3 +++
> >  arch/x86/kvm/x86.c             |   16 ++++++++++++++++
> >  include/linux/kvm.h            |    2 ++
> >  3 files changed, 21 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclo=
ck.h
> >index 7d3ba41..9312814 100644
> >--- a/arch/x86/include/asm/pvclock.h
> >+++ b/arch/x86/include/asm/pvclock.h
> >@@ -3,6 +3,7 @@
> >
> >  #include<linux/clocksource.h>
> >  #include<asm/pvclock-abi.h>
> >+#include<linux/kvm_host.h>
> >
> >  /* some helper functions for xen and kvm pv clock sources */
> >  cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src);
> >@@ -13,6 +14,8 @@ void pvclock_read_wallclock(struct pvclock_wall_clock =
*wall,
> >  			    struct timespec *ts);
> >  void pvclock_resume(void);
> >
> >+void kvm_set_host_stopped(struct kvm_vcpu *vcpu);
>=20
> This can't go in pvclock.h.
>=20

Will move for V3.

> >+
> >  bool kvm_check_and_clear_host_stopped(int cpu);
> >
> >  /*
> >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >index c38efd7..592ac3b 100644
> >--- a/arch/x86/kvm/x86.c
> >+++ b/arch/x86/kvm/x86.c
> >@@ -3295,6 +3295,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >
> >  		goto out;
> >  	}
> >+	case KVM_GUEST_PAUSED: {
> >+		r =3D 0;
> >+		kvm_set_host_stopped(vcpu);
> >+		break;
> >+	}
> >  	default:
> >  		r =3D -EINVAL;
> >  	}
> >@@ -6117,6 +6122,17 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 ts=
s_selector, int reason,
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_task_switch);
> >
> >+/*
> >+ * kvm_set_host_stopped() indicates to the guest kernel that it has been
> >+ * stopped by the hypervisor.  This function will be called from the ho=
st only.
> >+ */
> >+void kvm_set_host_stopped(struct kvm_vcpu *vcpu)
> >+{
> >+	struct pvclock_vcpu_time_info *src =3D&vcpu->arch.hv_clock;
> >+	src->flags |=3D PVCLOCK_GUEST_STOPPED;
>=20
> Shouldn't we throw some sort of error if you're trying to set a flag
> and kvmclock isn't enabled?
>=20
> Regards,
>=20
> Anthony Liguori
>=20

Is kvmclock a compile time only option or something set at runtime?

> >+}
> >+EXPORT_SYMBOL_GPL(kvm_set_host_stopped);
> >+
> >  int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> >  				  struct kvm_sregs *sregs)
> >  {
> >diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> >index f47fcd3..87cab0d 100644
> >--- a/include/linux/kvm.h
> >+++ b/include/linux/kvm.h
> >@@ -763,6 +763,8 @@ struct kvm_clock_data {
> >  #define KVM_CREATE_SPAPR_TCE	  _IOW(KVMIO,  0xa8, struct kvm_create_sp=
apr_tce)
> >  /* Available with KVM_CAP_RMA */
> >  #define KVM_ALLOCATE_RMA	  _IOR(KVMIO,  0xa9, struct kvm_allocate_rma)
> >+/* VM is being stopped by host */
> >+#define KVM_GUEST_PAUSED	  _IO(KVMIO,   0xaa)
> >
> >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1<<  0)
> >
>=20

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsFKAAAoJEKhG9nGc1bpJkKkP/R9ixoEQeJGOdjrZJpl4DlqP
VygkN579YcVsJfg0jfiZP7zn3rBjoyv8ywGBTl1ngZ6v3x7CCMixXm1Xas3pUgpM
/5SwJN8EFlWXlQwVHa9Nu/CMqlmRgi4Gb4pg/f6OgmTLLFoY2gUEthSyf6f0aPRz
Clj/v1zeI7E2DliQemYsVBbAh6wJwW+3xFhBUzrHJriwRGTWO+ZLezeSTV5Sj3lo
1MQhc731Ol96uaGOtrEybB4+1fOeEtIvIgaSx4PIYCeJs7Q9yzbWbBm8CvvLuBM1
LWts+r9JXDVQ41B/n4bHFqdnptKSqhNbFHmo+1fAIB+mmLThavPVfNyzGmOgARWQ
CfbfYpEz5M+iwXW/CYRcymREkkU9+JRxokUB8gcM8p/LbXK1MNe5/G6q/1FlXGot
DSwzCWE92SAgNUU/UlWF4rczzjVuCyswSQnKfUpb2P9jwtUMATx8hz+XSjRofFr+
qnAgmt8AeOXIqNQvey0scZ1aAEXGMmq5+I5XLAFbcFn6SK7Myp6S0soqF5D2O7xL
NluY+HgIK9z+X8yEqDVu9NE3js3VYfTXq1EqJXg0ZmoM/HpN3h9AshQ77R/ZfMw+
8563beQH9IAPJp8jSGtyg5wfrk7pdqevIjLz9lvUCt5czaPX1EDQZ7RfB2qbXkyV
HGFCkKUM/3kksRaBf0Hf
=51vE
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
