Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0DWXFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:05:31 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16330 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0DWXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:05:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andy Isaacson <adi@hexapodia.org>, "R. Andrew Bailey" <bailey@akamai.com>
Subject: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
Date: Fri, 23 Apr 2010 17:05:24 -0600
User-Agent: KMail/1.9.10
Cc: Yinghai <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
References: <4BC4E55B.7000103@oracle.com> <4BCE8E3E.4030809@oracle.com> <20100421193120.GD11130@hexapodia.org>
In-Reply-To: <20100421193120.GD11130@hexapodia.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004231705.25659.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
> On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
> > Update e820 at first, and later put them resource tree.
> > Reserved that early, will not be allocated to unassigned PCI BAR
> > 
> > v3: remove probe_roms() that is not needed, because whole range is reserved
> > 	 already
> 
> Test booted this patch series on the problematic t3400, seems to work
> fine.  dmesg attached to bug 15744.

Thanks for testing (again).  I'm not confident that this series is
going to be successful, so I started looking for other approaches.

I can't reproduce the exact problem you're seeing, but in my
kludged-up attempt, the patch below is enough to keep us from
assigning the space below 1MB to a device.

Would you guys (Andy & Andy, what a coincidence :-)) mind giving
it a try?  This is intended to work on top of current upstream,
with no other patches required.

Bjorn


commit 7fb707eb97fdf6dc4fa4b127f127f8d00223afc7
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Fri Apr 23 15:22:10 2010 -0600

x86/PCI: never allocate PCI MMIO resources below BIOS_END
    
When we move a PCI device or assign resources to a device not configured
by the BIOS, we want to avoid the BIOS region below 1MB.  Note that if the
BIOS places devices below 1MB, we leave them there.
    
See https://bugzilla.kernel.org/show_bug.cgi?id=15744
and https://bugzilla.kernel.org/show_bug.cgi?id=15841
    
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 46fd43f..97da2ba 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -72,6 +72,9 @@ pcibios_align_resource(void *data, const struct resource *res,
 			return start;
 		if (start & 0x300)
 			start = (start + 0x3ff) & ~0x3ff;
+	} else if (res->flags & IORESOURCE_MEM) {
+		if (start < BIOS_END)
+			start = BIOS_END;
 	}
 	return start;
 }
