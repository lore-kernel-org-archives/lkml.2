Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184Ab2IKXWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:22:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2IKXWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:22:08 -0400
Date: Wed, 12 Sep 2012 09:21:53 +1000
From: NeilBrown <neilb@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: Seeking clarity on IRQCHIP_MASK_ON_SUSPEND
Message-ID: <20120912092153.02f3a7e5@notabene.brown>
In-Reply-To: <alpine.LFD.2.02.1209111512130.7093@ionos>
References: <20120910165127.37dd07f3@notabene.brown>
	<alpine.LFD.2.02.1209101215300.2724@ionos>
	<20120911094252.0e78a8f9@notabene.brown>
	<alpine.LFD.2.02.1209111512130.7093@ionos>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6O7ajK=UdKQEECF5hO5=XH."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6O7ajK=UdKQEECF5hO5=XH.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Sep 2012 15:20:53 +0200 (CEST) Thomas Gleixner
<tglx@linutronix.de> wrote:

> On Tue, 11 Sep 2012, NeilBrown wrote:
> > On Mon, 10 Sep 2012 12:28:35 +0200 (CEST) Thomas Gleixner
> > <tglx@linutronix.de> wrote:
> > > You might be looking for a different functionality. Can you explain
> > > what you need?
> >=20
> > I want as particular GPIO interrupt to be masked before entering suspen=
d.
> > I produced code to get the ->suspend() callback to perform this masking.
> > Another developer (Santosh) felt that IRQCHIP_MASK_ON_SUSPEND was the
> > preferred way to do this and on the surface this looks like it should be
> > correct.  However it doesn't work as explained previously.
> > I want a resolution to this difference of opinion that doesn't just swe=
ep the
> > issue under that carpet but provides a clear answer to this sort of iss=
ue.
> >=20
> > My current opinion is that IRQCHIP_MASK_ON_SUSPEND should be discarded.=
  The
> > patch which introduced it says:
> >=20
> >     Rather than working around this in the affected interrupt chip
> >     implementations we can solve this elegant in the core code itself.
> >    =20
> > It appears that the solution in core code, while elegant, is wrong.  It
> > happens too late to be generally usable.  It is easy enough to handle t=
his
>=20
> Sigh. The flag was invented with the semantics to keep the current
> "check for any interrupt" pending functionality alive and then mask it
> right before going down, so only the designated wakeup interrupts can
> wake the device. That was the result of the discussion back then and
> that was what the developer wanted to achieve with his driver suspend
> hackery.
>=20
> > issue in the interrupt chip drivers so maybe that is the best place
> > to handle it.
>=20
> And have the same "keep track of wakeup interrupts" code over and over
> in the drivers.

We could have a 'mask my non-wakeup interrupts' library call that interested
drivers could call when appropriate, rather than having a flag to be set wh=
en
appropriate.

In the case of the gpio_omap driver, simply disabling wakeup requires less
talking to hardware than a full 'irq_mask' call.  So if we give the driver
more information about what is happening, it can implement it more
efficiently.

(I generally prefer providing code to call rather than flags to set.  It
gives more control with introducing more complexity).

> =20
> > The the very least I think we need a big comment saying the
> > IRQCHIP_MASK_ON_SUSPEND can only be used for irqchips which can always =
be
> > programmed, even when they are suspended from an runtime-PM perspective,
> > and that those chips must handle masking in their 'suspend' callback.
>=20
> Sigh, no. Either we make IRQCHIP_MASK_ON_SUSPEND into an
> implementation which masks the interrupts early, if the existing users
> find this acceptable or have a separate IRQCHIP_MASK_BEFORE_SUSPEND
> flag.

Something like this may be?  Just compile-tested so far.
I'll see if I can understand the two current users of IRQCHIP_MASK_ON_SUSPE=
ND
well enough to see if they should work with this flag.  I suspect they will.

Thanks,
NeilBrown



diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e68a8e5..d46f6c1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -228,8 +228,12 @@ extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
+void mask_non_wakeup_irqs(void);
+void unmask_non_wakeup_irqs(void);
 #else
 static inline int check_wakeup_irqs(void) { return 0; }
+static inline void mask_non_wakeup_irqs(void) { return 0; }
+static inline void unmask_non_wakeup_irqs(void) { return 0; }
 #endif
 #else
 static inline void suspend_device_irqs(void) { };
diff --git a/include/linux/irq.h b/include/linux/irq.h
index a5261e3..fbd9d7b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -340,7 +340,10 @@ struct irq_chip {
  *
  * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
  * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
- * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
+ * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs late in the suspend path
+ * IRQCHIP_MASK_PRE_SUSPEND:	Mask non wake irqs early in the suspend path
+ *				before devices are powered off or interrupts are
+ *				disabled.
  * IRQCHIP_ONOFFLINE_ENABLED:	Only call irq_on/off_line callbacks
  *				when irq enabled
  * IRQCHIP_SKIP_SET_WAKE:	Skip chip.irq_set_wake(), for this irq chip
@@ -351,6 +354,7 @@ enum {
 	IRQCHIP_MASK_ON_SUSPEND		=3D (1 <<  2),
 	IRQCHIP_ONOFFLINE_ENABLED	=3D (1 <<  3),
 	IRQCHIP_SKIP_SET_WAKE		=3D (1 <<  4),
+	IRQCHIP_MASK_PRE_SUSPEND	=3D (1 <<  5),
 };
=20
 /* This include will go away once we isolated irq_desc usage to core code =
*/
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 3728c97..836737b 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -128,3 +128,35 @@ int check_wakeup_irqs(void)
=20
 	return 0;
 }
+
+/**
+ * mask_non_wakeup_irqs - irqs that should not wake from suspend should be
+ *       masked now.
+ * This is called after devices have been suspended, but before suspend_la=
te
+ * and before interrupts are disabled.  This means it should still be poss=
ible
+ * to talk to the interrupt controller to effect the mask.
+ */
+void mask_non_wakeup_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc)
+		if ((irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_PRE_SUSPEND)
+		    && !irqd_is_wakeup_set(&desc->irq_data)
+		    && !irqd_irq_masked(&desc->irq_data))
+			mask_irq(desc);
+}
+
+void unmask_non_wakeup_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc)
+		if ((irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_PRE_SUSPEND)
+		    && !irqd_is_wakeup_set(&desc->irq_data)
+		    && irqd_irq_masked(&desc->irq_data)
+		    && !irqd_irq_disabled(&desc->irq_data))
+			unmask_irq(desc);
+}
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 16a0f77..05054a4 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/suspend.h>
+#include <linux/interrupt.h>
 #include <linux/syscore_ops.h>
 #include <trace/events/power.h>
=20
@@ -222,11 +223,12 @@ int suspend_devices_and_enter(suspend_state_t state)
 	if (suspend_test(TEST_DEVICES))
 		goto Recover_platform;
=20
+	mask_non_wakeup_irqs();
 	do {
 		error =3D suspend_enter(state, &wakeup);
 	} while (!error && !wakeup
 		&& suspend_ops->suspend_again && suspend_ops->suspend_again());
-
+	unmask_non_wakeup_irqs();
  Resume_devices:
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);

--Sig_/6O7ajK=UdKQEECF5hO5=XH.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE/HkTnsnt1WYoG5AQKryw/7BiExCJq2BPd5dgLbrjSvSEmvFGxfRMtN
GNP43vh6ebPYn5XHqQK10v330PbsChuuWDjhzjhOUd/C4ydnD+RZfv4BHhxZdHcX
39cNlNZOQpmPyj55FMI2sHF07fU+Pepjspis4Fzjpa99EDB2iRHPC29aoraM0fxN
B89KKND8U1SmffwhEj8xrWyewh+bpBU4iOnmlSzfWZ44scesT4GV9q8nWtDhwnOw
KXZeuGcCgMfDxGVyRdSPKc0GacnLYsoEiUJYhjWvUdisTAOJj0jlC7OSrTPDiZal
KKEsjHuWMrKpsoh5NMLtcCspFsqKh77u/HqGv86RjXtvL9RL560c/kil8I/4lEJi
8IBsWi//6QND4pBgwk61UwFMMEvQccbhnO/iGF7M4fJ9E6hUix1u9KX89N1vvHcV
L5KiwOG6zwFADwKo80vf7+LS9fqrtN64EifvgsZ0hqiYvoUhWYmb0V0M4dJCzIgj
R1erpaL6JLOvBBjqBUFZHFFNDEN4W6NwDwHNQBV9365S6iRqqTz/4apk6Fcq1Vtc
gU6bf1TFYt7nnAVj5WcRCGlE/78lHracGLCKvbNm6AM8HYPsjjdSpIGCRwa3HoKS
JjJ3xN8jxQAwpAdJb0Sx9JUj6ytt50HNsfuCZzOU2AvnvVGSyi16pHDRSQ5dg94e
WB9tgMUfSwA=
=ly9f
-----END PGP SIGNATURE-----

--Sig_/6O7ajK=UdKQEECF5hO5=XH.--
