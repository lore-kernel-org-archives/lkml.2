Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0KWTHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:07:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:45641 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0KWTHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:07:36 -0500
Subject: Re: [PATCH] x86, perf, nmi: Disable perf if counters are not
 accessable
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, sedat.dilek@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101123190417.GC5997@lenovo>
References: <AANLkTikzSY09i=C+A2Y=_gVa-44r_bN76P-U2-NZMnpz@mail.gmail.com>
	 <20101123165657.GF18100@redhat.com>
	 <AANLkTimsz2XWQq7bJ4uhWXhoPuQw-fSJbCJ6D6Xo69XM@mail.gmail.com>
	 <1290536827.2072.417.camel@laptop>  <20101123190417.GC5997@lenovo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 20:07:47 +0100
Message-ID: <1290539267.2072.418.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 22:04 +0300, Cyrill Gorcunov wrote:
> On Tue, Nov 23, 2010 at 07:27:07PM +0100, Peter Zijlstra wrote:
> > On Tue, 2010-11-23 at 19:21 +0100, Sedat Dilek wrote:
> > > Due to BIOS l(ocal)apic is not possible:
> > > 
> > > # dmesg | grep -i apic
> > > [    0.000000] Using APIC driver default
> > > [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
> > > [    0.000000] APIC: disable apic facility
> > > [    0.000000] APIC: switched to apic NOOP
> > > [    0.008891] no APIC, boot with the "lapic" boot parameter to force-enable it.
> > > [    0.036141] Local APIC not detected. Using dummy APIC emulation. 
> > 
> > Have you tried booting with "lapic" as the second last msg suggests you
> > do?
> 
>  Peter, Don, might not we need something like the patch below -- ie to check for
> apic earlier and do not acquire cpu for PERF cpu bit, and its cpu model, etc
> if there is no active apic? And perhaps for nmi-watchdog, we should not try
> to creat perf event for same reason and simply report that nmi-watchdog is
> disabled (though of course hpet based one should try to continue).
> 
>  No?
> 

Ah, no.. now I get what you mean.

We can use the pmu without interrupt with we miss the lapic, that is
perf-stat will still work.

>  void __init init_hw_perf_events(void)
> @@ -1346,6 +1348,10 @@ void __init init_hw_perf_events(void)
>  
>  	pr_info("Performance Events: ");
>  
> +	/* apic is required */
> +	if (pmu_check_apic())
> +		goto no_pmu;
> +

> +no_pmu:
> +	pr_cont("no PMU driver, software events only.\n");
> +	return;
>  }
>  
>  static inline void x86_pmu_read(struct perf_event *event)


