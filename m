Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1CUD3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:29:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:32023 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1CUD3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:29:16 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: jbarnes@virtuousgeek.org
Cc: rjw@sisk.pl, mjg59@srcf.ucam.org,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Message-Id: <20110321032510.2353.69194.sendpatchset@nchumbalkar.americas.hpqcorp.net>
In-Reply-To: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
References: <20110321032504.2353.59070.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [RFC][PATCH v3 2/3]: PCI: Changing ASPM policy, via /sys, to POWERSAVE could cause NMIs
Date: Mon, 21 Mar 2011 03:29:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v3 -> v2: Modified the text that describes the problem
v2 -> v1: Returned -EPERM
v1      : http://marc.info/?l=linux-pci&m=130013194803727&w=2

For servers whose hardware cannot handle ASPM the BIOS ought to set the
FADT bit shown below:
In Sec 5.2.9.3 (IA-PC Boot Arch. Flags) of ACPI4.0a Specification, please
see Table 5-11:
PCIe ASPM Controls: If set, indicates to OSPM that it must not enable
OPSM ASPM control on this platform.

However there are shipping servers whose BIOS did not set this bit. (An
example is the HP ProLiant DL385 G6. A Maintenance BIOS will fix that).
For such servers even if a call is made via pci_no_aspm(), based on _OSC
support in the BIOS, it may be too late because the ASPM code may have 
already allocated and filled its "link_list".

So if a user sets the ASPM "policy" to "powersave" via /sys then
pcie_aspm_set_policy() will run through the "link_list" and re-configure
ASPM policy on devices that advertise ASPM L0s/L1 capability:
# echo powersave > /sys/module/pcie_aspm/parameters/policy
# cat /sys/module/pcie_aspm/parameters/policy
default performance [powersave]

That can cause NMIs since the hardware doesn't play well with ASPM:
[ 1651.906015] NMI: PCI system error (SERR) for reason b1 on CPU 0.
[ 1651.906015] Dazed and confused, but trying to continue

Ideally, the BIOS should have set that FADT bit in the first place but we
could be more robust - especially given the fact that Windows doesn't
cause NMIs in the above scenario.

There should be a sanity check to not allow a user to modify ASPM policy
when aspm_disabled is set.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>

---
 drivers/pci/pcie/aspm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index e768620..7ab61ac 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -769,6 +769,8 @@ static int pcie_aspm_set_policy(const char *val, struct kernel_param *kp)
 	int i;
 	struct pcie_link_state *link;
 
+	if (aspm_disabled)
+		return -EPERM;
 	for (i = 0; i < ARRAY_SIZE(policy_str); i++)
 		if (!strncmp(val, policy_str[i], strlen(policy_str[i])))
 			break;
@@ -823,6 +825,8 @@ static ssize_t link_state_store(struct device *dev,
 	struct pcie_link_state *link, *root = pdev->link_state->root;
 	u32 val = buf[0] - '0', state = 0;
 
+	if (aspm_disabled)
+		return -EPERM;
 	if (n < 1 || val > 3)
 		return -EINVAL;
 
-- 
1.7.1.2

