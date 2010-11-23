Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0KWMzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:55:37 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:20081 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0KWMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:55:36 -0500
X-IronPort-AV: E=Sophos;i="4.59,241,1288569600"; 
   d="scan'208";a="3003806"
Date: Tue, 23 Nov 2010 12:55:37 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: use PHYSDEVOP_get_free_pirq to implement
 find_unbound_pirq
In-Reply-To: <20101122161433.GC20383@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1011231237170.2373@kaball-desktop>
References: <alpine.DEB.2.00.1011191350250.2373@kaball-desktop> <20101119162353.GA26747@dumpdata.com> <alpine.DEB.2.00.1011200115240.2373@kaball-desktop> <20101122161433.GC20383@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010, Konrad Rzeszutek Wilk wrote:
> On Sat, Nov 20, 2010 at 01:19:31AM +0000, Stefano Stabellini wrote:
> > On Fri, 19 Nov 2010, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Nov 19, 2010 at 01:58:03PM +0000, Stefano Stabellini wrote:
> > > > Use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq
> > > > 
> > > > Use the new hypercall PHYSDEVOP_get_free_pirq to ask Xen to allocate a
> > > > pirq. Remove the unsupported PHYSDEVOP_get_nr_pirqs hypercall to get the
> > > > amount of pirq available.
> > > > 
> > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > 
> > > > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > > > index 321a0c8..ffd286e 100644
> > > > --- a/drivers/xen/events.c
> > > > +++ b/drivers/xen/events.c
> > > > @@ -382,12 +382,17 @@ static int get_nr_hw_irqs(void)
> > > >  	return ret;
> > > >  }
> > > >  
> > > > -/* callers of this function should make sure that PHYSDEVOP_get_nr_pirqs
> > > > - * succeeded otherwise nr_pirqs won't hold the right value */
> > > > -static int find_unbound_pirq(void)
> > > > +static int find_unbound_pirq(int type)
> > > >  {
> > > > -	int i;
> > > > -	for (i = nr_pirqs-1; i >= 0; i--) {
> > > > +	int rc, i;
> > > > +	struct physdev_get_free_pirq op_get_free_pirq;
> > > > +	op_get_free_pirq.type = type;
> > > > +
> > > > +	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
> > > > +	if (!rc)
> > > > +		return op_get_free_pirq.pirq;
> > > > +
> > > > +	for (i = 16; i <= nr_pirqs-1; i++) {
> > > 
> > > 16? No no. Why not re-use the old loop, like so:
> > > 
> > >  	for (i = nr_pirqs-1; i >= 0; i--) {
> > > 
> > 
> > Because we don't know the real nr_pirqs anymore (PHYSDEVOP_get_nr_pirqs
> > has been removed), so it is highly possible that starting from the top
> > down would give us pirq numbers out of range in Xen.  Therefore we need
> > to start from the bottom up, and the bottom for Xen is 16.
> 
> Right, I forgot about the hypercall call. How about using LEGACY_IRQ instead then?
> 

Do you mean NR_IRQS_LEGACY? Yeah, I could do that.

> > 
> > 
> > > >  		if (pirq_to_irq[i] < 0)
> > > >  			return i;
> > > >  	}
> > > > @@ -669,7 +674,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
> > > >  	if (*irq == -1)
> > > >  		goto out;
> > > >  
> > > > -	*pirq = find_unbound_pirq();
> > > > +	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
> > > >  	if (*pirq == -1)
> > > >  		goto out;
> > > >  
> > > > @@ -1504,23 +1509,12 @@ void xen_callback_vector(void) {}
> > > >  void __init xen_init_IRQ(void)
> > > >  {
> > > >  	int i, rc;
> > > > -	struct physdev_nr_pirqs op_nr_pirqs;
> > > >  
> > > >  	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
> > > >  				    GFP_KERNEL);
> > > >  	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
> > > >  
> > > > -	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
> > > > -	if (rc < 0) {
> > > > -		nr_pirqs = nr_irqs;
> > > > -		if (rc != -ENOSYS)
> > > > -			printk(KERN_WARNING "PHYSDEVOP_get_nr_pirqs returned rc=%d\n", rc);
> > > > -	} else {
> > > > -		if (xen_pv_domain() && !xen_initial_domain())
> > > > -			nr_pirqs = max((int)op_nr_pirqs.nr_pirqs, nr_irqs);
> > > > -		else
> > > > -			nr_pirqs = op_nr_pirqs.nr_pirqs;
> > > > -	}
> > > > +	nr_pirqs = nr_irqs;
> > > 
> > > Why not just get rid of nr_pirgs altogether then? And use 'nr_irqs' instead?
> > > 
> > 
> > Yeah, I guess we could do that. I kept it around just to make it more
> > obvious that the max pirq number is different from nr_irqs and we don't
> > know what the exact value is.
> 
> 
> But with this change it is the same, is it not?
> 
> 	"nr_pirgs = nr_irqs;"
> 
> Or when you say "max pirq" you are referring to something else altogether?
> 

Yes, it is the same. I guess a comment would be better then.

Appended the updated version of this patch.

---

Use PHYSDEVOP_get_free_pirq to implement find_unbound_pirq

Use the new hypercall PHYSDEVOP_get_free_pirq to ask Xen to allocate a
pirq. Remove the unsupported PHYSDEVOP_get_nr_pirqs hypercall to get the
amount of pirq available.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2811bb9..9f19daa 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -105,7 +105,6 @@ struct irq_info
 
 static struct irq_info *irq_info;
 static int *pirq_to_irq;
-static int nr_pirqs;
 
 static int *evtchn_to_irq;
 struct cpu_evtchn_s {
@@ -385,12 +384,17 @@ static int get_nr_hw_irqs(void)
 	return ret;
 }
 
-/* callers of this function should make sure that PHYSDEVOP_get_nr_pirqs
- * succeeded otherwise nr_pirqs won't hold the right value */
-static int find_unbound_pirq(void)
+static int find_unbound_pirq(int type)
 {
-	int i;
-	for (i = nr_pirqs-1; i >= 0; i--) {
+	int rc, i;
+	struct physdev_get_free_pirq op_get_free_pirq;
+	op_get_free_pirq.type = type;
+
+	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_free_pirq, &op_get_free_pirq);
+	if (!rc)
+		return op_get_free_pirq.pirq;
+
+	for (i = NR_IRQS_LEGACY; i <= nr_irqs-1; i++) {
 		if (pirq_to_irq[i] < 0)
 			return i;
 	}
@@ -611,9 +615,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name)
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if ((pirq > nr_pirqs) || (gsi > nr_irqs)) {
+	if ((pirq > nr_irqs) || (gsi > nr_irqs)) {
 		printk(KERN_WARNING "xen_map_pirq_gsi: %s %s is incorrect!\n",
-			pirq > nr_pirqs ? "nr_pirqs" :"",
+			pirq > nr_irqs ? "nr_pirqs" :"",
 			gsi > nr_irqs ? "nr_irqs" : "");
 		goto out;
 	}
@@ -672,7 +676,7 @@ void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
 	if (*irq == -1)
 		goto out;
 
-	*pirq = find_unbound_pirq();
+	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
 	if (*pirq == -1)
 		goto out;
 
@@ -1506,26 +1510,17 @@ void xen_callback_vector(void) {}
 
 void __init xen_init_IRQ(void)
 {
-	int i, rc;
-	struct physdev_nr_pirqs op_nr_pirqs;
+	int i;
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
 	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
-	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
-	if (rc < 0) {
-		nr_pirqs = nr_irqs;
-		if (rc != -ENOSYS)
-			printk(KERN_WARNING "PHYSDEVOP_get_nr_pirqs returned rc=%d\n", rc);
-	} else {
-		if (xen_pv_domain() && !xen_initial_domain())
-			nr_pirqs = max((int)op_nr_pirqs.nr_pirqs, nr_irqs);
-		else
-			nr_pirqs = op_nr_pirqs.nr_pirqs;
-	}
-	pirq_to_irq = kcalloc(nr_pirqs, sizeof(*pirq_to_irq), GFP_KERNEL);
-	for (i = 0; i < nr_pirqs; i++)
+	/* We are using nr_irqs as the maximum number of pirq available but
+	 * that number is actually chosen by Xen and we don't know exactly
+	 * what it is. Be careful choosing high pirq numbers. */
+	pirq_to_irq = kcalloc(nr_irqs, sizeof(*pirq_to_irq), GFP_KERNEL);
+	for (i = 0; i < nr_irqs; i++)
 		pirq_to_irq[i] = -1;
 
 	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
index 2b2c66c..534cac8 100644
--- a/include/xen/interface/physdev.h
+++ b/include/xen/interface/physdev.h
@@ -188,6 +188,16 @@ struct physdev_nr_pirqs {
     uint32_t nr_pirqs;
 };
 
+/* type is MAP_PIRQ_TYPE_GSI or MAP_PIRQ_TYPE_MSI
+ * the hypercall returns a free pirq */
+#define PHYSDEVOP_get_free_pirq    23
+struct physdev_get_free_pirq {
+    /* IN */ 
+    int type;
+    /* OUT */
+    uint32_t pirq;
+};
+
 /*
  * Notify that some PIRQ-bound event channels have been unmasked.
  * ** This command is obsolete since interface version 0x00030202 and is **
