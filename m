Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1D2OsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:48:18 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:60888 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab1D2OsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:48:15 -0400
Subject: [PATCH] arm: prevent heap corruption in OABI semtimedop
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 10:48:07 -0400
Message-ID: <1304088487.28093.7.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_OABI_COMPAT is set, the wrapper for semtimedop does not
bound the nsops argument.  A sufficiently large value will cause an
integer overflow in allocation size, followed by copying too much data
into the allocated buffer.  Fix this by restricting nsops to SEMOPM.
Untested.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
---
 arch/arm/kernel/sys_oabi-compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 4ad8da1..af0aaeb 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -311,7 +311,7 @@ asmlinkage long sys_oabi_semtimedop(int semid,
 	long err;
 	int i;
 
-	if (nsops < 1)
+	if (nsops < 1 || nsops > SEMOPM)
 		return -EINVAL;
 	sops = kmalloc(sizeof(*sops) * nsops, GFP_KERNEL);
 	if (!sops)


