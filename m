Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2IJGvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:51:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab2IJGvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:51:36 -0400
Date: Mon, 10 Sep 2012 16:51:27 +1000
From: NeilBrown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: Seeking clarity on  IRQCHIP_MASK_ON_SUSPEND
Message-ID: <20120910165127.37dd07f3@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ndnR1XxiLx6OYpB/27eWoli"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ndnR1XxiLx6OYpB/27eWoli
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


The IRQCHIP_MASK_ON_SUSPEND flag seems to be hard to use correctly, so eith=
er
I'm understanding it wrongly, or it could be made easier to use.
If the first case, I'm hoping that some improvement to documentation might
result.  If the second, then maybe we can fix the code.

As I understand it, the need for IRQCHIP_MASK_ON_SUSPEND comes from the fact
that interrupt masking happens lazily.  When an interrupt is disabled the
hardware isn't told about that immediately, only internal data structures a=
re
updated.  If/when the interrupt actually happens, only then is it masked and
ignored.
This cannot really work in suspend as masking after the interrupt fires mea=
ns
that we have already woken from suspend.

So suspend_device_irqs() (called between the suspend_late handlers and the
suspend_noirq handlers) just disables all interrupts and check_wakeup_irqs()
(which is called very late) is left to talk to the hardware and actually ma=
sk
those which should not cause a wake-from-suspend.

The problem is that check_wakeup_irqs() is called so late that it might not=
 be
possible to talk to the hardware.  For example, on the OMAP3 platform,
runtime power management will gate the 'iclk' (interface clock) and possibly
other clocks so that it is no longer possible to talk over an i2c bus or ev=
en
directly to the GPIO SoC module to effect the masking.
As runtime PM is disabled at this stage of the suspend cycle it is not even
possible to turn the iclk back on, mask the interrupt, then turn it off
again.

So it seems to me that either:

 1/ irq_chip devices need to mask any non-wakeup interrupts in ->suspend or
    possibly in ->suspend_late before runtimePM has switched the interface
    off, making IRQCHIP_MASK_ON_SUSPEND essentially useless except for some
    rare cases.
or
 2/ IRQCHIP_MASK_ON_SUSPEND needs to happen much earlier, probably before
    the suspend_late callbacks.

It might be tempting to change suspend_device_irqs() to disable interrupts =
in
such a way that the 'mask' happen synchronously (for non-wakeup interrupts).
However I don't think that would work as it happens after suspend_late and I
think suspend_late is allowed to power_down devices (and iclks).

I *think* the correct answer is '1'.  In that case I would love to know when
IRQCHIP_MASK_ON_SUSPEND can be used correctly (if ever).  I'm hoping someone
who works with interrupts and power management more than I can help me
understand...

There are currently only two drivers that set IRQCHIP_MASK_ON_SUSPEND:=20
  arch/arm/mach-omap2/omap-wakeupgen.c
and=20
  drivers/mfd/pm8xxx-irq.c

The former is in an 'always-on' power domain so the interaction with runtime
PM presumably doesn't affect it.

The later ... I don't think will compile.  It is only used by pm8921-core.c,
and that requires #include <linux/msm_ssbi.h>, which doesn't exist in
mainline.

Is anyone able to give a definitive answer on this?  Should
IRQCHIP_MASK_ON_SUSPEND be removed?


Thanks,
NeilBrown

--Sig_/ndnR1XxiLx6OYpB/27eWoli
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE2N7znsnt1WYoG5AQLEyA/+JRnB+LIWek+PlM1tWbpjR2Qg0UOdMRMd
c32OA+3iBzFfqLtC76TKsjM5zSr8DEihcGn5FMWNYvPMXkrBwropFIMI7DK8kMNO
BfOS1uImxZ6Uk2zpNl7BpdO69VzPvZCUcW7z85FpskXPOfyLq0DjktWfNO16e0gI
GQ6j+oKLumiQgMlsHOW+/F/ZcERRR/Gkb4n4vKUp/vvQW95JHkb/g8j0eEFcXk1e
n3GtJO9PEdwudzng19Jb554JgGLY9PIeqRpmFNVPswbozPGxcSxOd3wiaFq7rYR6
1Un9kPMI+ipv5FPMXVKAN2ATAGZc/zEMNg80ZhrYcN1fa1CUduaOcL3STj42cOhC
6ory5lVNtgx9QnPnzbYP8GUjk3XtZ0wiF6LDxrgxhW9qiy4rwHqiZlA0lyn5jzcw
UcvTw7GDhi3VIvMUBeJqH0uFHoWPbnr0pGdPZ3mexjVoo2Jtt9soefNryhuHeMvp
x9j0KjSEXt6TudRC+vuoGOadc8N9yF1SjvTKaABfACh0ScCeYry9ClJiGmtpoH6x
P/xGKqQeCgcDZ6aOE2ZppoFkoY1ihB781/9VXUxfbQrxbGOIrf6O53tPzNXevzol
5YxDkmeNiVVH9G/rBt1hGdR0syVLAgpaQMHyQQDbRYS7iAH33nRe/JinAZM/IH0y
tDJ4xUsHPns=
=oMCi
-----END PGP SIGNATURE-----

--Sig_/ndnR1XxiLx6OYpB/27eWoli--
