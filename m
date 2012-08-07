Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2HGDqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:46:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964809Ab2HGDiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:54 -0400
Message-Id: <20120807032802.358047510@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:38 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Rosenberg <drosenberg@vsecurity.com>,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [ 43/70] lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq
 show-all-timers(Q)
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 3715c5309f6d175c3053672b73fd4f73be16fd07 upstream.

When using ALT+SysRq+Q all the pointers are replaced with "pK-error" like
this:

	[23153.208033]   .base:               pK-error

with echo h > /proc/sysrq-trigger it works:

	[23107.776363]   .base:       ffff88023e60d540

The intent behind this behavior was to return "pK-error" in cases where
the %pK format specifier was used in interrupt context, because the
CAP_SYSLOG check wouldn't be meaningful.  Clearly this should only apply
when kptr_restrict is actually enabled though.

Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>
Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -886,7 +886,8 @@ char *pointer(const char *fmt, char *buf
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi()) {
+		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
+				      in_nmi())) {
 			if (spec.field_width == -1)
 				spec.field_width = 2 * sizeof(void *);
 			return string(buf, end, "pK-error", spec);


