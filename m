Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1DFVQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:16:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34078 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab1DFVQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type;
        b=b7Rv+b/56+sdLyGcXWMrDiERloYLeMSvRabD9shK0N1FAa1VUdyGUESt/0pBKbc7Vm
         dwGdIvp/tzV4pWs+w+/buN/4mRBkH6ppFftekDOYUIdWky2NAqAXoGMVNxSWTQYdu0Yz
         G3flc1/AKRy+/Bzx0WIFSBnuuD2V0htUoayXc=
Date: Thu, 7 Apr 2011 00:18:37 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] um: x86: unbreak build by reintroducing
 this_cpu_cmpxchg16b_emu
Message-ID: <20110407001837.12e6f01c@sf.home>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ny9MwLaR9EtgbIi4WWPXtqr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ny9MwLaR9EtgbIi4WWPXtqr
Content-Type: multipart/mixed; boundary="MP_/Wyi1zXQ2o+_Y3x+fDwvHPFe"

--MP_/Wyi1zXQ2o+_Y3x+fDwvHPFe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I'm sure fix can be nices, but initial patch should express an idea.

The main offender is privileged 'cli'.

Thanks!

--=20

  Sergei

--MP_/Wyi1zXQ2o+_Y3x+fDwvHPFe
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename=0001-RFC-um-x86-unbreak-build-by-reintroducing-this_cpu_c.patch

=46rom 59c59c76b0238ff2469bb7f4201b9b88ec436df4 Mon Sep 17 00:00:00 2001
From: Sergei Trofimovich <slyfox@gentoo.org>
Date: Thu, 7 Apr 2011 00:09:37 +0300
Subject: [PATCH] [RFC] um: x86: unbreak build by reintroducing this_cpu_cmp=
xchg16b_emu

  LD      .tmp_vmlinux1
mm/built-in.o: In function `slab_free':
/home/slyfox/linux-2.6/mm/slub.c:2148: undefined reference to `this_cpu_cmp=
xchg16b_emu'
/home/slyfox/linux-2.6/mm/slub.c:2148: undefined reference to `this_cpu_cmp=
xchg16b_emu'
mm/built-in.o: In function `slab_alloc':
/home/slyfox/linux-2.6/mm/slub.c:1943: undefined reference to `this_cpu_cmp=
xchg16b_emu'
/home/slyfox/linux-2.6/mm/slub.c:1943: undefined reference to `this_cpu_cmp=
xchg16b_emu'
/home/slyfox/linux-2.6/mm/slub.c:1943: undefined reference to `this_cpu_cmp=
xchg16b_emu'

Original implementation of this_cpu_cmpxchg16b_emu contained privileged 'cl=
i' instruction
so copied implementation to private um/ space. Tested on x86_64, untested o=
n i386.

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 arch/um/sys-i386/Makefile              |    2 +-
 arch/um/sys-i386/cmpxchg8b_emu_um.S    |   56 ++++++++++++++++++++++++++++
 arch/um/sys-x86_64/Makefile            |    2 +-
 arch/um/sys-x86_64/cmpxchg16b_emu_um.S |   64 ++++++++++++++++++++++++++++=
++++
 4 files changed, 122 insertions(+), 2 deletions(-)
 create mode 100644 arch/um/sys-i386/cmpxchg8b_emu_um.S
 create mode 100644 arch/um/sys-x86_64/cmpxchg16b_emu_um.S

diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 804b28d..40d7940 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
=20
 obj-y =3D bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o
+	sys_call_table.o tls.o cmpxchg8b_emu_um.o
=20
 obj-$(CONFIG_BINFMT_ELF) +=3D elfcore.o
=20
diff --git a/arch/um/sys-i386/cmpxchg8b_emu_um.S b/arch/um/sys-i386/cmpxchg=
8b_emu_um.S
new file mode 100644
index 0000000..b2f0d5f
--- /dev/null
+++ b/arch/um/sys-i386/cmpxchg8b_emu_um.S
@@ -0,0 +1,56 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+
+.text
+
+/*
+ * Inputs:
+ * %esi : memory location to compare
+ * %eax : low 32 bits of old value
+ * %edx : high 32 bits of old value
+ * %ebx : low 32 bits of new value
+ * %ecx : high 32 bits of new value
+ */
+ENTRY(cmpxchg8b_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg8b (%esi)' on UP except we don't
+# set the whole ZF thing (caller will just compare
+# eax:edx with the expected value)
+#
+cmpxchg8b_emu:
+	pushfl
+
+	cmpl  (%esi), %eax
+	jne not_same
+	cmpl 4(%esi), %edx
+	jne half_same
+
+	movl %ebx,  (%esi)
+	movl %ecx, 4(%esi)
+
+	popfl
+	ret
+
+ not_same:
+	movl  (%esi), %eax
+ half_same:
+	movl 4(%esi), %edx
+
+	popfl
+	ret
+
+CFI_ENDPROC
+ENDPROC(cmpxchg8b_emu)
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index c1ea9eb..3259f54 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -6,7 +6,7 @@
=20
 obj-y =3D bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
-	sysrq.o ksyms.o tls.o
+	sysrq.o ksyms.o tls.o cmpxchg16b_emu_um.o
=20
 subarch-obj-y =3D lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
 		lib/rwsem_64.o
diff --git a/arch/um/sys-x86_64/cmpxchg16b_emu_um.S b/arch/um/sys-x86_64/cm=
pxchg16b_emu_um.S
new file mode 100644
index 0000000..e954084
--- /dev/null
+++ b/arch/um/sys-x86_64/cmpxchg16b_emu_um.S
@@ -0,0 +1,64 @@
+/*
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; version 2
+ *	of the License.
+ *
+ */
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+#ifdef CONFIG_SMP
+#define SEG_PREFIX %gs:
+#else
+#define SEG_PREFIX
+#endif
+
+.text
+
+/*
+ * Inputs:
+ * %rsi : memory location to compare
+ * %rax : low 64 bits of old value
+ * %rdx : high 64 bits of old value
+ * %rbx : low 64 bits of new value
+ * %rcx : high 64 bits of new value
+ * %al  : Operation successful
+ */
+ENTRY(this_cpu_cmpxchg16b_emu)
+CFI_STARTPROC
+
+#
+# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in %al not
+# via the ZF.  Caller will access %al to get result.
+#
+# Note that this is only useful for a cpuops operation.  Meaning that we
+# do *not* have a fully atomic operation but just an operation that is
+# *atomic* on a single cpu (as provided by the this_cpu_xx class of
+# macros).
+#
+this_cpu_cmpxchg16b_emu:
+	pushf
+
+	cmpq SEG_PREFIX(%rsi), %rax
+	jne not_same
+	cmpq SEG_PREFIX 8(%rsi), %rdx
+	jne not_same
+
+	movq %rbx, SEG_PREFIX(%rsi)
+	movq %rcx, SEG_PREFIX 8(%rsi)
+
+	popf
+	mov $1, %al
+	ret
+
+ not_same:
+	popf
+	xor %al,%al
+	ret
+
+CFI_ENDPROC
+
+ENDPROC(this_cpu_cmpxchg16b_emu)
--=20
1.7.3.4


--MP_/Wyi1zXQ2o+_Y3x+fDwvHPFe--

--Sig_/Ny9MwLaR9EtgbIi4WWPXtqr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2c2LIACgkQcaHudmEf86qRhQCfT8B9w2mjLnr1UHHQJmszDu3t
kEgAmwQgmWlp1h93+qhN1W6fZQ4J1yA7
=vlgw
-----END PGP SIGNATURE-----

--Sig_/Ny9MwLaR9EtgbIi4WWPXtqr--
