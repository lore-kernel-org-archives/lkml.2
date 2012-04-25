Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab2DYN4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:56:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2DYN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:56:19 -0400
Date: Wed, 25 Apr 2012 06:54:10 -0700
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, wim@iguana.be,
        thomas.mingarelli@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        thomas.mingarelli@hp.com, wim@iguana.be, akpm@linux-foundation.org,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1333051877-15755-2-git-send-email-dzickus@redhat.com>
References: <1333051877-15755-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] watchdog, hpwdt:
  Remove priority option for NMI callback
Git-Commit-ID: 09ee10143658cd021d879ead61ead72a196302b6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:54:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  09ee10143658cd021d879ead61ead72a196302b6
Gitweb:     http://git.kernel.org/tip/09ee10143658cd021d879ead61ead72a196302b6
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Thu, 29 Mar 2012 16:11:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:43:33 +0200

watchdog, hpwdt: Remove priority option for NMI callback

The NMI_UNKNOWN bucket only allows for one function to register
to it. The reason for that is because only functions which can
not determine if the NMI belongs to them or not should register
and would like to assume/swallow any NMI they see.

As a result it doesn't make sense to let more than one function
like this register.  In fact, letting a second function fail
allows us to know that more than one function is going to
swallow NMIs on the current system. This is better than silently
being ignored.

Therefore hpwdt's priority mechanism doesn't make sense any
more.  They will be always first on the NMI_UNKNOWN queue, if
they register.

Removing this parameter cleans up the code and simplifies things
for the next patch which changes how nmis are registered.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1333051877-15755-2-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/watchdog/hpwdt.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index cbc7cee..4000b80 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -147,7 +147,6 @@ struct cmn_registers {
 
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump;
-static unsigned int priority;		/* hpwdt at end of die_notify list */
 static unsigned int is_icru;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
@@ -723,13 +722,9 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	}
 
 	/*
-	 * If the priority is set to 1, then we will be put first on the
-	 * die notify list to handle a critical NMI. The default is to
-	 * be last so other users of the NMI signal can function.
+	 * Only one function can register for NMI_UNKNOWN
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
-					(priority) ? NMI_FLAG_FIRST : 0,
-					"hpwdt");
+	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout, 0, "hpwdt");
 	if (retval != 0) {
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",
@@ -740,10 +735,8 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
-			", allow kernel dump: %s (default = 0/OFF)"
-			", priority: %s (default = 0/LAST).\n",
-			(allow_kdump == 0) ? "OFF" : "ON",
-			(priority == 0) ? "LAST" : "FIRST");
+			", allow kernel dump: %s (default = 0/OFF)\n",
+			(allow_kdump == 0) ? "OFF" : "ON");
 	return 0;
 }
 
@@ -881,10 +874,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 #ifdef CONFIG_HPWDT_NMI_DECODING
 module_param(allow_kdump, int, 0);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
-
-module_param(priority, int, 0);
-MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
-		" (default = 0/Last)\n");
 #endif /* !CONFIG_HPWDT_NMI_DECODING */
 
 module_init(hpwdt_init);
