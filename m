Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1LCPfv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 10:35:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1LCPfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 10:35:48 -0500
Date: Sat, 3 Dec 2011 09:35:37 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RT]  scheduling while atomic splats on 3.2-rc4-rt5
Message-ID: <20111203093537.7d805f64@redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qqcCkFo1Ov0tlITMCj8D7fp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qqcCkFo1Ov0tlITMCj8D7fp
Content-Type: multipart/mixed; boundary="MP_/vpQJX5Dx26lcOP8XRWCYO5/"

--MP_/vpQJX5Dx26lcOP8XRWCYO5/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thomas,

I was seeing a bunch of scheduling while atomic backtraces from rc4-rt5
on my laptop:

Dec  2 17:50:56 localhost kernel: [ 1397.730931] Call Trace:
Dec  2 17:50:56 localhost kernel: [ 1397.730938]  [<ffffffff814d5006>] __sc=
hedule_bug+0x75/0x7a
Dec  2 17:50:56 localhost kernel: [ 1397.730943]  [<ffffffff814e8e4a>] __sc=
hedule+0x8a/0x505
Dec  2 17:50:56 localhost kernel: [ 1397.730947]  [<ffffffff814e96df>] sche=
dule+0x75/0x91
Dec  2 17:50:56 localhost kernel: [ 1397.730951]  [<ffffffff814ea64e>] rt_s=
pin_lock_slowlock+0x182/0x21e
Dec  2 17:50:56 localhost kernel: [ 1397.730954]  [<ffffffff814ea5d9>] ? rt=
_spin_lock_slowlock+0x10d/0x21e
Dec  2 17:50:56 localhost kernel: [ 1397.730961]  [<ffffffff81090477>] rt_s=
pin_lock_fastlock.constprop.12+0x24/0x26
Dec  2 17:50:56 localhost kernel: [ 1397.730965]  [<ffffffff814eaabb>] rt_s=
pin_lock+0x16/0x3d
Dec  2 17:50:56 localhost kernel: [ 1397.730969]  [<ffffffff812acbe3>] adva=
nce_transaction+0x31/0x141
Dec  2 17:50:56 localhost kernel: [ 1397.730972]  [<ffffffff812ad819>] acpi=
_ec_gpe_handler+0x3f/0xc0
Dec  2 17:50:56 localhost kernel: [ 1397.730977]  [<ffffffff812b862a>] acpi=
_ev_gpe_dispatch+0xc5/0x13e
Dec  2 17:50:56 localhost kernel: [ 1397.730983]  [<ffffffff812b8758>] acpi=
_ev_gpe_detect+0xb5/0x10d
Dec  2 17:50:56 localhost kernel: [ 1397.730987]  [<ffffffff810b5048>] ? ir=
q_thread_fn+0x3a/0x3a
Dec  2 17:50:56 localhost kernel: [ 1397.730990]  [<ffffffff812b6d26>] acpi=
_ev_sci_xrupt_handler+0x22/0x2b
Dec  2 17:50:56 localhost kernel: [ 1397.730994]  [<ffffffff812a7a08>] acpi=
_irq+0x16/0x31
Dec  2 17:50:56 localhost kernel: [ 1397.730996]  [<ffffffff810b506d>] irq_=
forced_thread_fn+0x25/0x46
Dec  2 17:50:56 localhost kernel: [ 1397.730998]  [<ffffffff814eb566>] ? _r=
aw_spin_unlock_irq+0x53/0x60
Dec  2 17:50:56 localhost kernel: [ 1397.731001]  [<ffffffff810b4f26>] irq_=
thread+0xa5/0x18d
Dec  2 17:50:56 localhost kernel: [ 1397.731003]  [<ffffffff810b4e81>] ? ir=
q_finalize_oneshot+0x19/0x19
Dec  2 17:50:56 localhost kernel: [ 1397.731006]  [<ffffffff81077ad2>] kthr=
ead+0x99/0xa1
Dec  2 17:50:56 localhost kernel: [ 1397.731009]  [<ffffffff814eb8b8>] ? re=
tint_restore_args+0x13/0x13
Dec  2 17:50:56 localhost kernel: [ 1397.731014]  [<ffffffff814f3984>] kern=
el_thread_helper+0x4/0x10
Dec  2 17:50:56 localhost kernel: [ 1397.731016]  [<ffffffff814eb8b8>] ? re=
tint_restore_args+0x13/0x13
Dec  2 17:50:56 localhost kernel: [ 1397.731019]  [<ffffffff81077a39>] ? __=
init_kthread_worker+0x89/0x89
Dec  2 17:50:56 localhost kernel: [ 1397.731022]  [<ffffffff814f3980>] ? gs=
_change+0x13/0x13


The attached patch converts the ACPI Embedded Controller lock to a raw
spinlock. Boots and suspends/resumes with no backtraces (from this
anyway...let's not talk about nouveau right now...)

Clark

--MP_/vpQJX5Dx26lcOP8XRWCYO5/
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=ec_raw_spinlock.patch

commit 03981ccbd4b3d368aa227aa55961f8481e9e645c
Author: Clark Williams <williams@redhat.com>
Date:   Sat Dec 3 09:15:46 2011 -0600

    convert ACPI embedded controller lock to raw spinlock
   =20
    Was seeing multiple "scheduling while atomic" backtraces on the
    3.2-rc2-rt5 realtime kernel. This patch converts the spinlock in
    the ACPI embedded controller structure (curr_lock) to be a raw
    spinlock.
   =20
    Signed-off-by: Clark Williams <williams@redhat.com>

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

--MP_/vpQJX5Dx26lcOP8XRWCYO5/--

--Sig_/qqcCkFo1Ov0tlITMCj8D7fp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk7aQc0ACgkQHyuj/+TTEp1wdQCdGi7huqfZZYwMBW91bICU9zew
FZcAoM6leP805J/d5rruxEvbU1nNPQ6Z
=+fyw
-----END PGP SIGNATURE-----

--Sig_/qqcCkFo1Ov0tlITMCj8D7fp--
