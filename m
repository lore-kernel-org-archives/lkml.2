Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab1BSDHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 22:07:08 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59891 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab1BSDHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 22:07:05 -0500
Date: Fri, 18 Feb 2011 19:06:59 -0800
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: David Woodhouse <dwmw2@infradead.org>, cbou@mail.ru,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, dmitry.torokhov@gmail.com,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness
Message-ID: <20110218190659.7f955e4c@queued.net>
In-Reply-To: <AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
	<1297896277.3011.5.camel@macbook.infradead.org>
	<AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 23:42:57 +0000
Daniel Drake <dsd@laptop.org> wrote:

> On 16 February 2011 22:44, David Woodhouse <dwmw2@infradead.org>
> wrote:
> > On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
> >>
> >> +static int __init add_common_platform_devices(void)
> >> +{
> >> +       struct platform_device *pdev;
> >> +
> >> +       pdev = platform_device_register_simple("olpc-battery", -1,
> >> NULL, 0);
> >> +       if (IS_ERR(pdev))
> >> +               return PTR_ERR(pdev);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >
> > Still kind of sucks that you have to do this, and can't bind to
> > something in the device-tree.
> 
> OK, feel free to put this patch on hold for now. I started looking at
> the device tree approach today. It looks doable but first we have to
> fix a DT bug/inconsistency that is preventing us from correctly
> binding to the tree's devices.
> 
> Daniel


Mea culpa.  The patch below fixes a bug I introduced earlier.
Cc'ing the sparc folks, as this probably affects them
(although I would think that it fixes broken behavior for them..?)





From: Andres Salomon <dilinger@queued.net>

Commit e2f2a93b changed dp->name from using the 'name' property to
using package-to-path.  This fixed /proc/device-tree creation by
eliminating conflicts between names (the 'name' property provides
names like 'battery', whereas package-to-path provides names like
'/foo/bar/battery@0', which we stripped to 'battery@0').  However,
it also breaks of_device_id table matching.

The fix that we _really_ wanted was to keep dp->name based upon
the name property ('battery'), but based dp->full_name upon
package-to-path ('battery@0').  This patch does just that.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Reported-by: Daniel Drake <dsd@laptop.org>
---
 drivers/of/pdt.c |   42 +++++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 28295d0..b39d584 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -48,7 +48,7 @@ static inline void irq_trans_init(struct device_node *dp) { }
 
 static inline const char *of_pdt_node_name(struct device_node *dp)
 {
-	return dp->name;
+	return NULL;
 }
 
 #endif /* !CONFIG_SPARC */
@@ -156,23 +156,6 @@ static char * __init of_pdt_try_pkg2path(phandle node)
 	return res+1;
 }
 
-/*
- * When fetching the node's name, first try using package-to-path; if
- * that fails (either because the arch hasn't supplied a PROM callback,
- * or some other random failure), fall back to just looking at the node's
- * 'name' property.
- */
-static char * __init of_pdt_build_name(phandle node)
-{
-	char *buf;
-
-	buf = of_pdt_try_pkg2path(node);
-	if (!buf)
-		buf = of_pdt_get_one_property(node, "name");
-
-	return buf;
-}
-
 static struct device_node * __init of_pdt_create_node(phandle node,
 						    struct device_node *parent)
 {
@@ -187,7 +170,7 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 
 	kref_init(&dp->kref);
 
-	dp->name = of_pdt_build_name(node);
+	dp->name = of_pdt_get_one_property(node, "name");
 	dp->type = of_pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
 
@@ -198,13 +181,26 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	return dp;
 }
 
-static char * __init of_pdt_build_full_name(struct device_node *dp)
+static char * __init of_pdt_build_full_name(struct device_node *dp,
+		phandle node)
 {
 	int len, ourlen, plen;
+	const char *name;
 	char *n;
 
+	/*
+	 * When fetching the full name, rather than what we see with the
+	 * name property (ie, 'battery'), we want the name we see with
+	 * package-to-path (ie, 'battery@0').
+	 */
+	name = of_pdt_node_name(dp);
+	if (!name)
+		name = of_pdt_try_pkg2path(node);
+	if (!name)
+		name = dp->name;
+
 	plen = strlen(dp->parent->full_name);
-	ourlen = strlen(of_pdt_node_name(dp));
+	ourlen = strlen(name);
 	len = ourlen + plen + 2;
 
 	n = prom_early_alloc(len);
@@ -213,7 +209,7 @@ static char * __init of_pdt_build_full_name(struct device_node *dp)
 		strcpy(n + plen, "/");
 		plen++;
 	}
-	strcpy(n + plen, of_pdt_node_name(dp));
+	strcpy(n + plen, name);
 
 	return n;
 }
@@ -243,7 +239,7 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 #if defined(CONFIG_SPARC)
 		dp->path_component_name = build_path_component(dp);
 #endif
-		dp->full_name = of_pdt_build_full_name(dp);
+		dp->full_name = of_pdt_build_full_name(dp, node);
 
 		dp->child = of_pdt_build_tree(dp,
 				of_pdt_prom_ops->getchild(node), nextp);
-- 
1.7.2.3

