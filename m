Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0LHVhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:37:14 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2990 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab0LHVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:19 -0500
Subject: [PATCH 3/5] x86: avoid PNP resources when allocating address space
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Dan Williams <dcbw@redhat.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>,
        Matthew Garrett <mjg@redhat.com>
Date: Wed, 08 Dec 2010 14:36:16 -0700
Message-ID: <20101208213616.13026.77390.stgit@bob.kio>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove PNP resources from "available space" used by allocate_resource().
This would be better done by putting the PNP resources directly in the
resource maps (iomem_resource, etc), but there are some issues that
keep us from doing that yet.

This patch keeps us from handing out PNP device address space to other
callers of allocate_resource().

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23332
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23542
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=23802
Reported-by: Matthew Garrett <mjg@redhat.com>
Reported-by: Dan Williams <dcbw@redhat.com>
Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/resource.c |   78 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/resource.c b/arch/x86/kernel/resource.c
index 5dd6473..1daee92 100644
--- a/arch/x86/kernel/resource.c
+++ b/arch/x86/kernel/resource.c
@@ -1,6 +1,80 @@
 #include <linux/ioport.h>
+#include <linux/pnp.h>
 #include <asm/e820.h>
 
+#ifdef CONFIG_PNP
+static bool resource_conflict(struct resource *res, resource_size_t start,
+			      resource_size_t end)
+{
+	/*
+	 * Return true if and only if "res" conflicts with the [start-end]
+	 * range.
+	 */
+	return res->start <= end && res->end >= start;
+}
+
+static void resource_split(struct resource *res, resource_size_t start,
+			   resource_size_t end, struct resource *low,
+			   struct resource *high)
+{
+	/*
+	 * If "res" conflicts with [start-end], split "res" into the
+	 * part below "start" (low) and the part above "end" (high),
+	 * either (or both) of which may be empty.
+	 *
+	 * If there's no conflict, return the entire "res" as "low".
+	 */
+	*low = *res;
+	low->start = res->start;
+	low->end = res->start - 1;	/* default to empty (size 0) */
+
+	*high = *res;
+	high->end = res->end;
+	high->start = res->end + 1;	/* default to empty (size 0) */
+
+	if (!resource_conflict(res, start, end)) {
+		low->end = res->end;
+		return;
+	}
+
+	if (res->start < start)
+		low->end = start - 1;
+
+	if (res->end > end)
+		high->start = end + 1;
+}
+
+static void pnp_remove_reservations(struct resource *avail)
+{
+	unsigned long type = resource_type(avail);
+	struct pnp_dev *dev;
+	int i;
+	struct resource *res, low, high;
+
+	/*
+	 * Clip the available region to avoid PNP devices.  The PNP
+	 * resources really should be in the resource map to begin with,
+	 * but there are still some issues preventing that.
+	 */
+	pnp_for_each_dev(dev) {
+		i = 0;
+		res = pnp_get_resource(dev, type, i++);
+		while (res) {
+			if (!(res->flags & IORESOURCE_WINDOW)) {
+				resource_split(avail, res->start, res->end,
+					       &low, &high);
+				if (resource_size(&low) > resource_size(&high))
+					*avail = low;
+				else
+					*avail = high;
+			}
+
+			res = pnp_get_resource(dev, type, i++);
+		}
+	}
+}
+#endif
+
 void arch_remove_reservations(struct resource *avail)
 {
 	/*
@@ -11,4 +85,8 @@ void arch_remove_reservations(struct resource *avail)
 		if (avail->start < BIOS_END)
 			avail->start = BIOS_END;
 	}
+
+#ifdef CONFIG_PNP
+	pnp_remove_reservations(avail);
+#endif
 }

