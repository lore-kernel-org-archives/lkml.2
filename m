Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1AYKnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:43:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:50322 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1AYKnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:43:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208";a="650851292"
Date: Tue, 25 Jan 2011 18:43:02 +0800
From: Yin Kangkai <kangkai.yin@linux.intel.com>
To: linux-serial <linux-serial@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@laptop.org>,
        Jason Wang <jason77.wang@gmail.com>,
        Stanislav Brabec <sbrabec@suse.cz>, Daniel Drake <dsd@laptop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] serial-core: reset the console speed on resume
Message-ID: <20110125104302.GM3315@kai-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On some platforms, we need to restore the console speed on resume even
it was not suspended (no_console_suspend), and on others we don't have
to do that.

So don't care about the "console_suspend_enabled" and unconditionally
reset the console speed if it is a console.


This is actually a redo of ba15ab0 (Set proper console speed on resume
if console suspend is disabled) from Deepak Saxena.  I also tried to
investigate more to find out if this change will break others, here is
what I've found out:


commit 891b9dd10764352926e1e107756aa229dfa2c210
Author: Jason Wang <jason77.wang@gmail.com>
    serial-core: restore termios settings when resume console ports

commit ca2e71aa8cfb0056ce720f3fd53f59f5fac4a3e1
Author: Jason Wang <jason77.wang@gmail.com>
    serial-core: skip call set_termios/console_start when no_console_suspend

commit 4547be7809a3b775ce750ec7f8b5748954741523
Author: Stanislav Brabec <sbrabec@suse.cz>
    serial-core: resume serial hardware with no_console_suspend

commit ba15ab0e8de0d4439a91342ad52d55ca9e313f3d
Author: Deepak Saxena <dsaxena@laptop.org>
    Set proper console speed on resume if console suspend is disabled

from ba15ab0, we learned that, even if the console suspend is disabled
(when no_console_suspend is set), we may still need to "reset the port
to the state it was in before we suspended."

Then with 4547be7, this piece of code is removed.

And then Jason Wang added that back in ca2e71a and 891b9dd, to fix
some breakage on OMAP3EVM platform. From ca2e71a we learned that the
"set_termios" things is actually needed by both console is suspended
and not suspended.

That's why I removed the console_suspended_enabled condition, and only
call console_start() when we actually suspeneded it.

I also noticed in this thread:
http://marc.info/?t=129079257100004&r=1&w=2, which talked about on
some platforms, UART HW will be cut power whether or not we set
no_console_suspend, and then on resume it does not work quite well. I
have a similar HW, and this patch fixed this issue, don't know if this
patch also works on their platforms.

Thanks,
Kangkai


>From 71a5c8e88f91febcd3714bf645023a5b9a4885d8 Mon Sep 17 00:00:00 2001
From: Yin Kangkai <kangkai.yin@intel.com>
Date: Mon, 24 Jan 2011 18:07:02 +0800
Subject: [PATCH] serial-core: reset the console speed on resume

On some platforms, we need to restore the console speed on resume even
it was not suspended (no_console_suspend), and on others we don't have
to do that.

So don't care about the "console_suspend_enabled" and unconditionally
reset the console speed if it is a console.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
---
 drivers/serial/serial_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 9ffa5be..af4a4c1 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2060,7 +2060,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	/*
 	 * Re-enable the console device after suspending.
 	 */
-	if (console_suspend_enabled && uart_console(uport)) {
+	if (uart_console(uport)) {
 		/*
 		 * First try to use the console cflag setting.
 		 */
@@ -2073,9 +2073,9 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 		if (port->tty && port->tty->termios && termios.c_cflag == 0)
 			termios = *(port->tty->termios);
 
-		uart_change_pm(state, 0);
 		uport->ops->set_termios(uport, &termios, NULL);
-		console_start(uport->cons);
+		if (console_suspend_enabled)
+			console_start(uport->cons);
 	}
 
 	if (port->flags & ASYNC_SUSPENDED) {
-- 
1.6.5

-- 
Don't worry, be happy.
