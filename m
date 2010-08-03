Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab0HCHeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:34:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42036 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab0HCHeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:34:06 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Tue, 3 Aug 2010 13:03:25 +0530
Subject: RE: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Thread-Topic: Additional fix : (was [v2]printk: fix delayed messages from
 CPU hotplug events)
Thread-Index: AcsylFIglA7ghRZ+SOeN2I36O9G8vQANWtcA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
 <20100802154434.5615bcf9.akpm@linux-foundation.org>
In-Reply-To: <20100802154434.5615bcf9.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641D8ECdbde02enttico_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641D8ECdbde02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thanks Andrew for looking into this.
> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, August 03, 2010 4:15 AM
> To: Shilimkar, Santosh
> Cc: Kevin Cernekee; linux-kernel@vger.kernel.org; Russell King - ARM Linu=
x
> Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from
> CPU hotplug events)
>=20
> On Tue, 29 Jun 2010 14:22:26 +0530
> "Shilimkar, Santosh" <santosh.shilimkar@ti.com> wrote:
>=20
> > Hi,
> >
> > I have faced similar issue as what is being described in below with
> > latest kernel.
> >
> > ------------------------------------------------
> > https://patchwork.kernel.org/patch/103347/
> >
> > When a secondary CPU is being brought up, it is not uncommon for
> > printk() to be invoked when cpu_online(smp_processor_id()) =3D=3D 0.  T=
he
> > case that I witnessed personally was on MIPS:
> >
> > http://lkml.org/lkml/2010/5/30/4
> >
> > If (can_use_console() =3D=3D 0), printk() will spool its output to log_=
buf
> > and it will be visible in "dmesg", but that output will NOT be echoed t=
o
> > the console until somebody calls release_console_sem() from a CPU that
> > is online.  Therefore, the boot time messages from the new CPU can get
> > stuck in "limbo" for a long time, and might suddenly appear on the
> > screen when a completely unrelated event (e.g. "eth0: link is down")
> > occurs.
> >
> > This patch modifies the console code so that any pending messages are
> > automatically flushed out to the console whenever a CPU hotplug
> > operation completes successfully or aborts.
> >
> > -----------------------------------------------
> >
> > Above patch fixes only half of the problem. I mean the cpu online
> > path prints are coming on the console.
> >
> > But similar problem also exist if there are prints in the cpu offline
> > path. I got that fixed by adding below patch on top of you patch.
> >
> > diff --git a/kernel/printk.c b/kernel/printk.c
> > index d370b74..f4d7352 100644
> > --- a/kernel/printk.c
> > +++ b/kernel/printk.c
> > @@ -982,6 +982,9 @@ static int __cpuinit console_cpu_notify(struct
> notifier_bloc
> >         switch (action) {
> >         case CPU_ONLINE:
> >         case CPU_UP_CANCELED:
> > +       case CPU_DEAD:
> > +       case CPU_DYING:
> > +       case CPU_DOWN_FAILED:
> >                 if (try_acquire_console_sem() =3D=3D 0)
> >                         release_console_sem();
> >         }
>=20
> The patch lacked a suitable title.  I called it "console: flush log
> messages for more cpu-hotplug events".
>
This diff was on top of already posted RFC patch. I will combine them

> The patch lacks a Signed-off-by:.  Please send one.
>=20
> The patch has its tabs replaced with spaces.  I fixed that.  Please
> reconfigure your email client for next time.
>=20
> The code which is being patch has changed.  It now does
>=20
>                 acquire_console_sem();
>                 release_console_sem();
>=20
> so the code may no longer work - perhaps it now deadlocks (unlikely).
> Please retest?
Retested. No deadlock observed
>=20
> Finally, I don't understand the patch :( Who is sending out CPU_DEAD,
> CPU_DYING or CPU_DOWN_FAILED events during kernel boot?  I'd have
> thought that those events simply aren't occurring, and that the patch
> has no effect.  Confused - please explain further.
These events can come during the CPU hotplug(offline). Below is the
complete patch. Also attaching it in case some email format screw
up.

-----------------------------------------------
>From b99271ce43cc82cda28447444004933d0f218ee3 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Tue, 3 Aug 2010 12:58:22 +0530
Subject: [PATCH] console: flush delayed log messages from cpu-hotplug event=
s

When a secondary CPU is being brought up, it is not uncommon for
printk() to be invoked when cpu_online(smp_processor_id()) =3D=3D 0.  The
case that I witnessed personally was on MIPS:

http://lkml.org/lkml/2010/5/30/4

If (can_use_console() =3D=3D 0), printk() will spool its output to log_buf
and it will be visible in "dmesg", but that output will NOT be echoed to
the console until somebody calls release_console_sem() from a CPU that
is online.  Therefore, the boot time messages from the new CPU can get
stuck in "limbo" for a long time, and might suddenly appear on the
screen when a completely unrelated event (e.g. "eth0: link is down")
occurs.

This patch modifies the console code so that any pending messages are
automatically flushed out to the console whenever a CPU hotplug
operation completes successfully or aborts.
This is true even when CPU is getting hot-plugged out(offline) so
need to add additional hotplug events.

The issue was seen on 2.6.34.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 kernel/printk.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..a884d81 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -37,6 +37,8 @@
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
=20
 #include <asm/uaccess.h>
=20
@@ -985,6 +987,40 @@ void resume_console(void)
 }
=20
 /**
+ * console_cpu_notify - print deferred console messages after CPU hotplug
+ *
+ * If printk() is called from a CPU that is not online yet, the messages
+ * will be spooled but will not show up on the console.  This function is
+ * called when a new CPU comes online and ensures that any such output
+ * gets printed.
+ */
+static int __cpuinit console_cpu_notify(struct notifier_block *self,
+	unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_DEAD:
+	case CPU_DYING:
+	case CPU_DOWN_FAILED:
+	case CPU_UP_CANCELED:
+		if (try_acquire_console_sem() =3D=3D 0)
+			release_console_sem();
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata console_nb =3D {
+	.notifier_call		=3D console_cpu_notify,
+};
+
+static int __init console_notifier_init(void)
+{
+	register_cpu_notifier(&console_nb);
+	return 0;
+}
+late_initcall(console_notifier_init);
+
+/**
  * acquire_console_sem - lock the console system for exclusive use.
  *
  * Acquires a semaphore which guarantees that the caller has
--=20
1.6.0.4
-----------------------------------------------



--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641D8ECdbde02enttico_
Content-Type: application/octet-stream;
	name="console-flush-delayed-log-messages-from-cpu-hotplug.patch"
Content-Description: console-flush-delayed-log-messages-from-cpu-hotplug.patch
Content-Disposition: attachment;
	filename="console-flush-delayed-log-messages-from-cpu-hotplug.patch";
	size=2844; creation-date="Tue, 03 Aug 2010 13:00:58 GMT";
	modification-date="Tue, 03 Aug 2010 13:00:58 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiOTkyNzFjZTQzY2M4MmNkYTI4NDQ3NDQ0MDA0OTMzZDBmMjE4ZWUzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJA
dGkuY29tPgpEYXRlOiBUdWUsIDMgQXVnIDIwMTAgMTI6NTg6MjIgKzA1MzAKU3ViamVjdDogW1BB
VENIXSBjb25zb2xlOiBmbHVzaCBkZWxheWVkIGxvZyBtZXNzYWdlcyBmcm9tIGNwdS1ob3RwbHVn
IGV2ZW50cwoKV2hlbiBhIHNlY29uZGFyeSBDUFUgaXMgYmVpbmcgYnJvdWdodCB1cCwgaXQgaXMg
bm90IHVuY29tbW9uIGZvcgpwcmludGsoKSB0byBiZSBpbnZva2VkIHdoZW4gY3B1X29ubGluZShz
bXBfcHJvY2Vzc29yX2lkKCkpID09IDAuICBUaGUKY2FzZSB0aGF0IEkgd2l0bmVzc2VkIHBlcnNv
bmFsbHkgd2FzIG9uIE1JUFM6CgpodHRwOi8vbGttbC5vcmcvbGttbC8yMDEwLzUvMzAvNAoKSWYg
KGNhbl91c2VfY29uc29sZSgpID09IDApLCBwcmludGsoKSB3aWxsIHNwb29sIGl0cyBvdXRwdXQg
dG8gbG9nX2J1ZgphbmQgaXQgd2lsbCBiZSB2aXNpYmxlIGluICJkbWVzZyIsIGJ1dCB0aGF0IG91
dHB1dCB3aWxsIE5PVCBiZSBlY2hvZWQgdG8KdGhlIGNvbnNvbGUgdW50aWwgc29tZWJvZHkgY2Fs
bHMgcmVsZWFzZV9jb25zb2xlX3NlbSgpIGZyb20gYSBDUFUgdGhhdAppcyBvbmxpbmUuICBUaGVy
ZWZvcmUsIHRoZSBib290IHRpbWUgbWVzc2FnZXMgZnJvbSB0aGUgbmV3IENQVSBjYW4gZ2V0CnN0
dWNrIGluICJsaW1ibyIgZm9yIGEgbG9uZyB0aW1lLCBhbmQgbWlnaHQgc3VkZGVubHkgYXBwZWFy
IG9uIHRoZQpzY3JlZW4gd2hlbiBhIGNvbXBsZXRlbHkgdW5yZWxhdGVkIGV2ZW50IChlLmcuICJl
dGgwOiBsaW5rIGlzIGRvd24iKQpvY2N1cnMuCgpUaGlzIHBhdGNoIG1vZGlmaWVzIHRoZSBjb25z
b2xlIGNvZGUgc28gdGhhdCBhbnkgcGVuZGluZyBtZXNzYWdlcyBhcmUKYXV0b21hdGljYWxseSBm
bHVzaGVkIG91dCB0byB0aGUgY29uc29sZSB3aGVuZXZlciBhIENQVSBob3RwbHVnCm9wZXJhdGlv
biBjb21wbGV0ZXMgc3VjY2Vzc2Z1bGx5IG9yIGFib3J0cy4KVGhpcyBpcyB0cnVlIGV2ZW4gd2hl
biBDUFUgaXMgZ2V0dGluZyBob3QtcGx1Z2dlZCBvdXQob2ZmbGluZSkgc28KbmVlZCB0byBhZGQg
YWRkaXRpb25hbCBob3RwbHVnIGV2ZW50cy4KClRoZSBpc3N1ZSB3YXMgc2VlbiBvbiAyLjYuMzQu
CgpTaWduZWQtb2ZmLWJ5OiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJAdGku
Y29tPgpTaWduZWQtb2ZmLWJ5OiBLZXZpbiBDZXJuZWtlZSA8Y2VybmVrZWVAZ21haWwuY29tPgot
LS0KIGtlcm5lbC9wcmludGsuYyB8ICAgMzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay5jIGIva2VybmVsL3ByaW50ay5jCmluZGV4IDQ0
NGI3NzAuLmE4ODRkODEgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9wcmludGsuYworKysgYi9rZXJuZWwv
cHJpbnRrLmMKQEAgLTM3LDYgKzM3LDggQEAKICNpbmNsdWRlIDxsaW51eC9yYXRlbGltaXQuaD4K
ICNpbmNsdWRlIDxsaW51eC9rbXNnX2R1bXAuaD4KICNpbmNsdWRlIDxsaW51eC9zeXNsb2cuaD4K
KyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KKyNpbmNsdWRlIDxsaW51eC9ub3RpZmllci5oPgogCiAj
aW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4KIApAQCAtOTg1LDYgKzk4Nyw0MCBAQCB2b2lkIHJlc3Vt
ZV9jb25zb2xlKHZvaWQpCiB9CiAKIC8qKgorICogY29uc29sZV9jcHVfbm90aWZ5IC0gcHJpbnQg
ZGVmZXJyZWQgY29uc29sZSBtZXNzYWdlcyBhZnRlciBDUFUgaG90cGx1ZworICoKKyAqIElmIHBy
aW50aygpIGlzIGNhbGxlZCBmcm9tIGEgQ1BVIHRoYXQgaXMgbm90IG9ubGluZSB5ZXQsIHRoZSBt
ZXNzYWdlcworICogd2lsbCBiZSBzcG9vbGVkIGJ1dCB3aWxsIG5vdCBzaG93IHVwIG9uIHRoZSBj
b25zb2xlLiAgVGhpcyBmdW5jdGlvbiBpcworICogY2FsbGVkIHdoZW4gYSBuZXcgQ1BVIGNvbWVz
IG9ubGluZSBhbmQgZW5zdXJlcyB0aGF0IGFueSBzdWNoIG91dHB1dAorICogZ2V0cyBwcmludGVk
LgorICovCitzdGF0aWMgaW50IF9fY3B1aW5pdCBjb25zb2xlX2NwdV9ub3RpZnkoc3RydWN0IG5v
dGlmaWVyX2Jsb2NrICpzZWxmLAorCXVuc2lnbmVkIGxvbmcgYWN0aW9uLCB2b2lkICpoY3B1KQor
eworCXN3aXRjaCAoYWN0aW9uKSB7CisJY2FzZSBDUFVfT05MSU5FOgorCWNhc2UgQ1BVX0RFQUQ6
CisJY2FzZSBDUFVfRFlJTkc6CisJY2FzZSBDUFVfRE9XTl9GQUlMRUQ6CisJY2FzZSBDUFVfVVBf
Q0FOQ0VMRUQ6CisJCWlmICh0cnlfYWNxdWlyZV9jb25zb2xlX3NlbSgpID09IDApCisJCQlyZWxl
YXNlX2NvbnNvbGVfc2VtKCk7CisJfQorCXJldHVybiBOT1RJRllfT0s7Cit9CisKK3N0YXRpYyBz
dHJ1Y3Qgbm90aWZpZXJfYmxvY2sgX19jcHVpbml0ZGF0YSBjb25zb2xlX25iID0geworCS5ub3Rp
Zmllcl9jYWxsCQk9IGNvbnNvbGVfY3B1X25vdGlmeSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0
IGNvbnNvbGVfbm90aWZpZXJfaW5pdCh2b2lkKQoreworCXJlZ2lzdGVyX2NwdV9ub3RpZmllcigm
Y29uc29sZV9uYik7CisJcmV0dXJuIDA7Cit9CitsYXRlX2luaXRjYWxsKGNvbnNvbGVfbm90aWZp
ZXJfaW5pdCk7CisKKy8qKgogICogYWNxdWlyZV9jb25zb2xlX3NlbSAtIGxvY2sgdGhlIGNvbnNv
bGUgc3lzdGVtIGZvciBleGNsdXNpdmUgdXNlLgogICoKICAqIEFjcXVpcmVzIGEgc2VtYXBob3Jl
IHdoaWNoIGd1YXJhbnRlZXMgdGhhdCB0aGUgY2FsbGVyIGhhcwotLSAKMS42LjAuNAoK

--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641D8ECdbde02enttico_--
