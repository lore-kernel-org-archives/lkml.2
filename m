Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0LUViR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0LUViL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 06/10] xen/setup: Only set identity mapping in E820 regions when privileged.
Date: Tue, 21 Dec 2010 16:37:36 -0500
Message-Id: <1292967460-15709-7-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not want to set the identity mapping on E820 reserved
regions when running as PV. This is b/c the 0->ISA_END_ADDRESS region
would be considered identity and we would try to read DMI information
and fail (since the pfn_to_mfn(mfn)==pfn) under PV guests.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 752c865..34fb906 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -160,7 +160,7 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
 		if (end < start)
 			continue;
 
-		if (e820->map[i].type != E820_RAM) {
+		if (xen_initial_domain() && e820->map[i].type != E820_RAM) {
 			for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
 				set_phys_to_machine(pfn, pfn);
 			identity += pfn - PFN_UP(start);
-- 
1.7.1

