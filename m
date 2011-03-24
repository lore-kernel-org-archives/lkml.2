Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab1CXUgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:36:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58871 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab1CXUgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:36:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=kUBhR2ArWenJuV9mXDGh9myASCvzrT7Z65Ai9sgV3IHxTQ/gvVGS2ZG9LWA2hyW2WD
         2C81DfQBmgPVk5PaVeO5FvzOqmy2QcJonroBnR5rrvtmCcjMou9x6yF8T4Lh+/EEFX+f
         wlQyjZ7blxmzE5wAgMsugOK6faaC5beqJOrys=
Message-ID: <4D8BAB49.3080701@openvz.org>
Date: Thu, 24 Mar 2011 23:36:25 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: P4 PMU - Read proper MSR register to catch unflagged
 overflows
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Read proper MSR register to catch unflagged overflows

The read of a proper MSR register was missed and instead of counter the
configration register was tested (it has ARCH_P4_UNFLAGGED_BIT always
cleared) leading to unknown NMI hitting the system. As result the user may
obtain "Dazed and confused, but trying to continue" message. Fix it by reading
a proper MSR register.

When an NMI happens on a P4, the perf nmi handler checks the configuration
register to see if the overflow bit is set or not before taking
appropriate action.  Unfortunately, various P4 machines had a broken
overflow bit, so a backup mechanism was implemented.  This mechanism
checked to see if the counter rolled over or not.

A previous commit that implemented this backup mechanism was broken.
Instead of reading the counter register, it used the configuration
register to determine if the counter rolled over or not. Reading that bit
would give incorrect results.

This would lead to 'Dazed and confused' messages for the end user when
using the perf tool (or if the nmi watchdog is running).

The fix is to read the counter register before determining if the counter
rolled over or not.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;


-- 
    Cyrill
