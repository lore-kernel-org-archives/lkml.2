Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab1CILzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:55:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab1CILzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:55:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Brumlow <mbrumlow@gmail.com>
Subject: [PATCH] cris: fix locking in pcf8563.c
Date: Wed, 9 Mar 2011 12:55:28 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: tobiasa@axis.com, linux-kernel@vger.kernel.org
References: <AANLkTi=kQGB0YKOunpEEy8xQqM7UCRSCwGqWC5TxJHY8@mail.gmail.com>
In-Reply-To: <AANLkTi=kQGB0YKOunpEEy8xQqM7UCRSCwGqWC5TxJHY8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103091255.28510.arnd@arndb.de>
X-Provags-ID: V02:K0:rVSND0DlpMKnwka5pdWBk9KWB7MVa8uuUJifsnGNzDN
 zzAAiLe9aXBNeqVeNrTiwybZWQqajXK5+/KEljk3RjXS5Z7uMK
 H6T9Nyb0srBkgKqeZp6tZYENv8ell47PR32A15Z5Dc/OlTD59Q
 gDFGOdziDHpdv9T0XdOU6FBmYgyzFpFfL6wP0RgsobVqQgh+aE
 POyJZ7XkQRVLOTYPGGyEg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl function was incorrectly converted to unlocked_ioctl,
this fixes the locking.

Reported-by: Michael Brumlow <mbrumlow@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Wednesday 09 March 2011, Michael Brumlow wrote:

> I was looking through some code and found an issue in the driver you
> wrote. The problem can be found in
> "arch/cris/arch-v10/drivers/pcf8563.c" function
> "pcf8563_unlocked_ioctl". The function locks a mutex and returns, when
> it should be locking the locking the mutex, storing the return from
> the function called and then unlocking the mutex and finally returning
> the stored value of the function called.
> 
> # in its current state.
>  343 static long pcf8563_unlocked_ioctl(struct file *filp, unsigned
> int cmd, unsigned long arg)
>  344 {
>  345         int ret;
>  346
>  347         mutex_lock(&pcf8563_mutex);
>  348         return pcf8563_ioctl(filp, cmd, arg);
>  349         mutex_unlock(&pcf8563_mutex);
>  350
>  351         return ret;
>  352 }
> 
> # what is suggested.
>  343 static long pcf8563_unlocked_ioctl(struct file *filp, unsigned
> int cmd, unsigned long arg)
>  344 {
>  345         int ret;
>  346
>  347         mutex_lock(&pcf8563_mutex);
>  348         ret = pcf8563_ioctl(filp, cmd, arg);
>  349         mutex_unlock(&pcf8563_mutex);
>  350
>  351         return ret;
>  352 }

You are right. This problem exists in both arch/cris/arch-v10/drivers/pcf8563.c
and arch/cris/arch-v32/drivers/pcf8563.c, and apparently both are my fault.

	Arnd
---
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index ea69fab..1391b73 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -345,7 +345,7 @@ static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned
 	int ret;
 
 	mutex_lock(&pcf8563_mutex);
-	return pcf8563_ioctl(filp, cmd, arg);
+	ret = pcf8563_ioctl(filp, cmd, arg);
 	mutex_unlock(&pcf8563_mutex);
 
 	return ret;
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index b6e4fc0..208594f 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -341,7 +341,7 @@ static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned
 	int ret;
 
 	mutex_lock(&pcf8563_mutex);
-	return pcf8563_ioctl(filp, cmd, arg);
+	ret = pcf8563_ioctl(filp, cmd, arg);
 	mutex_unlock(&pcf8563_mutex);
 
 	return ret;
