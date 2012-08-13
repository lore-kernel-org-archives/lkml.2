Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2HMUVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2HMUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stevie Trujillo <stevie.trujillo@gmail.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>
Subject: [ 07/82] lib/vsprintf.c: kptr_restrict: fix pK-error in SysRq show-all-timers(Q)
Date: Mon, 13 Aug 2012 13:18:43 -0700
Message-Id: <20120813201747.102087767@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/vsprintf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1030,7 +1030,8 @@ char *pointer(const char *fmt, char *buf
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi()) {
+		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
+				      in_nmi())) {
 			if (spec.field_width == -1)
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);


