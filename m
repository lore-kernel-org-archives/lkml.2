Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab2BIWcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:32:50 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26975 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2BIWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:32:49 -0500
Date: Thu, 9 Feb 2012 23:33:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 2/2] Staging; Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
In-Reply-To: <20120209175217.GA13959@kroah.com>
Message-ID: <alpine.LNX.2.00.1202092329110.32491@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net> <20120209175217.GA13959@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Greg KH wrote:

> On Tue, Jan 24, 2012 at 11:47:27PM +0100, Jesper Juhl wrote:
> > We allocate memory for 'pstAddIndication' with kmalloc() in
> > drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
> > neglect to free it on a number of exit paths from that function.
> > 
> > This could probably be resolved cleaner/nicer, but this file needs a
> > serious overhaul in any case, so I opted for just fixing the problem
> > as directly as I could and then we can clean it up generally
> > later... This at least makes it stop bleeding..
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/staging/bcm/CmHost.c |   27 ++++++++++++++++++++-------
> >  1 files changed, 20 insertions(+), 7 deletions(-)
> 
> 
> This patch no longer applies, care to redo it against the latest
> linux-next tree?
> 

No problem. Here's one against a freshly cloned linux-next.

>From e54030c49d36d6519fb50f89582df69a5624069f Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jj@codesealer.com>
Date: Thu, 9 Feb 2012 13:16:09 +0100
Subject: Staging; Don't leak 'pstAddIndication' in CmHost.c::StoreCmControlResponseMessage()

We allocate memory for 'pstAddIndication' with kmalloc() in 
drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then 
neglect to free it on a number of exit paths from that function.

This could probably be resolved cleaner/nicer, but this file needs a
serious overhaul in any case, so I opted for just fixing the problem
as directly as I could and then we can clean it up generally
later... This at least makes it stop bleeding..

Signed-off-by: Jesper Juhl <jj@codesealer.com>
---
 drivers/staging/bcm/CmHost.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

 Note: I have absolutely no way to test this, so this patch is based 
       purely on inspection of the code and then a simple check to see 
       that it at least compiles with allyesconfig.
       If it breaks you get to keep the pieces.

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index c0ee95a..7c30be1 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1663,7 +1663,7 @@ static ULONG StoreSFParam(PMINI_ADAPTER Adapter,PUCHAR pucSrcBuffer,ULONG  ulAdd
 ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *puBufferLength)
 {
 	stLocalSFAddIndicationAlt *pstAddIndicationAlt = NULL;
-	stLocalSFAddIndication *  pstAddIndication = NULL;
+	stLocalSFAddIndication *pstAddIndication = NULL;
 	stLocalSFDeleteRequest *pstDeletionRequest;
 	UINT uiSearchRuleIndex;
 	ULONG ulSFID;
@@ -1698,19 +1698,23 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	}
 	// For DSA_REQ, only up to "psfAuthorizedSet" parameter should be accessed by driver!
 
-	pstAddIndication=kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
-	if(NULL==pstAddIndication)
+	pstAddIndication = kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
+	if (!pstAddIndication)
 		return 0;
 
 	/* AUTHORIZED SET */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)
 			GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfAuthorizedSet)
+	if (!pstAddIndication->psfAuthorizedSet) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
-	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfAuthorizedSet,
-				(ULONG)pstAddIndication->psfAuthorizedSet)!= 1)
+	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfAuthorizedSet,
+				(ULONG)pstAddIndication->psfAuthorizedSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	/* this can't possibly be right */
 	pstAddIndication->psfAuthorizedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
@@ -1744,10 +1748,15 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	/* ADMITTED SET */
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfAdmittedSet)
+	if (!pstAddIndication->psfAdmittedSet) {
+		kfree(pstAddIndication);
 		return 0;
-	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfAdmittedSet,(ULONG)pstAddIndication->psfAdmittedSet) != 1)
+	}
+	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfAdmittedSet,
+				(ULONG)pstAddIndication->psfAdmittedSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	pstAddIndication->psfAdmittedSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
 
@@ -1755,10 +1764,15 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	/* ACTIVE SET */
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)
 		GetNextTargetBufferLocation(Adapter, pstAddIndicationAlt->u16TID);
-	if(!pstAddIndication->psfActiveSet)
+	if (!pstAddIndication->psfActiveSet) {
+		kfree(pstAddIndication);
 		return 0;
-	if(StoreSFParam(Adapter,(PUCHAR)&pstAddIndicationAlt->sfActiveSet,(ULONG)pstAddIndication->psfActiveSet) != 1)
+	}
+	if (StoreSFParam(Adapter, (PUCHAR)&pstAddIndicationAlt->sfActiveSet,
+				(ULONG)pstAddIndication->psfActiveSet) != 1) {
+		kfree(pstAddIndication);
 		return 0;
+	}
 
 	pstAddIndication->psfActiveSet = (stServiceFlowParamSI *)ntohl((ULONG)pstAddIndication->psfActiveSet);
 
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

