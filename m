Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1AYOC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:02:28 -0500
Received: from smtp.citrix.com ([66.165.176.89]:51421 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1AYOC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:02:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,374,1291611600"; 
   d="scan'208";a="12117407"
Subject: Re: [Xen-devel] Re: [PATCH 08/23] xen: statically initialize
 cpu_evtchn_mask_p
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@novell.com>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <4D3DBA6A.3080700@redhat.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
	 <1286898271-32018-9-git-send-email-konrad.wilk@oracle.com>
	 <4D3DBA6A.3080700@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 25 Jan 2011 14:02:17 +0000
Message-ID: <1295964137.14780.6148.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 17:44 +0000, Paolo Bonzini wrote:
> On 10/12/2010 05:44 PM, Konrad Rzeszutek Wilk wrote:
> > -static struct cpu_evtchn_s *cpu_evtchn_mask_p;
> > +
> > +static __initdata struct cpu_evtchn_s init_evtchn_mask = {
> > +	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
> > +};
> > +static struct cpu_evtchn_s *cpu_evtchn_mask_p =&init_evtchn_mask;
> > +
> >   static inline unsigned long *cpu_evtchn_mask(int cpu)
> >   {
> >   	return cpu_evtchn_mask_p[cpu].bits;
> 
> This causes a modpost warning:
> 
>     WARNING: drivers/xen/built-in.o(.data+0x0): Section mismatch in
>     reference from the variable cpu_evtchn_mask_p to the variable
>     .init.data:init_evtchn_mask
> 
>     The variable cpu_evtchn_mask_p references
>     the variable __initdata init_evtchn_mask
> 
>     If the reference is valid then annotate the
>     variable with __init* or __refdata (see linux/init.h) or name the variable:
>     *driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 
> 
> This is harmless, the variable is initialized to non-init data
> in an __init function.  The added noise is ugly, though.

Does this help? If I understand the comment which precedes  __initref
correctly it is intended to address precisely this situation.

Ian.
8<---------

xen: events: mark cpu_evtchn_mask_p as __refdata

This variable starts out pointing at init_evtchn_mask which is marked
__initdata but is set to point to a non-init data region in xen_init_IRQ
which is itself an __init function so this is safe.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 31af0ac..5061af0 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -114,7 +114,7 @@ struct cpu_evtchn_s {
 static __initdata struct cpu_evtchn_s init_evtchn_mask = {
 	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
 };
-static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
+static struct __refdata cpu_evtchn_s *cpu_evtchn_mask_p =
&init_evtchn_mask;
 
 static inline unsigned long *cpu_evtchn_mask(int cpu)
 {



