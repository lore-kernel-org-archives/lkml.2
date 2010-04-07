Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab0DGQ1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:27:39 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:17492 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753535Ab0DGQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:27:38 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 12:27:37 EDT
Message-ID: <4BBCB0E7.9000701@draigBrady.com>
Date: Wed, 07 Apr 2010 17:20:55 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: linux-kernel@vger.kernel.org, wim@iguana.be, seth.heasley@intel.com
Subject: Re: [PATCH] iTCO_wdt: Don't double the requested timeout
References: <20100223164019.60a6de1a@marrow.netinsight.se>	<4B840154.1010501@draigBrady.com>	<4B840BC6.9090809@draigBrady.com> <20100224101618.39c3468b@marrow.netinsight.se> <4B855140.7030408@draigBrady.com>
In-Reply-To: <4B855140.7030408@draigBrady.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/10 16:18, Pádraig Brady wrote:
> On 24/02/10 09:16, Simon Kagstrom wrote:
>> On Tue, 23 Feb 2010 17:09:26 +0000
>> Pádraig Brady<P@draigBrady.com>  wrote:
>>
>>> Actually looking at that code I noticed that it wasn't
>>> accounting for the timer counting down twice before reboot,
>>> which I thought was the case for ICH4 at least.
>>> The following is not even compiled, nor am I sure it
>>> applies to TCO v2. Testing/info appreciated.
>>
>> I tested your change on our TCO v1-based board, and it doubles the time
>> until the watchdog triggers. So:
> 
> Well it should be halving the timeout :)
> I amended the patch and Simon retested to verify
> that it now honors the requested timeout.
> 
> I also checked an ICH7 box here and it doesn't
> seem to need the adjustment, so I've amended the patch accordingly.
> 
> Wim, please apply, thanks...

In further testing it was seen that the "timer status" bit
needs to be cleared at each pat of the watchdog so as
to support timeouts in the 34s to 76s range.
This was done with: outb (0x08, TCO1_STS);
The updated patch is below.

cheers,
Pádraig.

iTCO_wdt: fix TCO V1 timeout values and limits

For TCO V1 devices the programmed timeout was twice too long
because the fact that the TCO V1 timer needs to count down
twice before triggering the watchdog, wasn't accounted for.
Also the timeout values in the module description and error
message were clarified.

Signed-off-by: Pádraig Brady <P@draigBrady.com>
Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.se>

--- a/iTCO_wdt.c	2010-04-06 15:00:41.000000000 +0000
+++ b/iTCO_wdt.c	2010-04-07 16:08:27.000000000 +0000
@@ -391,8 +391,8 @@
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
-	"(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
+MODULE_PARM_DESC(heartbeat, "Watchdog timeout in seconds. "
+	"5..76 (TCO v1) or 3..614 (TCO v2), default="
 				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");

 static int nowayout = WATCHDOG_NOWAYOUT;
@@ -408,8 +408,12 @@
 static inline unsigned int seconds_to_ticks(int seconds)
 {
 	/* the internal timer is stored as ticks which decrement
-	 * every 0.6 seconds */
-	return (seconds * 10) / 6;
+	 * every 0.6 seconds. For TCO v1 the timer counts down
+	 * twice before triggering the watchdog */
+	if (iTCO_wdt_private.iTCO_version == 1)
+		return (seconds * 5) / 6;
+	else
+		return (seconds * 10) / 6;
 }

 static void iTCO_wdt_set_NO_REBOOT_bit(void)
@@ -521,10 +525,15 @@
 	iTCO_vendor_pre_keepalive(iTCO_wdt_private.ACPIBASE, heartbeat);

 	/* Reload the timer by writing to the TCO Timer Counter register */
-	if (iTCO_wdt_private.iTCO_version == 2)
-		outw(0x01, TCO_RLD);
-	else if (iTCO_wdt_private.iTCO_version == 1)
+	if (iTCO_wdt_private.iTCO_version == 1) {
+		/* Reset the timeout status bit so that the timer
+		 * needs to count down twice again before rebooting */
+		outb (0x08, TCO1_STS); /* write 1 to clear bit */
+
 		outb(0x01, TCO_RLD);
+	} else if (iTCO_wdt_private.iTCO_version == 2)
+		outw(0x01, TCO_RLD);
+	}

 	spin_unlock(&iTCO_wdt_private.io_lock);
 	return 0;
@@ -843,9 +852,14 @@
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
+		int tco_min=5; int tco_max=76; /* TCO V1 */
+		if (iTCO_wdt_private.iTCO_version == 2) {
+			tco_min=3; tco_max=614;
+		}
 		printk(KERN_INFO PFX
-			"heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
-				"or 613 (TCO v2), using %d\n", heartbeat);
+			"timeout value %d is not between %d and %d"
+			" inclusive, using %d\n",
+			heartbeat, tco_min, tco_max, WATCHDOG_HEARTBEAT);
 	}

 	ret = misc_register(&iTCO_wdt_miscdev);
