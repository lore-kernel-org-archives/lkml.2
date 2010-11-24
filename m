Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0KXOxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:53:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0KXOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:53:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=Sti8C1gfNm7ryFG/aKTLWU/mD1SqY6eoKVA/bXRo7vRvW11q5FRQXvbR/0kMXKYJva
         307E+ltLYwwNlDLDOT2MWt3Tv966a+mDzTX/7RVWg+2v247sy7qklc6KNAKNLsObGgeO
         sOnuc9uAManhNGVfhH0gp4w7oWPoLgcUiDcv4=
Message-ID: <4CED26EF.5000109@suse.cz>
Date: Wed, 24 Nov 2010 15:53:35 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: mjg@redhat.com
CC: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: eeepc: rfkill on 900A defunct
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there is a 900A model out there with wifi at the 2nd bus:
02:00.0 Ethernet controller [0200]: Atheros Communications Inc. AR5001
Wireless Network Adapter [168c:001c] (rev 01)

but without hotplug support (pciehp cannot be bound to it). However the
eeepc-laptop driver expects the wifi on the 1st bus (pci_find_bus(0,
1)), so it operates on a NIC on this machine instead of wifi.

Changing the code to pci_find_bus(0, 2) indeed fixes the problem, but I
see no way how to determine when to do this. model == "900A" seems to be
wrong, because there are other 900A devices which work OK with bus == 1.

Any ideas?

lspci -vvnnxxx:
https://bugzillafiles.novell.org/attachment.cgi?id=370529
dmidecode:
https://bugzillafiles.novell.org/attachment.cgi?id=401633
dmesg:
https://bugzillafiles.novell.org/attachment.cgi?id=370538

The workaround for such machines:
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -588,7 +588,7 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop
*eeepc)
        mutex_lock(&eeepc->hotplug_lock);

        if (eeepc->hotplug_slot) {
-               bus = pci_find_bus(0, 1);
+               bus = pci_find_bus(0, 2);
                if (!bus) {
                        pr_warning("Unable to find PCI bus 1?\n");
                        goto out_unlock;
@@ -714,7 +714,7 @@ static struct hotplug_slot_ops
eeepc_hotplug_slot_ops = {
 static int eeepc_setup_pci_hotplug(struct eeepc_laptop *eeepc)
 {
        int ret = -ENOMEM;
-       struct pci_bus *bus = pci_find_bus(0, 1);
+       struct pci_bus *bus = pci_find_bus(0, 2);

        if (!bus) {
                pr_err("Unable to find wifi PCI bus\n");

thanks,
-- 
js
suse labs
