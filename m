Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0KLPSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:18:12 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36768 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab0KLPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:18:07 -0500
Date: Fri, 12 Nov 2010 16:17:37 +0100
From: Borislav Petkov <bp@amd64.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Bob Picco <bpicco@redhat.com>,
        Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Becker <chemobejk@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] PCI: fix pci_bus_alloc_resource() hang, prefer
 positive decode
Message-ID: <20101112151737.GC28968@aftab>
References: <20101110172607.2537.10985.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110172607.2537.10985.stgit@bob.kio>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 12:26:07PM -0500, Bjorn Helgaas wrote:
> 
> When a PCI bus has two resources with the same start/end, e.g.,
> 
>     pci_bus 0000:04: resource 2 [mem 0xd0000000-0xd7ffffff pref]
>     pci_bus 0000:04: resource 7 [mem 0xd0000000-0xd7ffffff]
> 
> the previous pci_bus_find_resource_prev() implementation would alternate
> between them forever:
> 
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff pref])
>         returns [mem 0xd0000000-0xd7ffffff]
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff])
>         returns [mem 0xd0000000-0xd7ffffff pref]
>     pci_bus_find_resource_prev(... [mem 0xd0000000-0xd7ffffff pref])
>         returns [mem 0xd0000000-0xd7ffffff]
>     ...
> 
> This happened because there was no ordering between two resources with the
> same start and end.  A resource that had the same start and end as the
> cursor, but was not itself the cursor, was considered to be before the
> cursor.
> 
> This patch fixes the hang by making a fixed ordering between any two
> resources.
> 
> In addition, it tries to allocate from positively decoded regions before
> using any subtractively decoded resources.  This means we will use a
> positive decode region before a subtractive decode one, even if it means
> using a smaller address.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=22062
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Looks good.

Reported-and-tested-by: Borislav Petkov <bp@amd64.org>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
