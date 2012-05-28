Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2E1Dgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754074Ab2E1D3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:43 -0400
Message-Id: <20120528031216.656728457@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>
Subject: [ 100/117] x86/mce: Fix check for processor context when machine check was
 taken.
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 875e26648cf9b6db9d8dc07b7959d7c61fb3f49c upstream.

Linus pointed out that there was no value is checking whether m->ip
was zero - because zero is a legimate value.  If we have a reliable
(or faked in the VM86 case) "m->cs" we can use it to tell whether we
were in user mode or kernelwhen the machine check hit.

Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index 0c82091..1ccd453 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -165,15 +165,19 @@ static struct severity {
 };
 
 /*
- * If the EIPV bit is set, it means the saved IP is the
- * instruction which caused the MCE.
+ * If mcgstatus indicated that ip/cs on the stack were
+ * no good, then "m->cs" will be zero and we will have
+ * to assume the worst case (IN_KERNEL) as we actually
+ * have no idea what we were executing when the machine
+ * check hit.
+ * If we do have a good "m->cs" (or a faked one in the
+ * case we were executing in VM86 mode) we can use it to
+ * distinguish an exception taken in user from from one
+ * taken in the kernel.
  */
 static int error_context(struct mce *m)
 {
-	if (m->mcgstatus & MCG_STATUS_EIPV)
-		return (m->ip && (m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
-	/* Unknown, assume kernel */
-	return IN_KERNEL;
+	return ((m->cs & 3) == 3) ? IN_USER : IN_KERNEL;
 }
 
 int mce_severity(struct mce *m, int tolerant, char **msg)


