Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab2GTKxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 06:53:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55625 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab2GTKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 06:53:13 -0400
Date: Fri, 20 Jul 2012 11:52:48 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jon Masters <jonathan@jonmasters.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
Message-ID: <20120720105248.GA2692@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <5008445B.2010109@codeaurora.org>
 <5009044E.9060908@jonmasters.org>
 <201207200828.13128.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207200828.13128.arnd@arndb.de>
Thread-Topic: [PATCH 08/36] AArch64: Kernel booting and initialisation
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 09:28:12AM +0100, Arnd Bergmann wrote:
> On Friday 20 July 2012, Jon Masters wrote:
> > > I think it would be best to list the technical limitations, from the
> > > kernel's perspective, of the unsupported exception levels and the
> > > advantages of the supported exception levels here. If you want to guide
> > > system builders towards EL2, I think it'd be more convincing to document
> > > the relevant technical aspects (perhaps KVM needs facilities only
> > > available in EL2) than just providing an unexplained requirement.
> > 
> > Unless you enter at EL2 you can never install a hypervisor. That's the
> > reason for the requirement for generally entering at EL2 when possible.
> 
> How do nested hypervisors work in this scenario? Does the first-level
> hypervisor (counting from most priviledged) provide a guest that starts
> in an emulated EL2 state, or is this done differently?

Your favourite topic :). Self virtualisation is not easily possible, at
least not with how KVM on ARM is being implemented. The hardware does
not allow code running at EL1 to be told that it is at EL2 (or code
running at EL2 to be trapped at EL2). So for normal virtualisation,
guest OSes start at EL1 and they benefit of all the hardware
acceleration. If a guest OS wants to run KVM again, it won't have access
to the virtualisation extensions (EL2 system register access would cause
an undefined trap). The best it can do is run the nested guest OS in EL0
and trap accesses to system registers (no that different from Qemu).

If such feature is needed, the best approach is for all kernels, host or
guest, to always enter at (non-secure) EL1. The EL2 would have a clearly
defined HVC API for nested page tables, virtual interrupts, context
switching etc. This way, the host OS can inform the hypervisor that
guest OSes are allowed to use this API for their own nested guests. But
getting such hypervisor API right is a bit tricky and the feedback from
the KVM guys so far is that they need the flexibility of running their
own code at EL2. I guess another benefit is that both KVM and Xen could
use the same API.

But is this feature really needed?

-- 
Catalin
