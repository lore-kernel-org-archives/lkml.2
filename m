Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0LHArJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:09 -0500
Received: from kroah.org ([198.145.64.141]:46042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0LHArE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:04 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.224683861@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Prarit Bhargava <prarit@redhat.com>, bhavna.sarathy@amd.com,
        jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com,
        Ingo Molnar <mingo@elte.hu>, maximilian attems <max@stro.at>
Subject: [039/127] x86: AMD Northbridge: Verify NBs node is online
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 303fc0870f8fbfabe260c5c32b18e53458d597ea upstream.

Fix panic seen on some IBM and HP systems on 2.6.32-rc6:

 BUG: unable to handle kernel NULL pointer dereference at (null)
 IP: [<ffffffff8120bf3f>] find_next_bit+0x77/0x9c
  [...]
  [<ffffffff8120bbde>] cpumask_next_and+0x2e/0x3b
  [<ffffffff81225c62>] pci_device_probe+0x8e/0xf5
  [<ffffffff812b9be6>] ? driver_sysfs_add+0x47/0x6c
  [<ffffffff812b9da5>] driver_probe_device+0xd9/0x1f9
  [<ffffffff812b9f1d>] __driver_attach+0x58/0x7c
  [<ffffffff812b9ec5>] ? __driver_attach+0x0/0x7c
  [<ffffffff812b9298>] bus_for_each_dev+0x54/0x89
  [<ffffffff812b9b4f>] driver_attach+0x19/0x1b
  [<ffffffff812b97ae>] bus_add_driver+0xd3/0x23d
  [<ffffffff812ba1e7>] driver_register+0x98/0x109
  [<ffffffff81225ed0>] __pci_register_driver+0x63/0xd3
  [<ffffffff81072776>] ? up_read+0x26/0x2a
  [<ffffffffa0081000>] ? k8temp_init+0x0/0x20 [k8temp]
  [<ffffffffa008101e>] k8temp_init+0x1e/0x20 [k8temp]
  [<ffffffff8100a073>] do_one_initcall+0x6d/0x185
  [<ffffffff8108d765>] sys_init_module+0xd3/0x236
  [<ffffffff81011ac2>] system_call_fastpath+0x16/0x1b

I put in a printk and commented out the set_dev_node()
call when and got this output:

 quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x0
 quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x1
 quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x2
 quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x3

I.e. the issue appears to be that the HW has set val to a valid
value, however, the system is only configured for a single
node -- 0, the others are offline.

Check to see if the node is actually online before setting
the numa node for an AMD northbridge in quirk_amd_nb_node().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: bhavna.sarathy@amd.com
Cc: jbarnes@virtuousgeek.org
Cc: andreas.herrmann3@amd.com
LKML-Reference: <20091112180933.12532.98685.sendpatchset@prarit.bos.redhat.com>
[ v2: clean up the code and add comments ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/quirks.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -512,6 +512,7 @@ static void __init quirk_amd_nb_node(str
 {
 	struct pci_dev *nb_ht;
 	unsigned int devfn;
+	u32 node;
 	u32 val;
 
 	devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 0);
@@ -520,7 +521,13 @@ static void __init quirk_amd_nb_node(str
 		return;
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
-	set_dev_node(&dev->dev, val & 7);
+	node = val & 7;
+	/*
+	 * Some hardware may return an invalid node ID,
+	 * so check it first:
+	 */
+	if (node_online(node))
+		set_dev_node(&dev->dev, node);
 	pci_dev_put(nb_ht);
 }
 


