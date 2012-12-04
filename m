Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2LDHka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:40:30 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53154 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab2LDHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:40:28 -0500
Message-ID: <50BDA8DA.7070109@ilyx.ru>
Date: Tue, 04 Dec 2012 11:40:10 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 0/9] tty: Fix buffer work access-after-free
References: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012 11:07, Peter Hurley wrote:
> This patch series addresses the causes of flush_to_ldisc accessing
> the tty after freeing.
> 

I think, it is have sense only if you can take effect,
with this patch or something like. I can't. :)

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 2ea176b..f24751d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -170,6 +170,10 @@ struct tty_struct *alloc_tty_struct(void)
 	return kzalloc(sizeof(struct tty_struct), GFP_KERNEL);
 }

+static void flush_to_ldisc2(struct work_struct *work)
+{
+	printk(KERN_WARNING "Possible intrusion detected.\n");
+}
 /**
  *	free_tty_struct		-	free a disused tty
  *	@tty: tty struct to free
@@ -188,6 +192,8 @@ void free_tty_struct(struct tty_struct *tty)
 	kfree(tty->write_buf);
 	tty_buffer_free_all(tty);
 	tty->magic = 0xDEADDEAD;
+	PREPARE_WORK(&tty->buf.work,flush_to_ldisc2);
+	//memset(tty, 0, sizeof(struct tty_struct));
 	kfree(tty);
 }
