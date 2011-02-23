Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1BWUpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:45:52 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:32208 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755808Ab1BWUpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:45:51 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANsAZU1R8sEZ/2dsb2JhbACmIHS8HA2FUQQ
Date: Wed, 23 Feb 2011 21:45:49 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RFC] [PATCH 10/10] Generic Watchdog Timer Driver
Message-ID: <20110223204549.GA7497@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c5651be8a416dd427f4a5f184e1d87b37631d15b
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jul 18 10:59:56 2010 +0000

    watchdog: WatchDog Timer Driver Core - Part 10
    
    Add support for extra ioctl calls by adding a
    ioctl watchdog operation. This operation will be
    called before we do our own handling of ioctl
    commands. This way we can override the internal
    ioctl command handling and we can also add
    extra ioctl commands. The ioctl watchdog operation
    should return the appropriate error codes or
    -ENOIOCTLCMD if the ioctl command should be handled
    through the internal ioctl handling of the framework.
    
    Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
index aa4f836..ad5ff57 100644
--- a/Documentation/watchdog/watchdog-kernel-api.txt
+++ b/Documentation/watchdog/watchdog-kernel-api.txt
@@ -74,6 +74,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 It is important that you first define the module owner of the watchdog timer
@@ -119,6 +120,10 @@ they are supported. These optional routines/operations are:
   was just used to re-program the watchdog timer device.
   (Note: the WDIOF_SETTIMEOUT needs to be set in the options field of the
   watchdog's info structure).
+* ioctl: if this routine is present then it will be called first before we do
+  our own internal ioctl call handling. This routine should return -ENOIOCTLCMD
+  if a command is not supported. The parameters that are passsed to the ioctl
+  call are: watchdog_device, cmd and arg.
 
 The status bits should (preferably) be set with the set_bit and clear_bit alike
 bit-operations. The status bit's that are defined are:
diff --git a/drivers/watchdog/core/watchdog_dev.c b/drivers/watchdog/core/watchdog_dev.c
index ad080fe..15865db 100644
--- a/drivers/watchdog/core/watchdog_dev.c
+++ b/drivers/watchdog/core/watchdog_dev.c
@@ -207,6 +207,12 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
 
 	trace("%p, %u, %li", file, cmd, arg);
 
+	if (wdd->ops->ioctl) {
+		err = wdd->ops->ioctl(wdd, cmd, arg);
+		if (err != -ENOIOCTLCMD)
+			return err;
+	}
+
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, wdd->info,
diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
index d264493..447a2e5 100644
--- a/include/linux/watchdog.h
+++ b/include/linux/watchdog.h
@@ -72,6 +72,7 @@ struct watchdog_ops {
 	int (*ping)(struct watchdog_device *);
 	int (*status)(struct watchdog_device *);
 	int (*set_timeout)(struct watchdog_device *, int);
+	long (*ioctl)(struct watchdog_device *, unsigned int, unsigned long);
 };
 
 /* The structure that defines a watchdog device */
