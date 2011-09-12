Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1ILFKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 01:10:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57845 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1ILFKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 01:10:39 -0400
MIME-Version: 1.0
From: Greg Lee <glee@swspec.com>
Date: Mon, 12 Sep 2011 01:10:17 -0400
X-Google-Sender-Auth: MKifcm5WWryJlvDjwOZC4eMT-nE
Message-ID: <CADB-PD0N+tEC0H_iKzvV4Ms2snAJ3-+Lnk7tNF5=egAHdVuARQ@mail.gmail.com>
Subject: [PATCH] Add WDIOC_GETTIMELEFT ioctl support to w83627 watchdog driver
To: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add WDIOC_GETTIMELEFT ioctl allowing you to check how much time is left
on the watchdog counter before a reset occurs.

Signed-off-by: Greg Lee <glee [at] swspec.com>

---
--- linux-3.1-rc5.orig/drivers/watchdog/w83627hf_wdt.c
+++ linux-3.1-rc5.mine/drivers/watchdog/w83627hf_wdt.c
@@ -176,6 +176,23 @@ static int wdt_set_heartbeat(int t)
        return 0;
 }

+static int wdt_get_time_left(void){
+       int timeleft;
+
+       spin_lock(&io_lock);
+
+       w83627hf_select_wd_register();
+
+       outb_p(0xF6, WDT_EFER);    /* Select CRF6 */
+       timeleft = inb_p(WDT_EFDR); /* Read Timeout counter to CRF6 */
+
+       w83627hf_unselect_wd_register();
+
+       spin_unlock(&io_lock);
+
+       return timeleft;
+}
+
 static ssize_t wdt_write(struct file *file, const char __user *buf,
                                                size_t count, loff_t *ppos)
 {
@@ -202,7 +219,7 @@ static long wdt_ioctl(struct file *file,
 {
        void __user *argp = (void __user *)arg;
        int __user *p = argp;
-       int new_timeout;
+       int timeval;
        static const struct watchdog_info ident = {
                .options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
                                                        WDIOF_MAGICCLOSE,
@@ -238,14 +255,17 @@ static long wdt_ioctl(struct file *file,
                wdt_ping();
                break;
        case WDIOC_SETTIMEOUT:
-               if (get_user(new_timeout, p))
+               if (get_user(timeval, p))
                        return -EFAULT;
-               if (wdt_set_heartbeat(new_timeout))
+               if (wdt_set_heartbeat(timeval))
                        return -EINVAL;
                wdt_ping();
                /* Fall */
        case WDIOC_GETTIMEOUT:
                return put_user(timeout, p);
+       case WDIOC_GETTIMELEFT:
+               timeval = wdt_get_time_left();
+               return put_user(timeval, p);
        default:
                return -ENOTTY;
        }
