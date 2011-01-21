Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1AUNqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:46:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37429 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1AUNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:46:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=DeMqWwPrR+lQo04vwJMNTjlEOVw4cUf1ciDZgdEANYmE6SozO7TEO8Nrm+MlELJ2JF
         y0Ef6Zt7PUqY/uL7ypwc83/1PSqDHTdisCz8EXCoy/nqSaNATGrG34FEglhi5UpHsJ3u
         YOs+aggAjjoiSUlbmK2Vo3UFZOaWA/iCkeip0=
Date: Fri, 21 Jan 2011 13:46:34 +0000 (GMT)
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stuart Swales <stuart.swales.croftnuisk@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: improve timestamp precision
In-Reply-To: <20110119153335.06b4637b.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1101211344040.4479@dc5850.croftnuisk.local>
References: <4D2DECDC.7020801@gmail.com> <20110119153335.06b4637b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Thanks Andrew - icedove had screwed up the patch somewhat.  I'm using
alpine to send this (have tested that it went round the loop ok and
produces the same patch)]

diff -uprN -X linux-2.6.37-vanilla/Documentation/dontdiff linux-2.6.37-vanilla/fs/adfs/inode.c linux-2.6.37-sks-adfs/fs/adfs/inode.c
--- linux-2.6.37-vanilla/fs/adfs/inode.c	2011-01-05 00:50:19.000000000 +0000
+++ linux-2.6.37-sks-adfs/fs/adfs/inode.c	2011-01-12 17:08:19.000000000 +0000
@@ -175,50 +175,48 @@ adfs_mode2atts(struct super_block *sb, s

 /*
  * Convert an ADFS time to Unix time.  ADFS has a 40-bit centi-second time
- * referenced to 1 Jan 1900 (til 2248)
+ * referenced to 1 Jan 1900 (til 2248) so we need to discard 2208988800 seconds
+ * of time to convert from RISC OS epoch to Unix epoch.
  */
 static void
 adfs_adfs2unix_time(struct timespec *tv, struct inode *inode)
 {
 	unsigned int high, low;
+	/* 01 Jan 1970 00:00:00 (Unix epoch) as nanoseconds since
+	 * 01 Jan 1900 00:00:00 (RISC OS epoch)
+	 */
+	static const s64 nsec_unix_epoch_diff_risc_os_epoch =
+							2208988800000000000LL;
+	s64 nsec;

 	if (ADFS_I(inode)->stamped == 0)
 		goto cur_time;

-	high = ADFS_I(inode)->loadaddr << 24;
-	low  = ADFS_I(inode)->execaddr;
+	high = ADFS_I(inode)->loadaddr & 0xFF; /* top 8 bits of timestamp */
+	low  = ADFS_I(inode)->execaddr;    /* bottom 32 bits of timestamp */

-	high |= low >> 8;
-	low  &= 255;
+	/* convert 40-bit centi-seconds to 32-bit seconds
+	 * going via nanoseconds to retain precision
+	 */
+	nsec = (((s64) high << 32) | (s64) low) * 10000000; /* cs to ns */

 	/* Files dated pre  01 Jan 1970 00:00:00. */
-	if (high < 0x336e996a)
+	if (nsec < nsec_unix_epoch_diff_risc_os_epoch)
 		goto too_early;

-	/* Files dated post 18 Jan 2038 03:14:05. */
-	if (high >= 0x656e9969)
-		goto too_late;
-
-	/* discard 2208988800 (0x336e996a00) seconds of time */
-	high -= 0x336e996a;
-
-	/* convert 40-bit centi-seconds to 32-bit seconds */
-	tv->tv_sec = (((high % 100) << 8) + low) / 100 + (high / 100 << 8);
-	tv->tv_nsec = 0;
+	/* convert from RISC OS to Unix epoch */
+	nsec -= nsec_unix_epoch_diff_risc_os_epoch;
+
+	*tv = ns_to_timespec(nsec);
 	return;

  cur_time:
-	*tv = CURRENT_TIME_SEC;
+	*tv = CURRENT_TIME;
 	return;

  too_early:
 	tv->tv_sec = tv->tv_nsec = 0;
 	return;
-
- too_late:
-	tv->tv_sec = 0x7ffffffd;
-	tv->tv_nsec = 0;
-	return;
 }

 /*


