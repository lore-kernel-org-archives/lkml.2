Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2E0BCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:02:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab2E0BA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:00:58 -0400
Message-Id: <20120527002621.250295871@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:27:02 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [ 49/55] x86/mce: Fix check for processor context when machine check was taken.
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 875e26648cf9b6db9d8dc07b7959d7c61fb3f49c upstream.

Linus pointed out that there was no value is checking whether m->ip
was zero - because zero is a legimate value.  If we have a reliable
(or faked in the VM86 case) "m->cs" we can use it to tell whether we
were in user mode or kernelwhen the machine check hit.

Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -101,15 +101,19 @@ static struct severity {
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
 
 int mce_severity(struct mce *a, int tolerant, char **msg)


