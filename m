Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0ICNwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:52:07 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:3969 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0ICNwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:52:05 -0400
X-IronPort-AV: E=Sophos;i="4.56,313,1280707200"; 
   d="scan'208";a="1683396"
Date: Fri, 3 Sep 2010 14:51:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/7] PV on HVM: receive interrupts as xen events
In-Reply-To: <4C7FF538.7020704@goop.org>
Message-ID: <alpine.DEB.2.00.1009031240510.2714@kaball-desktop>
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop> <4C7FF538.7020704@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Jeremy Fitzhardinge wrote:
>  On 08/30/2010 04:20 AM, Stefano Stabellini wrote:
> > Hi all,
> > this patch series introduces some performance improvements for xen PV on
> > HVM guests: interacting with the emulated APIC is slow because it causes
> > traps in the hypervisor while receiving xen events using the vector callback
> > mechanism allow us to skip all that. For this reason we remap interrupts
> > and MSIs into xen pirqs so that from that point on we can receive them
> > as xen events instead.
> > This series is based on Konrad's pcifront series (not upstream yet):
> >
> > http://lkml.org/lkml/2010/8/4/374
> >
> > and requires a patch to xen and a patch to qemu-xen (just sent to
> > xen-devel).
> 
> My only concern with this series is the pirq remapping stuff.  Why do
> pirq and irq need to be non-identical?  Is it because pirq is a global
> namespace, and dom0 has already assigned it?
>
> Why do guests need to know about max pirq?  Would it be better to make
> Xen use a more dynamic structure for pirqs so that any arbitrary value
> can be used?
> 
 
No, pirq is a per-domain namespace, but pirq and irq are conceptually
different: pirqs are used by xen as a reference for interrupts of
devices assigned to the guest, while linux uses irqs for its
internal purposes.
The pirq namespace is chosen by xen while the linux irq namespace is
chosen by linux.
Linux is allowed to choose the pirq number it wants when mapping an
interrupt, this is why linux needs to know the max pirq, so that it can
safely chose a pirq that is in the allowed range.
The difference between pirqs and linux irqs increases when we talk about
PV on HVM guests: in this case qemu also maps interrupts in the guests
getting pirqs in return, so the linux kernel has to be able to cope with
already assigned pirq numbers.
The current PHYSDEVOP_map_pirq interface is already flexible enough for
that because it provides the possibility for the caller to let xen
choose the pirq, something that linux never does in the pure PV case,
but it is still possible. Obviously if you let xen choose the pirq
number you are safe from conflicts but you must be able to cope with
pirq numbers different from linux irq numbers.

