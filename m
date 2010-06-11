Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0FKXJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 19:09:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61348 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0FKXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 19:09:03 -0400
Message-ID: <4C12C189.50201@oracle.com>
Date: Fri, 11 Jun 2010 16:06:49 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Graham Ramsey <ramsey.graham@ntlworld.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
       Myron Stowe <myron.stowe@hp.com>,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>
Subject: Re: [Bug 16007] x86/pci Oops with CONFIG_SND_HDA_INTEL
References: <4BF40014.30303@ntlworld.com> <201005201108.07040.bjorn.helgaas@hp.com> <201006021058.57361.bjorn.helgaas@hp.com> <201006111549.05164.bjorn.helgaas@hp.com>
In-Reply-To: <201006111549.05164.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4C12C1E6.00E1:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


please check if this one workaround the problem

Thanks

Yinghai Lu

[PATCH] x86, pci: handle fallout pci devices with peer root bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/bus_numa.c |    4 +++-
 kernel/resource.c       |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

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
 
@@ -37,6 +38,7 @@ void x86_pci_root_bus_res_quirks(struct
 	for (j = 0; j < info->res_num; j++) {
 		struct resource *res;
 		struct resource *root;
+		struct resource *tmp;
 
 		res = &info->res[j];
 		pci_bus_add_resource(b, res, 0);
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
