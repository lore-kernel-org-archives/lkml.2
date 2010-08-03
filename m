Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0HCQya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:54:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45057 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149Ab0HCQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:54:28 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Tue, 3 Aug 2010 22:23:45 +0530
Subject: RE: Additional fix : (was [v2]printk: fix delayed messages from CPU
 hotplug events)
Thread-Topic: Additional fix : (was [v2]printk: fix delayed messages from
 CPU hotplug events)
Thread-Index: AcszIA3V0iNm2hToRuGdfHm4WzcbUwAC6xGA
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02C641DD23@dbde02.ent.ti.com>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C5DB6D1F@dbde02.ent.ti.com>
	<20100802154434.5615bcf9.akpm@linux-foundation.org>
	<EAF47CD23C76F840A9E7FCE10091EFAB02C641D8EC@dbde02.ent.ti.com>
 <20100803082456.3b91e7a5.rdunlap@xenotime.net>
In-Reply-To: <20100803082456.3b91e7a5.rdunlap@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641DD23dbde02enttico_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641DD23dbde02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Tuesday, August 03, 2010 8:55 PM
> To: Shilimkar, Santosh
> Cc: Andrew Morton; Kevin Cernekee; linux-kernel@vger.kernel.org; Russell
> King - ARM Linux
> Subject: Re: Additional fix : (was [v2]printk: fix delayed messages from
> CPU hotplug events)
>=20
> On Tue, 3 Aug 2010 13:03:25 +0530 Shilimkar, Santosh wrote:
>=20

<snip>

> >  /**
> > + * console_cpu_notify - print deferred console messages after CPU
> hotplug
> > + *
> > + * If printk() is called from a CPU that is not online yet, the
> messages
> > + * will be spooled but will not show up on the console.  This function
> is
> > + * called when a new CPU comes online and ensures that any such output
> > + * gets printed.
> > + */
> > +static int __cpuinit console_cpu_notify(struct notifier_block *self,
> > +	unsigned long action, void *hcpu)
> > +{
>=20
>=20
> kernel-doc notation should include function parameters also, please.
>=20
Sure. Here is an updated version.
--------------------------------------------
>From 127c0ea58982762ad194f22d1281baaf529c9cbc Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Tue, 3 Aug 2010 12:58:22 +0530
Subject: [PATCH v2] console: flush delayed log messages from cpu-hotplug ev=
ents

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
 kernel/printk.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..c145cef 100644
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
@@ -985,6 +987,43 @@ void resume_console(void)
 }
=20
 /**
+ * console_cpu_notify - print deferred console messages after CPU hotplug
+ * @self: pointer to notfier block
+ * @action: cpu-hotplug events
+ * @hcpu: void poniter to pass any data
+ *
+ * If printk() is called from a CPU that is not online yet, the messages
+ * will be spooled but will not show up on the console.  This function is
+ * called when a new CPU comes online or goes offline and ensures that
+ * any such output gets printed.
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


--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641DD23dbde02enttico_
Content-Type: application/octet-stream;
	name="console-flush-delayed-log-messages-from-cpu-hotplug_v2.patch"
Content-Description: console-flush-delayed-log-messages-from-cpu-hotplug_v2.patch
Content-Disposition: attachment;
	filename="console-flush-delayed-log-messages-from-cpu-hotplug_v2.patch";
	size=2975; creation-date="Tue, 03 Aug 2010 22:24:25 GMT";
	modification-date="Tue, 03 Aug 2010 22:24:25 GMT"
Content-Transfer-Encoding: base64

RnJvbSAxMjdjMGVhNTg5ODI3NjJhZDE5NGYyMmQxMjgxYmFhZjUyOWM5Y2JjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJA
dGkuY29tPgpEYXRlOiBUdWUsIDMgQXVnIDIwMTAgMTI6NTg6MjIgKzA1MzAKU3ViamVjdDogW1BB
VENIIHYyXSBjb25zb2xlOiBmbHVzaCBkZWxheWVkIGxvZyBtZXNzYWdlcyBmcm9tIGNwdS1ob3Rw
bHVnIGV2ZW50cwoKV2hlbiBhIHNlY29uZGFyeSBDUFUgaXMgYmVpbmcgYnJvdWdodCB1cCwgaXQg
aXMgbm90IHVuY29tbW9uIGZvcgpwcmludGsoKSB0byBiZSBpbnZva2VkIHdoZW4gY3B1X29ubGlu
ZShzbXBfcHJvY2Vzc29yX2lkKCkpID09IDAuICBUaGUKY2FzZSB0aGF0IEkgd2l0bmVzc2VkIHBl
cnNvbmFsbHkgd2FzIG9uIE1JUFM6CgpodHRwOi8vbGttbC5vcmcvbGttbC8yMDEwLzUvMzAvNAoK
SWYgKGNhbl91c2VfY29uc29sZSgpID09IDApLCBwcmludGsoKSB3aWxsIHNwb29sIGl0cyBvdXRw
dXQgdG8gbG9nX2J1ZgphbmQgaXQgd2lsbCBiZSB2aXNpYmxlIGluICJkbWVzZyIsIGJ1dCB0aGF0
IG91dHB1dCB3aWxsIE5PVCBiZSBlY2hvZWQgdG8KdGhlIGNvbnNvbGUgdW50aWwgc29tZWJvZHkg
Y2FsbHMgcmVsZWFzZV9jb25zb2xlX3NlbSgpIGZyb20gYSBDUFUgdGhhdAppcyBvbmxpbmUuICBU
aGVyZWZvcmUsIHRoZSBib290IHRpbWUgbWVzc2FnZXMgZnJvbSB0aGUgbmV3IENQVSBjYW4gZ2V0
CnN0dWNrIGluICJsaW1ibyIgZm9yIGEgbG9uZyB0aW1lLCBhbmQgbWlnaHQgc3VkZGVubHkgYXBw
ZWFyIG9uIHRoZQpzY3JlZW4gd2hlbiBhIGNvbXBsZXRlbHkgdW5yZWxhdGVkIGV2ZW50IChlLmcu
ICJldGgwOiBsaW5rIGlzIGRvd24iKQpvY2N1cnMuCgpUaGlzIHBhdGNoIG1vZGlmaWVzIHRoZSBj
b25zb2xlIGNvZGUgc28gdGhhdCBhbnkgcGVuZGluZyBtZXNzYWdlcyBhcmUKYXV0b21hdGljYWxs
eSBmbHVzaGVkIG91dCB0byB0aGUgY29uc29sZSB3aGVuZXZlciBhIENQVSBob3RwbHVnCm9wZXJh
dGlvbiBjb21wbGV0ZXMgc3VjY2Vzc2Z1bGx5IG9yIGFib3J0cy4KVGhpcyBpcyB0cnVlIGV2ZW4g
d2hlbiBDUFUgaXMgZ2V0dGluZyBob3QtcGx1Z2dlZCBvdXQob2ZmbGluZSkgc28KbmVlZCB0byBh
ZGQgYWRkaXRpb25hbCBob3RwbHVnIGV2ZW50cy4KClRoZSBpc3N1ZSB3YXMgc2VlbiBvbiAyLjYu
MzQuCgpTaWduZWQtb2ZmLWJ5OiBTYW50b3NoIFNoaWxpbWthciA8c2FudG9zaC5zaGlsaW1rYXJA
dGkuY29tPgpTaWduZWQtb2ZmLWJ5OiBLZXZpbiBDZXJuZWtlZSA8Y2VybmVrZWVAZ21haWwuY29t
PgotLS0KIGtlcm5lbC9wcmludGsuYyB8ICAgMzkgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDM5IGluc2VydGlvbnMoKyksIDAgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3ByaW50ay5jIGIva2VybmVsL3ByaW50ay5jCmlu
ZGV4IDQ0NGI3NzAuLmMxNDVjZWYgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9wcmludGsuYworKysgYi9r
ZXJuZWwvcHJpbnRrLmMKQEAgLTM3LDYgKzM3LDggQEAKICNpbmNsdWRlIDxsaW51eC9yYXRlbGlt
aXQuaD4KICNpbmNsdWRlIDxsaW51eC9rbXNnX2R1bXAuaD4KICNpbmNsdWRlIDxsaW51eC9zeXNs
b2cuaD4KKyNpbmNsdWRlIDxsaW51eC9jcHUuaD4KKyNpbmNsdWRlIDxsaW51eC9ub3RpZmllci5o
PgogCiAjaW5jbHVkZSA8YXNtL3VhY2Nlc3MuaD4KIApAQCAtOTg1LDYgKzk4Nyw0MyBAQCB2b2lk
IHJlc3VtZV9jb25zb2xlKHZvaWQpCiB9CiAKIC8qKgorICogY29uc29sZV9jcHVfbm90aWZ5IC0g
cHJpbnQgZGVmZXJyZWQgY29uc29sZSBtZXNzYWdlcyBhZnRlciBDUFUgaG90cGx1ZworICogQHNl
bGY6IHBvaW50ZXIgdG8gbm90ZmllciBibG9jaworICogQGFjdGlvbjogY3B1LWhvdHBsdWcgZXZl
bnRzCisgKiBAaGNwdTogdm9pZCBwb25pdGVyIHRvIHBhc3MgYW55IGRhdGEKKyAqCisgKiBJZiBw
cmludGsoKSBpcyBjYWxsZWQgZnJvbSBhIENQVSB0aGF0IGlzIG5vdCBvbmxpbmUgeWV0LCB0aGUg
bWVzc2FnZXMKKyAqIHdpbGwgYmUgc3Bvb2xlZCBidXQgd2lsbCBub3Qgc2hvdyB1cCBvbiB0aGUg
Y29uc29sZS4gIFRoaXMgZnVuY3Rpb24gaXMKKyAqIGNhbGxlZCB3aGVuIGEgbmV3IENQVSBjb21l
cyBvbmxpbmUgb3IgZ29lcyBvZmZsaW5lIGFuZCBlbnN1cmVzIHRoYXQKKyAqIGFueSBzdWNoIG91
dHB1dCBnZXRzIHByaW50ZWQuCisgKi8KK3N0YXRpYyBpbnQgX19jcHVpbml0IGNvbnNvbGVfY3B1
X25vdGlmeShzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKnNlbGYsCisJdW5zaWduZWQgbG9uZyBhY3Rp
b24sIHZvaWQgKmhjcHUpCit7CisJc3dpdGNoIChhY3Rpb24pIHsKKwljYXNlIENQVV9PTkxJTkU6
CisJY2FzZSBDUFVfREVBRDoKKwljYXNlIENQVV9EWUlORzoKKwljYXNlIENQVV9ET1dOX0ZBSUxF
RDoKKwljYXNlIENQVV9VUF9DQU5DRUxFRDoKKwkJaWYgKHRyeV9hY3F1aXJlX2NvbnNvbGVfc2Vt
KCkgPT0gMCkKKwkJCXJlbGVhc2VfY29uc29sZV9zZW0oKTsKKwl9CisJcmV0dXJuIE5PVElGWV9P
SzsKK30KKworc3RhdGljIHN0cnVjdCBub3RpZmllcl9ibG9jayBfX2NwdWluaXRkYXRhIGNvbnNv
bGVfbmIgPSB7CisJLm5vdGlmaWVyX2NhbGwJCT0gY29uc29sZV9jcHVfbm90aWZ5LAorfTsKKwor
c3RhdGljIGludCBfX2luaXQgY29uc29sZV9ub3RpZmllcl9pbml0KHZvaWQpCit7CisJcmVnaXN0
ZXJfY3B1X25vdGlmaWVyKCZjb25zb2xlX25iKTsKKwlyZXR1cm4gMDsKK30KK2xhdGVfaW5pdGNh
bGwoY29uc29sZV9ub3RpZmllcl9pbml0KTsKKworLyoqCiAgKiBhY3F1aXJlX2NvbnNvbGVfc2Vt
IC0gbG9jayB0aGUgY29uc29sZSBzeXN0ZW0gZm9yIGV4Y2x1c2l2ZSB1c2UuCiAgKgogICogQWNx
dWlyZXMgYSBzZW1hcGhvcmUgd2hpY2ggZ3VhcmFudGVlcyB0aGF0IHRoZSBjYWxsZXIgaGFzCi0t
IAoxLjYuMC40Cgo=

--_002_EAF47CD23C76F840A9E7FCE10091EFAB02C641DD23dbde02enttico_--
