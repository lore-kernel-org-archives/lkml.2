Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0CaAWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:22:52 -0400
Received: from kroah.org ([198.145.64.141]:49095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab0C3XMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:42 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:43 2010
Message-Id: <20100330225842.638011337@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jean Delvare <jdelvare@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [55/89] hwmon: (fschmd) Fix a memleak on multiple opens of /dev/watchdog
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit c453615f77aa51593c1c9c9031b4278797d3fd19 upstream.

When /dev/watchdog gets opened a second time we return -EBUSY, but
we already have got a kref then, so we end up leaking our data struct.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/hwmon/fschmd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -767,6 +767,7 @@ leave:
 static int watchdog_open(struct inode *inode, struct file *filp)
 {
 	struct fschmd_data *pos, *data = NULL;
+	int watchdog_is_open;
 
 	/* We get called from drivers/char/misc.c with misc_mtx hold, and we
 	   call misc_register() from fschmd_probe() with watchdog_data_mutex
@@ -781,10 +782,12 @@ static int watchdog_open(struct inode *i
 		}
 	}
 	/* Note we can never not have found data, so we don't check for this */
-	kref_get(&data->kref);
+	watchdog_is_open = test_and_set_bit(0, &data->watchdog_is_open);
+	if (!watchdog_is_open)
+		kref_get(&data->kref);
 	mutex_unlock(&watchdog_data_mutex);
 
-	if (test_and_set_bit(0, &data->watchdog_is_open))
+	if (watchdog_is_open)
 		return -EBUSY;
 
 	/* Start the watchdog */


