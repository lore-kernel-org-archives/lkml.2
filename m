Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0JIWgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:36:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41374 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0JIWgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:36:17 -0400
From: James Hogan <james@albanarts.com>
To: linux-pm@lists.linux-foundation.org
Subject: [PATCH 1/2] pm_trace: Lock pm device list mutex.
Date: Sat, 9 Oct 2010 23:36:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
References: <201010092334.27808.james@albanarts.com>
In-Reply-To: <201010092334.27808.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010092336.11548.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lock the pm device list mutex using device_pm_lock() and
device_pm_unlock() around the list iteration in show_dev_hash().

show_dev_hash() was reverse iterating dpm_list without first locking the
mutex that the functions in drivers/base/power/main.c lock. I assume
this was unintentional since there is no comment suggesting why the lock
might not be necessary.

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/base/power/trace.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 0a1a2c4..17e24e3 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -188,8 +188,10 @@ static int show_file_hash(unsigned int value)
 static int show_dev_hash(unsigned int value)
 {
 	int match = 0;
-	struct list_head *entry = dpm_list.prev;
+	struct list_head *entry;
 
+	device_pm_lock();
+	entry = dpm_list.prev;
 	while (entry != &dpm_list) {
 		struct device * dev = to_device(entry);
 		unsigned int hash = hash_string(DEVSEED, dev_name(dev), DEVHASH);
@@ -199,6 +201,7 @@ static int show_dev_hash(unsigned int value)
 		}
 		entry = entry->prev;
 	}
+	device_pm_unlock();
 	return match;
 }
 
-- 
1.7.2.3

