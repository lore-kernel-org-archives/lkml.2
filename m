Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab0KLLOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:20 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:37181 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0KLLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:16 -0500
Subject: [PATCH 02/17] staging/vme_user: return the appropriate error code
	when module_init fails
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:14 +0000
Message-ID: <20101112111414.11631.51853.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

When init_module fails, 0 is returned anyway; the module is then installed
and oopses when we try to remove it:

[ 3236.368009] WARNING: at drivers/base/driver.c:262 driver_unregister+0x36/0x6f()
[ 3236.368012] Hardware name:
[ 3236.368014] Unexpected driver unregister!
[ 3236.368016] Modules linked in: vme_user(-) vme_tsi148 vme e1000e iTCO_wdt iTCO_vendor_support [last unloaded: vme]
[ 3236.368027] Pid: 16162, comm: rmmod Not tainted 2.6.35 #2
[ 3236.368029] Call Trace:
[ 3236.368037]  [<ffffffff81036ea3>] warn_slowpath_common+0x80/0x98
[ 3236.368044]  [<ffffffff81060a65>] ? __try_stop_module+0x0/0x58
[ 3236.368049]  [<ffffffff81036f4f>] warn_slowpath_fmt+0x41/0x43
[ 3236.368054]  [<ffffffff81060a65>] ? __try_stop_module+0x0/0x58
[ 3236.368059]  [<ffffffff811e8f78>] driver_unregister+0x36/0x6f
[ 3236.368066]  [<ffffffffa004aa44>] vme_unregister_driver+0xd/0xf [vme]
[ 3236.368072]  [<ffffffffa00616c8>] vme_user_exit+0x10/0x1e [vme_user]
[ 3236.368076]  [<ffffffff810612c1>] sys_delete_module+0x1ba/0x226
[ 3236.368082]  [<ffffffff812d6e14>] ? do_page_fault+0x25d/0x28a
[ 3236.368088]  [<ffffffff8100202b>] system_call_fastpath+0x16/0x1b
[ 3236.368092] ---[ end trace cab6d88ebc44c1de ]---

The appended fixes it by returning the appropriate error code in module_init
whenever something goes wrong, thus cancelling the insertion of the module.

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index cbe2e11..a6f6116 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -611,6 +611,7 @@ static int __init vme_user_init(void)
 	if (bus_num == 0) {
 		printk(KERN_ERR "%s: No cards, skipping registration\n",
 			driver_name);
+		retval = -ENODEV;
 		goto err_nocard;
 	}
 
@@ -629,6 +630,7 @@ static int __init vme_user_init(void)
 	if (ids == NULL) {
 		printk(KERN_ERR "%s: Unable to allocate ID table\n",
 			driver_name);
+		retval = -ENOMEM;
 		goto err_id;
 	}
 


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
