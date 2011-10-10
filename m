Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1JJSht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:37:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1JJShs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:37:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=mtAwzTAXZ4m/7Ln2qmc7MbPwxdXNKm7GzJ9RtKNRIDtE6CAOm8axhLi0aWzgYHQjF
	Qt1vSDr79tXTEJbqt3Y2Q==
Date: Mon, 10 Oct 2011 11:37:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device
 independant
In-Reply-To: <CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1110101102330.21957@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain> <20110705144140.23872.86541.stgit@localhost.localdomain> <alpine.LSU.2.00.1107071742250.10362@sister.anvils> <20110708093859.299958df@lxorguk.ukuu.org.uk> <alpine.LSU.2.00.1107080917430.1781@sister.anvils>
 <20110711172517.46907e62@lxorguk.ukuu.org.uk> <alpine.LSU.2.00.1107111033440.1752@sister.anvils> <CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-686441387-1318271854=:21957"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-686441387-1318271854=:21957
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sun, 9 Oct 2011, Patrik Jakobsson wrote:
> On Mon, Jul 11, 2011 at 7:49 PM, Hugh Dickins wrote:
> > On Mon, 11 Jul 2011, Alan Cox wrote:
> >> > Your <4GB pages won't get swapped out while they're pinned. =A0But c=
an
> >> > it happen that they'd be unpinned, swapped out, swapped back in >4GB
> >> > pages, then cause trouble for you when needed again?
> >>
> >> It does look that way, in which case that will eventually need fixing.=
 At
> >> the moment you can't put enough memory into a device using these chips
> >> but that won't always be true I imagine.
> >
> > Thanks, I won't worry about it at this moment, but we'd better not forg=
et.
> >
> > If it's easy for you to include a WARN_ON_ONCE check (perhaps
> > on page_to_pfn(page)), that may be worth doing to remind us.
> >
> > It's a bit sad to learn this requirement just after I'd completed
> > removing the readpage copying code, and a bit strange to have shmem
> > confined by hardware constraints; but I guess that's what we took on
> > when we opened it up to GEM.
> >
> > It will probably make sense for me to add synchronous migration when
> > a shmem swap page is found not to match the contraints wanted by the
> > mapping it goes into: mainly for NUMA, but covering your case too.
>=20
> I think we need to revisit this problem. On 3.1-rc4 with some of my own c=
hanges
> I've just triggered read_cache_page_gfp in psb_gtt_attach_pages when tryi=
ng to
> set a resolution that doesn't fit in stolen memory. Replacing it with
> shmem_read_mapping_page seems to work but how do we go about solving the =
>4GB
> issue? Is it ok for now to just use shmem_read_mapping_page or did any of=
 you
> have a better solution?

I was surprised to see drivers/staging/gma500 appearing still to use
read_cache_page_gfp().  I assumed that since nobody was complaining,
it must be on a currently unusable path.  But you have code coming up,
that now enables that path?

Am I right to think that your immediate problem is just the oops in
__read_cache_page(), that you're not yet about to hit the 4GB issue?

I haven't rushed to address the 4GB issue, but what I have in mind is
killing two-and-a-half birds with one stone, by putting a little cookie
into the swapper_space radix_tree when we free a swapcache page, that
specifies node/zone and hashes object/offset.

NUMA mempolicies are too complex to be encapsulated in a sizeof(long)
cookie, but it should improve the common case after swapin; while
solving your 4GB GEM case, and vastly speeding up swapoff.

Here's the kind of patch I imagined would be going in for gma500, that
specifies __GFP_DMA32 on the mapping, so even swapoff can know that
this object needs its pages below 4GB (even before my recent changes,
swapoff would have broken you by inserting higher pages in the cache)
- once I implement that.  But I've not tested this patch at all...


[PATCH] gma500: use shmem_read_mapping_page

In 3.1 onwards, read_cache_page_gfp() just oopses on GEM objects:
switch gma500 over to shmem_read_mapping_page() like i915.  But when
larger devices arrive, gma500 will need to keep its pages below 4GB, so
specify __GFP_DMA32 (though that limit is not yet enforced in shmem.c).

Signed-off-by: Hugh Dicking <hughd@google.com>
---

 drivers/staging/gma500/framebuffer.c |    7 +++++++
 drivers/staging/gma500/gem.c         |    4 ++++
 drivers/staging/gma500/gtt.c         |    5 ++---
 3 files changed, 13 insertions(+), 3 deletions(-)

--- 3.1-rc9/drivers/staging/gma500/framebuffer.c=092011-08-07 23:44:38.5879=
14954 -0700
+++ linux/drivers/staging/gma500/framebuffer.c=092011-10-10 10:40:06.422389=
114 -0700
@@ -317,7 +317,9 @@ static struct drm_framebuffer *psb_frame
  */
 static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_s=
ize)
 {
+=09struct address_space *mapping;
 =09struct gtt_range *backing;
+
 =09/* Begin by trying to use stolen memory backing */
 =09backing =3D psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
 =09if (backing) {
@@ -336,6 +338,11 @@ static struct gtt_range *psbfb_alloc(str
 =09=09psb_gtt_free_range(dev, backing);
 =09=09return NULL;
 =09}
+
+=09/* Specify that its pages be allocated below 4GB */
+=09mapping =3D backing->gem.filp->f_path.dentry->d_inode->i_mapping;
+=09mapping_set_gfp_mask(mapping, GFP_USER | __GFP_DMA32);
+
 =09return backing;
 }
=20
--- 3.1-rc9/drivers/staging/gma500/gem.c=092011-08-07 23:44:38.587914954 -0=
700
+++ linux/drivers/staging/gma500/gem.c=092011-10-10 10:39:31.974219007 -070=
0
@@ -104,6 +104,7 @@ unlock:
 static int psb_gem_create(struct drm_file *file,
 =09struct drm_device *dev, uint64_t size, uint32_t *handlep)
 {
+=09struct address_space *mapping;
 =09struct gtt_range *r;
 =09int ret;
 =09u32 handle;
@@ -125,6 +126,9 @@ static int psb_gem_create(struct drm_fil
 =09=09dev_err(dev->dev, "GEM init failed for %lld\n", size);
 =09=09return -ENOMEM;
 =09}
+=09/* Specify that its pages be allocated below 4GB */
+=09mapping =3D r->gem.filp->f_path.dentry->d_inode->i_mapping;
+=09mapping_set_gfp_mask(mapping, GFP_USER | __GFP_DMA32);
 =09/* Give the object a handle so we can carry it more easily */
 =09ret =3D drm_gem_handle_create(file, &r->gem, &handle);
 =09if (ret) {
--- 3.1-rc9/drivers/staging/gma500/gtt.c=092011-08-07 23:44:38.591914970 -0=
700
+++ linux/drivers/staging/gma500/gtt.c=092011-10-10 10:19:31.424265313 -070=
0
@@ -20,6 +20,7 @@
  */
=20
 #include <drm/drmP.h>
+#include <linux/shmem_fs.h>
 #include "psb_drv.h"
=20
=20
@@ -158,9 +159,7 @@ static int psb_gtt_attach_pages(struct g
 =09gt->npage =3D pages;
=20
 =09for (i =3D 0; i < pages; i++) {
-=09=09/* FIXME: review flags later */
-=09=09p =3D read_cache_page_gfp(mapping, i,
-=09=09=09=09=09__GFP_COLD | GFP_KERNEL);
+=09=09p =3D shmem_read_mapping_page(mapping, i);
 =09=09if (IS_ERR(p))
 =09=09=09goto err;
 =09=09gt->pages[i] =3D p;
--8323584-686441387-1318271854=:21957--
