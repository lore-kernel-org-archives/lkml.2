Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0HXSqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 14:46:45 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34994 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0HXSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 14:46:43 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/3] drm: kill BKL from common code
References: <1278798701-11171-1-git-send-email-arnd@arndb.de>
	<1278798701-11171-2-git-send-email-arnd@arndb.de>
X-Yow: INSIDE, I have the same personality disorder as LUCY RICARDO!!
Date: Tue, 24 Aug 2010 20:46:40 +0200
In-Reply-To: <1278798701-11171-2-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Sat, 10 Jul 2010 23:51:39 +0200")
Message-ID: <m262yzyhkf.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> index 4a66201..76d98f4 100644
> --- a/drivers/gpu/drm/drm_drv.c
> +++ b/drivers/gpu/drm/drm_drv.c
> @@ -506,9 +506,9 @@ long drm_ioctl(struct file *filp,
>  		if (ioctl->flags & DRM_UNLOCKED)
>  			retcode = func(dev, kdata, file_priv);
>  		else {
> -			lock_kernel();
> +			mutex_lock(&drm_global_mutex);
>  			retcode = func(dev, kdata, file_priv);
> -			unlock_kernel();
> +			mutex_unlock(&drm_global_mutex);

How is this supposed to work in the context of sleeping ioctls, like
drm_lock?

[drm:drm_ioctl], pid=2461, cmd=0x8008642a, nr=0x2a, dev 0xe200, auth=1
[drm:drm_lock], 1 (pid 2461) requests lock (0x80000003), flags = 0x00000000
[drm:drm_ioctl], pid=2520, cmd=0x8008642b, nr=0x2b, dev 0xe200, auth=1

# ps 2461 2520
  PID TTY      STAT   TIME COMMAND
 2461 tty7     Ss+    0:01 /usr/bin/Xorg -br :0 vt7 -nolisten tcp -auth /var/lib
 2520 pts/2    D+     0:00 glxgears

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
