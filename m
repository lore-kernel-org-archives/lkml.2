Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2HAT6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:58:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab2HAT6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:58:00 -0400
Date: Wed, 1 Aug 2012 21:57:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: fix personality flag check in copy_thread()
Message-ID: <alpine.LNX.2.00.1208012155330.14910@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly comparing task_struct->personality against PER_* is not fully 
correct, as it doesn't take flags potentially stored in top three bytes 
into account.

Analogically, directly forcefully setting personality to PER_LINUX32 or
PER_LINUX discards any flags stored in the top three bytes.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

Found accidentally, untested, I don't have the hardware.

 arch/parisc/kernel/process.c    |    2 +-
 arch/parisc/kernel/sys_parisc.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index d4b94b3..2c05a92 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -309,7 +309,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
 		cregs->ksp = (unsigned long)stack
 			+ (pregs->gr[21] & (THREAD_SIZE - 1));
 		cregs->gr[30] = usp;
-		if (p->personality == PER_HPUX) {
+		if (personality(p->personality) == PER_HPUX) {
 #ifdef CONFIG_HPUX
 			cregs->kpc = (unsigned long) &hpux_child_return;
 #else
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_parisc.c
index c9b9322..f309990 100644
--- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -225,12 +225,12 @@ long parisc_personality(unsigned long personality)
 	long err;
 
 	if (personality(current->personality) == PER_LINUX32
-	    && personality == PER_LINUX)
-		personality = PER_LINUX32;
+	    && personality(personality) == PER_LINUX)
+		personality &= ~PER_LINUX | PER_LINUX32;
 
 	err = sys_personality(personality);
-	if (err == PER_LINUX32)
-		err = PER_LINUX;
+	if (personality(err) == PER_LINUX32)
+		err &= ~PER_LINUX32 | PER_LINUX;
 
 	return err;
 }

-- 
Jiri Kosina
SUSE Labs
