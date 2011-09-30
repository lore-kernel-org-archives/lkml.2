Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab1I3LHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 07:07:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38289 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758293Ab1I3LHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 07:07:36 -0400
Message-ID: <4E85A311.5030805@arm.com>
Date: Fri, 30 Sep 2011 12:08:01 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316793788-14500-1-git-send-email-marc.zyngier@arm.com> <1316793788-14500-2-git-send-email-marc.zyngier@arm.com> <4E84088C.8050101@codeaurora.org>
In-Reply-To: <4E84088C.8050101@codeaurora.org>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 30 Sep 2011 11:07:31.0388 (UTC) FILETIME=[260D8FC0:01CC7F61]
X-MC-Unique: 111093012073203801
Content-Type: multipart/mixed;
 boundary="------------040908090006060506080309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040908090006060506080309
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

On 29/09/11 06:56, Abhijeet Dharmapurikar wrote:
> On 09/23/2011 09:03 AM, Marc Zyngier wrote:
>> The ARM GIC interrupt controller offers per CPU interrupts (PPIs),
>> which are usually used to connect local timers to each core.
>> Each CPU has its own private interface to the GIC,
>> and only sees the PPIs that are directly connect to it.
>>
>> While these timers are separate devices and have a separate
>> interrupt line to a core, they all use the same IRQ number.
>>
>> For these devices, request_irq() is not the right API as it
>> assumes that an IRQ number is visible by a number of CPUs
>> (through the affinity setting), but makes it very awkward to
>> express that an IRQ number can be handled by all CPUs, and
>> yet be a different interrupt line on each CPU, requiring a
>> different dev_id cookie to be passed back to the handler.
>>
>> The *_percpu_irq() functions is designed to overcome these
>> limitations, by providing a per-cpu dev_id vector:
>>
>> int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>> =09=09   const char *devname, void __percpu *percpu_dev_id);
>> void free_percpu_irq(unsigned int, void __percpu *);
>> int setup_percpu_irq(unsigned int irq, struct irqaction *new);
>> void remove_percpu_irq(unsigned int irq, struct irqaction *act);
>> void enable_percpu_irq(unsigned int irq);
>=20
> As mentioned here
> https://lkml.org/lkml/2011/9/25/121
>=20
> can we add irqflags to enable_percpu_irq? This will make msm's
> usage cleaner and it wont have to rely on accessing the gic
> registers outside the driver.

I have the attached patch in my tree (and obviously hacked the
corresponding timer code).

Can you give it a whirl by removing your private GIC configuration and
passing the type to enable_percpu_irq()?

Thanks,

=09M.
--=20
Jazz is not dead. It just smells funny...
--------------040908090006060506080309
Content-Type: text/x-patch; 
	name=0001-genirq-percpu-allow-interrupt-type-to-be-set-at-enab.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename*0="0001-genirq-percpu-allow-interrupt-type-to-be-set-at-enab.pa";
 filename*1="tch"

>From 9b1df95320aea19dce7232e8b7d66104c380aed2 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <marc.zyngier@arm.com>
Date: Fri, 30 Sep 2011 10:48:47 +0100
Subject: [PATCH] genirq: percpu: allow interrupt type to be set at enable t=
ime

As request_percpu_irq() doesn't allow for a percpu interrupt
to have its type configured (it is generally impossible to
configure it on all CPUs at once), add a 'type' argument to
enable_percpu_irq().

This allows some low-level, board specific init code to
be switched to a generic API.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/linux/interrupt.h |    2 +-
 kernel/irq/manage.c       |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 1cdfd09..664544f 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -223,7 +223,7 @@ extern void disable_irq_nosync(unsigned int irq);
 extern void disable_irq(unsigned int irq);
 extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
-extern void enable_percpu_irq(unsigned int irq);
+extern void enable_percpu_irq(unsigned int irq, unsigned int type);
=20
 /* The following three functions are for the core kernel use only. */
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 7b4b156..e647ce1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1419,7 +1419,7 @@ int request_any_context_irq(unsigned int irq, irq_han=
dler_t handler,
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
=20
-void enable_percpu_irq(unsigned int irq)
+void enable_percpu_irq(unsigned int irq, unsigned int type)
 {
 =09unsigned int cpu =3D smp_processor_id();
 =09unsigned long flags;
@@ -1428,7 +1428,20 @@ void enable_percpu_irq(unsigned int irq)
 =09if (!desc)
 =09=09return;
=20
+=09type &=3D IRQ_TYPE_SENSE_MASK;
+=09if (type !=3D IRQ_TYPE_NONE) {
+=09=09int ret;
+
+=09=09ret =3D __irq_set_trigger(desc, irq, type);
+
+=09=09if (ret) {
+=09=09=09WARN(1, "failed to set type for IRQ%d\n");
+=09=09=09goto out;
+=09=09}
+=09}
+
 =09irq_percpu_enable(desc, cpu);
+out:
 =09irq_put_desc_unlock(desc, flags);
 }
=20
--=20
1.7.0.4

--------------040908090006060506080309--

