Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934356Ab1FWSc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:32:56 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:23110
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932699Ab1FWScw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:32:52 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz1dbaL1432N98dKc8kzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 24 Jun 2011 02:38:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <patches@linaro.org>, <netdev@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Jason Liu <jason.hui@linaro.org>, <linux-kernel@vger.kernel.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Message-ID: <20110623183821.GA19188@S2100-06.ap.freescale.net>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org>
 <1308410354-21387-2-git-send-email-shawn.guo@linaro.org>
 <20110618161934.GH8195@ponder.secretlab.ca>
 <20110619073000.GA23171@S2100-06.ap.freescale.net>
 <20110621135558.GB9228@S2101-09.ap.freescale.net>
 <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTim4vunTm1176MRw3pqRZnunu4=9jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:13:50PM -0600, Grant Likely wrote:
[...]
> >
> >  /**
> > + *     of_get_device_index - Get device index by looking up "aliases" node
> > + *     @np:    Pointer to device node that asks for device index
> > + *     @name:  The device alias without index number
> > + *
> > + *     Returns the device index if find it, else returns -ENODEV.
> > + */
> > +int of_get_device_index(struct device_node *np, const char *alias)
> > +{
> > +       struct device_node *aliases = of_find_node_by_name(NULL, "aliases");
> > +       struct property *prop;
> > +       char name[32];
> > +       int index = 0;
> > +
> > +       if (!aliases)
> > +               return -ENODEV;
> > +
> > +       while (1) {
> > +               snprintf(name, sizeof(name), "%s%d", alias, index);
> > +               prop = of_find_property(aliases, name, NULL);
> > +               if (!prop)
> > +                       return -ENODEV;
> > +               if (np == of_find_node_by_path(prop->value))
> > +                       break;
> > +               index++;
> > +       }
> 
> Rather than parsing the alias strings everytime, it would probably be
> better to preprocess all the properties in the aliases node and create
> a lookup table of alias->node references that can be walked quickly
> and trivially.
> 
> Also, when obtaining an enumeration for a device, you'll need to be
> careful about what number gets returned.  If the node doesn't match a
> given alias, but aliases do exist for other devices of like type, then
> you need to be careful not to assign a number already assigned to
> another device via an alias (this of course assumes the driver
> supports dynamics enumeration, which many drivers will).  It would be
> 

Grant, please take a look at the second shot below.  Please let me
know what you think.

diff --git a/arch/arm/boot/dts/imx51-babbage.dts b/arch/arm/boot/dts/imx51-babbage.dts
index 7976932..f4a5c3c 100644
--- a/arch/arm/boot/dts/imx51-babbage.dts
+++ b/arch/arm/boot/dts/imx51-babbage.dts
@@ -18,6 +18,12 @@
 	compatible = "fsl,imx51-babbage", "fsl,imx51";
 	interrupt-parent = <&tzic>;
 
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+	};
+
 	chosen {
 		bootargs = "console=ttymxc0,115200 root=/dev/mmcblk0p3 rootwait";
 	};
@@ -47,29 +53,29 @@
 			reg = <0x70000000 0x40000>;
 			ranges;
 
-			uart@7000c000 {
-				compatible = "fsl,imx51-uart", "fsl,imx-uart";
+			uart2: uart@7000c000 {
+				compatible = "fsl,imx51-uart", "fsl,imx21-uart";
 				reg = <0x7000c000 0x4000>;
 				interrupts = <33>;
 				id = <3>;
				fsl,has-rts-cts;
 			};
 		};
 
-		uart@73fbc000 {
-			compatible = "fsl,imx51-uart", "fsl,imx-uart";
+		uart0: uart@73fbc000 {
+			compatible = "fsl,imx51-uart", "fsl,imx21-uart";
 			reg = <0x73fbc000 0x4000>;
 			interrupts = <31>;
 			id = <1>;
			fsl,has-rts-cts;
 		};
 
-		uart@73fc0000 {
-			compatible = "fsl,imx51-uart", "fsl,imx-uart";
+		uart1: uart@73fc0000 {
+			compatible = "fsl,imx51-uart", "fsl,imx21-uart";
 			reg = <0x73fc0000 0x4000>;
 			interrupts = <32>;
 			id = <2>;
			fsl,has-rts-cts;
 		};
 	};
 
diff --git a/arch/arm/mach-mx5/imx51-dt.c b/arch/arm/mach-mx5/imx51-dt.c
index 8bfdb91..e6c7298 100644
--- a/arch/arm/mach-mx5/imx51-dt.c
+++ b/arch/arm/mach-mx5/imx51-dt.c
@@ -40,6 +40,8 @@ static const struct of_device_id tzic_of_match[] __initconst = {
 
 static void __init imx51_dt_init(void)
 {
+	of_scan_aliases();
+
 	irq_domain_generate_simple(tzic_of_match, MX51_TZIC_BASE_ADDR, 0);
 
 	of_platform_populate(NULL, of_default_bus_match_table,
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 632ebae..90349a2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -17,12 +17,27 @@
  *      as published by the Free Software Foundation; either version
  *      2 of the License, or (at your option) any later version.
  */
+#include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 
+struct alias_devname {
+	char devname[32];
+	struct list_head link;
+	struct list_head head;
+};
+
+struct alias_devid {
+	int devid;
+	struct device_node *node;
+	struct list_head link;
+};
+
+static LIST_HEAD(aliases_lookup);
+
 struct device_node *allnodes;
 struct device_node *of_chosen;
 
@@ -922,3 +937,170 @@ out_unlock:
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
 
+/*
+ * get_alias_dev_name_id - Get device name and id from alias name
+ *
+ * an:	The alias name passed in
+ * dn:	The pointer used to return device name
+ *
+ * Returns device id which should be the number at the end of alias
+ * name, otherwise returns -1.
+ */
+static int get_alias_name_id(char *an, char *dn)
+{
+	int len = strlen(an);
+	char *end = an + len;
+
+	while (isdigit(*--end))
+		len--;
+
+	end++;
+	strncpy(dn, an, len);
+	dn[len] = '\0';
+
+	return strlen(end) ? simple_strtol(end, NULL, 10) : -1;
+}
+
+/*
+ * get_an_available_devid - Get an available devid for the given devname
+ *
+ * adn:	The pointer to the given alias_devname
+ *
+ * Returns the available devid
+ */
+static int get_an_available_devid(struct alias_devname *adn)
+{
+	int devid = 0;
+	struct alias_devid *adi;
+
+	while (1) {
+		bool used = false;
+		list_for_each_entry(adi, &adn->head, link) {
+			if (adi->devid == devid) {
+				used = true;
+				break;
+			}
+		}
+
+		if (!used)
+			break;
+
+		devid++;
+	}
+
+	return devid;
+}
+
+/*
+ * of_scan_aliases - Scan all properties of aliases node and populate the
+ * 		     global lookup table with the device name and id info
+ *
+ * Returns the number of aliases properties found, or error code in error case.
+ */
+int of_scan_aliases(void)
+{
+	struct device_node *aliases = of_find_node_by_name(NULL, "aliases");
+	struct property *pp;
+	struct alias_devname *adn;
+	struct alias_devid *adi;
+	int ret = 0;
+
+	if (!aliases) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	for (pp = aliases->properties; pp != NULL; pp = pp->next) {
+		bool found = false;
+		char devname[32];
+		int devid = get_alias_name_id(pp->name, devname);
+
+		/* We do not want to proceed this sentinel one */
+		if (!strcmp(pp->name, "name") && !strcmp(pp->value, "aliases"))
+			break;
+
+		/* See if the devname already exists */
+		list_for_each_entry(adn, &aliases_lookup, link) {
+			if (!strcmp(adn->devname, devname)) {
+				found = true;
+				break;
+			}
+		}
+
+		/*
+		 * Create the entry for this devname if not found,
+		 * and add it into aliases_lookup
+		 */
+		if (!found) {
+			adn = kzalloc(sizeof(*adn), GFP_KERNEL);
+			if (!adn) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			strcpy(adn->devname, devname);
+			INIT_LIST_HEAD(&adn->head);
+			list_add_tail(&adn->link, &aliases_lookup);
+		}
+
+		/*
+		 * Save the devid as one entry of the list for this
+		 * specified devname
+		 */
+		adi = kzalloc(sizeof(*adi), GFP_KERNEL);
+		if (!adi) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		adi->devid = (devid == -1) ? get_an_available_devid(adn) :
+					     devid;
+		adi->node = of_find_node_by_path(pp->value);
+
+		list_add_tail(&adi->link, &adn->head);
+		ret++;
+	}
+
+out:
+	return ret;
+}
+
+/**
+ *	of_get_device_id - Get device id by looking up "aliases" node
+ *	@np:	Pointer to device node that asks for device id
+ *	@name:	The device alias name
+ *
+ *	Returns the device id if find it, else returns -ENODEV.
+ */
+int of_get_device_id(struct device_node *np, const char *name)
+{
+	struct alias_devname *adn;
+	struct alias_devid *adi;
+	bool found = false;
+	int ret;
+
+	list_for_each_entry(adn, &aliases_lookup, link) {
+		if (!strcmp(adn->devname, name)) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	found = false;
+	list_for_each_entry(adi, &adn->head, link) {
+		if (np == adi->node) {
+			found = true;
+			break;
+		}
+	}
+
+	ret = found ? adi->devid : -ENODEV;
+out:
+	return ret;
+}
+EXPORT_SYMBOL(of_get_device_id);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 2769353..062639e 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1225,43 +1265,33 @@ static int serial_imx_resume(struct platform_device *dev)
 	return 0;
 }
 
 static int serial_imx_probe_dt(struct imx_port *sport,
 		struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
-	const __be32 *line;
+	int line;
 
 	if (!node)
 		return -ENODEV;
 
-	line = of_get_property(node, "id", NULL);
-	if (!line)
+	line = of_get_device_id(node, "serial");
+	if (IS_ERR_VALUE(line))
 		return -ENODEV;
 
-	sport->port.line = be32_to_cpup(line) - 1;
+	sport->port.line = line;
 
diff --git a/include/linux/of.h b/include/linux/of.h
index bfc0ed1..270c671 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -213,6 +213,9 @@ extern int of_parse_phandles_with_args(struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct device_node **out_node, const void **out_args);
 
+extern int of_scan_aliases(void);
+extern int of_get_device_id(struct device_node *np, const char *name);
+
 extern int of_machine_is_compatible(const char *compat);
 
 extern int prom_add_property(struct device_node* np, struct property* prop);

-- 
Regards,
Shawn

