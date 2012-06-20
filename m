Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2FTUEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:04:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37603 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2FTUEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120620193438.GB2248@gmail.com>
References: <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
 <CAErSpo57H_ZD_-Z8z9vD3c50My4Rejtc9gXXrxGxDtQomYmrSA@mail.gmail.com>
 <CAOPLpQeJTfB2UNy3O9FgRCyZb=LyMqd0SOsz7qDM0Ur_sfeNhg@mail.gmail.com>
 <CAE9FiQVzKr+nyBh=8-v+HEDF=7JqN2CqdTNx1=LHTq=c_OyZvg@mail.gmail.com>
 <CAErSpo40SDii6PTNisAnsn6SoB7SzPUGztWAg9vaZZv+ByQsPw@mail.gmail.com>
 <CAE9FiQVDnS9n28GQrKVVTU7GiMtJZLFN1T9vmOm5oSysvMEVhQ@mail.gmail.com>
 <CAErSpo4x8+M6hGAqJR2rjGEGk2AnnZfJkmaJrJedzhnKiRf2qw@mail.gmail.com>
 <CAOPLpQchY4gMYaw-Ew5uujD9JCu==VLjQ7Z_OjrT6akTgX4+iA@mail.gmail.com>
 <CAErSpo6JWKoFcbsLnyzPGXLKssobfudjcYMvYzfEpYZ-bzCHPg@mail.gmail.com>
 <CAE9FiQWOUZhUQYc66ceG5EMWQ0uO7L3odh0+XwRsLV2Bza2ZpQ@mail.gmail.com> <20120620193438.GB2248@gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 20 Jun 2012 16:04:26 -0400
Message-ID: <CAOPLpQdi-8NZL1rwt3APU_is4GcyGaAN0Vq0T23BMSHob--YYg@mail.gmail.com>
Subject: Re: SNB PCI root information
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 3:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
> I mean, if we create a parameter space that tweaks data then why
> not make it complete and allow *all* firmware data to be
> (optionally) modified, from the kernel boot line?

If there is proof that BIOSes get it wrong then just use this small
additional patch:


Signed-off-by: Ulrich Drepper <drepper@gmail.com>

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index fc09c27..7aceb84 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -387,16 +387,16 @@ struct pci_bus * __devinit
pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 	}

-	node = -1;
+	node = get_mp_bus_to_node(busnum);
 #ifdef CONFIG_ACPI_NUMA
-	pxm = acpi_get_pxm(device->handle);
-	if (pxm >= 0)
-		node = pxm_to_node(pxm);
-	if (node != -1)
-		set_mp_bus_to_node(busnum, node);
-	else
+	if (node == -1) {
+		pxm = acpi_get_pxm(device->handle);
+		if (pxm >= 0)
+			node = pxm_to_node(pxm);
+		if (node != -1)
+			set_mp_bus_to_node(busnum, node);
+	}
 #endif
-		node = get_mp_bus_to_node(busnum);

 	if (node != -1 && !node_online(node))
 		node = -1;
