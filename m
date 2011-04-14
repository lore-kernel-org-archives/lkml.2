Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab1DNS2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:28:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:38013 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab1DNRqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 041/209] xen: ensure that all event channels start off bound to VCPU 0
Date: Thu, 14 Apr 2011 13:41:11 -0400
Message-Id: <1302803039-9400-42-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit b0097adeec27e30223c989561ab0f7aa60d1fe93 upstream.

All event channels startbound to VCPU 0 so ensure that cpu_evtchn_mask
is initialised to reflect this. Otherwise there is a race after registering an
event channel but before the affinity is explicitly set where the event channel
can be delivered. If this happens then the event channel remains pending in the
L1 (evtchn_pending) array but is cleared in L2 (evtchn_pending_sel), this means
the event channel cannot be reraised until another event channel happens to
trigger the same L2 entry on that VCPU.

sizeof(cpu_evtchn_mask(0))==sizeof(unsigned long*) which is not correct, and
causes only the first 32 or 64 event channels (depending on architecture) to be
initially bound to VCPU0. Use sizeof(struct cpu_evtchn_s) instead.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/xen/events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 6830a4d..0769108 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -256,7 +256,7 @@ static void init_evtchn_cpu_bindings(void)
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
 }
 
 static inline void clear_evtchn(int port)
-- 
1.7.4.4

