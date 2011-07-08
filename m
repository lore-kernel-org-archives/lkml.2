Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1GHPN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:13:27 -0400
Received: from service87.mimecast.com ([94.185.240.25]:54236 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752887Ab1GHPNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:13:25 -0400
Message-ID: <4E171E93.8020608@arm.com>
Date: Fri, 08 Jul 2011 16:13:23 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v2 0/4] Core device subsystem
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>	<CAHXqBFJiovYq5x_JDAxikvFs-t1To6yC-1uajBJFRX_jwjvejA@mail.gmail.com> <4E170134.1020306@arm.com>
In-Reply-To: <4E170134.1020306@arm.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 08 Jul 2011 15:13:19.0664 (UTC) FILETIME=[9202E300:01CC3D81]
X-MC-Unique: 111070816132204201
Content-Type: multipart/mixed;
 boundary="------------030902030506000907060603"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030902030506000907060603
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

On 08/07/11 14:08, Marc Zyngier wrote:
> So you're basically folding of_core_device_populate() and
> core_driver_init_class() into one call, and generating the
> of_device_ids on the fly. If you're going down that road,
> it would be even simpler to directly use of_device_ids
> instead of core_device_ids and skip the generation altogether.
>=20
> That would also remove the static declaration of devices to be
> probed in the architecture support code...
>=20
> Let me think of it and prototype that.

See the attached patch against branch dt_gic_twd from
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git

It boots fine on my PB11MP.

What do you think?

=09M.
--=20
Jazz is not dead. It just smells funny...
--------------030902030506000907060603
Content-Type: text/plain; name=code_dev.patch.txt
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="code_dev.patch.txt"

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 74825c2..e7d9922 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -712,9 +712,9 @@ static int __init gic_core_init(struct core_device *dev=
)
 =09return 0;
 }
=20
-static struct core_device_id gic_ids[] __initdata =3D {
-=09{ .name =3D "arm,gic-spi" }, /* DT */
-=09{ .name =3D "arm_gic" },     /* Static device */
+static struct of_device_id gic_ids[] __initdata =3D {
+=09{ .compatible =3D "arm,gic-spi" }, /* DT */
+=09{ .name =3D "arm_gic" },=09=09 /* Static device */
 =09{ },
 };
=20
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 0b0681c..1cb4bd7 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -114,15 +114,10 @@ void set_irq_flags(unsigned int irq, unsigned int ifl=
ags)
 =09irq_modify_status(irq, clr, set & ~clr);
 }
=20
-static struct of_device_id of_irq_controller_ids[] __initdata =3D {
-=09{ .compatible   =3D "arm,gic-spi", },
-=09{},
-};
-
 void __init init_IRQ(void)
 {
 =09machine_desc->init_irq();
-=09of_core_device_populate(CORE_DEV_CLASS_IRQ, of_irq_controller_ids);
+=09of_core_device_populate(CORE_DEV_CLASS_IRQ);
 =09core_driver_init_class(CORE_DEV_CLASS_IRQ, core_device_irq_sort);
 }
=20
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index b879698..80f7ad2 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -150,18 +150,13 @@ device_initcall(timer_init_syscore_ops);
=20
 void (* __initdata arm_late_time_init)(void);
=20
-static struct of_device_id of_timer_ids[] __initdata =3D {
-=09{ .compatible =3D "arm,smp-twd", },
-=09{},
-};
-
 static void __init __arm_late_time_init(void)
 {
 =09if (arm_late_time_init)
 =09=09arm_late_time_init();
=20
 #ifdef CONFIG_LOCAL_TIMER_DEVICES
-=09of_core_device_populate(CORE_DEV_CLASS_TIMER, of_timer_ids);
+=09of_core_device_populate(CORE_DEV_CLASS_TIMER);
 =09core_driver_init_class(CORE_DEV_CLASS_TIMER, NULL);
 #endif
 }
diff --git a/drivers/base/core_device.c b/drivers/base/core_device.c
index a8df59d..0f1c585 100644
--- a/drivers/base/core_device.c
+++ b/drivers/base/core_device.c
@@ -20,20 +20,22 @@ static struct list_head anchors[CORE_DEV_CLASS_MAX] __i=
nitdata =3D {
 };
=20
 static int __init core_device_match(struct core_device *dev,
-=09=09=09=09    struct core_device_id *ids)
+=09=09=09=09    struct of_device_id *ids)
 {
-=09int i;
 #ifdef CONFIG_OF
-=09if (dev->of_node)
-=09=09for (i =3D 0; ids[i].name !=3D NULL; i++)
-=09=09=09if (of_device_is_compatible(dev->of_node,
-=09=09=09=09=09=09    ids[i].name))
-=09=09=09=09return 1;
+=09if (dev->of_node) {
+=09=09if (of_match_node(ids, dev->of_node))
+=09=09=09return 1;
+
+=09=09return 0;
+=09}
 #endif
-=09for (i =3D 0; ids[i].name !=3D NULL; i++)
-=09=09if (!strcmp(dev->name, ids[i].name))
+=09while (ids->name[0] || ids->type[0] || ids->compatible[0]) {
+=09=09if (ids->name[0] && !strcmp(dev->name, ids->name))
 =09=09=09return 1;
=20
+=09=09ids++;
+=09}
 =09return 0;
 }
=20
@@ -82,29 +84,37 @@ void __init core_driver_init_class(enum core_device_cla=
ss class,
 }
=20
 #ifdef CONFIG_OF
-void __init of_core_device_populate(enum core_device_class class,
-=09=09=09     struct of_device_id *matches)
+void __init of_core_device_populate(enum core_device_class class)
 {
+=09const struct core_driver_setup_block *b;
 =09struct device_node *np;
 =09struct core_device *dev;
 =09int num_res;
=20
-=09for_each_matching_node(np, matches) {
-=09=09pr_debug("core: registering OF device %s\n", np->full_name);
-=09=09dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
-=09=09if (!dev)
-=09=09=09return;
-=09=09dev->name =3D np->name;
-=09=09dev->of_node =3D np;
+=09for (b =3D __core_driver_block_start; b < __core_driver_block_end; b++)=
 {
+=09=09if (b->class !=3D class)
+=09=09=09continue;
+
+=09=09for_each_matching_node(np, b->drv->ids) {
+=09=09=09pr_debug("core: registering OF device %s\n",
+=09=09=09=09 np->full_name);
+=09=09=09dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
+=09=09=09if (!dev) {
+=09=09=09=09of_node_put(np);
+=09=09=09=09return;
+=09=09=09}
+=09=09=09dev->resource =3D of_device_alloc_resources(np, &num_res);
+=09=09=09if (num_res < 0) {
+=09=09=09=09of_node_put(np);
+=09=09=09=09kfree(dev);
+=09=09=09=09return;
+=09=09=09}
=20
-=09=09dev->resource =3D of_device_alloc_resources(np, &num_res);
-=09=09if (num_res < 0) {
-=09=09=09kfree(dev);
-=09=09=09return;
+=09=09=09dev->num_resources =3D num_res;
+=09=09=09dev->of_node =3D of_node_get(np);
+=09=09=09dev->name =3D np->name;
+=09=09=09core_device_register(class, dev);
 =09=09}
-=09=09dev->num_resources =3D num_res;
-
-=09=09core_device_register(class, dev);
 =09}
 }
=20
diff --git a/drivers/clocksource/arm_smp_twd.c b/drivers/clocksource/arm_sm=
p_twd.c
index 8d45000..717b4da 100644
--- a/drivers/clocksource/arm_smp_twd.c
+++ b/drivers/clocksource/arm_smp_twd.c
@@ -389,9 +389,9 @@ static int __init twd_core_init(struct core_device *dev=
)
 =09return 0;
 }
=20
-static struct core_device_id twd_core_ids[] __initdata =3D {
+static struct of_device_id twd_core_ids[] __initdata =3D {
 =09{ .name=09=3D "arm_smp_twd", },
-=09{ .name =3D "arm,smp-twd", },
+=09{ .compatible =3D "arm,smp-twd", },
 =09{},
 };
=20
diff --git a/include/linux/core_device.h b/include/linux/core_device.h
index e632868..f21caba 100644
--- a/include/linux/core_device.h
+++ b/include/linux/core_device.h
@@ -16,10 +16,6 @@
 #include <linux/ioport.h>
 #include <linux/of.h>
=20
-struct core_device_id {
-=09const char=09=09*name;
-};
-
 enum core_device_class {
 =09CORE_DEV_CLASS_IRQ,
 =09CORE_DEV_CLASS_TIMER,
@@ -38,7 +34,7 @@ struct core_device {
=20
 struct core_driver {
 =09int=09=09=09(*init)(struct core_device *);
-=09struct core_device_id=09*ids;
+=09struct of_device_id=09*ids;
 };
=20
 void core_device_register(enum core_device_class class,
@@ -46,12 +42,10 @@ void core_device_register(enum core_device_class class,
 void core_driver_init_class(enum core_device_class class,
 =09=09=09    void (*sort)(struct list_head *));
 #ifdef CONFIG_OF
-void of_core_device_populate(enum core_device_class class,
-=09=09=09     struct of_device_id *matches);
+void of_core_device_populate(enum core_device_class class);
 void core_device_irq_sort(struct list_head *head);
 #else
-static inline void of_core_device_populate(enum core_device_class class,
-=09=09=09=09=09   struct of_device_id *matches)
+static inline void of_core_device_populate(enum core_device_class class)
 {
 }
 #define core_device_irq_sort=09NULL
--------------030902030506000907060603--

