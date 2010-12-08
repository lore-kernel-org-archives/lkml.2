Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990Ab0LHBiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:38:10 -0500
Received: from kroah.org ([198.145.64.141]:48934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab0LHBBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:07 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:33 2010
Message-Id: <20101208005733.478414057@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [121/289] xen: ensure that all event channels start off bound to VCPU 0
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/events.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -261,7 +261,7 @@ static void init_evtchn_cpu_bindings(voi
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(cpu_evtchn_mask(0)));
+	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
 }
 
 static inline void clear_evtchn(int port)


