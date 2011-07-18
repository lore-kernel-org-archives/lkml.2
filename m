Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab1GRIbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:31:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:63195 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1GRIbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:31:47 -0400
X-IronPort-AV: E=Sophos;i="4.67,221,1309737600"; 
   d="scan'208";a="6821315"
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Keir Fraser <keir.xen@gmail.com>
CC: Jan Beulich <JBeulich@novell.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "keir@xen.org" <keir@xen.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CA499EDA.1E10E%keir.xen@gmail.com>
References: <CA499EDA.1E10E%keir.xen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 18 Jul 2011 09:31:45 +0100
Message-ID: <1310977905.20648.26.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 08:27 +0100, Keir Fraser wrote:
> On 18/07/2011 08:05, "Jan Beulich" <JBeulich@novell.com> wrote:
> 
> >>>> On 15.07.11 at 20:23, Keir Fraser <keir.xen@gmail.com> wrote:
> >> On 15/07/2011 18:30, "Jan Beulich" <JBeulich@novell.com> wrote:
> >> 
> >>> Actually, one more thought: What's the purpose of this hypercall if
> >>> it is set in stone what values it ought to return? Isn't a guest using
> >>> it (supposed to be) advertising that it can deal with the values being
> >>> variable (and it was just overlooked so far that this doesn't only
> >>> include varying values from boot to boot, but also migration)? Or in
> >>> other words, if we found a need to relocate the M2P table or grow
> >>> its static maximum size, it would be impossible to migrate guests
> >>> from an old to a new hypervisor.
> >> 
> >> Fair point. There has to be a static fallback set of return values for old
> >> guests.
> > 
> > Hmm, in my reading the two sentences sort of contradict each other.
> > That is, I'm not certain what route we want to go here: Keep things
> > the way they are after 23706:3dd399873c9e, and introduce a
> > completely new discovery mechanism if we find it necessary to change
> > the M2P table's location and/or size, including a mechanism for a guest
> > to announce it's capable of dealing with that? If so, I think we ought
> > to add a comment to the hypercall implementation documenting that
> > its return values must not be changed (and why).
> 
> We can return different values from the existing hypercall if that is
> negotiated with the guest, at run time or build time.

Pushing things down at build time is pretty easy. FWIW here's an
incomplete patch to push the kernel declared features down into the
hypervisor at build time extracted from some old PV in HVM container
stuff (so not directly applicable). I can bring it up to date if the
approach seems useful.

One thing which is somewhat missing is user control of non-mandatory
features declared by a kernel, although normally that should be a
decision made by the tools/hypervisor based upon available features etc.

diff -r a6c4d03b7d45 tools/libxc/xc_dom_core.c
--- a/tools/libxc/xc_dom_core.c	Mon Feb 08 13:05:48 2010 +0000
+++ b/tools/libxc/xc_dom_core.c	Thu Feb 11 12:48:47 2010 +0000
@@ -609,6 +609,7 @@
 
 int xc_dom_parse_image(struct xc_dom_image *dom)
 {
+    DECLARE_DOMCTL;
     int i;
 
     xc_dom_printf("%s: called\n", __FUNCTION__);
@@ -629,8 +630,26 @@
     /* check features */
     for ( i = 0; i < XENFEAT_NR_SUBMAPS; i++ )
     {
-        dom->f_active[i] |= dom->f_requested[i]; /* cmd line */
-        dom->f_active[i] |= dom->parms.f_required[i]; /* kernel   */
+        domctl.cmd = XEN_DOMCTL_setfeatures;
+        domctl.domain = dom->guest_domid;
+
+        domctl.u.setfeatures.submap_idx = i;
+        domctl.u.setfeatures.submap = 0;
+
+        domctl.u.setfeatures.submap |= dom->f_requested[i]; /* cmd line */
+        domctl.u.setfeatures.submap |= dom->parms.f_required[i]; /* kernel   */
+
+        xc_dom_printf("requesting features[%d] = %#x\n", domctl.u.setfeatures.submap_idx, domctl.u.setfeatures.submap);
+        if (do_domctl(dom->guest_xc, &domctl))
+        {
+            xc_dom_panic(XC_INVALID_PARAM,
+                         "%s: unable to set requested features\n", __FUNCTION__);
+            goto err;
+        }
+
+        xc_dom_printf("received   features[%d] = %#x\n", domctl.u.setfeatures.submap_idx, domctl.u.setfeatures.submap);
+        dom->f_active[i] = domctl.u.setfeatures.submap;
+
         if ( (dom->f_active[i] & dom->parms.f_supported[i]) !=
              dom->f_active[i] )
         {
@@ -639,6 +658,7 @@
             goto err;
         }
     }
+
     return 0;
 
  err:
diff -r a6c4d03b7d45 tools/libxl/xl.c
--- a/tools/libxl/xl.c	Mon Feb 08 13:05:48 2010 +0000
+++ b/tools/libxl/xl.c	Thu Feb 11 12:48:47 2010 +0000
@@ -468,6 +468,8 @@
         }
         if (config_lookup_string (&config, "ramdisk", &buf) == CONFIG_TRUE)
             b_info->u.pv.ramdisk = strdup(buf);
+        if (config_lookup_string (&config, "features", &buf) == CONFIG_TRUE)
+            b_info->u.pv.features = strdup(buf);
     }
 
     if ((vbds = config_lookup (&config, "disk")) != NULL) {
diff -r a6c4d03b7d45 xen/common/domctl.c
--- a/xen/common/domctl.c	Mon Feb 08 13:05:48 2010 +0000
+++ b/xen/common/domctl.c	Thu Feb 11 12:48:47 2010 +0000
@@ -23,6 +23,7 @@
 #include <xen/paging.h>
 #include <asm/current.h>
 #include <public/domctl.h>
+#include <public/features.h>
 #include <xsm/xsm.h>
 
 static DEFINE_SPINLOCK(domctl_lock);
@@ -960,6 +962,54 @@
     }
     break;
 
+    case XEN_DOMCTL_setfeatures:
+    {
+        struct domain *d;
+        ret = -ESRCH;
+        if ( (d = rcu_lock_domain_by_id(op->domain)) != NULL )
+        {
+            printk("dom%d set features[%d] = %#x\n", d->domain_id, op->u.setfeatures.submap_idx, op->u.setfeatures.submap);
+
+            switch (op->u.setfeatures.submap_idx) {
+            case 0:
+                if ( !paging_mode_translate(d) )
+                {
+                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_page_tables);
+                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_auto_translated_physmap);
+                }
+                if ( !is_pvhvm_domain(d) )
+                {
+                    op->u.setfeatures.submap &= ~(1U<<XENFEAT_supervisor_mode_kernel);
+                }
+
+                op->u.setfeatures.submap &= ~(1U<<XENFEAT_writable_descriptor_tables);
+
+                /* XXX other features */
+
+
+                if ( op->u.setfeatures.submap &(1U<<XENFEAT_supervisor_mode_kernel) )
+                    d->arch.pv_kernel_minimum_rpl = 0;
+
+                ret = 0;
+                break;
+
+            default:
+                printk("dom%d unknown feature submap %d\n", d->domain_id, op->u.setfeatures.submap_idx);
+                op->u.setfeatures.submap = 0;
+                ret = -EINVAL;
+                break;
+            }
+
+            rcu_unlock_domain(d);
+            ret = 0;
+
+            if ( copy_to_guest(u_domctl, op, 1) )
+                ret = -EFAULT;
+
+        }
+    }
+    break;
+
     default:
         ret = arch_do_domctl(op, u_domctl);
         break;
diff -r a6c4d03b7d45 xen/include/public/domctl.h
--- a/xen/include/public/domctl.h	Mon Feb 08 13:05:48 2010 +0000
+++ b/xen/include/public/domctl.h	Thu Feb 11 12:48:47 2010 +0000
@@ -169,6 +169,13 @@
     XEN_GUEST_HANDLE_64(xen_pfn_t) array;
 };
 
+/* XEN_DOMCTL_setfeatures */
+struct xen_domctl_setfeatures {
+    /* IN variables */
+    unsigned int submap_idx;    /* which 32-bit submap to return */
+    /* IN/OUT variables */
+    uint32_t     submap;        /* 32-bit submap, updated with actual result. */
+};
 
 /*
  * Control shadow pagetables operation
@@ -842,6 +848,7 @@
 #define XEN_DOMCTL_gettscinfo                    59
 #define XEN_DOMCTL_settscinfo                    60
 #define XEN_DOMCTL_getpageframeinfo3             61
+#define XEN_DOMCTL_setfeatures	                 62
 #define XEN_DOMCTL_gdbsx_guestmemio            1000
 #define XEN_DOMCTL_gdbsx_pausevcpu             1001
 #define XEN_DOMCTL_gdbsx_unpausevcpu           1002
@@ -855,6 +862,7 @@
         struct xen_domctl_getpageframeinfo  getpageframeinfo;
         struct xen_domctl_getpageframeinfo2 getpageframeinfo2;
         struct xen_domctl_getpageframeinfo3 getpageframeinfo3;
+        struct xen_domctl_setfeatures		setfeatures;
         struct xen_domctl_vcpuaffinity      vcpuaffinity;
         struct xen_domctl_shadow_op         shadow_op;
         struct xen_domctl_max_mem           max_mem;


