Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0IBTE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:04:27 -0400
Received: from claw.goop.org ([74.207.240.146]:48584 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0IBTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:04:26 -0400
Message-ID: <4C7FF538.7020704@goop.org>
Date: Thu, 02 Sep 2010 12:04:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 0/7] PV on HVM: receive interrupts as xen events
References: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1008301134160.2545@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/30/2010 04:20 AM, Stefano Stabellini wrote:
> Hi all,
> this patch series introduces some performance improvements for xen PV on
> HVM guests: interacting with the emulated APIC is slow because it causes
> traps in the hypervisor while receiving xen events using the vector callback
> mechanism allow us to skip all that. For this reason we remap interrupts
> and MSIs into xen pirqs so that from that point on we can receive them
> as xen events instead.
> This series is based on Konrad's pcifront series (not upstream yet):
>
> http://lkml.org/lkml/2010/8/4/374
>
> and requires a patch to xen and a patch to qemu-xen (just sent to
> xen-devel).

My only concern with this series is the pirq remapping stuff.  Why do
pirq and irq need to be non-identical?  Is it because pirq is a global
namespace, and dom0 has already assigned it?

Why do guests need to know about max pirq?  Would it be better to make
Xen use a more dynamic structure for pirqs so that any arbitrary value
can be used?

    J

>
> The list of patches with diffstat follows:
>
> Jeremy Fitzhardinge (2):
>  xen: add xen hvm acpi_register_gsi variant
>  acpi: use indirect call to register gsi in different modes
>
> Stefano Stabellini (5):
>  xen: xen: map MSIs into pirqs
>  xen: support GSI -> pirq remapping in PV on HVM guests
>  xen: implement xen_hvm_register_pirq
>  xen: get the maximum number of pirqs from xen
>  xen: support pirq != irq
>
>
>  arch/x86/include/asm/acpi.h      |    3 +
>  arch/x86/include/asm/xen/pci.h   |   10 +++
>  arch/x86/kernel/acpi/boot.c      |   60 ++++++++++++++------
>  arch/x86/pci/xen.c               |  114 ++++++++++++++++++++++++++++++++++++++
>  drivers/pci/xen-pcifront.c       |    2 +-
>  drivers/xen/events.c             |  106 +++++++++++++++++++++++++++++++----
>  include/xen/events.h             |    3 +
>  include/xen/interface/features.h |    3 +
>  include/xen/interface/physdev.h  |   36 ++++++++++++
>  9 files changed, 308 insertions(+), 29 deletions(-)
>
>
> A git tree with this series and Konrad's pcifront series on top of Linux
> 2.6.36-rc1 is available here:
>
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc1-pvhvm-pirq-v3
>
> Cheers,
>
> Stefano Stabellini
>

