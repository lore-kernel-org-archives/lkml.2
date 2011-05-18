Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1ERO0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 10:26:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab1ERO0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 10:26:42 -0400
Date: Wed, 18 May 2011 16:26:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: NULL pointer deref in tty port / uart
Message-ID: <20110518142631.GB2011@jolsa.brq.redhat.com>
References: <20110517231229.GB1776@nowhere>
 <20110518004420.2b8f5da9@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518004420.2b8f5da9@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 12:44:20AM +0100, Alan Cox wrote:
> > 	echo 1 > /dev/ttyS4 # which blocks
> > 
> > And on another console:
> > 
> > 	cat /dev/ttyS4 # which blocks
> > 
> > Then Ctrl + C the echo in the first console. This produces the
> > following trace:
> 
> First cat is in tty_port_block_til_ready, second cat joins it there. ^C
> causes one to close, which wakes the second which goes around the loop
> again, tries to raise the carrier and explodes, it seems because
> someone trashed memory it is using.
> 
> Not quite sure why at this point
> 
> On the first exit of the open path port->count is 1 which is as we want
> it. Close takes it down to zero which triggers the port shutdown path
> which is as we want. We clean up port->tty and shut down the port.
> Seeing the second pending open we wake it which is when it goes kaboom
> 
> Nothing obvious strikes me from reading the code.

hi,

have the same issue.. looks like we should not NULL the port->tty
if there's blocked open, but not sure what's exactly the logic
behind "port's block_open and count" ..

attached patch fixes it for me

wbr,
jirka

---
 drivers/tty/serial/serial_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 733fe8e..86a40cb 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1346,7 +1346,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	tty_ldisc_flush(tty);
 
-	tty_port_tty_set(port, NULL);
+	if (!tty_port_users(port))
+		tty_port_tty_set(port, NULL);
+
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
 
-- 
1.7.1
