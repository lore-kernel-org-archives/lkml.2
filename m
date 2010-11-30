Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0K3VDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:03:25 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44986 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752266Ab0K3VDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:03:24 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 6pDZfQIVM1l5O_mQ_gGkIXtAus.2cG2JLuzkcfr5KR76LVk
 nxgI2bQEANVJOyQfAefXFEhzTKRvFQ0XhsOSgaGidD_YlNGP7TQzGCFMgJVJ
 iR7g2SA48.omYw4dfv5aCwZAYPLLrVhgwYsYL3JBzbUYoFhxD8HclrASziwG
 YdXGb8VmNSjLi_RXv9kNm2NG.1nf4oldVTZJMlncnttjvt_G1NcXP9tG5NKt
 a7UCydCN3aJFf_I2kVlPQmiW1n8ftJkryt.QkrqQ-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 30 Nov 2010 15:03:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 15/18] Xen: Use this_cpu_ops
In-Reply-To: <4CF56463.3040109@goop.org>
Message-ID: <alpine.DEB.2.00.1011301501320.4039@router.home>
References: <20101130190707.457099608@linux.com> <20101130190850.002148257@linux.com> <4CF56463.3040109@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Jeremy Fitzhardinge wrote:

> On 11/30/2010 11:07 AM, Christoph Lameter wrote:
> >  static irqreturn_t xen_timer_interrupt(int irq, void *dev_id)
> >  {
> > -	struct clock_event_device *evt = &__get_cpu_var(xen_clock_events);
> >  	irqreturn_t ret;
> >
> >  	ret = IRQ_NONE;
> > -	if (evt->event_handler) {
> > -		evt->event_handler(evt);
> > +	if (__this_cpu_read(xen_clock_events.event_handler)) {
> > +		__this_cpu_read(xen_clock_events.event_handler)(evt);
>
> Really?  What code does this generate?  If this is generating two
> segment-prefixed reads rather than getting the address and doing normal
> reads on it, then I don't think it is an improvement.

Lets drop that hunk. No point to do optimizations at that location then.

evt is also not defined then. Without the evt address determination via
__get_cpu_var we have at least 2 prefixed load and one address
calculation to figure out the parameter to pass. No win.

