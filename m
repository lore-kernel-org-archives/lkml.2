Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab2DAKTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 06:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab2DAKTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 06:19:49 -0400
Date: Sun, 1 Apr 2012 20:19:30 +1000
From: NeilBrown <neilb@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Subject: [PATCH] APM: fix deadlock in APM_IOC_SUSPEND ioctl
Message-ID: <20120401201930.01202cd2@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lSh1viA=o=O1z2tcqxhkKq7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lSh1viA=o=O1z2tcqxhkKq7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



I found the Xorg server on my ARM device stuck in the 'msleep()' loop
in apm_ioctl.

I suspect it had attempted suspend immediately after resuming and lost
a race.
During that msleep(10);, a new suspend cycle must have started and
changed ->suspend_state to SUSPEND_PENDING, so it was never seen to
be SUSPEND_DONE and the loop could never exited.  It would have moved on
to SUSPEND_ACKTO but never been able to reach SUSPEND_DONE.

So change the loop to only run while SUSPEND_ACKED rather than until
SUSPEND_DONE.  This is much safer.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index f4837a8..6005c5c 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -302,7 +302,7 @@ apm_ioctl(struct file *filp, u_int cmd, u_long arg)
 			 * anything critical, chill a bit on each iteration.
 			 */
 			while (wait_event_freezable(apm_suspend_waitqueue,
-					as->suspend_state =3D=3D SUSPEND_DONE))
+					as->suspend_state !=3D SUSPEND_ACKED))
 				msleep(10);
 			break;
 		case SUSPEND_ACKTO:

--Sig_/lSh1viA=o=O1z2tcqxhkKq7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3grujnsnt1WYoG5AQIkRhAAna+NQ3J9w+iYBuIkiSGXPOnRKYSx/okx
iWj0U7dk05X5kWqFm6t7zX6DQ93obpVYAIflSH2BIULbHLwrO6sfuqNCMehHinsQ
HeEupfrSizl5FCACUo187ePeGiAqc6gwDt3zEs2TkailM9sZbQQT4Qg9cBdJY/IK
Uf/Fzi2dJE5yhkuz2+rOq0/Lv5TUuP22uN11L6jd1nj7jpJ04xQC+9O4fD0U08yp
woptYTGQzHtDiBi/fIrxFEWfEciW6VEWYM7D9yT8pvXlv9vaMCz80pRycwMkybmH
V0c87Bl+h/LC5LDreN7nqMUCVCh724/a8jn8M+HZkkLh7n7ykgIClNIesKoK/03t
0s5b3nhBpYywILC0v55D03RNAc2LzYFYeac2WVvnvN8cwVb56qZpJlUNxx0P2HlI
s8XpPI22ie5H4PFBnhPFFoMMkz8geWUhGyWOBdycc0HBh9BIOWMqz0L/T+JtOSvY
8EWNFxUaG6l9JRvubJjCEseb30ffRSMLruwKvDWaac96EgXswyR81TvPuyjBw1/8
FwpopVLwZuNKtgJww878EeRDe+wLeoozG2ImuRa22mmLQAH1l8GqVxzltW3BlkI4
KhgowlR9jQ7K11CkZKPESd3KNq/8vtYjdzbIPV6YtCliOUFCuGV3hG2cHFxMWiKK
prN1vgt5rjQ=
=APha
-----END PGP SIGNATURE-----

--Sig_/lSh1viA=o=O1z2tcqxhkKq7--
