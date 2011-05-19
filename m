Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934309Ab1ESS2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:28:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48164 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933941Ab1ESSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:25:54 -0400
X-Sasl-enc: StP7qbNI7eDMHrklwaU7fOEYXlBXx4Nf/3hwMNK04z+W 1305829553
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:24:37 2011
Message-Id: <20110519182437.773080895@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:23:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [15/21] clocksource: Install completely before selecting
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: john stultz <johnstul@us.ibm.com>

commit e05b2efb82596905ebfe88e8612ee81dec9b6592 upstream.

Christian Hoffmann reported that the command line clocksource override
with acpi_pm timer fails:

 Kernel command line: <SNIP> clocksource=acpi_pm
 hpet clockevent registered
 Switching to clocksource hpet
 Override clocksource acpi_pm is not HRT compatible.
 Cannot switch while in HRT/NOHZ mode.

The watchdog code is what enables CLOCK_SOURCE_VALID_FOR_HRES, but we
actually end up selecting the clocksource before we enqueue it into
the watchdog list, so that's why we see the warning and fail to switch
to acpi_pm timer as requested. That's particularly bad when we want to
debug timekeeping related problems in early boot.

Put the selection call last.

Reported-by: Christian Hoffmann <email@christianhoffmann.info>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/%3C1304558210.2943.24.camel%40work-vm%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/clocksource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -561,8 +561,8 @@ int clocksource_register(struct clocksou
 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
-	clocksource_select();
 	clocksource_enqueue_watchdog(cs);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }


