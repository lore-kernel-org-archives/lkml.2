Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1BTLDE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 06:03:04 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:52148 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab1BTLDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 06:03:01 -0500
Message-ID: <95a30235b6074bd31fa18d72dbfab8ff.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110220092012.GA3514@viiv.ffwll.ch>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
    <20110220092012.GA3514@viiv.ffwll.ch>
Date: Sun, 20 Feb 2011 12:02:58 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 1629bd954af37e9bd463cbe85bf61e19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Sun, February 20, 2011 10:20, Daniel Vetter wrote:
> On Sun, Feb 20, 2011 at 03:20:15AM +0100, Indan Zupancic wrote:
>> Sorry, I plainly forgot to mention that. I'm on my Thinkpad X40 with gen 2
>> hardware, 855GM.
>
> Ah, craptastic i855gm. Is this with the HIC poke patch?

Yeah, that one. That's what I first suspected, so I tried both with and
without it, but this is something new.

> Well, these two patches completely undo the patch by Chris Wilson (and
> I've re-reviewed it to check whether there are any other hidden bugs in
> it).

I can't find anything dodgy in it either, so it's either somewhere else
or really subtle. I certainly don't see much gen2 specific stuff.

> I suspect that your bisect went wrong because the range
> a00b10c360b35d6431a94cb..5e78330126e23e00950 is known to be broken on your
> hw.

It mostly worked after a bit of twiddling (after that I didn't need to skip
commits any more), and the kind of corruption was the same too.

Only way I can see that this would make a difference is when a00b10c3 created
the bug, the bug got fixed by your patches, but something else introduced it
between that range in a different way. This actually makes sense when it's
re-introduced by a bad merge. But then it should show up in the current code.
If not for a bad merge it seems unlikely though.

> Could you recheck these two endpoints to confirm that breakage was
> introduce in that range?

I'm pretty sure the breakage was introduced starting with a00b10c3, because
the commit just before it (746537) works fine. so yes, it's in that range.
I was getting a bit tired and less sharp though, so perhaps I made a mistake
somewhere. I'll recheck, probably tomorrow (getting a bit late here).

> If so, could you rebase this range and squash the
> three patches by me you've mentioned in the original report into the patch
> by Chris and re-run git bisect on this new branch?

As I have to apply patches anyway, it seems easier to just add your patches
to the bunch, if they apply...

Annoying bug, it seems I'm always hitting the tricky ones.

Looking at: gitk a00b10c360b35d6431a94cb..5e78330126e23e00950  \
             drivers/char/agp/ drivers/gpu/drm/i915/

There were three merges around that area, so it seems a bit messy and something
might have gone wrong when merging there. But the right branch seems okay because
all later good bisections were from there.

---

I just saw your new email with a new patch to try, I'll try that one first and
report back, before digging further into all this.

Greetings,

Indan

---

First bisection info:

When I did the bisect I had to fix a compile error and an OOPS, patches I
applied were:

commit ff75b9bc489710ff223bc0d805bf3b862dc347ea
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sat Oct 30 22:52:31 2010 +0100

    drm/i915: Fix typo from e5281ccd in i915_gem_attach_phys_object()

    Accessing the uninitialised obj->pages instead of the local page lead to
    an OOPs.

    Reported-by: Xavier Chantry <chantry.xavier@gmail.com>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 936ddd8..e3fc333 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4925,7 +4925,7 @@ i915_gem_attach_phys_object(struct drm_device *dev,
 		if (IS_ERR(page))
 			return PTR_ERR(page);

-		src = kmap_atomic(obj_priv->pages[i]);
+		src = kmap_atomic(page);
 		dst = obj_priv->phys_obj->handle->vaddr + (i * PAGE_SIZE);
 		memcpy(dst, src, PAGE_SIZE);
 		kunmap_atomic(src);

diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 75a3d7f..e1cc56a 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -61,7 +61,8 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, pgprot_t prot)

 	pagefault_disable();

-	type = kmap_atomic_idx_push();
+//	type = kmap_atomic_idx_push();
+	type = 0;
 	idx = type + KM_TYPE_NR * smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte - idx, pfn_pte(pfn, prot));
@@ -98,7 +99,8 @@ iounmap_atomic(void __iomem *kvaddr)
 	    vaddr <= __fix_to_virt(FIX_KMAP_BEGIN)) {
 		int idx, type;

-		type = kmap_atomic_idx_pop();
+//		type = kmap_atomic_idx_pop();
+		type = 0;
 		idx = type + KM_TYPE_NR * smp_processor_id();

 #ifdef CONFIG_DEBUG_HIGHMEM

With these patches it worked for me and the only difference was that corruption
showing up or not, and the kind of corruption seemed the same too.

I ran bisect on the drm/i915 and char/agp paths. My bisect log was:

# bad: [d2478521afc20227658a10a8c5c2bf1a2aa615b3] char/ipmi: fix OOPS caused by
pnp_unregister_driver on unregistered driver
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect start 'd2478521afc20227658a10a8c5c2bf1a2aa615b3' 'v2.6.37'
'drivers/gpu/drm/i915/' 'drivers/char/agp/'
# bad: [c6748e09eed072be077fe583976516b76daf42ec] drm/i915: Remove inactive LRU tracking
from set_domain_ioctl
git bisect bad c6748e09eed072be077fe583976516b76daf42ec
# bad: [e624ae8e0d4243e71daedce7570e91290438eaca] Merge branch 'drm-intel-fixes' into
drm-intel-next
git bisect bad e624ae8e0d4243e71daedce7570e91290438eaca
# good: [4ab0fbd3a29067e1540f05093ae4ed07645d18c8] Merge remote branch 'linus' into
drm-intel-fixes
git bisect good 4ab0fbd3a29067e1540f05093ae4ed07645d18c8
# good: [1bb95834bbcdc969e477a9284cf96c17a4c2616f] Merge remote branch
'airlied/drm-fixes' into drm-intel-fixes
git bisect good 1bb95834bbcdc969e477a9284cf96c17a4c2616f
# bad: [c94f28c383f58c9de74678e0f1624db9c5f8a8cb] Merge branch 'drm-intel-fixes' into
drm-intel-next
git bisect bad c94f28c383f58c9de74678e0f1624db9c5f8a8cb
# bad: [46168f39360f419e59952d58cd08a862886ec8cd] Merge branch 'drm-intel-fixes' into
drm-intel-next
git bisect bad 46168f39360f419e59952d58cd08a862886ec8cd
# good: [16a02cf08a2de0863daf7ebb91718d7c6bbe7f9c] agp/intel: fix cache control for
sandybridge
git bisect good 16a02cf08a2de0863daf7ebb91718d7c6bbe7f9c
# bad: [ff75b9bc489710ff223bc0d805bf3b862dc347ea] drm/i915: Fix typo from e5281ccd in
i915_gem_attach_phys_object()
git bisect bad ff75b9bc489710ff223bc0d805bf3b862dc347ea
# good: [dd2b379f071424f36f9f90ff83cb4ad058c7b6ed] drm/i915: Fix typo from "Enable
DisplayPort Audio"
git bisect good dd2b379f071424f36f9f90ff83cb4ad058c7b6ed
# good: [b4ce0f85159f77f208a62930f67b4e548576a5a3] drm/i915: Use pci_iomap for remapping
the MMIO registers.
git bisect good b4ce0f85159f77f208a62930f67b4e548576a5a3
# good: [39a01d1fb63cf8ebc1a8cf436f5c0ba9657b55c6] drm/i915: Remove mmap_offset
git bisect good 39a01d1fb63cf8ebc1a8cf436f5c0ba9657b55c6
# good: [e5281ccd2e0049e2b9e8ce82449630d25082372d] drm/i915: Eliminate nested get/put pages
git bisect good e5281ccd2e0049e2b9e8ce82449630d25082372d
# good: [e5281ccd2e0049e2b9e8ce82449630d25082372d] drm/i915: Eliminate nested get/put pages
git bisect good e5281ccd2e0049e2b9e8ce82449630d25082372d
# bad: [e380f60b22eddec7825224b8d788572c82b63161] agp/intel: Sandybridge doesn't require
GMCH enabling
git bisect bad e380f60b22eddec7825224b8d788572c82b63161
# bad: [e380f60b22eddec7825224b8d788572c82b63161] agp/intel: Sandybridge doesn't require
GMCH enabling
git bisect bad e380f60b22eddec7825224b8d788572c82b63161
# bad: [a00b10c360b35d6431a94cbf130a4e162870d661] drm/i915: Only enforce fence limits
inside the GTT.
git bisect bad a00b10c360b35d6431a94cbf130a4e162870d661
# good: [4a684a4117abd756291969336af454e8a958802f] drm/i915: Kill GTT mappings when
moving from GTT domain
git bisect good 4a684a4117abd756291969336af454e8a958802f
# good: [7465378fd7c681f6cf2b74b3494c4f0991d8c8ac] drm/i915: Convert BUG_ON(pin_count)
from an impossible condition
git bisect good 7465378fd7c681f6cf2b74b3494c4f0991d8c8ac

Or in condensed form:

- d24785 char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
+ 3c0eee Linux 2.6.37
- c6748e drm/i915: Remove inactive LRU tracking from set_domain_ioctl
- e624ae Merge branch 'drm-intel-fixes' into drm-intel-next
+ 4ab0fb Merge remote branch 'linus' into drm-intel-fixes
+ 1bb958 Merge remote branch 'airlied/drm-fixes' into drm-intel-fixes
- c94f28 Merge branch 'drm-intel-fixes' into drm-intel-next
- 46168f Merge branch 'drm-intel-fixes' into drm-intel-next
+ 16a02c agp/intel: fix cache control for sandybridge
- ff75b9 drm/i915: Fix typo from e5281ccd in i915_gem_attach_phys_object()
+ dd2b37 drm/i915: Fix typo from "Enable DisplayPort Audio"
+ b4ce0f drm/i915: Use pci_iomap for remapping the MMIO registers.
+ 39a01d drm/i915: Remove mmap_offset
+ e5281c drm/i915: Eliminate nested get/put pages
- e380f6 agp/intel: Sandybridge doesn't require GMCH enabling
- a00b10 drm/i915: Only enforce fence limits inside the GTT.
+ 4a684a drm/i915: Kill GTT mappings when moving from GTT domain
+ 746537 drm/i915: Convert BUG_ON(pin_count) from an impossible condition


