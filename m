Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1BVWWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:02 -0500
Received: from kroah.org ([198.145.64.141]:46777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1BVWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.000392632@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>
Subject: [40/70] workqueue: make sure MAYDAY_INITIAL_TIMEOUT is at least 2 jiffies long
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 3233cdbd9fa347a6d6897a94cc6ed0302ae83c4f upstream.

MAYDAY_INITIAL_TIMEOUT is defined as HZ / 100 and depending on
configuration may end up 0 or 1.  Even when it's 1, depending on when
the mayday timer is added in the current jiffy interval, it may expire
way before a jiffy has passed.

Make sure MAYDAY_INITIAL_TIMEOUT is at least two to guarantee that at
least a full jiffy has passed before calling rescuers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/workqueue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -79,7 +79,9 @@ enum {
 	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
 	IDLE_WORKER_TIMEOUT	= 300 * HZ,	/* keep idle ones for 5 mins */
 
-	MAYDAY_INITIAL_TIMEOUT	= HZ / 100,	/* call for help after 10ms */
+	MAYDAY_INITIAL_TIMEOUT  = HZ / 100 >= 2 ? HZ / 100 : 2,
+						/* call for help after 10ms
+						   (min two ticks) */
 	MAYDAY_INTERVAL		= HZ / 10,	/* and then every 100ms */
 	CREATE_COOLDOWN		= HZ,		/* time to breath after fail */
 	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */


