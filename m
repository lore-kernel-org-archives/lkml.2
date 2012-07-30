Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2G3BgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:36:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699Ab2G3BgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:36:03 -0400
Date: Mon, 30 Jul 2012 11:35:47 +1000
From: NeilBrown <neilb@suse.de>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: Avoid races between RTC alarm wakeup and suspend.
Message-ID: <20120730113547.2c425ea9@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jcu6Ko=r3ASkF2RE017CSiM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Jcu6Ko=r3ASkF2RE017CSiM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


If an RTC alarm fires just as suspend is happening, it is possible for
suspend to complete and the alarm to be missed.

To avoid the race, we must register the event with the PM core.

As the event is made visible to userspace through a thread which is
only scheduled by the interrupt, we need a pm_stay_awake/pm_relax
pair preventing suspend from the interrupt until the thread completes
its work.

Signed-off-by: NeilBrown <neilb@suse.de>

--
This makes the pm_wakeup_event() call in cmos_interrupt unnecessary as it
provides suspend protection for all RTCs that use rtc_update_irq.

I think the pm_stay_awake//pm_relax is needed - just pm_wakup_event() is=20
theoretically not sufficient.

This is because there is no guarantee (that I know of) that the workqueue
thread will actually get scheduled before 'suspend' takes over.

Thanks,
NeilBrown


diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index eb415bd..9592b93 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -582,6 +582,7 @@ enum hrtimer_restart rtc_pie_update_irq(struct hrtimer =
*timer)
 void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
+	pm_stay_awake(rtc->dev.parent);
 	schedule_work(&rtc->irqwork);
 }
 EXPORT_SYMBOL_GPL(rtc_update_irq);
@@ -844,6 +845,7 @@ void rtc_timer_do_work(struct work_struct *work)
=20
 	mutex_lock(&rtc->ops_lock);
 again:
+	pm_relax(rtc->dev.parent);
 	__rtc_read_time(rtc, &tm);
 	now =3D rtc_tm_to_ktime(tm);
 	while ((next =3D timerqueue_getnext(&rtc->timerqueue))) {

--Sig_/Jcu6Ko=r3ASkF2RE017CSiM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBXk9Dnsnt1WYoG5AQKrjA//et5zuVgveV/UKUPXe21DomsaLpbUuAIg
1HDBypawA1qrCDqm4RH3hkVwy2tFQuY4312m1CAimRtldV7VW2+uQ+tAwOjA8f4n
zqGJQlAnqQOE3VemcAXcXzKhZHK+rQW04QIbim09ZK5nila+mOKXGY5J9LswpI1I
U3cR/6ZPOyswmqSiygZDLz5ZnqpxQnIhuSXGdFKz5yeRnYwctYWsTtD4sf8xxSOD
CeLasf0xYY9IiqDCCtU2kSShDX4JKB2W35NIvkReIj4hGIybDH3s7qv2BMljGjLq
CAy9f3xFPR+JNDzgzM8nM76NLvHaL7zDmOVrwYYd/qVk7DcgICLLTYMAwBcglmIp
WoiCTnDI6skf97BWqoiV/XBWLyoJNApOLmyoqtPz03sIghypEpdytHJMRu8kKE9W
sy7s0+mwL0hfXTRuRPOnJRldb9ADedDdSlmu/G4+7E6hK+NVLkgNVIMY3Pov2vG0
DaaGfkBk4dIhjCVOVHvopaTmtISTl9Znqhagf00d0jewJTrNbbSPHDMB1LNB8DON
gyx7/RuQmabvp8kfg778OQrzGho8Gg2ysHZm6Xne3arb/jU+jiETphyBN8FqCGF1
TfX/dlD6ByzPU068rwhINyBRCwc4ShcbX14Z6cHaIJYkUsx1we1vL/Z/alaDgODL
dXeSTW/x04c=
=/hcC
-----END PGP SIGNATURE-----

--Sig_/Jcu6Ko=r3ASkF2RE017CSiM--
