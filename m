Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512Ab0EJXpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:45:32 -0400
Received: from kroah.org ([198.145.64.141]:32883 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab0EJWvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:18 2010
Message-Id: <20100510223317.996822645@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [009/117] w1: w1 temp: fix negative termperature calculation
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ian Dall <ian@beware.dropbear.id.au>

commit 9a6a1ecd9e9b5d046a236da2f7eb6b6812f04229 upstream.

Fix regression caused by commit 507e2fbaaacb6f164b4125b87c5002f95143174b
("w1: w1 temp calculation overflow fix") whereby negative temperatures for
the DS18B20 are not converted properly.

When the temperature exceeds 32767 milli-degrees the temperature overflows
to -32768 millidegrees.  These are both well within the -55 - +125 degree
range for the sensor.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=12646

Signed-of-by: Ian Dall <ian@beware.dropbear.id.au>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Tested-by: Karsten Elfenbein <kelfe@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/w1/slaves/w1_therm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -115,9 +115,8 @@ static struct w1_therm_family_converter
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
 {
-	int t = ((s16)rom[1] << 8) | rom[0];
-	t = t*1000/16;
-	return t;
+	s16 t = le16_to_cpup((__le16 *)rom);
+	return t*1000/16;
 }
 
 static inline int w1_DS18S20_convert_temp(u8 rom[9])


