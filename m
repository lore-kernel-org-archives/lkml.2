Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322Ab2KBQh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:37:29 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:43841 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab2KBQh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:37:28 -0400
Date: Fri, 2 Nov 2012 12:37:20 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/hvm: If we fail to fetch an HVM
 parameter print out which flag it is.
Message-ID: <20121102163720.GA27213@konrad-lan.dumpdata.com>
References: <1350673381-20342-1-git-send-email-konrad.wilk@oracle.com>
 <1350984138.2237.22.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350984138.2237.22.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:22:18AM +0100, Ian Campbell wrote:
> On Fri, 2012-10-19 at 20:03 +0100, Konrad Rzeszutek Wilk wrote:
> > Makes it easier to troubleshoot in the field.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  include/xen/hvm.h |   31 +++++++++++++++++++++++++++++--
> >  1 files changed, 29 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/xen/hvm.h b/include/xen/hvm.h
> > index b193fa2..c2a4238 100644
> > --- a/include/xen/hvm.h
> > +++ b/include/xen/hvm.h
> > @@ -5,6 +5,33 @@
> >  #include <xen/interface/hvm/params.h>
> >  #include <asm/xen/hypercall.h>
> >  
> > +static const char *param_name(int op)
> > +{
> > +	static const char *const names[] = {
> 
> #define PARAM(x) [x] = STRINGIFY(x)
> would save from typos due to doubling everything up.
> 
> Or even:
> #define PARAM(x) [HVM_PARAM#_x] STRINGIFY(x)
> 
> > +		[HVM_PARAM_CALLBACK_IRQ] = "HVM_PARAM_CALLBACK_IRQ",
> > +		[HVM_PARAM_STORE_PFN] = "HVM_PARAM_STORE_PFN",
> > +		[HVM_PARAM_STORE_EVTCHN] = "HVM_PARAM_STORE_EVTCHN",
> > +		[HVM_PARAM_PAE_ENABLED] = "HVM_PARAM_PAE_ENABLED",
> > +		[HVM_PARAM_IOREQ_PFN] = "HVM_PARAM_IOREQ_PFN",
> > +		[HVM_PARAM_BUFIOREQ_PFN] = "HVM_PARAM_BUFIOREQ_PFN",
> > +		[HVM_PARAM_TIMER_MODE] = "HVM_PARAM_TIMER_MODE",
> > +		[HVM_PARAM_HPET_ENABLED] = "HVM_PARAM_HPET_ENABLED",
> > +		[HVM_PARAM_IDENT_PT] = "HVM_PARAM_IDENT_PT",
> > +		[HVM_PARAM_DM_DOMAIN] = "HVM_PARAM_DM_DOMAIN",
> > +		[HVM_PARAM_ACPI_S_STATE] = "HVM_PARAM_ACPI_S_STATE",
> > +		[HVM_PARAM_VM86_TSS] = "HVM_PARAM_VM86_TSS",
> > +		[HVM_PARAM_VPT_ALIGN] = "HVM_PARAM_VPT_ALIGN",
> > +		[HVM_PARAM_CONSOLE_PFN] = "HVM_PARAM_CONSOLE_PFN",
> > +		[HVM_PARAM_CONSOLE_EVTCHN] = "HVM_PARAM_CONSOLE_EVTCHN" };
> 
> You probably want a , and a newline before the }.
> 
> > +
> > +	if (op >= ARRAY_SIZE(names))
> > +		return "unknown";
> > +
> > +	if (!names[op])
> > +		return "reserved";
> > +
> > +	return names[op];
> > +}
> >  static inline int hvm_get_parameter(int idx, uint64_t *value)
> >  {
> >  	struct xen_hvm_param xhv;
> > @@ -14,8 +41,8 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
> >  	xhv.index = idx;
> >  	r = HYPERVISOR_hvm_op(HVMOP_get_param, &xhv);
> >  	if (r < 0) {
> > -		printk(KERN_ERR "Cannot get hvm parameter %d: %d!\n",
> > -			idx, r);
> > +		printk(KERN_ERR "Cannot get hvm parameter %s (%d): %d!\n",
> > +			param_name(idx), idx, r);
> >  		return r;
> >  	}
> >  	*value = xhv.value;

Like this?

>From 66705b0ff8808d86c12fcb3815d849a848b5409b Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 19 Oct 2012 15:01:46 -0400
Subject: [PATCH] xen/hvm: If we fail to fetch an HVM parameter print out
 which flag it is.

Makes it easier to troubleshoot in the field.

[v1: Use macro per Ian's suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/hvm.h | 34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/xen/hvm.h b/include/xen/hvm.h
index b193fa2..13e43e4 100644
--- a/include/xen/hvm.h
+++ b/include/xen/hvm.h
@@ -5,6 +5,36 @@
 #include <xen/interface/hvm/params.h>
 #include <asm/xen/hypercall.h>
 
+static const char *param_name(int op)
+{
+#define PARAM(x) [HVM_PARAM_##x] = #x
+	static const char *const names[] = {
+		PARAM(CALLBACK_IRQ),
+		PARAM(STORE_PFN),
+		PARAM(STORE_EVTCHN),
+		PARAM(PAE_ENABLED),
+		PARAM(IOREQ_PFN),
+		PARAM(BUFIOREQ_PFN),
+		PARAM(TIMER_MODE),
+		PARAM(HPET_ENABLED),
+		PARAM(IDENT_PT),
+		PARAM(DM_DOMAIN),
+		PARAM(ACPI_S_STATE),
+		PARAM(VM86_TSS),
+		PARAM(VPT_ALIGN),
+		PARAM(CONSOLE_PFN),
+		PARAM(CONSOLE_EVTCHN),
+	};
+#undef PARAM
+
+	if (op >= ARRAY_SIZE(names))
+		return "unknown";
+
+	if (!names[op])
+		return "reserved";
+
+	return names[op];
+}
 static inline int hvm_get_parameter(int idx, uint64_t *value)
 {
 	struct xen_hvm_param xhv;
@@ -14,8 +44,8 @@ static inline int hvm_get_parameter(int idx, uint64_t *value)
 	xhv.index = idx;
 	r = HYPERVISOR_hvm_op(HVMOP_get_param, &xhv);
 	if (r < 0) {
-		printk(KERN_ERR "Cannot get hvm parameter %d: %d!\n",
-			idx, r);
+		printk(KERN_ERR "Cannot get hvm parameter %s (%d): %d!\n",
+			param_name(idx), idx, r);
 		return r;
 	}
 	*value = xhv.value;
-- 
1.7.11.7

