Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab0FNRty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:49:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36330 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0FNRtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:49:53 -0400
Message-ID: <4C166B4F.90308@oracle.com>
Date: Mon, 14 Jun 2010 10:47:59 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
References: <4BF40014.30303@ntlworld.com> <201005201108.07040.bjorn.helgaas@hp.com> <201006021058.57361.bjorn.helgaas@hp.com> <201006111549.05164.bjorn.helgaas@hp.com> <4C12C189.50201@oracle.com>
In-Reply-To: <4C12C189.50201@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C166B79.00DD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Graham bisected
|    commit 3e3da00c01d050307e753fb7b3e84aefc16da0d0
|    x86/pci: AMD one chain system to use pci read out res

cause the SND_HDA_INTEL doesn't work anymore.

https://bugzilla.kernel.org/show_bug.cgi?id=16007

It turns out that his system with via chipset only have one hypertransport
chain, but does have one extra orphan device 80:01.0

 PCI: Probing PCI hardware (bus 00)
 PCI: Discovered primary peer bus 80 [IRQ]

 node 0 link 0: io port [1000, ffffff]
 TOM: 0000000080000000 aka 2048M
 node 0 link 0: mmio [e0000000, efffffff]
 node 0 link 0: mmio [a0000, bffff]
 node 0 link 0: mmio [80000000, ffffffff]
 bus: [00, ff] on node 0 link 0

Try to make peer root buses to share same mmio/io resources if those peer root
buses fall into the same bus range.

Also need to update insert_resource to avoid insert same resource two times.

We need this patch for 2.6.34 stable.

Reported-by: Graham Ramsey <ramsey.graham@ntlworld.com>
Bisected-by: Graham Ramsey <ramsey.graham@ntlworld.com>
Tested-by: Graham Ramsey <ramsey.graham@ntlworld.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/pci/bus_numa.c |    3 ++-
 kernel/resource.c       |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.c
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -22,7 +22,8 @@ void x86_pci_root_bus_res_quirks(struct
 		return;
 
 	for (i = 0; i < pci_root_num; i++) {
-		if (pci_root_info[i].bus_min == b->number)
+		if (pci_root_info[i].bus_min <= b->number &&
+		    pci_root_info[i].bus_max >= b->number)
 			break;
 	}
 
Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -451,7 +451,7 @@ static struct resource * __insert_resour
 		if (!first)
 			return first;
 
-		if (first == parent)
+		if (first == parent || first == new)
 			return first;
 
 		if ((first->start > new->start) || (first->end < new->end))
