Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445Ab0GASge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:36:34 -0400
Received: from kroah.org ([198.145.64.141]:40654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758024Ab0GASXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:54 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:15 2010
Message-Id: <20100701173214.987781878@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephane Eranian <eranian@google.com>, peterz@infradead.org,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 097/149] perf_events: Fix resource leak in x86 __hw_perf_event_init()
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephane Eranian <eranian@google.com>

commit 4b24a88b35e15e04bd8f2c5dda65b5dc8ebca05f upstream.

If reserve_pmc_hardware() succeeds but reserve_ds_buffers()
fails, then we need to release_pmc_hardware. It won't be done
by the destroy() callback because we return before setting it
in case of error.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: robert.richter@amd.com
Cc: perfmon2-devel@lists.sf.net
LKML-Reference: <4ba1568b.15185e0a.182a.7802@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1005,8 +1005,11 @@ static int __hw_perf_event_init(struct p
 		if (atomic_read(&active_events) == 0) {
 			if (!reserve_pmc_hardware())
 				err = -EBUSY;
-			else
+			else {
 				err = reserve_bts_hardware();
+				if (err)
+					release_pmc_hardware();
+			}
 		}
 		if (!err)
 			atomic_inc(&active_events);


