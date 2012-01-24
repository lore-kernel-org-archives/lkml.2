Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2AXWrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:47:24 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16083 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2AXWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:47:23 -0500
Date: Tue, 24 Jan 2012 23:47:27 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH 2/2] Staging; Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
In-Reply-To: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We allocate memory for 'pstAddIndication' with kmalloc() in
drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
neglect to free it on a number of exit paths from that function.

This could probably be resolved cleaner/nicer, but this file needs a
serious overhaul in any case, so I opted for just fixing the problem
as directly as I could and then we can clean it up generally
later... This at least makes it stop bleeding..

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/bcm/CmHost.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 1fcc039..a404d30 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1595,18 +1595,22 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter, PVOID pvBuffer, UINT
 	// For DSA_REQ, only up to "psfAuthorizedSet" parameter should be accessed by driver!
 
 	pstAddIndication = kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
-	if (NULL == pstAddIndication)
+	if (!pstAddIndication)
 		return 0;
 
 	/* AUTHORIZED SET */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if (!pstAddIndication->psfAuthorizedSet)
+	if (!pstAddIndication->psfAuthorizedSet) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfAuthorizedSet,
-				(ULONG)pstAddIndication->psfAuthorizedSet) != 1)
+				(ULONG)pstAddIndication->psfAuthorizedSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	/* This can't possibly be right */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
@@ -1622,6 +1626,7 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter, PVOID pvBuffer, UINT
 		AddRequest.psfParameterSet =pstAddIndication->psfAuthorizedSet ;
 		(*puBufferLength) = sizeof(stLocalSFAddRequest);
 		memcpy(pvBuffer, &AddRequest, sizeof(stLocalSFAddRequest));
+		kfree(pstAddIndication);
 		return 1;
 	}
 
@@ -1639,20 +1644,28 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter, PVOID pvBuffer, UINT
 	/* ADMITTED SET */
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if (!pstAddIndication->psfAdmittedSet)
+	if (!pstAddIndication->psfAdmittedSet) {
+		kfree(pstAddIndication);
 		return 0;
-	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfAdmittedSet, (ULONG)pstAddIndication->psfAdmittedSet) != 1)
+	}
+	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfAdmittedSet, (ULONG)pstAddIndication->psfAdmittedSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
 
 	/* ACTIVE SET */
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if (!pstAddIndication->psfActiveSet)
+	if (!pstAddIndication->psfActiveSet) {
+		kfree(pstAddIndication);
 		return 0;
-	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfActiveSet, (ULONG)pstAddIndication->psfActiveSet) != 1)
+	}
+	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfActiveSet, (ULONG)pstAddIndication->psfActiveSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfActiveSet);
 
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

