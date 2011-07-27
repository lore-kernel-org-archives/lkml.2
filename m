Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab1G0Aff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:46796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1G0AfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471178"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: drosenberg@vsecurity.com, rmk+kernel@arm.linux.org.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [27/98] ARM: 6891/1: prevent heap corruption in OABI semtimedop
Message-Id: <20110727003519.71E532403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 0f22072ab50cac7983f9660d33974b45184da4f9 upstream.

When CONFIG_OABI_COMPAT is set, the wrapper for semtimedop does not
bound the nsops argument.  A sufficiently large value will cause an
integer overflow in allocation size, followed by copying too much data
into the allocated buffer.  Fix this by restricting nsops to SEMOPM.
Untested.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/arm/kernel/sys_oabi-compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/arm/kernel/sys_oabi-compat.c
===================================================================
--- linux-2.6.35.y.orig/arch/arm/kernel/sys_oabi-compat.c
+++ linux-2.6.35.y/arch/arm/kernel/sys_oabi-compat.c
@@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int 
 	long err;
 	int i;
 
-	if (nsops < 1)
+	if (nsops < 1 || nsops > SEMOPM)
 		return -EINVAL;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)
