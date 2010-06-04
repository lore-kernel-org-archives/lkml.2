Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab0FDWKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:10:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab0FDWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:10:01 -0400
Date: Fri, 4 Jun 2010 15:05:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Dave Young <hidave.darkstar@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: Tree for June 3
In-Reply-To: <987664A83D2D224EAE907B061CE93D530114C3DC47@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.1006041452130.8175@i5.linux-foundation.org>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au> <AANLkTilr92GkR8bfgyjtb8ToYEEAv4oCsFsfsy04HJRU@mail.gmail.com> <AANLkTim6v2s-Q5BndAKLOZKaA1wYgbU3UKJwNy-6Jkki@mail.gmail.com> <201006032222.57411.rusty@rustcorp.com.au>
 <AANLkTikN_3oLIFQ0CRiLwXUV79myy_aqriezdCgnZHFT@mail.gmail.com> <alpine.LFD.2.00.1006041255210.8175@i5.linux-foundation.org> <987664A83D2D224EAE907B061CE93D530114C3DC47@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Jun 2010, Luck, Tony wrote:
> 
> This almost always means that we dereferenced a NULL pointer ... though
> any access into the bottom PAGE_SIZE of kernel virtual address space
> will result in this trap.  This happens on ia64 because we have a "NaT"
> page mapped at 0x0 so that speculative loads that chase NULL pointers
> at the end of lists behave more rationally.
> 
> Sadly I don't have the actual address. The register that was used
> for the dereference isn't included in the OOPS output.

Ok, so it confirms just that load_module() has returned a pointer that is 
either NULL or at least within PAGE_SIZE-552.

It could be a negative error pointer (and the offset of 552 turns it into 
the NULL page), but that's what the whole IS_ERR() thing checks for, so 
that's not the case.

So the

	if (err)
		return ERR_PTR(err);

case does seem pretty likely (most of them with a "goto <error-case>", but 
some directly. Many of them have the stricter form of "if (err < 0)", but 
there's a number that do not.

And in fact, I think I see the bad one:

        /* Figure out module layout, and allocate all the memory. */
        mod = layout_and_allocate(&info);
        if (IS_ERR(mod))
                goto free_copy;

which looks fine, but "free_copy:" expects the error number in "err", 
which is what the other error cases do.

I think this was introduced by Rusty's commit 5d3f5be82944 ("module: 
layout_and_allocate"), and here's a suggested fix.. The easiest fix is to 
actually change the "free_copy" target to return "mod" as the above goto 
expects, and then just do a conversion before the fall-through from the 
other error cases (that have it in 'err').

Does this fix it? I stopped looking for other possible causes when I found 
this one.

		Linus

---
 kernel/module.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 69a3f12..9a0b275 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2653,9 +2653,10 @@ static struct module *load_module(void __user *umod,
 	module_unload_free(mod);
  free_module:
 	module_deallocate(mod, &info);
+	mod = ERR_PTR(err);
  free_copy:
 	free_copy(&info);
-	return ERR_PTR(err);
+	return mod;
 }
 
 /* Call module constructors. */
