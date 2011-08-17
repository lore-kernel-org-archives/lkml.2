Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1HQLs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:48:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49914 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1HQLsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:48:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Russel King <linux@arm.linux.org.uk>
Subject: [PATCH] TTY: serial, document ignoring of uart->ops->startup error
Date: Wed, 17 Aug 2011 13:48:15 +0200
Message-Id: <1313581695-30520-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110817111309.6abf1fe6@lxorguk.ukuu.org.uk>
References: <20110817111309.6abf1fe6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user has SYS_ADMIN capabilities and uart->ops->startup returns
an error in uart_startup, we silently drop the error. We then return 0
and behave as if it didn't fail. (Not quite, since we set TTY_IO_ERROR
bit and leave ASYNC_INITIALIZED bit cleared.)

This all is to allow setserial to work with improperly configured or
unconfigured ports. User can thus set port properties and reconfigure
properly.

This patch only documents this behavior.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Cc: Russel King <linux@arm.linux.org.uk>
---
On 08/17/2011 12:13 PM, Alan Cox wrote:
> On Wed, 17 Aug 2011 11:25:27 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hi,
>>
>> while I was in the process of uart cleanup, I found this:
>> static int uart_startup(...) {
>>   ...
>>   retval = port->ops->startup(port);
>>   ...
>>   if (retval && capable(CAP_SYS_ADMIN))
>>     retval = 0;
>>
>>   return retval;
>> }
>>
>> Why CAP_SYS_ADMIN should not see the failing port startup? Does anybody
>> from you remember if it is for some kind of possibility to later
>> re-autoconfigure the port or something like that?
> 
> In a word - setserial

Yes, thanks. So I assume especially for the configuration of port/irq/type. So
this is why this is special to tty/serial and USB serials don't need to support
this.

 drivers/tty/serial/serial_core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index db7912c..a3efbea 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -200,6 +200,11 @@ static int uart_startup(struct tty_struct *tty, struct uart_state *state, int in
 		clear_bit(TTY_IO_ERROR, &tty->flags);
 	}
 
+	/*
+	 * This is to allow setserial on this port. People may want to set
+	 * port/irq/type and then reconfigure the port properly if it failed
+	 * now.
+	 */
 	if (retval && capable(CAP_SYS_ADMIN))
 		retval = 0;
 
-- 
1.7.6


