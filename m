Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab0JNUGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:06:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:59937 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0JNUGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:06:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: mmotm 2010-10-13 - GSPCA SPCA561 webcam driver broken
In-Reply-To: Your message of "Wed, 13 Oct 2010 17:13:25 PDT."
             <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1287086789_5000P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 14 Oct 2010 16:06:29 -0400
Message-ID: <5158.1287086789@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4CB762C6.012B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1287086789_5000P
Content-Type: text/plain; charset=us-ascii

On Wed, 13 Oct 2010 17:13:25 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

This broke my webcam.  I bisected it down to this commit, and things
work again after reverting the 2 code lines of change.

commit 9e4d79a98ebd857ec729f5fa8f432f35def4d0da
Author: Hans Verkuil <hverkuil@xs4all.nl>
Date:   Sun Sep 26 08:16:56 2010 -0300

    V4L/DVB: v4l2-dev: after a disconnect any ioctl call will be blocked
    
    Until now all fops except release and (unlocked_)ioctl returned an error
    after the device node was unregistered. Extend this as well to the ioctl
    fops. There is nothing useful that an application can do here and it
    complicates the driver code unnecessarily.
    
    Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>


diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index d4a3532..f069c61 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -221,8 +221,8 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, 
        struct video_device *vdev = video_devdata(filp);
        int ret;
 
-       /* Allow ioctl to continue even if the device was unregistered.
-          Things like dequeueing buffers might still be useful. */
+       if (!vdev->fops->ioctl)
+               return -ENOTTY;
        if (vdev->fops->unlocked_ioctl) {
                ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
        } else if (vdev->fops->ioctl) {

I suspect this doesn't do what's intended if a driver is using ->unlocked_ioctl
rather than ->ioctl, and it should be reverted - it only saves at most one
if statement.


--==_Exmh_1287086789_5000P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMt2LFcC3lWbTT17ARAjfuAKDDTUXbTNeuq9on+MoSM7ZCYo0aCACfTeC/
0Y2ydJe6V1LNdBC0O8LH5Ak=
=0IAe
-----END PGP SIGNATURE-----

--==_Exmh_1287086789_5000P--

