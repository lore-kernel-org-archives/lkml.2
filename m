Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0JQPSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:18:20 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:49752 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab0JQPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:18:18 -0400
Message-ID: <4CBB13B7.8080705@web.de>
Date: Sun, 17 Oct 2010 17:18:15 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        i4ldeveloper@listserv.isdn4linux.de,
        Linux Netdev List <netdev@vger.kernel.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v2] CAPI: Silence lockdep warning on get_capi_appl_by_nr usage
References: <4CB9891B.4060606@web.de> <1287311135.1998.154.camel@laptop>
In-Reply-To: <1287311135.1998.154.camel@laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18173e638r47U7tm03EmBSR8bDI8T1QS6A+2W0A
	+yaxFtMdQiiRhhSKo6bOQIsduHmBn7EEsbNhXNBjFNCzvaKN2h
	UvpQooTtU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As long as we hold capi_controller_lock, we can safely access
capi_applications without RCU protection as no one can modify the
application list underneath us. Introduce an RCU-free
__get_capi_appl_by_nr for this purpose. This silences lockdep warnings
on suspicious rcu_dereference usage.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---

v2:
 - use lockdep_assert_held in favor of WARN_ON_ONCE(!mutex_is_locked)
   as suggested by Peter

 drivers/isdn/capi/kcapi.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/capi/kcapi.c b/drivers/isdn/capi/kcapi.c
index 2648d39..2b33b26 100644
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -99,6 +99,16 @@ static inline struct capi_ctr *get_capi_ctr_by_nr(u16 contr)
 	return capi_controller[contr - 1];
 }
 
+static inline struct capi20_appl *__get_capi_appl_by_nr(u16 applid)
+{
+	lockdep_assert_held(&capi_controller_lock);
+
+	if (applid - 1 >= CAPI_MAXAPPL)
+		return NULL;
+
+	return capi_applications[applid - 1];
+}
+
 static inline struct capi20_appl *get_capi_appl_by_nr(u16 applid)
 {
 	if (applid - 1 >= CAPI_MAXAPPL)
@@ -186,10 +196,9 @@ static void notify_up(u32 contr)
 		ctr->state = CAPI_CTR_RUNNING;
 
 		for (applid = 1; applid <= CAPI_MAXAPPL; applid++) {
-			ap = get_capi_appl_by_nr(applid);
-			if (!ap)
-				continue;
-			register_appl(ctr, applid, &ap->rparam);
+			ap = __get_capi_appl_by_nr(applid);
+			if (ap)
+				register_appl(ctr, applid, &ap->rparam);
 		}
 
 		wake_up_interruptible_all(&ctr->state_wait_queue);
@@ -216,7 +225,7 @@ static void ctr_down(struct capi_ctr *ctr, int new_state)
 	memset(ctr->serial, 0, sizeof(ctr->serial));
 
 	for (applid = 1; applid <= CAPI_MAXAPPL; applid++) {
-		ap = get_capi_appl_by_nr(applid);
+		ap = __get_capi_appl_by_nr(applid);
 		if (ap)
 			capi_ctr_put(ctr);
 	}
-- 
1.7.1
