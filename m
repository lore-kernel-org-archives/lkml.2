Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1IZS1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:27:31 -0400
Received: from claw.goop.org ([74.207.240.146]:32968 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab1IZS13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:27:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Xen Devel <xen-devel@lists.xensource.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/3] xen/dom0: set wallclock time in Xen
Date: Mon, 26 Sep 2011 11:27:25 -0700
Message-Id: <fdb9eb9f155bfc0f8dc2fc88f90448b30c78ad97.1317061152.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317061152.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/time.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 5158c50..8c9cdfa 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -200,8 +200,22 @@ static unsigned long xen_get_wallclock(void)
 
 static int xen_set_wallclock(unsigned long now)
 {
+	struct xen_platform_op op;
+	int rc;
+
 	/* do nothing for domU */
-	return -1;
+	if (!xen_initial_domain())
+		return -1;
+
+	op.cmd = XENPF_settime;
+	op.u.settime.secs = now;
+	op.u.settime.nsecs = 0;
+	op.u.settime.system_time = xen_clocksource_read();
+
+	rc = HYPERVISOR_dom0_op(&op);
+	WARN(rc != 0, "XENPF_settime failed: now=%ld\n", now);
+
+	return rc;
 }
 
 static struct clocksource xen_clocksource __read_mostly = {
-- 
1.7.6.2

