Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0CXDuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:50:16 -0400
Received: from ppa04.Princeton.EDU ([128.112.128.215]:54511 "EHLO
	ppa04.Princeton.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0CXDuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:50:10 -0400
X-Greylist: delayed 811 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 23:50:10 EDT
Date: Tue, 23 Mar 2010 23:36:11 -0400
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100323233611.6dcbe4f4@penta.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3lQ3o0QISS5wDHyes/bsE6Z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3lQ3o0QISS5wDHyes/bsE6Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Dear Joel,

The drivers/char/hangcheck-timer.c is doubly broken. First, the
following line overflows unsigned long:
# define TIMER_FREQ (HZ*loops_per_jiffy)

Second, and more importantly, loops_per_jiffy has little to do with the con=
version from the
the time scale of get_cycles() (aka rdtsc) to the time scale of jiffies.

The attached patch resolves both of the problems.

Best,
Yury

PS. I have CC-ed a few people who touched hangcheck-timer.c in 2006. Please=
 CC me for follow-ups.

diff --git a/drivers/char/hangcheck-timer.c b/drivers/char/hangcheck-timer.c
index 712d9f2..c57a508 100644
--- a/drivers/char/hangcheck-timer.c
+++ b/drivers/char/hangcheck-timer.c
@@ -49,8 +49,9 @@
 #include <asm/uaccess.h>
 #include <linux/sysrq.h>
 #include <linux/timer.h>
+#include <linux/time.h>
=20
-#define VERSION_STR "0.9.0"
+#define VERSION_STR "0.9.1"
=20
 #define DEFAULT_IOFENCE_MARGIN 60	/* Default fudge factor, in seconds */
 #define DEFAULT_IOFENCE_TICK 180	/* Default timer timeout, in seconds */
@@ -119,10 +120,8 @@ __setup("hcheck_dump_tasks", hangcheck_parse_dump_task=
s);
 #if defined(CONFIG_S390)
 # define HAVE_MONOTONIC
 # define TIMER_FREQ 1000000000ULL
-#elif defined(CONFIG_IA64)
-# define TIMER_FREQ ((unsigned long long)local_cpu_data->itc_freq)
 #else
-# define TIMER_FREQ (HZ*loops_per_jiffy)
+# define TIMER_FREQ 1000000000ULL
 #endif
=20
 #ifdef HAVE_MONOTONIC
@@ -130,7 +129,9 @@ extern unsigned long long monotonic_clock(void);
 #else
 static inline unsigned long long monotonic_clock(void)
 {
-	return get_cycles();
+	struct timespec ts;
+	getrawmonotonic(&ts);
+	return timespec_to_ns(&ts);
 }
 #endif  /* HAVE_MONOTONIC */
=20
@@ -168,6 +169,13 @@ static void hangcheck_fire(unsigned long data)
 			printk(KERN_CRIT "Hangcheck: hangcheck value past margin!\n");
 		}
 	}
+#if 0
+	/*=20
+	 * Enable to investigate delays in detail
+	 */
+	printk("Hangcheck: called %Ld ns since last time (%Ld ns overshoot)\n",=20
+			tsc_diff, tsc_diff - hangcheck_tick*TIMER_FREQ);
+#endif
 	mod_timer(&hangcheck_ticktock, jiffies + (hangcheck_tick*HZ));
 	hangcheck_tsc =3D monotonic_clock();
 }
@@ -180,7 +188,7 @@ static int __init hangcheck_init(void)
 #if defined (HAVE_MONOTONIC)
 	printk("Hangcheck: Using monotonic_clock().\n");
 #else
-	printk("Hangcheck: Using get_cycles().\n");
+	printk("Hangcheck: Using getrawmonotonic().\n");
 #endif  /* HAVE_MONOTONIC */
 	hangcheck_tsc_margin =3D
 		(unsigned long long)(hangcheck_margin + hangcheck_tick);

--Sig_/3lQ3o0QISS5wDHyes/bsE6Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupiKsACgkQemuRe3zuqORrYQCgs/VjxAkbIs2NojwJd6KQXbAp
gO8AmgK1OyJKE4Iv6vIxTTdxNnvSngAx
=ah+u
-----END PGP SIGNATURE-----

--Sig_/3lQ3o0QISS5wDHyes/bsE6Z--
