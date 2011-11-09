Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777Ab1KJDqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:46:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965746Ab1KJDqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:46:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:03 2011
Message-Id: <20111109213203.336714741@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [208/264] hwmon: (w83627ehf) Properly report PECI and AMD-SI sensor types
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit 2265cef2751b3441df91f85e0107f9f549e5b711 upstream.

When temperature sources are PECI or AMD-SI agents, it makes no sense
to report their type as diode or thermistor. Instead we must report
their digital nature.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627ehf.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1756,7 +1756,14 @@ static inline void __devinit w83627ehf_i
 		diode = 0x70;
 	}
 	for (i = 0; i < 3; i++) {
-		if ((tmp & (0x02 << i)))
+		const char *label = data->temp_label[data->temp_src[i]];
+
+		/* Digital source overrides analog type */
+		if (strncmp(label, "PECI", 4) == 0)
+			data->temp_type[i] = 6;
+		else if (strncmp(label, "AMD", 3) == 0)
+			data->temp_type[i] = 5;
+		else if ((tmp & (0x02 << i)))
 			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 3;
 		else
 			data->temp_type[i] = 4; /* thermistor */


