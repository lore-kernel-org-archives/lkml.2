Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254Ab0HMMjC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 08:39:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49203 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab0HMMi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=sfInt06iC+ggQ2sQ5gzM+3qElS6W1a9LxId/Z6kwOloihw+JdKKuTLGhmmasBoMcU5
         2Qj53OIyjRR0NLldqIVdvmCZvNbtyhAJJG9TMvQgRkfJaAipBImR60WsLYTlLFLiKy1z
         Sv3EGrCUF9EcLrvvQInVgnrhQR3Y5hYRxt+ng=
Date: Fri, 13 Aug 2010 14:38:11 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] usb/serial/ssu100: uninitialized variable
Message-ID: <20100813123811.GA31262@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Bill Pemberton <wfp5p@virginia.edu>, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC complains about the original code, because we're using an
unintialized variable "flag".  I think we should be setting flag based
on the UART_LSR_BRK_ERROR_BITS but I'm not sure...  I don't have this
hardware.  Probably passing TTY_NORMAL is better than the current code?

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 6e82d4f..494998c 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -563,7 +563,6 @@ static int ssu100_process_packet(struct tty_struct *tty,
 				 char *packet, int len)
 {
 	int i;
-	char flag;
 	char *ch;
 
 	dbg("%s - port %d", __func__, port->number);
@@ -597,10 +596,10 @@ static int ssu100_process_packet(struct tty_struct *tty,
 	if (port->port.console && port->sysrq) {
 		for (i = 0; i < len; i++, ch++) {
 			if (!usb_serial_handle_sysrq_char(tty, port, *ch))
-				tty_insert_flip_char(tty, *ch, flag);
+				tty_insert_flip_char(tty, *ch, TTY_NORMAL);
 		}
 	} else
-		tty_insert_flip_string_fixed_flag(tty, ch, flag, len);
+		tty_insert_flip_string_fixed_flag(tty, ch, TTY_NORMAL, len);
 
 	return len;
 }
