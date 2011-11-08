Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1KHStu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:49:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:3615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382Ab1KHStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:49:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=lyV4F/OGVLOrLzO67d75/UOoSUXdn8MfVAVKTdyuMhMzbzP2DFLuT2MkIY+zkE10J
	yl1n+lbNA82qQj299IGDQ==
Subject: [RESEND PATCH] x86: mpparse: fix mp_bus_not_pci handling
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dan McGrath <troubledaemon@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org#2.6.26+,
        Jonathan Nieder <jrnieder@gmail.com>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Date: Tue, 08 Nov 2011 11:49:34 -0700
Message-ID: <20111108184934.5180.26968.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan bisected a Dell PowerEdge 4200 boot regression to commit f8924e770.
Prior to that commit, 32-bit kernels set mp_bus_not_pci for all buses
except PCI.  Afterwards, we set mp_bus_not_pci only for ISA.  But ISA is
not the only non-PCI bus, so it's better to always set mp_bus_not_pci
and clear it only for PCI.

The workaround was to boot with "noapic".  Dan verified that with this
patch, his system boots without "noapic".

Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586494
Reported-and-tested-by: Dan McGrath <troubledaemon@gmail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: stable@kernel.org # 2.6.26+
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 9103b89..0741b062 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -95,8 +95,8 @@ static void __init MP_bus_info(struct mpc_bus *m)
 	}
 #endif
 
+	set_bit(m->busid, mp_bus_not_pci);
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
 		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif

