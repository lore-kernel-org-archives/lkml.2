Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab1AKSgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:36:53 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47432 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1AKSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:36:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uykf1NhOF/b1BGNDO+tFMwvndFCwSvw9jtDvnAtSwEgkTBoR0nMkfI4s+nG8tXXjQY
         pAGfRtan/NSqOIGNQxqSrjD24iP+idft/y9c9xap0tHa0JWFvdth2B11RUxi4z1NZjE2
         lPCmClyd8jfk4V93F6bH0jeM1c+8F2+zIohxs=
MIME-Version: 1.0
In-Reply-To: <AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
References: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
	<4d2654c410489a1b90@agluck-desktop.sc.intel.com>
	<AANLkTi=0cf=JGGiJ6w3nanJTN1zyLvgVt8FUzwTWp2YG@mail.gmail.com>
	<AANLkTimJMMC=LoD4igGCMdcFaBS9EpHVHh_x5=91_bbE@mail.gmail.com>
Date: Tue, 11 Jan 2011 10:36:50 -0800
X-Google-Sender-Auth: -onTe942oaO7lPdKNciBjDx6Wqs
Message-ID: <AANLkTim6Qn5Ttc9w673c1jrT0dObm8x_Osvbf9Vhjfys@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
From: Tony Luck <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 4:17 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Assume Tony will have another patch for IA64 to check that before
> apply this patch.

Ingo,

Ok, I sent (a slightly modified version of) this patch up to Linus
as part of the ia64 merge window pull ... so it is safe to update
drivers/acpi/numa.c with a patch that will parse all the SRAT cpu
entries down to ia64 now.

-Tony

Pasted version of commit - which gmail will munge ...


commit 05f2f274c8a8747bbfb13ac8ee0c27d5f2ad8510
Author: Tony Luck <tony.luck@intel.com>
Date:   Fri Jan 7 09:11:55 2011 -0800

    [IA64] Avoid array overflow if there are too many cpus in SRAT table

    acpi_numa_init() has to parse the whole SRAT table, even if the
    kernel wants to limit the number of cpus it will use (because the
    ones it is going to use may be described by entries at the end of
    the SRAT table).  Avoid overflowing the node_cpuid array.

    Reported-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Tony Luck <tony.luck@intel.com>

diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index c6c90f3..7b897b7 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -477,6 +477,12 @@ acpi_numa_processor_affinity_init(struct
acpi_srat_cpu_affinity *pa)
        if (!(pa->flags & ACPI_SRAT_CPU_ENABLED))
                return;

+       if (srat_num_cpus >= ARRAY_SIZE(node_cpuid)) {
+               printk_once(KERN_WARNING
+                           "node_cpuid[%d] is too small, may not be
able to use all cpus\n",
+                           ARRAY_SIZE(node_cpuid));
+               return;
+       }
        pxm = get_processor_proximity_domain(pa);

        /* record this node in proximity bitmap */
