Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1AXHeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 02:34:19 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41361 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab1AXHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 02:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hGBZu25gHEHwGnATQDhnmpTaRIgFJg2DgLxpJham3QygsQHipfg+LOEs3WCqvWjhHe
         y1TRokMC6JdiqbTtJd25aW8Dp5Og6Bq/UBk055PbYYvJcGu1f4JuwrlC4LiTWTkrd25f
         RdvJh/ZI2ngaNyunP9G9PVaUtiKWkBQEuxjLk=
MIME-Version: 1.0
Date: Mon, 24 Jan 2011 02:34:18 -0500
Message-ID: <AANLkTinaOQpuJis5HgK316ANxpDS8eZ8Q0S4a44POrp0@mail.gmail.com>
Subject: [PATCH] a patch to fix the cpu-offline-online problem caused by pm_idle
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd6ac9caa8fbd049a92a09d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd6ac9caa8fbd049a92a09d
Content-Type: text/plain; charset=UTF-8

Hi there,

I've seen many problems caused by deep-c-state-capable pm_idle on a
NHM-EX system with this test script
# for i in `seq 1 1000`; do echo $i; echo 0 >
/sys/devices/system/cpu/cpu59/online ; sleep 1; echo 1 >
/sys/devices/system/cpu/cpu59/online; done

As the bug " CPU online/offline causes system slowdown"
https://bugzilla.redhat.com/show_bug.cgi?id=586551 described.

The simplest and easiest and cleanest way I can think of now is as the
patch attached.

Signed-off-by: Yu Luming <luming.yu@intel.com>

diff --git a/kernel/cpu.c b/kernel/cpu.c
index c75fcdd..d419eb3 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -135,6 +135,7 @@ int __ref register_cpu_notifier(struct notifier_block *nb)

 #ifdef CONFIG_HOTPLUG_CPU

+static void (*pm_idle_saved) (void) __read_mostly;
 EXPORT_SYMBOL(register_cpu_notifier);

 void __ref unregister_cpu_notifier(struct notifier_block *nb)
@@ -145,6 +146,19 @@ void __ref unregister_cpu_notifier(struct
notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);

+static inline void save_pm_idle(void)
+{
+	pm_idle_saved = pm_idle;
+	pm_idle = default_idle;
+	cpu_idle_wait();
+}
+
+static inline void restore_pm_idle(void)
+{
+	pm_idle = pm_idle_saved;
+	cpu_idle_wait();
+}
+
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
@@ -278,7 +292,9 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}

+	save_pm_idle();
 	err = _cpu_down(cpu, 0);
+	restore_pm_idle();

 out:
 	cpu_maps_update_done();
@@ -376,7 +392,9 @@ int __cpuinit cpu_up(unsigned int cpu)
 		goto out;
 	}

+	save_pm_idle();
 	err = _cpu_up(cpu, 0);
+	restore_pm_idle();

 out:
 	cpu_maps_update_done();

--000e0cd6ac9caa8fbd049a92a09d
Content-Type: application/octet-stream; 
	name="bz586551-using-default-idle.patch"
Content-Disposition: attachment; 
	filename="bz586551-using-default-idle.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjb27f9x0

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jcHUuYyBiL2tlcm5lbC9jcHUuYwppbmRleCBjNzVmY2RkLi5k
NDE5ZWIzIDEwMDY0NAotLS0gYS9rZXJuZWwvY3B1LmMKKysrIGIva2VybmVsL2NwdS5jCkBAIC0x
MzUsNiArMTM1LDcgQEAgaW50IF9fcmVmIHJlZ2lzdGVyX2NwdV9ub3RpZmllcihzdHJ1Y3Qgbm90
aWZpZXJfYmxvY2sgKm5iKQogCiAjaWZkZWYgQ09ORklHX0hPVFBMVUdfQ1BVCiAKK3N0YXRpYyB2
b2lkICgqcG1faWRsZV9zYXZlZCkgKHZvaWQpIF9fcmVhZF9tb3N0bHk7CiBFWFBPUlRfU1lNQk9M
KHJlZ2lzdGVyX2NwdV9ub3RpZmllcik7CiAKIHZvaWQgX19yZWYgdW5yZWdpc3Rlcl9jcHVfbm90
aWZpZXIoc3RydWN0IG5vdGlmaWVyX2Jsb2NrICpuYikKQEAgLTE0NSw2ICsxNDYsMTkgQEAgdm9p
ZCBfX3JlZiB1bnJlZ2lzdGVyX2NwdV9ub3RpZmllcihzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5i
KQogfQogRVhQT1JUX1NZTUJPTCh1bnJlZ2lzdGVyX2NwdV9ub3RpZmllcik7CiAKK3N0YXRpYyBp
bmxpbmUgdm9pZCBzYXZlX3BtX2lkbGUodm9pZCkKK3sKKwlwbV9pZGxlX3NhdmVkID0gcG1faWRs
ZTsKKwlwbV9pZGxlID0gZGVmYXVsdF9pZGxlOworCWNwdV9pZGxlX3dhaXQoKTsKK30KKworc3Rh
dGljIGlubGluZSB2b2lkIHJlc3RvcmVfcG1faWRsZSh2b2lkKQoreworCXBtX2lkbGUgPSBwbV9p
ZGxlX3NhdmVkOworCWNwdV9pZGxlX3dhaXQoKTsKK30KKwogc3RhdGljIGlubGluZSB2b2lkIGNo
ZWNrX2Zvcl90YXNrcyhpbnQgY3B1KQogewogCXN0cnVjdCB0YXNrX3N0cnVjdCAqcDsKQEAgLTI3
OCw3ICsyOTIsOSBAQCBpbnQgX19yZWYgY3B1X2Rvd24odW5zaWduZWQgaW50IGNwdSkKIAkJZ290
byBvdXQ7CiAJfQogCisJc2F2ZV9wbV9pZGxlKCk7CiAJZXJyID0gX2NwdV9kb3duKGNwdSwgMCk7
CisJcmVzdG9yZV9wbV9pZGxlKCk7CiAKIG91dDoKIAljcHVfbWFwc191cGRhdGVfZG9uZSgpOwpA
QCAtMzc2LDcgKzM5Miw5IEBAIGludCBfX2NwdWluaXQgY3B1X3VwKHVuc2lnbmVkIGludCBjcHUp
CiAJCWdvdG8gb3V0OwogCX0KIAorCXNhdmVfcG1faWRsZSgpOwogCWVyciA9IF9jcHVfdXAoY3B1
LCAwKTsKKwlyZXN0b3JlX3BtX2lkbGUoKTsKIAogb3V0OgogCWNwdV9tYXBzX3VwZGF0ZV9kb25l
KCk7Cg==
--000e0cd6ac9caa8fbd049a92a09d--
