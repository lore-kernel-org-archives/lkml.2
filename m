Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0HXUqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:46:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0HXUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:46:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH 1/3] drm: kill BKL from common code
Date: Tue, 24 Aug 2010 22:45:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <1278798701-11171-2-git-send-email-arnd@arndb.de> <m262yzyhkf.fsf@igel.home>
In-Reply-To: <m262yzyhkf.fsf@igel.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008242245.35907.arnd@arndb.de>
X-Provags-ID: V02:K0:wbLTGlrbkRaea+8IlDJZaK7BbWpBSAYDAmCYEQsYODA
 D+tItBZCYYKu212dBQXD7efZwbh88M/gEvHI8UQNjnYb/XJKWM
 FVE3k0lni3EATxGn4iSJo1rQ5O0afIlwkdSRmDlIGipnx0r3xX
 MJhduXp/MNU8Xd1qIS9d7ewkzsXVjP2qgqiZuoMYIXIetuIyHM
 YkJf1ww2A++Xc91Mfdc7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 August 2010 20:46:40 Andreas Schwab wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
> > index 4a66201..76d98f4 100644
> > --- a/drivers/gpu/drm/drm_drv.c
> > +++ b/drivers/gpu/drm/drm_drv.c
> > @@ -506,9 +506,9 @@ long drm_ioctl(struct file *filp,
> >               if (ioctl->flags & DRM_UNLOCKED)
> >                       retcode = func(dev, kdata, file_priv);
> >               else {
> > -                     lock_kernel();
> > +                     mutex_lock(&drm_global_mutex);
> >                       retcode = func(dev, kdata, file_priv);
> > -                     unlock_kernel();
> > +                     mutex_unlock(&drm_global_mutex);
> 
> How is this supposed to work in the context of sleeping ioctls, like
> drm_lock?
> 
> [drm:drm_ioctl], pid=2461, cmd=0x8008642a, nr=0x2a, dev 0xe200, auth=1
> [drm:drm_lock], 1 (pid 2461) requests lock (0x80000003), flags = 0x00000000
> [drm:drm_ioctl], pid=2520, cmd=0x8008642b, nr=0x2b, dev 0xe200, auth=1
> 
> # ps 2461 2520
>   PID TTY      STAT   TIME COMMAND
>  2461 tty7     Ss+    0:01 /usr/bin/Xorg -br :0 vt7 -nolisten tcp -auth /var/lib
>  2520 pts/2    D+     0:00 glxgears

I was assuming that no ioctl sleeps indefinitely, which is normally the
case. As I described in the changelog, all locked ioctls are serialized
with the drm_global_mutex, while they used to be only serialized when
not sleeping before.

I did not realize that DRM has mutexes that are held across ioctls.
To restore the old behavior, apply this patch:

diff --git a/drivers/gpu/drm/drm_lock.c b/drivers/gpu/drm/drm_lock.c
index e2f70a5..9bf93bc 100644
--- a/drivers/gpu/drm/drm_lock.c
+++ b/drivers/gpu/drm/drm_lock.c
@@ -92,7 +92,9 @@ int drm_lock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 		}
 
 		/* Contention */
+		mutex_unlock(&drm_global_mutex);
 		schedule();
+		mutex_lock(&drm_global_mutex);
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;

However, it would be better instead to mark the drm_lock and drm_unlock
ioctls as DRM_UNLOCKED so they are not called under drm_global_mutex to
start with, like this:

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 90288ec..469bc18 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -91,8 +91,8 @@ static struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_ADD_DRAW, drm_adddraw, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 	DRM_IOCTL_DEF(DRM_IOCTL_RM_DRAW, drm_rmdraw, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 
-	DRM_IOCTL_DEF(DRM_IOCTL_LOCK, drm_lock, DRM_AUTH),
-	DRM_IOCTL_DEF(DRM_IOCTL_UNLOCK, drm_unlock, DRM_AUTH),
+	DRM_IOCTL_DEF(DRM_IOCTL_LOCK, drm_lock, DRM_AUTH|DRM_UNLOCKED),
+	DRM_IOCTL_DEF(DRM_IOCTL_UNLOCK, drm_unlock, DRM_AUTH|DRM_UNLOCKED),
 
 	DRM_IOCTL_DEF(DRM_IOCTL_FINISH, drm_noop, DRM_AUTH),

Ideally, all the ioctls should be marked as DRM_UNLOCKED and the path calling
ioctl under drm_global_mutex be removed, but that requires auditing of each
call by someone who understands the drm locking better than I do.

Apply only one of the two patches at a time, they are mutually exclusive.

	Arnd
