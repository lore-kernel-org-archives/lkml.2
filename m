Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0C3XTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:13 -0400
Received: from kroah.org ([198.145.64.141]:45373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932258Ab0C3XSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:43 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:55 2010
Message-Id: <20100330225654.491053211@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dean Nelson <dnelson@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [085/116] PCI: fix access of PCI_X_CMD by pcix get and set mmrbc functions
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dean Nelson <dnelson@redhat.com>

commit bdc2bda7c4dd253026cc1fce45fc939304749029 upstream.

An e1000 driver on a system with a PCI-X bus was always being returned
a value of 135 from both pcix_get_mmrbc() and pcix_set_mmrbc(). This
value reflects an error return of PCIBIOS_BAD_REGISTER_NUMBER from
pci_bus_read_config_dword(,, cap + PCI_X_CMD,).

This is because for a dword, the following portion of the PCI_OP_READ()
macro:

	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;

expands to:

	if (pos & 3) return PCIBIOS_BAD_REGISTER_NUMBER;

And is always true for 'cap + PCI_X_CMD', which is 0xe4 + 2 = 0xe6. ('cap' is
the result of calling pci_find_capability(, PCI_CAP_ID_PCIX).)

The same problem exists for pci_bus_write_config_dword(,, cap + PCI_X_CMD,).
In both cases, instead of calling _dword(), _word() should be called.

Signed-off-by: Dean Nelson <dnelson@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2375,13 +2375,13 @@ EXPORT_SYMBOL(pcix_get_max_mmrbc);
 int pcix_get_mmrbc(struct pci_dev *dev)
 {
 	int ret, cap;
-	u32 cmd;
+	u16 cmd;
 
 	cap = pci_find_capability(dev, PCI_CAP_ID_PCIX);
 	if (!cap)
 		return -EINVAL;
 
-	ret = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	ret = pci_read_config_word(dev, cap + PCI_X_CMD, &cmd);
 	if (!ret)
 		ret = 512 << ((cmd & PCI_X_CMD_MAX_READ) >> 2);
 
@@ -2401,7 +2401,8 @@ EXPORT_SYMBOL(pcix_get_mmrbc);
 int pcix_set_mmrbc(struct pci_dev *dev, int mmrbc)
 {
 	int cap, err = -EINVAL;
-	u32 stat, cmd, v, o;
+	u32 stat, v, o;
+	u16 cmd;
 
 	if (mmrbc < 512 || mmrbc > 4096 || !is_power_of_2(mmrbc))
 		goto out;
@@ -2419,7 +2420,7 @@ int pcix_set_mmrbc(struct pci_dev *dev,
 	if (v > (stat & PCI_X_STATUS_MAX_READ) >> 21)
 		return -E2BIG;
 
-	err = pci_read_config_dword(dev, cap + PCI_X_CMD, &cmd);
+	err = pci_read_config_word(dev, cap + PCI_X_CMD, &cmd);
 	if (err)
 		goto out;
 
@@ -2431,7 +2432,7 @@ int pcix_set_mmrbc(struct pci_dev *dev,
 
 		cmd &= ~PCI_X_CMD_MAX_READ;
 		cmd |= v << 2;
-		err = pci_write_config_dword(dev, cap + PCI_X_CMD, cmd);
+		err = pci_write_config_word(dev, cap + PCI_X_CMD, cmd);
 	}
 out:
 	return err;


