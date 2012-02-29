Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab2B2VlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 16:41:12 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932220Ab2B2VlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 16:41:10 -0500
Message-ID: <4F4E9B71.2010407@nod.at>
Date: Wed, 29 Feb 2012 22:41:05 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: Thomas Gleixner <tglx@linutronix.de>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RTC regression
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig52D25EF375A4EA3885FF10CB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig52D25EF375A4EA3885FF10CB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

hwclock calls the RTC_UIE_ON ioctl to wait for a timer tick.
If RTC_UIE_ON was successful it opens /dev/rtcX and waits up to 5 seconds=
 using select()
for a tick.
Some RTC drivers have no support for RTC_UIE_ON and ioctl just returns -E=
INVAL.
Drivers indicated this by setting rtc_class_ops->update_irq_enable to NUL=
L.
In this case hwclock waits in a busy loop for the next timer tick.

These two commits changed this behavior:
6610e08 (RTC: Rework RTC code to use timerqueue for events)
51ba60c (RTC: Cleanup rtc_class_ops->update_irq_enable())

rtc_class_ops->update_irq_enable was removed and rtc_update_irq_enable()
is now using rtc_class_ops->set_alarm instead of rtc_class_ops->update_ir=
q_enable.

Some RTC devices (like mpc515x) don't support intervals smaller than one
minute.
rtc-mpc5121.c deals with this by rounding up to one minute.
But now after commit 6610e08 RTC_UIE_ON will no longer return -EINVAL and=

the next tick comes somewhen within the next 60 seconds, because the driv=
er rounded up...
hwclock's select() is not happy about this and timeouts in most cases.

The attached patch fixes the issue for mpc512x.
set_alarm returns now -EINVAL if the requested interval is less than one =
minute.
But I'm sure there are more RTC drivers and devices which are unable to h=
andle
such short intervals.
Their RTC_UIE_ON behavior is currently undefined.

Thanks,
//richard

----
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 09ccd8d..dee992c 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -161,10 +161,18 @@ static int mpc5121_rtc_set_alarm(struct device *dev=
, struct rtc_wkalrm *alarm)
 {
        struct mpc5121_rtc_data *rtc =3D dev_get_drvdata(dev);
        struct mpc5121_rtc_regs __iomem *regs =3D rtc->regs;
+       struct rtc_time now;

        /*
-        * the alarm has no seconds so deal with it
+        * the alarm has no seconds so deal with it:
+        * - return -EINVAL if the interval is < 1 minute
+        * - round up to one minute if it's > 1 minute
         */
+       mpc5121_rtc_read_time(dev, &now);
+       if (alarm->time.tm_min =3D=3D now.tm_min &&
+               alarm->time.tm_hour =3D=3D now.tm_hour)
+               return -EINVAL;
+
        if (alarm->time.tm_sec) {
                alarm->time.tm_sec =3D 0;
                alarm->time.tm_min++;


--------------enig52D25EF375A4EA3885FF10CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPTptxAAoJEN9758yqZn9eA8MH/0xTULGGC7wK8bTJ1p+A7bLw
JFgB1H5mbxUqkltUL7bb8NmVQRRV7r/smRTQ3rH/94yEXOF8k1NLQRqnXoh+iwBG
kKZSaBxhAOXWEZ8lb4FL+RZaB9ZHlaOIezc+eLaj3mg9Pin8GXVYN2rDqQp+IKnr
psa+NZtHz52k59Dl9x8WPcdeLlqFJQ+mIb6AM3F2m61gcr7SC3qvtTS0ya1aP534
5b7XmqhEt0EmNgRRLaJ4JFvMEyTQrs7pnogKNbNwC3/Qv/RyBx6jCs2g4z2f+V08
zemjHVae7SdkvAP+APo1lt8L4BsNdsSwUGmEsAFRsjT2+mJH7By4+8YHlKK0NhM=
=YBBh
-----END PGP SIGNATURE-----

--------------enig52D25EF375A4EA3885FF10CB--
