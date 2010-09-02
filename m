Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0IBOQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:16:40 -0400
Received: from drzdedi.ed3l.fr ([88.191.71.8]:44395 "EHLO drzdedi.nathael.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754295Ab0IBOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:16:39 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Sep 2010 10:16:38 EDT
Message-ID: <4C7FAF58.9030700@ed3l.fr>
Date: Thu, 02 Sep 2010 16:06:16 +0200
From: Nathael Pajani <nathael.pajani@ed3l.fr>
Reply-To: nathael.pajani@ed3l.fr
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH 1/1] tty : fix tty_line must not be equal to number of allocated
 tty pointers in tty driver
Content-Type: multipart/mixed;
 boundary="------------000606080304050805010505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000606080304050805010505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I found a bug "by chance" in drivers/char/tty_io.c

I mean "by chance" because I was just reading the code of the tty_find_polling_driver() to 
make a new tty_find_by_name() function.

---
In tty_find_polling_driver() the driver actually test "tty_line <= p->num" while num 
refers to the number of struct tty_struct pointers allocated for the p->ttys (p is a 
tty_driver), and tty_line is scanned in a tty name, which can be for example ttyS2. Then 
tty_line equals 2. And if p->num is 2, we have only p->ttys[0] and p->ttys[1], but no 
p->ttys[2].

This is actually unharmful, for tty_find_polling_driver() is used only in 
drivers/serial/kgdboc.c, and there's a test over there to find a console with a matching 
index, which will never happen.

This is still a bug anyway.

Signed-off-by: Nathael Pajani <nathael.pajani@ed3l.fr>
---

patch against 2bfc96a127bc1cc94d26bfaa40159966064f9c8c (Linux 2.6.36-rc3) :


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 949067a..613c852 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -355,7 +355,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
         if (*stp == '\0')
             stp = NULL;

-       if (tty_line >= 0 && tty_line <= p->num && p->ops &&
+       if (tty_line >= 0 && tty_line < p->num && p->ops &&
             p->ops->poll_init && !p->ops->poll_init(p, tty_line, stp)) {
             res = tty_driver_kref_get(p);
             *line = tty_line;



Have fun.
+++

-- 
Nathaël PAJANI
ED3L - Etude et Développement - Linux et Logiciels Libres
Internet : http://www.ed3l.fr

--------------000606080304050805010505
Content-Type: text/x-diff;
 name="patch_tty_io_tty_line_cannot_equal_allocated_tty_num.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="patch_tty_io_tty_line_cannot_equal_allocated_tty_num.patch"

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 949067a..613c852 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -355,7 +355,7 @@ struct tty_driver *tty_find_polling_driver(char *name, int *line)
 		if (*stp == '\0')
 			stp = NULL;
 
-		if (tty_line >= 0 && tty_line <= p->num && p->ops &&
+		if (tty_line >= 0 && tty_line < p->num && p->ops &&
 		    p->ops->poll_init && !p->ops->poll_init(p, tty_line, stp)) {
 			res = tty_driver_kref_get(p);
 			*line = tty_line;

--------------000606080304050805010505--
