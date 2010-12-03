Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab0LCBTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 20:19:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120Ab0LCBTn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 20:19:43 -0500
MIME-Version: 1.0
In-Reply-To: <201011291504.40536.bjorn.helgaas@hp.com>
References: <20101129183009.11256.33739.stgit@bob.kio> <201011291432.51264.bjorn.helgaas@hp.com>
 <4CF41C89.9060708@zytor.com> <201011291504.40536.bjorn.helgaas@hp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 2 Dec 2010 17:19:20 -0800
Message-ID: <AANLkTinJhVj7sY6wC1tFRA+rYW72j7GqKvxfRsyRC=Vs@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI space from the last 1M below 4G
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 2:04 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>
> I think we're talking about whether to reserve the top 1MB or top 2MB.
> I freely admit I don't know the right answer.  My point is merely that
> since we're using a heuristic anyway, copying Windows is a pretty good
> starting point.  In my mind, doing something different requires a
> stronger argument than "it might fix some machines where Windows is
> broken."

What's the status of this? The original patch is pretty nasty, and I
think that hack to put things in the bios_align_resource() function is
just disgusting.

And why is the fix not the really _trivial_ one, which does just this:

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

Hmm?

(Ok, so that doesn't protect a 64-bit resource that just happens to be
inside a window that ends at 0xffffffff, but if you have those kinds
of bus windows, that means that there's nothing there at the 4GB mark
anyway, no?)

                     Linus

               Linus
