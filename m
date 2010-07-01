Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab0GAVPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:15:53 -0400
Received: from kroah.org ([198.145.64.141]:60916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758792Ab0GAVNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:13:49 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:52 2010
Message-Id: <20100701174252.914307119@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:42:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Mahoney <jeffm@suse.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [077/200] powerpc: Fix handling of strncmp with zero len
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 637a99022fb119b90fb281715d13172f0394fc12 upstream.

Commit 0119536c, which added the assembly version of strncmp to
powerpc, mentions that it adds two instructions to the version from
boot/string.S to allow it to handle len=0. Unfortunately, it doesn't
always return 0 when that is the case. The length is passed in r5, but
the return value is passed back in r3. In certain cases, this will
happen to work. Otherwise it will pass back the address of the first
string as the return value.

This patch lifts the len <= 0 handling code from memcpy to handle that
case.

Reported by: Christian_Sellars@symantec.com
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/lib/string.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/lib/string.S
+++ b/arch/powerpc/lib/string.S
@@ -71,7 +71,7 @@ _GLOBAL(strcmp)
 
 _GLOBAL(strncmp)
 	PPC_LCMPI r5,0
-	beqlr
+	ble-	2f
 	mtctr	r5
 	addi	r5,r3,-1
 	addi	r4,r4,-1
@@ -82,6 +82,8 @@ _GLOBAL(strncmp)
 	beqlr	1
 	bdnzt	eq,1b
 	blr
+2:	li	r3,0
+	blr
 
 _GLOBAL(strlen)
 	addi	r4,r3,-1


