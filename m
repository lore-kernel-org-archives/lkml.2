Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2EDFM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:12:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab2EDFM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:12:26 -0400
Date: Fri, 4 May 2012 15:12:21 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/3] IRQ: allow check_wakeup_irqs to notice
 level-triggered interrupts.
Message-ID: <20120504151221.6998d4e5@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1204251402360.2542@ionos>
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.85239.stgit@notabene.brown>
	<alpine.LFD.2.02.1204251018530.2542@ionos>
	<20120425193916.0db1b4b1@notabene.brown>
	<alpine.LFD.2.02.1204251402360.2542@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/M_Mnyl1jqY=ZXVnt32A/Lrt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/M_Mnyl1jqY=ZXVnt32A/Lrt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Apr 2012 14:54:54 +0200 (CEST) Thomas Gleixner
<tglx@linutronix.de> wrote:

> Why not simply managing the pending bit for level irqs ?
>=20

Hi Thomas,
 thanks again for the patch.  I finally made time to test it and it works as
expected.  I've included it below with a change-log entry and tested-by:
in case that helps.

Thanks,
NeilBrown


From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 25 Apr 2012 12:54:54 +0200
Subject: [PATCH] IRQ: allow check_wakeup_irqs to notice level-triggered int=
errupts.

Level triggered interrupts do not cause IRQS_PENDING to be set when
they fire-while-disabled as the 'pending' state is always present in
the level - they automatically refire where re-enabled.

However the IRQS_PENDING flag is also used to abort a suspend cycle -
if any 'is_wakeup_set' interrupt is PENDING, check_wakeup_irqs() will
cause suspend to abort. Without IRQS_PENDING, suspend won't abort.

Consequently, level-triggered interrupts that fire during the 'noirq'
phase of suspend do not currently abort suspend.

So set IRQS_PENDING even for level triggered interrupts, and make sure
to clear the flag in check_irq_resend.

Also: in check_wakeup_irqs, ignore 'is_wakeup' interrupts that were
already disabled before suspend_device_irqs() disabled them further.

Tested-by: NeilBrown <neilb@suse.de>

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 6080f6b..741f836 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -379,8 +379,10 @@ handle_level_irq(unsigned int irq, struct irq_desc *de=
sc)
 	 * If its disabled or no action available
 	 * keep it masked and get out of here
 	 */
-	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data)))
+	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
+		desc->istate |=3D IRQS_PENDING;
 		goto out_unlock;
+	}
=20
 	handle_irq_event(desc);
=20
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 15e53b1..b858ce3 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -103,7 +103,8 @@ int check_wakeup_irqs(void)
 	int irq;
=20
 	for_each_irq_desc(irq, desc) {
-		if (irqd_is_wakeup_set(&desc->irq_data)) {
+		if (desc->depth =3D=3D 1 &&
+		    irqd_is_wakeup_set(&desc->irq_data)) {
 			if (desc->istate & IRQS_PENDING)
 				return -EBUSY;
 			continue;
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 14dd576..6454db7 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -58,10 +58,13 @@ void check_irq_resend(struct irq_desc *desc, unsigned i=
nt irq)
 	/*
 	 * We do not resend level type interrupts. Level type
 	 * interrupts are resent by hardware when they are still
-	 * active.
+	 * active. Clear the pending bit so suspend/resume does not
+	 * get confused.
 	 */
-	if (irq_settings_is_level(desc))
+	if (irq_settings_is_level(desc)) {
+		desc->istate &=3D ~IRQS_PENDING;
 		return;
+	}
 	if (desc->istate & IRQS_REPLAY)
 		return;
 	if (desc->istate & IRQS_PENDING) {

--Sig_/M_Mnyl1jqY=ZXVnt32A/Lrt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6NlNTnsnt1WYoG5AQKhfw//a54qUJOTLtno4QY2fcBxkWmTVCr4c6KV
v0E3A6m9Xu1ZNExN5Tn6xYDU13eDKrlPm9+k+o/YxajppPnDUrfzKST0QnBSLn5w
cjLtPl6eDK31akteANJ+UgmZ0lfCXOAEeqNUXAMKZ/yjuzaaMKlLWtsJjANI/zaK
Y9ux2qbH7auNtFMLLWx8m1q45kvDH89OlzYeZPn0pg1PgITzHrsrDzHZE4GMcocd
ZB8vEu9fuZhrLEUtgWfWXXTrys1e0CJ+m939TKXpCeRjGbYDyv0vG/D7zGCf9GQr
0XfRZgWhAINAkVq7tldhKaNCFZxUyg7ppwu61qDPpKIBkcIQfPAXcZmBtc0dQAhn
+GmUMkphQyhdk+4sj4hD5rUr38FzfbCAgqk59nhO/nZU/E3N1Mnh6XyQaRc3LRId
vZYVbwcmPIptvbyUWuSE75S+jF8YKhDH1o/gCdLVLYb37DAsHU4aFL+bvpgKGmpF
EsEWP89/uK8+vbVDHXOsP7ahQeY4+z+1Rs8Gzp6Y9I3XSxU4Gs9GeBm77XW3NCzY
3SvjRp4kn2psqz8FFfCjWMYYxmZ4lcogldsF/4e/OnB0gP7spvSPcedVfok94Yek
vgZQnitxqjJoXBoh7E0W9Z4wz+8enS9hMXTeh/V8qhaqQOnXx6vDl9aRTsw4OBR6
DKGsdt+j2hg=
=5Na3
-----END PGP SIGNATURE-----

--Sig_/M_Mnyl1jqY=ZXVnt32A/Lrt--
