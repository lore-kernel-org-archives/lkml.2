Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0LDVFa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 16:05:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55337 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab0LDVF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 16:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nmKCZfypwIi29ucKxpZcNqXUGW9WC/nknq0jOj3nzlylJ6ywszcZEg7ENMpcJC3xh8
         SMsuDpSueWEMv2YiTNwnPhWItbNTNl40TzeYYugPcXlRxeCjM7bewcTEPnmrGqEBAfcY
         GYRJ2ayFuiSJ/5XHNyKZf5ZwJhtRQPHO89bqk=
Date: Sun, 5 Dec 2010 00:05:22 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: rc: ir-lirc-codec: fix integer overflow
Message-ID: <20101204210522.GA5244@albatros>
References: <20101202045126.GA1784@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101202045126.GA1784@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'n' may be bigger than MAX_INT*sizeof(int), if so checking of truncated
(int)(n/sizeof(int)) for LIRCBUF_SIZE overflows and then using nontruncated 'count'
doesn't make sense.  This is not a security issue as too big 'n' is catched in
kmalloc() in memdup_user() call.  However, it's better to prevent WARN() in kmalloc().

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/media/rc/ir-lirc-codec.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 1e87ee8..a7e91e6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -100,7 +100,8 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char *buf,
 	struct lirc_codec *lirc;
 	struct rc_dev *dev;
 	int *txbuf; /* buffer with values to transmit */
-	int ret = 0, count;
+	int ret = 0;
+	size_t count;
 
 	lirc = lirc_get_pdata(file);
 	if (!lirc)
-- 
1.7.0.4
