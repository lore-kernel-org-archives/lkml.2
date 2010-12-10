Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab0LJUaS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:30:18 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58556 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757073Ab0LJUaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:30:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MvLqZ6GklnzXvLS6F5Wj9p7wBZhNV+i/UjP4TXZuq6iboxXC6zMz1DfkMKgRWcYwgK8gMoA68d+PiATfZqTIskvFWc29AY3u26wZI+52aIRdIYSObCXA+p8lVudAvUJ0;
Date: Fri, 10 Dec 2010 12:30:08 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation
 in reserved areas
Message-ID: <20101210123008.7fed582d@jbarnes-desktop>
In-Reply-To: <20101208213606.13026.47657.stgit@bob.kio>
References: <20101208213606.13026.47657.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Dec 2010 14:36:06 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> This adds arch_remove_reservations(), which an arch can implement if it
> needs to protect part of the address space from allocation.
> 
> Sometimes that can be done by just requesting a resource.  This hook is to
> cover cases where protected area doesn't fit well in the hierarchical
> resource tree.  For example, x86 BIOS E820 reservations are not related
> to devices, so they may overlap part of, all of, or more than a device
> resource.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Hm, this is bigger than the simple change of just avoiding the high 2M;
Linus have you checked it out yet?  It's nicer than simply adjusting
PCIBIOS_MAX_MEM since it will affect all resource callers rather than
just PCI, but it's definitely bigger.

If you want just the simple change for 2.6.37 I can push that, but
we'll need to get a tested-by from Matthew:

  diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
  index ca0437c..aef9f77 100644
  --- a/arch/x86/include/asm/pci.h
  +++ b/arch/x86/include/asm/pci.h
  @@ -141,7 +141,7 @@ void dma32_reserve_bootmem(void);

   /* generic pci stuff */
   #include <asm-generic/pci.h>
  -#define PCIBIOS_MAX_MEM_32 0xffffffff
  +#define PCIBIOS_MAX_MEM_32 0xfff00000

   #ifdef CONFIG_NUMA
   /* Returns the node based on pci bus */

and I'll queue up this set for 2.6.38.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
