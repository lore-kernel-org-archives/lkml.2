Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2KMHqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:46:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47938 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2KMHqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:46:31 -0500
Date: Tue, 13 Nov 2012 10:44:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ALSA: es1968: precedence bug in snd_es1968_tea575x_get_pins()
Message-ID: <20121113074454.GB13198@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this works as intended.  '|' higher precedence than ?: so
the bitwize OR "0 | (val & STR_MOST)" is a no-op.

I have re-written it to be more clear.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have a way to test this.

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 50169bc..7266020 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2581,9 +2581,14 @@ static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
 	struct es1968 *chip = tea->private_data;
 	unsigned long io = chip->io_port + GPIO_DATA;
 	u16 val = inw(io);
-
-	return  (val & STR_DATA) ? TEA575X_DATA : 0 |
-		(val & STR_MOST) ? TEA575X_MOST : 0;
+	u8 ret;
+
+	ret = 0;
+	if (val & STR_DATA)
+		ret |= TEA575X_DATA;
+	if (val & STR_MOST)
+		ret |= TEA575X_MOST;
+	return ret;
 }
 
 static void snd_es1968_tea575x_set_direction(struct snd_tea575x *tea, bool output)
