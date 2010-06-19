Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0FSMhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 08:37:04 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:52011 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755610Ab0FSMhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 08:37:00 -0400
Date: Sat, 19 Jun 2010 14:36:47 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Another PCMCIA regression
Message-ID: <20100619123647.GC5575@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.1005251619020.12278@hs20-bc2-1.build.redhat.com>
 <20100526113515.GA7219@comet.dominikbrodowski.net>
 <20100602143822.GA11506@isilmar-3.linta.de>
 <Pine.LNX.4.64.1006141335540.24598@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006141335540.24598@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas,

many thanks for tracking down this issue. Does the following patch
(instead of the one you provided) help, too?

Thanks & best,
	Dominik


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Sat, 19 Jun 2010 14:33:56 +0200
Subject: [PATCH] pcmcia: do not initialize the present flag too late.

The "present" flag was initialized too late -- possibly, a card
was already registered at this time, so re-setting the flag to 0
caused pcmcia_dev_present() to fail.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/drivers/pcmcia/ds.c b/drivers/pcmcia/ds.c
index 9fc3398..eac9614 100644
--- a/drivers/pcmcia/ds.c
+++ b/drivers/pcmcia/ds.c
@@ -1356,6 +1356,7 @@ static int __devinit pcmcia_bus_add_socket(struct device *dev,
 	INIT_LIST_HEAD(&socket->devices_list);
 	memset(&socket->pcmcia_state, 0, sizeof(u8));
 	socket->device_count = 0;
+	atomic_set(&socket->present, 0);
 
 	ret = pccard_register_pcmcia(socket, &pcmcia_bus_callback);
 	if (ret) {
@@ -1364,8 +1365,6 @@ static int __devinit pcmcia_bus_add_socket(struct device *dev,
 		return ret;
 	}
 
-	atomic_set(&socket->present, 0);
-
 	return 0;
 }
 
