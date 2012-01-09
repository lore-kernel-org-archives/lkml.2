Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2AIBAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:00:50 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab2AIBAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:00:49 -0500
Message-ID: <4F0A3C3B.5090700@nod.at>
Date: Mon, 09 Jan 2012 02:00:43 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: gregkh@suse.de,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>
Subject: Is register_cpu() now obligatory?
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig648D3EF883DA5453A5566490"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig648D3EF883DA5453A5566490
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

In Linus' tree as of today UML is broken.
It's crashing because get_cpu_device() in topology_add_dev()
returns a device with an invalid kobj (address is 0x10).

The code seems to assume that each arch has to register their CPUs
using register_cpu().

Is this a regression or was UML always faulty because it did not register=
 it's CPU?

The below patch fixes the issue for UML.

Thanks,
//richard

---
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index bc49474..f3b43fe 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -12,7 +12,7 @@ clean-files :=3D
 obj-y =3D config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
 	physmem.o process.o ptrace.o reboot.o sigio.o \
 	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
-	um_arch.o umid.o skas/
+	um_arch.o umid.o cpu.o skas/

 obj-$(CONFIG_BLK_DEV_INITRD) +=3D initrd.o
 obj-$(CONFIG_GPROF)	+=3D gprof_syms.o
diff --git a/arch/um/kernel/cpu.c b/arch/um/kernel/cpu.c
new file mode 100644
index 0000000..4914df2
--- /dev/null
+++ b/arch/um/kernel/cpu.c
@@ -0,0 +1,19 @@
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/cpu.h>
+#include <linux/percpu.h>
+
+static DEFINE_PER_CPU(struct cpu, cpu_devices);
+
+static int __init topology_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct cpu *c =3D &per_cpu(cpu_devices, cpu);
+		register_cpu(c, cpu);
+	}
+
+	return 0;
+}
+subsys_initcall(topology_init);


--------------enig648D3EF883DA5453A5566490
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPCjw8AAoJEN9758yqZn9e3tMH/0aXUfT06226inujKrm8kP4m
iJrh0iEg3GjoOG/boP3NmFtmXOTsRYzXaH2SxIykq7InJfL+zO9KbGTLcbegkTni
vGVCIeEH6NYrZIW1oi5aq4jRj3//riHImkb/mOwGI4WHOdAQbVq0+t1NKwCNuiQH
Jt34txyxfDnRvew9T4wbhq4TGA4iB5jqD0BEO9D6C/wKH664cjOKCoNI2qB5BiJk
f/0ONsMT8nXf29CdLCmMgR8KBl5RfPdZkmz3zDVWp71b9mc/3pqJikmfZqBCbLDP
BQYO0LWNlCzy47eFaAEWj3P2+BmBd3mSQcuyU4iqe10Fximij6PcjVzSOd0BQBg=
=eFdJ
-----END PGP SIGNATURE-----

--------------enig648D3EF883DA5453A5566490--
