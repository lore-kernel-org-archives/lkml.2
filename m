Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2DYCI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 22:08:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab2DYCIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 22:08:55 -0400
Date: Wed, 25 Apr 2012 12:08:49 +1000
From: NeilBrown <neilb@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: gpio_keys - ensure we don't miss key-presses during
 resume.
Message-ID: <20120425120849.04cee091@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0bUeb0byYUfPqo5=cFr33YD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0bUeb0byYUfPqo5=cFr33YD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


If the latency of resume means we don't poll the key status until
after it has been released, we can lose the keypress which woke the
device.

So on each interrupt, record that a press is pending, and in that
case, report both the up and down event, ordered such that the second
event is that one that reflects the current state.

One event will normally be swallowed by the input layer if there was
no change, but the result will be that every interrupt will produce at
least one event.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gp=
io_keys.c
index 62bfce4..961e5e1 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -40,6 +40,7 @@ struct gpio_button_data {
 	spinlock_t lock;
 	bool disabled;
 	bool key_pressed;
+	bool pending;
 };
=20
 struct gpio_keys_drvdata {
@@ -335,6 +336,14 @@ static void gpio_keys_gpio_report_event(struct gpio_bu=
tton_data *bdata)
 		if (state)
 			input_event(input, type, button->code, button->value);
 	} else {
+		if (type =3D=3D EV_KEY && bdata->pending) {
+			/* Before reporting the observed state, report the
+			 * alternate to be sure that a change is seen.
+			 */
+			bdata->pending =3D 0;
+			input_event(input, type, button->code, !state);
+			input_sync(input);
+		}
 		input_event(input, type, button->code, !!state);
 	}
 	input_sync(input);
@@ -361,6 +370,7 @@ static irqreturn_t gpio_keys_gpio_isr(int irq, void *de=
v_id)
=20
 	BUG_ON(irq !=3D bdata->irq);
=20
+	bdata->pending =3D true;
 	if (bdata->timer_debounce)
 		mod_timer(&bdata->timer,
 			jiffies + msecs_to_jiffies(bdata->timer_debounce));

--Sig_/0bUeb0byYUfPqo5=cFr33YD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5dcsTnsnt1WYoG5AQLFmhAAlLFj1mTa9gLGnFuZy6yVh409Z4RV8BEp
+AqVi+Zfk/PqRQXm1w+StxJRZerjGQVIMdkavLvmg07wEdIe55ELEjWBDTvriUKe
9Sb6wNOUsYX3fFIGNQA9KCMhHsDftoJKcfPqxBgZccsMsitezblV7EMZjZ+WU+GD
H4cm2L/onA8VcduP1wztumT2KB+RszrBDf+N0aW1LKkqYRF1tu8/SUT7uoM96FXz
sKyfU2M33ZhMuEXvUXgsPBYYqIU+QdtEl/O9Lnoics5Xtcz9nSwSBcmQ7XHkSIYI
b4Y2fIaSz4falb45laJWZsgMtO/CF6hHJFNfyf/GRfpG3uuoMj7dJ95wDfzdW08v
oAbHatY6NhW504AInqGTSR+JrwRfdxqYEW5M18iGl7dhw8Zqf4kN8khhUfaX0V33
Nyphztt1TUEpNdDcAN1RrEStwXLz9GzQL4afN3HXfDEr1DpxdJsbFBDq9yA/wOqn
R7qRStwbMhftV8smfKu56RnevhiTQSBXWE+roDxaL7PJEJHZHtItYhIUtxYawpCd
oSIVc3bDp/1GOC+No+0TYfADiqvRdFFjrqr0RyrSy/yPkdTrSZBGnI7UWDsQ0hC+
Q/tbJ/vbJeEoARJgFrWOj5aW1plHXjPLLH07W1xlVnQZMjZi9UEw3/0FdbJBJsmM
zxlelELsYXU=
=lh2E
-----END PGP SIGNATURE-----

--Sig_/0bUeb0byYUfPqo5=cFr33YD--
