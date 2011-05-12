Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1ELNhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:37:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab1ELNg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:content-type:x-mailer:message-id
         :mime-version;
        b=hjj6MqO4edb791Yt7p0QZGDqWmFY2X7nENnf9yDRJRrFiDRVQLPgWuZaNJycqQZMs2
         q7xTalk7FJvktjO+TARv7c38p7P4HnkcnLMMkzjbPMYefMxnAaDNUJKy5fzZs/gyUhsx
         NA+UPNt3Nd1K1Qtle+mJF7vph9sjcbiopzVEI=
Subject: [PATCH] kvm: log directly from the guest to the host kvm buffer
From: Dhaval Giani <dhaval.giani@gmail.com>
To: kvm@vger.kernel.org, joro@8bytes.org, agraf@suse.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 12 May 2011 15:36:44 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GGRwtOy/krIvDrdSmGGS"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Message-ID: <1305207413.18715.3.camel@gondor.retis>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GGRwtOy/krIvDrdSmGGS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

As part of some of the work for my project, I have been looking at
tracing some of the events in the guest from inside the host. In
my usecase, I have been looking to co-relate the time of a network
packet arrival with that in the host. ftrace makes such arbitrary
use quite simple, so I went ahead an extended this functionality
in terms of a hypercall. There are still a few issues with this patch.

1. For some reason, the first time the hypercall is called, it works
just fine, but the second invocation refuses to happen. I am still
clueless about it. (and am looking for hints :-) )
2. I am not very sure if I got the demarcation between the guest and
the host code fine or not. Someone more experienced than me should take
a look at the code as well :-)
3. This adds a new paravirt call.
4. This has been implemented just for x86 as of now. If there is enough
interest, I will look to make it more generic to be used across other
architectures. However, it is quite easy to do the same.
5. It still does not have all the fancy ftrace features, but again,
depending on the interest, I can add all those in.
6. Create a config option for this feature.

I think such a feature is useful for debugging purposes and might make
sense to carry upstream.

Thanks,
Dhaval

---
kvm: log directly from the guest to the host kvm buffer

Add a new hypercall kvm_pv_ftrace() which logs in the host's
ftrace buffer. To use, the caller should use the kvm_ftrace
macro in the guest. This is still very early code and does not fully
work.

Signed-off-by: Dhaval Giani <dhaval.giani@gmail.com>

---
 arch/x86/include/asm/kvm_para.h |   11 +++++++++++
 arch/x86/kernel/kvm.c           |   22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   18 ++++++++++++++++++
 include/linux/kvm_para.h        |    1 +
 4 files changed, 52 insertions(+)

Index: linux-2.6/arch/x86/kvm/x86.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/kvm/x86.c
+++ linux-2.6/arch/x86/kvm/x86.c
@@ -4832,6 +4832,21 @@ int kvm_hv_hypercall(struct kvm_vcpu *vc
 	return 1;
 }
=20
+int kvm_pv_ftrace(struct kvm_vcpu *vcpu, unsigned long ip, gpa_t addr)
+{
+	int ret;
+	char *fmt =3D (char *) kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	ret =3D kvm_read_guest(vcpu->kvm, addr, fmt, PAGE_SIZE);
+
+	trace_printk("KVM instance %p: VCPU %d, IP %lu: %s",
+				vcpu->kvm, vcpu->vcpu_id, ip, fmt);
+
+	kfree(fmt);
+
+	return 0;
+}
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -4868,6 +4883,9 @@ int kvm_emulate_hypercall(struct kvm_vcp
 	case KVM_HC_MMU_OP:
 		r =3D kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
 		break;
+	case KVM_HC_FTRACE:
+		ret =3D kvm_pv_ftrace_printk(vcpu, a0, hc_gpa(vcpu, a1, a2));
+		break;
 	default:
 		ret =3D -KVM_ENOSYS;
 		break;
Index: linux-2.6/include/linux/kvm_para.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/linux/kvm_para.h
+++ linux-2.6/include/linux/kvm_para.h
@@ -19,6 +19,7 @@
 #define KVM_HC_MMU_OP			2
 #define KVM_HC_FEATURES			3
 #define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_FTRACE			5
=20
 /*
  * hypercalls use architecture specific
Index: linux-2.6/arch/x86/kernel/kvm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/kernel/kvm.c
+++ linux-2.6/arch/x86/kernel/kvm.c
@@ -274,6 +274,28 @@ static void kvm_mmu_op(void *buffer, uns
 	} while (len);
 }
=20
+int kvm_ftrace_printk(unsigned long ip, const char *fmt, ...)
+{
+	char *buffer =3D kzalloc(PAGE_SIZE, GFP_KERNEL);
+	int ret;
+	unsigned long a1, a2;
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i =3D vsnprintf(buffer, PAGE_SIZE, fmt, args);
+	va_end(args);
+
+	a1 =3D __pa(buffer);
+	a2 =3D 0;
+
+	ret =3D kvm_hypercall3(KVM_HC_FTRACE, ip, a1, a2);
+
+	kfree(buffer);
+	return ret;
+}
+EXPORT_SYMBOL(kvm_ftrace_printk);
+
 static void mmu_queue_flush(struct kvm_para_state *state)
 {
 	if (state->mmu_queue_len) {
Index: linux-2.6/arch/x86/include/asm/kvm_para.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/include/asm/kvm_para.h
+++ linux-2.6/arch/x86/include/asm/kvm_para.h
@@ -21,6 +21,10 @@
  */
 #define KVM_FEATURE_CLOCKSOURCE2        3
 #define KVM_FEATURE_ASYNC_PF		4
+/*
+ * Right now an experiment, hopefully it works
+ */
+#define KVM_FEATURE_FTRACE		5
=20
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -188,6 +192,13 @@ static inline u32 kvm_read_and_reset_pf_
 }
 #endif
=20
+int kvm_ftrace_printk(unsigned long ip, const char *fmt, ...);
+
+#define kvm_ftrace(fmt, args...)				\
+	do {							\
+		kvm_ftrace_printk(_THIS_IP_, fmt, ##args);	\
+	} while(0)
+
 #endif /* __KERNEL__ */
=20
 #endif /* _ASM_X86_KVM_PARA_H */


--=-GGRwtOy/krIvDrdSmGGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJNy+JsAAoJEFbfuAfUWC1YP9EP/0JLId0kj24iX/nKVjGggmiz
/KAEo5N+Cx5WbkujEbfEFU45d+Gjky+2tjl24pztAc/Fq/zgKmuc7qJN2lzllw30
PcpmAZB49G3cLGdPSq4yFh0YQtarpDdr62aqu6H4HXqRLEh3aMhwtnLYNw77guDl
WvObxQiAYCTNyGJX2IaRvyQIcvu4TYOSEjKRFSYoX6cOlU4X2EgFp3HdLevtgy4p
bUyZ3AvVhG38Wj7CoDdnoplgV+B8Y4a62Gq/XajcmA60xcO2oF4s7QvDPthRLWuw
ZRCvzMZRxShvKBpOxfsvKA505xVFVPH54Qsi9N2Q4/YST02PmiS2yD8h+Uq554Tv
qe7DUKl5fFcffUGZkie+hg8S97GxUSgpQlF20qG97ORdXWfD6/AY/ISQ+q6jy9Ro
Np6+yRCid1A5rqNuV+EDWDvCWxi0Q8qlQcGRYnHV0ELEnsAlUY3Ku3X7phKAS/yC
51qe8rK+/lW6ht0iQIx4sy4Z8fiWNkdOpLj0PIKn9mjD0XnSvvZi4K0XlnCqDM9F
4xAk+xCf0NPpptZU6dBzNOk25ZJRUxKZboiZid97cad4dYJ/uZJK35kK+JRJCxal
tlBEb8K8dyobcEfzG4p5YfFwvFxXlyLNAUuppq0YQNPzrNF5pa+vAxThS2o1AXA0
+yi4fMOJKZpOpZgWNXnC
=xnoD
-----END PGP SIGNATURE-----

--=-GGRwtOy/krIvDrdSmGGS--

