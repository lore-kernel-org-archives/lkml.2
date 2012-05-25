Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2EYIXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:23:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42118 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2EYIXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:23:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120525000934.78136313@pyramind.ukuu.org.uk>
References: <20110216161728.GA8431@darkside.kls.lan>
	<20110310014952.38b7a6ef@redhat.com>
	<CAJJYPdmmaDuW-yhLQbGj9ihfiJOp5K_C_Vn6dCTzmr0A_gaKjg@mail.gmail.com>
	<CAJJYPdnTMZiTi6OT2cqk_h_e8+m8iGZqVK_zazLM39eFWLf5xw@mail.gmail.com>
	<20120525000934.78136313@pyramind.ukuu.org.uk>
Date: Fri, 25 May 2012 10:23:01 +0200
Message-ID: <CAJJYPdnj02UV_9nAT908SOqGgTGu8nTGoXSpJnHz7O7yJENvpg@mail.gmail.com>
Subject: Re: kernel BUG and freeze on cat /proc/tty/driver/serial
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>,
        "Mario 'BitKoenig' Holbe" <Mario.Holbe@tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/25 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> -       struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
>> +       struct tty_ldisc *ld = port ? tty_ldisc_ref(port->tty) : NULL;
>>         struct pps_event_time ts;
>>
>>         if (ld && ld->ops->dcd_change)
>> @@ -2465,7 +2465,7 @@ void uart_handle_dcd_change(struct uart_port
>> *uport, unsigned int status)
>>                 hardpps();
>>  #endif
>>
>> -       if (port->flags & ASYNC_CHECK_CD) {
>> +       if (port && port->flags & ASYNC_CHECK_CD) {
>>                 if (status)
>>                         wake_up_interruptible(&port->open_wait);
>>                 else if (port->tty)
>
> Probably should be using tty krefs for this
>
>        tty = tty_port_tty_get( ..) /  tty_kref_put
>
> etc, and yes the NULL check is needed. The reference is needed so the tty
> can't be freed under you.
>
>
>

So you mean something like this ?
(going to test it)

Subject: [PATCH 6/6] tty check

---
 drivers/tty/serial/serial_core.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 9c4c05b..10f07ce 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2452,8 +2452,8 @@ EXPORT_SYMBOL(uart_match_port);
 void uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
 {
 	struct uart_state *state = uport->state;
-	struct tty_port *port = &state->port;
-	struct tty_ldisc *ld = tty_ldisc_ref(port->tty);
+	struct tty_struct *tty = tty_port_tty_get(&state->port);
+	struct tty_ldisc *ld = (tty) ? tty_ldisc_ref(tty) : NULL;
 	struct pps_event_time ts;

 	if (ld && ld->ops->dcd_change)
@@ -2465,17 +2465,19 @@ void uart_handle_dcd_change(struct uart_port
*uport, unsigned int status)
 		hardpps();
 #endif

-	if (port->flags & ASYNC_CHECK_CD) {
+	if (tty && (tty->flags & ASYNC_CHECK_CD)) {
 		if (status)
-			wake_up_interruptible(&port->open_wait);
-		else if (port->tty)
-			tty_hangup(port->tty);
+			wake_up_interruptible(&state->port.open_wait);
+		else
+			tty_hangup(tty);
 	}

 	if (ld && ld->ops->dcd_change)
-		ld->ops->dcd_change(port->tty, status, &ts);
+		ld->ops->dcd_change(tty, status, &ts);
 	if (ld)
 		tty_ldisc_deref(ld);
+	if (tty)
+		tty_kref_put(tty);
 }
 EXPORT_SYMBOL_GPL(uart_handle_dcd_change);
