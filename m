Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab2CIQvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:51:20 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:44983 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2CIQvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:51:19 -0500
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: RE: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Thread-Topic: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI
 callback
Thread-Index: AQHM/hMxk3iRaS4pqEOOCrKMt0Y51JZiKrpg
Date: Fri, 9 Mar 2012 16:51:09 +0000
Message-ID: <9774516974AF5F4C8A2C3C69CD34123320369D9C@G9W0755.americas.hpqcorp.net>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Has this been tested with echo c > /proc/sysrg-trigger and the virtual NMI button via iLO?

-----Original Message-----
From: Don Zickus [mailto:dzickus@redhat.com] 
Sent: Friday, March 09, 2012 10:37 AM
To: x86@kernel.org
Cc: Peter Zijlstra; LKML; Don Zickus; Mingarelli, Thomas; Wim Van Sebroeck
Subject: [PATCH 1/2] watchdog, hpwdt: Remove priority option for NMI callback

The NMI_UNKNOWN bucket only allows for one function to register to it.
The reason for that is because only functions which can not determine
if the NMI belongs to them or not should register and would like to
assume/swallow any NMI they see.

As a result it doesn't make sense to let more than one function like this
register.  In fact, letting a second function fail allows us to know that
more than one function is going to swallow NMIs on the current system.
This is better than silently being ignored.

Therefore hpwdt's priority mechanism doesn't make sense any more.  They
will be always first on the NMI_UNKNOWN queue, if they register.

Removing this parameter cleans up the code and simplifies things for the
next patch which changes how nmis are registered.

Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 drivers/watchdog/hpwdt.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3c166d3..deee02c8 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -145,7 +145,6 @@ struct cmn_registers {
 
 static unsigned int hpwdt_nmi_decoding;
 static unsigned int allow_kdump;
-static unsigned int priority;		/* hpwdt at end of die_notify list */
 static unsigned int is_icru;
 static DEFINE_SPINLOCK(rom_lock);
 static void *cru_rom_addr;
@@ -730,13 +729,9 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
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
@@ -747,10 +742,8 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 
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
 
@@ -888,10 +881,6 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 #ifdef CONFIG_HPWDT_NMI_DECODING
 module_param(allow_kdump, int, 0);
 MODULE_PARM_DESC(allow_kdump, "Start a kernel dump after NMI occurs");
-
-module_param(priority, int, 0);
-MODULE_PARM_DESC(priority, "The hpwdt driver handles NMIs first or last"
-		" (default = 0/Last)\n");
 #endif /* !CONFIG_HPWDT_NMI_DECODING */
 
 module_init(hpwdt_init);
-- 
1.7.7.6

