Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1KJExi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:53:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42876 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935331Ab1KJDbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.897270478@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [212/262] hwmon: (w83627ehf) Fix broken driver init
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit bfa02b0da66965caf46e441270af87edda4fea14 upstream.

Commit 2265cef2 (hwmon: (w83627ehf) Properly report PECI and AMD-SI
sensor types) results in kernel panic if data->temp_label was not
initialized.
The problem was found with chip W83627DHG-P.

Add check if data->temp->label was set before use.

Based on incomplete patch by Alexander Beregalov.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Tested-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627ehf.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1756,12 +1756,15 @@ static inline void __devinit w83627ehf_i
 		diode = 0x70;
 	}
 	for (i = 0; i < 3; i++) {
-		const char *label = data->temp_label[data->temp_src[i]];
+		const char *label = NULL;
+
+		if (data->temp_label)
+			label = data->temp_label[data->temp_src[i]];
 
 		/* Digital source overrides analog type */
-		if (strncmp(label, "PECI", 4) == 0)
+		if (label && strncmp(label, "PECI", 4) == 0)
 			data->temp_type[i] = 6;
-		else if (strncmp(label, "AMD", 3) == 0)
+		else if (label && strncmp(label, "AMD", 3) == 0)
 			data->temp_type[i] = 5;
 		else if ((tmp & (0x02 << i)))
 			data->temp_type[i] = (diode & (0x10 << i)) ? 1 : 3;


