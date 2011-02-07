Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab1BGWCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:02:41 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:61536 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1BGWCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:02:39 -0500
Message-ID: <4D506BC8.8080705@kernel.org>
Date: Mon, 07 Feb 2011 14:01:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH] x86, pci: early dump skip device the same way as later probe
 code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D506BE8.011F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use VENDOR_ID instead of CLASS_REVISION.

Do have one system with 0x00ffffff CLASS_REVSION

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/early.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/pci/early.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/early.c
+++ linux-2.6/arch/x86/pci/early.c
@@ -88,12 +88,17 @@ void early_dump_pci_devices(void)
 	for (bus = 0; bus < 256; bus++) {
 		for (slot = 0; slot < 32; slot++) {
 			for (func = 0; func < 8; func++) {
-				u32 class;
+				u32 l;
 				u8 type;
 
-				class = read_pci_config(bus, slot, func,
-							PCI_CLASS_REVISION);
-				if (class == 0xffffffff)
+				l = read_pci_config(bus, slot, func,
+							PCI_VENDOR_ID);
+				/*
+				 * some broken boards return 0 or ~0 if a slot
+				 *  is empty
+				 */
+				if (l == 0xffffffff || l == 0x00000000 ||
+				    l == 0x0000ffff || l == 0xffff0000)
 					continue;
 
 				early_dump_pci_device(bus, slot, func);
