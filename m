Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0EYK1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 06:27:33 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57559 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab0EYK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 06:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TWvAwvq7XkxlxJ71RtbbUf0zb9QxvG+8qE6lU+WzIdBkDIWgTaLtaKcNDuhHnTwmmP
         62aKCIlZV7dEjRF6EE0qUjt02xRD9W2RqTJ/sQLn/AJFRV0FSfo03FFkRGl9hGTGAuJP
         hXEfJ62f+3ZqDbLp36YYlzsGcyqHmm+3tX0t8=
Date: Tue, 25 May 2010 14:27:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Daniel Mack <daniel@caiaq.de>
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20100525102722.GA2613@oksana.dev.rtsoft.ru>
References: <201005250028.24687.rjw@sisk.pl>
 <201005250220.45889.rjw@sisk.pl>
 <20100525004744.GS30801@buzzloop.caiaq.de>
 <201005250255.11924.rjw@sisk.pl>
 <20100525070844.GV30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100525070844.GV30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull from

  git://git.infradead.org/battery-2.6.git master

to receive a fixup for regression reported by Rafael J. Wysocki
http://lkml.org/lkml/2010/5/24/273

Thanks!

commit bbabb158f0e9d41174ae5c2183a8e4f981daf6ce
Author: Daniel Mack <daniel@caiaq.de>
Date:   Tue May 25 02:39:45 2010 +0200

    power_supply: Fix regression for 'type' property
    
    Commit 5f487cd34f4337f9bc27ca19da72a39d1b0a0ab4 (power_supply: Use
    attribute groups) causes a regression the power supply core does not
    export the 'type' attribute anymore.
    
    POWER_SUPPLY_PROP_TYPE is handled by the power supply core without the
    low-level driver, so power_supply_attr_is_visible() must always return
    the entry as readable.
    
    Reported-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Daniel Mack <daniel@caiaq.de>
    Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 6a86cdf..9d30eeb 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -179,14 +179,16 @@ static mode_t power_supply_attr_is_visible(struct kobject *kobj,
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct power_supply *psy = dev_get_drvdata(dev);
+	mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
 	int i;
 
+	if (attrno == POWER_SUPPLY_PROP_TYPE)
+		return mode;
+
 	for (i = 0; i < psy->num_properties; i++) {
 		int property = psy->properties[i];
 
 		if (property == attrno) {
-			mode_t mode = S_IRUSR | S_IRGRP | S_IROTH;
-
 			if (psy->property_is_writeable &&
 			    psy->property_is_writeable(psy, property) > 0)
 				mode |= S_IWUSR;
