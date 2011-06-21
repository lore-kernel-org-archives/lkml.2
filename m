Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1FULI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:08:57 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:53478 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab1FULI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:08:56 -0400
Subject: [PATCH] Fix a memory leak reported by kmemleak.
To: x86@kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org
Date: Tue, 21 Jun 2011 13:08:53 +0200
Message-ID: <20110621110853.2537133.20464.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: utf-8
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocated by get_current_resources() will be never free'ed
if 'pci_use_crs' is not set.

Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 arch/x86/pci/acpi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 0972315..3ad040a 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -228,8 +228,11 @@ static void add_resources(struct pci_root_info *info)
 	int i;
 	struct resource *res, *root, *conflict;
 
-	if (!pci_use_crs)
+	if (!pci_use_crs) {
+		kfree(info->res);
+		kfree(info->name);
 		return;
+	}
 
 	coalesce_windows(info, IORESOURCE_MEM);
 	coalesce_windows(info, IORESOURCE_IO);

