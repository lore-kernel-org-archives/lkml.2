Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0LHVg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:36:27 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40756 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0LHVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:22 -0500
Subject: [PATCH 4/5] PNP: add framework for platform PNP quirks
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Wed, 08 Dec 2010 14:36:22 -0700
Message-ID: <20101208213621.13026.87155.stgit@bob.kio>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows platform quirks to fabricate PNP devices to describe things
that should have been described via ACPI.  For example, if the BIOS writer
forgets to describe a device, we may assign its address space to another
device, causing a conflict.  We can avoid the conflict by making a fake PNP
device to stand in for the one the BIOS missed.

In that case, there's no ACPI or PNPBIOS device, so we need a new
pnp_protocol that doesn't go back to firmware for get/set/wakeup/
suspend/etc.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/base.h   |    2 ++
 drivers/pnp/core.c   |    9 ++++++++-
 drivers/pnp/quirks.c |   15 +++++++++++++++
 3 files changed, 25 insertions(+), 1 deletions(-)


diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 19bc736..dca301e 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -7,6 +7,8 @@ extern spinlock_t pnp_lock;
 extern struct device_attribute pnp_interface_attrs[];
 void *pnp_alloc(long size);
 
+void platform_pnp_fixups(void);
+
 int pnp_register_protocol(struct pnp_protocol *protocol);
 void pnp_unregister_protocol(struct pnp_protocol *protocol);
 
diff --git a/drivers/pnp/core.c b/drivers/pnp/core.c
index 0f34d96..5076493 100644
--- a/drivers/pnp/core.c
+++ b/drivers/pnp/core.c
@@ -212,7 +212,14 @@ void __pnp_remove_device(struct pnp_dev *dev)
 
 static int __init pnp_init(void)
 {
-	return bus_register(&pnp_bus_type);
+	int ret;
+
+	ret = bus_register(&pnp_bus_type);
+	if (ret)
+		return ret;
+
+	platform_pnp_fixups();
+	return 0;
 }
 
 subsys_initcall(pnp_init);
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index dfbd5a6..f18bb69 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -15,6 +15,7 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/dmi.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
@@ -337,3 +338,17 @@ void pnp_fixup_device(struct pnp_dev *dev)
 		f->quirk_function(dev);
 	}
 }
+
+static struct pnp_protocol pnp_fixup_protocol = {
+	.name = "Plug and Play fixup",
+};
+
+static const struct dmi_system_id pnp_fixup_table[] __initconst = {
+	{}
+};
+
+void __init platform_pnp_fixups(void)
+{
+	pnp_register_protocol(&pnp_fixup_protocol);
+	dmi_check_system(pnp_fixup_table);
+}

