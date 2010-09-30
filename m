Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0I3ONJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:13:09 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:46632 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756161Ab0I3ONH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:13:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: bgOL33oVM1nb92pq8HxEU2lbsm1sLGFRPpWGIIoPJotqjyM
 nAEFlZ.bY..4AgnZuVAnH9egAFw5..yVLD7_IWoZYDeva364tCiC03aCtfiy
 Nz0ZAtZEbYeRk.mJMl11IZRWBPluTWmrGJpHI3LywdxJbIAV_GsCNryUgi1M
 uC1GFNIwrhe_vT5GTgCz6Dp3sGX_UQt2otSaxaoJ4f5KO_Upfj3Y1bE5oQs3
 O
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 30 Sep 2010 09:13:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Wu, Xia" <xia.wu@intel.com>
cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhu, Daniel" <daniel.zhu@intel.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: unnecessary timer interrupt of slab.c and bdi tasks when the
 system is in sleep state
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1009300908050.27201@router.home>
References: <A24AE1FFE7AEC5489F83450EE98351BF221878E0FB@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010, Wu, Xia wrote:

> I found some unnecessary timer interrupts when the system enter sleep state.
> (1)     /mm/slab.c
> cache_reap() clean up on allocated memory every 2s. If the system is in sleep state, the system is waked-up when this timer expires. In fact,
> there isn't more slabs to been cleaned up in sleep state.

Right. We could switch off the timer when idle without much of an issue.
The expiration of the caches wont occur and so we will have stale objects
on the queues when we exit sleep state. You could flush the queues before
switching off the timers?

(The alternate allocator SLUB does not use timers)

> I think these timers should not wake-up the system when the system is in
> sleep state. In these cases, these timers only waste the CPU resource
> and consume more power.

Agreed. In addition I would like these timers to also switch off if the
code running on this hardward thread does not engage in any memory
allocation (slab) or if there is no dirty writeback on a cpu. These timers
can cause unexpected latencies and introduce undesirable variability into
processes needing either full processor speed or low latency responses to
events.
