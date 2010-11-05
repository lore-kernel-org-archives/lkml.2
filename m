Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0KEGnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 02:43:35 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:60740 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751582Ab0KEGne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 02:43:34 -0400
Message-ID: <20101105064332.1678.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
To: linuxppc-dev@lists.ozlabs.org
Date: Fri, 5 Nov 2010 01:43:32 -0500 (GMT+5)
Cc: segher@kernel.crashing.org (Segher Boessenkool),
        linux-kernel@vger.kernel.org
In-Reply-To: <53195.84.105.60.153.1288311394.squirrel@gate.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool writes:
> 
> > Now I'm just trying to find the more correct way of doing it, without
> > hardcoded addresses. That'll be something like this:
> >
> >   search the device tree for OHCI nodes
> >   for each OHCI node
> >     get assigned-addresses
> >     map-in
> >     set HCR
> >     wait for acknowledgement
> >     map-out
 
> Sounds like it should work, yes.
> 

I have a mostly-finished patch to do the above. I'll include it below, but
first a few words about why it's only mostly finished.

The other Pegasos workarounds are in fixup_device_tree_chrp, and I don't see
anything like an "if(machine_is_pegasos)" around them. What keeps them from
being erroneously run on other CHRP-type machines? I made this patch mainly
by copying pieces of other functions from prom_init.c, but couldn't find the
"test for Pegasos before running a Pegasos workaround" piece.

Another issue is, since the firmware doesn't give me a "compatible" property
with the details of the controller, I just have to assume that it's
little-endian. I'm not sure if that's clean, since the real ohci driver
supports both endiannesses, with at least 3 different Kconfig options(!) to
choose between them.

Then there's the volatile which I guess is supposed to be replaced by
something else, but I don't know what the something else is. I believe this
usage is extremely close to what volatile was meant for.

Finally, when I updated to a more recent upstream kernel to test the patch, I
found that an intervening commit (3df7169e73fc1d71a39cffeacc969f6840cdf52b,
OHCI: work around for nVidia shutdown problem) has had a major effect,
on the appearance of my bug.

Before that change, the window in which the bug could strike was from the end
of prom_init (when the kernel believes that devices are quiescent) to the
initialization of the ohci-hcd driver (which actually quietens the device, or
at least directs its scribbling to a properly allocated page). After the
change, the window ends at some point early in the PCI bus setup. That's a
window so small that with a new kernel, I can't provoke a symptom even if I
try.

Mostly-finished patch:

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 941ff4d..a14f21b 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2237,6 +2237,81 @@ static void __init fixup_device_tree_chrp(void)
 		}
 	}
 }
+
+/*
+ * Pegasos firmware doesn't quiesce OHCI controllers, so do it manually
+ */
+static void __init pegasos_quiesce(void)
+{
+	phandle node, parent_node;
+	ihandle parent_ih;
+	int rc;
+	char type[16], *path;
+	u32 prop[5], map_size;
+	prom_arg_t ohci_virt;
+
+	for (node = 0; prom_next_node(&node); ) {
+		memset(type, 0, sizeof(type));
+		prom_getprop(node, "device_type", type, sizeof(type));
+		if (strcmp(type, RELOC("usb")) != 0)
+			continue;
+
+		/* Parent should be a PCI bus (so class-code makes sense).
+		   class-code should be 0x0C0310 */
+		parent_node = call_prom("parent", 1, 1, node);
+		if (!parent_node)
+			continue;
+		rc = prom_getprop(node, "class-code", prop, sizeof(u32));
+		if (rc != sizeof(u32) || prop[0] != 0x0c0310)
+			continue;
+
+		rc = prom_getprop(node, "assigned-addresses",
+				  prop, 5*sizeof(u32));
+		if (rc != 5*sizeof(u32))
+			continue;
+
+		/* Open the parent and call map-in */
+
+		/* It seems OF doesn't null-terminate the path :-( */
+		path = RELOC(prom_scratch);
+		memset(path, 0, PROM_SCRATCH_SIZE);
+
+		if (call_prom("package-to-path", 3, 1, parent_node,
+			      path, PROM_SCRATCH_SIZE-1) == PROM_ERROR)
+			continue;
+		parent_ih = call_prom("open", 1, 1, path);
+
+		/* Get the OHCI node's pathname, for printing later */
+		memset(path, 0, PROM_SCRATCH_SIZE);
+		call_prom("package-to-path", 3, 1, node,
+			  path, PROM_SCRATCH_SIZE-1);
+
+		map_size = prop[4];
+		if (call_prom_ret("call-method", 6, 2, &ohci_virt,
+				  ADDR("map-in"), parent_ih,
+				  map_size, prop[0], prop[1], prop[2]) == 0) {
+			prom_printf("resetting OHCI device %s...", path);
+
+			/* Set HostControllerReset (==1) in HcCommandStatus,
+			 * located at offset 8 in the register area. The <<24
+			 * is because the CPU is big-endian and the device is
+			 * little-endian. */
+			*(volatile u32 *)(ohci_virt + 8) |= (1<<24);
+
+			/* controller should acknowledge by zeroing the bit
+			 * within 10us. waiting 1ms should be plenty. */
+			call_prom("interpret", 1, 1, "1 ms");
+			if (*(volatile u32 *)(ohci_virt + 8) & (1<<24))
+				prom_printf("failed\n");
+			else
+				prom_printf("done\n");
+
+			call_prom("call-method", 4, 1, ADDR("map-out"),
+				  parent_ih, map_size, ohci_virt);
+		}
+		call_prom("close", 1, 0, parent_ih);
+	}
+}
 #else
 #define fixup_device_tree_chrp()
 #endif
@@ -2642,6 +2717,7 @@ unsigned long __init prom_init(unsigned long r3, unsigned long r4,
 	 * devices etc...
 	 */
 	prom_printf("Calling quiesce...\n");
+	pegasos_quiesce();
 	call_prom("quiesce", 0, 0);
 
 	/*

-- 
Alan Curry
