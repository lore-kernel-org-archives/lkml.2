Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1LEXDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:03:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab1LEXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:03:10 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=8lPxn2-XcZAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=P9WEJvhsO4qDUnCcdtQA:9 a=awtf8iAFJ7vvOCQ7o54A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=1bd2PkWpdRKY5yW3oBwA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230307.697516028@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Clark Williams <williams@redhat.com>,
        stable-rt@vger.kernel.org
Subject: [PATCH RT 11/12 rc3] ACPI: Convert embedded controller lock to raw spinlock
References: <20111205230046.736851081@goodmis.org>
Content-Disposition: inline; filename=0011-ACPI-Convert-embedded-controller-lock-to-raw-spinloc.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Clark Williams <williams@redhat.com>

Was seeing multiple "scheduling while atomic" backtraces on the
3.2-rc2-rt5 realtime kernel. This patch converts the spinlock in
the ACPI embedded controller structure (curr_lock) to be a raw
spinlock.

Signed-off-by: Clark Williams <williams@redhat.com>
Link: http://lkml.kernel.org/r/20111203093537.7d805f64@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/ec.c       |   22 +++++++++++-----------
 drivers/acpi/internal.h |    2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index b19a18d..5812e01 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -152,10 +152,10 @@ static int ec_transaction_done(struct acpi_ec *ec)
 {
 	unsigned long flags;
 	int ret =3D 0;
-	spin_lock_irqsave(&ec->curr_lock, flags);
+	raw_spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr || ec->curr->done)
 		ret =3D 1;
-	spin_unlock_irqrestore(&ec->curr_lock, flags);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 	return ret;
 }
=20
@@ -169,7 +169,7 @@ static void start_transaction(struct acpi_ec *ec)
 static void advance_transaction(struct acpi_ec *ec, u8 status)
 {
 	unsigned long flags;
-	spin_lock_irqsave(&ec->curr_lock, flags);
+	raw_spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
 	if (ec->curr->wlen > ec->curr->wi) {
@@ -194,7 +194,7 @@ err:
 	if (in_interrupt())
 		++ec->curr->irq_count;
 unlock:
-	spin_unlock_irqrestore(&ec->curr_lock, flags);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
=20
 static int acpi_ec_sync_query(struct acpi_ec *ec);
@@ -232,9 +232,9 @@ static int ec_poll(struct acpi_ec *ec)
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
 		pr_debug(PREFIX "controller reset, restart transaction\n");
-		spin_lock_irqsave(&ec->curr_lock, flags);
+		raw_spin_lock_irqsave(&ec->curr_lock, flags);
 		start_transaction(ec);
-		spin_unlock_irqrestore(&ec->curr_lock, flags);
+		raw_spin_unlock_irqrestore(&ec->curr_lock, flags);
 	}
 	return -ETIME;
 }
@@ -247,17 +247,17 @@ static int acpi_ec_transaction_unlocked(struct acpi_e=
c *ec,
 	if (EC_FLAGS_MSI)
 		udelay(ACPI_EC_MSI_UDELAY);
 	/* start transaction */
-	spin_lock_irqsave(&ec->curr_lock, tmp);
+	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
 	/* following two actions should be kept atomic */
 	ec->curr =3D t;
 	start_transaction(ec);
 	if (ec->curr->command =3D=3D ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	ret =3D ec_poll(ec);
-	spin_lock_irqsave(&ec->curr_lock, tmp);
+	raw_spin_lock_irqsave(&ec->curr_lock, tmp);
 	ec->curr =3D NULL;
-	spin_unlock_irqrestore(&ec->curr_lock, tmp);
+	raw_spin_unlock_irqrestore(&ec->curr_lock, tmp);
 	return ret;
 }
=20
@@ -678,7 +678,7 @@ static struct acpi_ec *make_acpi_ec(void)
 	mutex_init(&ec->lock);
 	init_waitqueue_head(&ec->wait);
 	INIT_LIST_HEAD(&ec->list);
-	spin_lock_init(&ec->curr_lock);
+	raw_spin_lock_init(&ec->curr_lock);
 	return ec;
 }
=20
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index ca75b9c..68ed95f 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -62,7 +62,7 @@ struct acpi_ec {
 	wait_queue_head_t wait;
 	struct list_head list;
 	struct transaction *curr;
-	spinlock_t curr_lock;
+	raw_spinlock_t curr_lock;
 };
=20
 extern struct acpi_ec *first_ec;
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3U2rAAoJEIy3vGnGbaoA12sP/RA/q7jsZvXCe600ogNX4jBL
b9E99HrmO1hX2wx41OFhk0qwnQyp69vMTaGjsv3pwB6XwE1l/AlSSmFEpxdww80/
k6hxisuF5QFDfXuNCYdTluPa8WBlgcpFa48lP+Z7l2Am0Y2ZI7prQcCM/25u4och
B/o0oSjyc2YpPMhqUk/U4uvoyURnAjWRAJ9OV0QTcAEtgwcY/x0m3Ng37WL1m+OE
pvUiqtXFhRl4Y3ZvbRTK/sLQimhM91FKC1CTTiw3aM2Inc6tIek7H92dGBg+oHlS
IxKPrwQQUzGV5i1O7vjboyGbH5tlnYQ0nx0qZTa/+iK7HFL6+uVKFkDNGERvVAkW
/IiE3oA1vs+EVAtT2w18bFA9i2KLpzkBCbaCaXrFyl09M1gj5pytZJCbUSuTBTbH
wE3FP6La+oFmzRaoHP3ybqWnyXr/Jvb6MHoTtiD39NLsEg3nCPSELzRPtnuLG95F
pQKC/ZvG+p1vtdwCxAwOvum0B9N1sCvSDBa5TyIqgqpS89NSXHkQ+Kj4hbfMDNcl
opcev3IW/rTWtC099+a/uVAtGu6ndsINGob3tC9PeFeUl+8FsRlHQV+mvA3W84id
BbIpHH5gi/AEkqtgUhMjEyokA8ZHNgT6EAGUJU58B1oU3ahCokrwDpnZMaUVTHdQ
LkCOy1/j4kd3ejiN2MYT
=a3nZ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
