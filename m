Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2LQVje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:39:34 -0500
Received: from bs1.fjl.org.uk ([84.45.41.196]:62015 "EHLO bs1.fjl.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2LQVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:39:33 -0500
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 16:39:33 EST
Message-ID: <50CF8B03.1070102@avoncliff.com>
Date: Mon, 17 Dec 2012 21:13:39 +0000
From: david <david@avoncliff.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] w1_therm:Retries:remove old code add CRC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

w1_therm includes some obsolete code to detect bad_roms, this is no
longer relevant.
The retry code is only used for this bad_rom test, however there is a
CRC check that detects a bad read, but does not trigger a retry. This
patch removes all the bad_rom code and uses the CRC check to trigger
retries.

Patch is against Raspberry 3.2.27 ( my test hardware) but has also been
tested against 3.7.

David Stevenson   david at avoncliff.com

diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index 016dd7d..8166075 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -45,10 +45,6 @@ MODULE_DESCRIPTION("Driver for 1-wire Dallas network
protocol, temperature famil
 static int w1_strong_pullup = 1;
 module_param_named(strong_pullup, w1_strong_pullup, int, 0);

-static u8 bad_roms[][9] = {
-				{0xaa, 0x00, 0x4b, 0x46, 0xff, 0xff, 0x0c, 0x10, 0x87},
-				{}
-			};

 static ssize_t w1_therm_read(struct device *device,
 	struct device_attribute *attr, char *buf);
@@ -159,16 +155,6 @@ static inline int w1_convert_temp(u8 rom[9], u8 fid)
 	return 0;
 }

-static int w1_therm_check_rom(u8 rom[9])
-{
-	int i;
-
-	for (i=0; i<sizeof(bad_roms)/9; ++i)
-		if (!memcmp(bad_roms[i], rom, 9))
-			return 1;
-
-	return 0;
-}

 static ssize_t w1_therm_read(struct device *device,
 	struct device_attribute *attr, char *buf)
@@ -183,10 +169,11 @@ static ssize_t w1_therm_read(struct device *device,

 	memset(rom, 0, sizeof(rom));

-	verdict = 0;
-	crc = 0;
-
 	while (max_trying--) {
+
+		verdict = 0;
+		crc = 0;
+		
 		if (!w1_reset_select_slave(sl)) {
 			int count = 0;
 			unsigned int tm = 750;
@@ -214,7 +201,7 @@ static ssize_t w1_therm_read(struct device *device,
 			}
 		}

-		if (!w1_therm_check_rom(rom))
+		if (verdict)
 			break;
 	}

