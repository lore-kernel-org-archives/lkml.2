Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092Ab1IUVIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:08:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56502 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1IUVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:08:44 -0400
Date: Wed, 21 Sep 2011 17:08:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH] xen/pciback: Use mutexes when working
 with Xenbus state transitions.
Message-ID: <20110921210838.GA1016@phenom.oracle.com>
References: <20110916190601.GA31796@phenom.oracle.com>
 <4E7738E90200007800056A54@nat28.tlf.novell.com>
 <4E773D440200007800056A6D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E773D440200007800056A6D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E7A5258.010D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 12:01:56PM +0100, Jan Beulich wrote:
> >>> On 19.09.11 at 12:43, "Jan Beulich" <JBeulich@suse.com> wrote:
> >>>> On 16.09.11 at 21:06, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> >> The caller that orchestrates the state changes is xenwatch_thread
> >> and it takes a mutex. In our processing of Xenbus states we can take
> >> the luxery of going to sleep on a mutex, so lets do that and
> > 
> > This is only the direct conversion of existing spinlock accesses in
> > xenbus.c. However, in the course of converting from the legacy
> > implementation you stripped a couple more (in xen_pcibk_attach(),
> > xen_pcibk_reconfigure(), and xen_pcibk_setup_backend()), and
> 
> Actually, xen_pcibk_attach() has its lock taken in xen_pcibk_do_attach(),
> so no change needed there.
> 
> In xen_pcibk_reconfigure() and xen_pcibk_setup_backend() the locking
> may be redundant with the one in passthrough.c/vpci.c - is that the
> basis upon which you removed the locks taken there?

No. I believe the reason was much simpler.. it was b/c of this patch (see below).
But for the life of me I don't recall what deadlock we could hit.

I think the better choice will be to restore the call-sites of these
spinlocks but use mutex instead.

So let me post two patches - one for xenbus.c and one for vpci.c to
complement "xen/pciback: use mutex rather than spinlock in passthrough backend"
you posted and I queued up.


commit 3a8d1841ae2dd32452b79284da03eda596f30827
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Jul 23 14:35:47 2010 -0400

    xen/pciback: Redo spinlock usage.
    
    We were using coarse spinlocks that could end up with a deadlock.
    This patch fixes that and makes the spinlocks much more fine-grained.
    
    We also drop be->watchding state spinlocks as they are already
    guarded by the xenwatch_thread against multiple customers.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/drivers/xen/pciback/xenbus.c b/drivers/xen/pciback/xenbus.c
index d448bf5..993b659 100644
--- a/drivers/xen/pciback/xenbus.c
+++ b/drivers/xen/pciback/xenbus.c
@@ -54,23 +54,29 @@ static void pciback_disconnect(struct pciback_device *pdev)
 		unbind_from_irqhandler(pdev->evtchn_irq, pdev);
 		pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
 	}
+	spin_unlock(&pdev->dev_lock);
 
 	/* If the driver domain started an op, make sure we complete it
 	 * before releasing the shared memory */
+
+	/* Note, the workqueue does not use spinlocks at all.*/
 	flush_workqueue(pciback_wq);
 
+	spin_lock(&pdev->dev_lock);
 	if (pdev->sh_info != NULL) {
 		xenbus_unmap_ring_vfree(pdev->xdev, pdev->sh_info);
 		pdev->sh_info = NULL;
 	}
-
 	spin_unlock(&pdev->dev_lock);
+
 }
 
 static void free_pdev(struct pciback_device *pdev)
 {
-	if (pdev->be_watching)
+	if (pdev->be_watching) {
 		unregister_xenbus_watch(&pdev->be_watch);
+		pdev->be_watching = 0;
+	}
 
 	pciback_disconnect(pdev);
 
@@ -98,7 +104,10 @@ static int pciback_do_attach(struct pciback_device *pdev, int gnt_ref,
 				"Error mapping other domain page in ours.");
 		goto out;
 	}
+
+	spin_lock(&pdev->dev_lock);
 	pdev->sh_info = vaddr;
+	spin_unlock(&pdev->dev_lock);
 
 	err = bind_interdomain_evtchn_to_irqhandler(
 		pdev->xdev->otherend_id, remote_evtchn, pciback_handle_event,
@@ -108,7 +117,10 @@ static int pciback_do_attach(struct pciback_device *pdev, int gnt_ref,
 				 "Error binding event channel to IRQ");
 		goto out;
 	}
+
+	spin_lock(&pdev->dev_lock);
 	pdev->evtchn_irq = err;
+	spin_unlock(&pdev->dev_lock);
 	err = 0;
 
 	dev_dbg(&pdev->xdev->dev, "Attached!\n");
@@ -122,7 +134,6 @@ static int pciback_attach(struct pciback_device *pdev)
 	int gnt_ref, remote_evtchn;
 	char *magic = NULL;
 
-	spin_lock(&pdev->dev_lock);
 
 	/* Make sure we only do this setup once */
 	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
@@ -168,7 +179,6 @@ static int pciback_attach(struct pciback_device *pdev)
 
 	dev_dbg(&pdev->xdev->dev, "Connected? %d\n", err);
 out:
-	spin_unlock(&pdev->dev_lock);
 
 	kfree(magic);
 
@@ -340,7 +350,6 @@ static int pciback_reconfigure(struct pciback_device *pdev)
 	char state_str[64];
 	char dev_str[64];
 
-	spin_lock(&pdev->dev_lock);
 
 	dev_dbg(&pdev->xdev->dev, "Reconfiguring device ...\n");
 
@@ -481,8 +490,6 @@ static int pciback_reconfigure(struct pciback_device *pdev)
 	}
 
 out:
-	spin_unlock(&pdev->dev_lock);
-
 	return 0;
 }
 
@@ -539,8 +546,6 @@ static int pciback_setup_backend(struct pciback_device *pdev)
 	char dev_str[64];
 	char state_str[64];
 
-	spin_lock(&pdev->dev_lock);
-
 	/* It's possible we could get the call to setup twice, so make sure
 	 * we're not already connected.
 	 */
@@ -621,8 +626,6 @@ static int pciback_setup_backend(struct pciback_device *pdev)
 				 "Error switching to initialised state!");
 
 out:
-	spin_unlock(&pdev->dev_lock);
-
 	if (!err)
 		/* see if pcifront is already configured (if not, we'll wait) */
 		pciback_attach(pdev);
@@ -669,6 +672,7 @@ static int pciback_xenbus_probe(struct xenbus_device *dev,
 				pciback_be_watch);
 	if (err)
 		goto out;
+
 	pdev->be_watching = 1;
 
 	/* We need to force a call to our callback here in case
@@ -708,8 +712,8 @@ int __init pciback_xenbus_register(void)
 {
 	pciback_wq = create_workqueue("pciback_workqueue");
 	if (!pciback_wq) {
-		printk(KERN_ERR "pciback_xenbus_register: create"
-			"pciback_workqueue failed\n");
+		printk(KERN_ERR "%s: create"
+			"pciback_workqueue failed\n",__FUNCTION__);
 		return -EFAULT;
 	}
 	return xenbus_register_backend(&xenbus_pciback_driver);
