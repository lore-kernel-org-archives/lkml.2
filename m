Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab0GAUv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:51:59 -0400
Received: from kroah.org ([198.145.64.141]:47680 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab0GAUup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:45 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:34 2010
Message-Id: <20100701173434.887017144@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 096/164] xen: ensure timer tick is resumed even on CPU driving the resume
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

commit cd52e17ea8278f8449b6174a8e5ed439a2e44ffb upstream.

The core suspend/resume code is run from stop_machine on CPU0 but
parts of the suspend/resume machinery (including xen_arch_resume) are
run on whichever CPU happened to schedule the xenwatch kernel thread.

As part of the non-core resume code xen_arch_resume is called in order
to restart the timer tick on non-boot processors. The boot processor
itself is taken care of by core timekeeping code.

xen_arch_resume uses smp_call_function which does not call the given
function on the current processor. This means that we can end up with
one CPU not receiving timer ticks if the xenwatch thread happened to
be scheduled on CPU > 0.

Use on_each_cpu instead of smp_call_function to ensure the timer tick
is resumed everywhere.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/suspend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/suspend.c
+++ b/arch/x86/xen/suspend.c
@@ -60,6 +60,6 @@ static void xen_vcpu_notify_restore(void
 
 void xen_arch_resume(void)
 {
-	smp_call_function(xen_vcpu_notify_restore,
-			       (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
+	on_each_cpu(xen_vcpu_notify_restore,
+		    (void *)CLOCK_EVT_NOTIFY_RESUME, 1);
 }


