Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab1CDPhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:37:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759742Ab1CDPhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uM8wnHiYzEsNSQx4c6l2Um+HSNR84kI6cAzEsGnnKFKx5xKS5qzTU8/HlcqA0GlF0e
         GP6PCjoed2YxjmlbB5mePyBbN2GqS8LJXYYIk0Hul59Sxfo50DSnuuGsjKIiaZFDlNet
         bxTO0V+3La3WdQ3Ic6t8S5F9jh+/omtMpzTu8=
Date: Fri, 4 Mar 2011 16:31:06 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] x86-64, NUMA: Don't assume phys node 0 is always
 online in numa_emulation() handling
Message-ID: <20110304153106.GT20499@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com>
 <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org>
 <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Undetermined entries in emu_nid_to_phys[] are filled with zero
assuming that physical node 0 is always online; however, this might
not be true depending on hardware configuration.  Find a physical node
which is actually online and use it instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1103020628210.31626@chino.kir.corp.google.com>
---
 arch/x86/mm/numa_emulation.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 75b31dc..3696be0 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -301,6 +301,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
+	int dfl_phys_nid;
 	int i, j, ret;
 
 	if (!emu_cmdline)
@@ -357,6 +358,19 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					node_distance(i, j);
 	}
 
+	/* determine the default phys nid to use for unmapped nodes */
+	dfl_phys_nid = NUMA_NO_NODE;
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++) {
+		if (emu_nid_to_phys[i] != NUMA_NO_NODE) {
+			dfl_phys_nid = emu_nid_to_phys[i];
+			break;
+		}
+	}
+	if (dfl_phys_nid == NUMA_NO_NODE) {
+		pr_warning("NUMA: Warning: can't determine default physical node, disabling emulation\n");
+		goto no_emu;
+	}
+
 	/* commit */
 	*numa_meminfo = ei;
 
@@ -377,7 +391,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	/* make sure all emulated nodes are mapped to a physical node */
 	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
-			emu_nid_to_phys[i] = 0;
+			emu_nid_to_phys[i] = dfl_phys_nid;
 
 	/*
 	 * Transform distance table.  numa_set_distance() ignores all
