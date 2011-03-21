Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1CUUym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:54:42 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19215 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1CUUyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:54:40 -0400
Date: Mon, 21 Mar 2011 21:54:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-pci@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [PATCH][resend] Don't index beyond end of intr_remap_fault_reasons
 array in dmar_get_fault_reason.
Message-ID: <alpine.LNX.2.00.1103212150030.23432@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/pci/dmar.c::dmar_get_fault_reason() we have 7 entries in the 
intr_remap_fault_reasons array and then this code:

...
        if (fault_reason >= 0x20 && (fault_reason <= 0x20 +                                    
				     ARRAY_SIZE(intr_remap_fault_reasons))) {
                *fault_type = INTR_REMAP;
                return intr_remap_fault_reasons[fault_reason - 0x20];
...

This ends up allowing array index values of 0-7 (both inclusive). A value 
of 7 indexes 1 past the end of the array, so I believe the code should be 
this instead:

...
        if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
                                     ARRAY_SIZE(intr_remap_fault_reasons) - 1)) {
                *fault_type = INTR_REMAP;
                return intr_remap_fault_reasons[fault_reason - 0x20];
...

Which only allows the actually legal values 0-6.

The patch below makes that change and also (while I was there) removes the 
completely unused  #define MAX_FAULT_REASON_IDX .


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dmar.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 09933eb..10ff0a5 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1207,12 +1207,10 @@ static const char *intr_remap_fault_reasons[] =
 	"Blocked an interrupt request due to source-id verification failure",
 };
 
-#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
-
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
 	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+				     ARRAY_SIZE(intr_remap_fault_reasons) - 1)) {
 		*fault_type = INTR_REMAP;
 		return intr_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

