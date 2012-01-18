Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2ARDrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:47:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2ARDrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:47:02 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=8_BHoHFEUQgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OmvK0a5Un1Pqigrg9NMA:9 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=OsUBtmL30GVTXfVKbioA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120118034700.688011222@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 17 Jan 2012 22:45:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 3/4] acpi-gpe-use-wait-simple.patch
References: <20120118034531.335521323@goodmis.org>
Content-Disposition: inline; filename=0003-acpi-gpe-use-wait-simple.patch.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/ec.c       |    8 ++++----
 drivers/acpi/internal.h |    4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5812e01..db0e6c3 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -222,7 +222,7 @@ static int ec_poll(struct acpi_ec *ec)
 				if (ec_transaction_done(ec))
 					return 0;
 			} else {
-				if (wait_event_timeout(ec->wait,
+				if (swait_event_timeout(ec->wait,
 						ec_transaction_done(ec),
 						msecs_to_jiffies(1)))
 					return 0;
@@ -272,7 +272,7 @@ static int ec_wait_ibf0(struct acpi_ec *ec)
 	unsigned long delay =3D jiffies + msecs_to_jiffies(ec_delay);
 	/* interrupt wait manually if GPE mode is not active */
 	while (time_before(jiffies, delay))
-		if (wait_event_timeout(ec->wait, ec_check_ibf0(ec),
+		if (swait_event_timeout(ec->wait, ec_check_ibf0(ec),
 					msecs_to_jiffies(1)))
 			return 0;
 	return -ETIME;
@@ -612,7 +612,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	advance_transaction(ec, acpi_ec_read_status(ec));
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) =3D=3D 0) {
-		wake_up(&ec->wait);
+		swait_wake(&ec->wait);
 		ec_check_sci(ec, acpi_ec_read_status(ec));
 	}
 	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
@@ -676,7 +676,7 @@ static struct acpi_ec *make_acpi_ec(void)
 		return NULL;
 	ec->flags =3D 1 << EC_FLAGS_QUERY_PENDING;
 	mutex_init(&ec->lock);
-	init_waitqueue_head(&ec->wait);
+	init_swait_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
 	raw_spin_lock_init(&ec->curr_lock);
 	return ec;
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index 68ed95f..2519b6e 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -23,6 +23,8 @@
=20
 #define PREFIX "ACPI: "
=20
+#include <linux/wait-simple.h>
+
 int init_acpi_device_notify(void);
 int acpi_scan_init(void);
 int acpi_sysfs_init(void);
@@ -59,7 +61,7 @@ struct acpi_ec {
 	unsigned long global_lock;
 	unsigned long flags;
 	struct mutex lock;
-	wait_queue_head_t wait;
+	struct swait_head wait;
 	struct list_head list;
 	struct transaction *curr;
 	raw_spinlock_t curr_lock;
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPFkC0AAoJEIy3vGnGbaoAlJsP/0MfHMifSJrjfT0WG81uLCgI
yPlQ1lQdNsFN8g6uPGjjRaKoQSWRjd7+FQJPdAfmkzF3Qu7wTCEBc27lbmCDlPlZ
EfcojMRYcq/c/yOyUDobQDf9QMJGIusWXCD0bfJkZyYxm7bXnoSTTuKNI6zNP+P7
2NVUu7NcX4jhYlKEDKEGKfYamSaR958BhWtzTt8IzomCFQpBDCPqG0qRBWBX5r12
Jvdy21g5P94Tl4eInffvbCfM3VPVJ4KQ2MeCZ9CsvZRgF+eZh9vxmwh4fMHKWSe8
VpRwYbYpddmpKNg6CUGzr5klHDNGM9IVZwsWyyw2brLEIQ+k3BtoKrfytUxuXLWe
X6c7LSejGIHqdRJ7oNmx314p+VIQWvJZ3Np1nx6yz2OVjFpWHV2k1ad7FZZecxSC
qdBg/DeUcPDBuvDOovy6Em+l0AAHuATEyIBJQAX9OwNK25ByVfHUwgOqIVRx4WlD
b1VWBAEkGLb/ZIuJQ6e8RirsAofRRpunfCvVpuMgLCegr9of3TNJjw5qBbUyxRsd
n8XIJDQVP0UznkumAd5ypJwmkA17E2EYq8eSzKvbmyLpZVj9BJXUzxgWiwkFU5iI
q5IQOO0LD5vWS/a2G/PzgX4eAvpVBhJ//AB3m+h9m0iGJfkwrZ0ZSUMbGMpfBtMl
d0BK0HCHFHXuaiNDdPEX
=ooxK
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
