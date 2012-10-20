Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab2JTU23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 16:28:29 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62290 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2JTU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 16:28:28 -0400
Date: Sat, 20 Oct 2012 22:28:46 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Heinz Diehl <htd@fritha.org>
Cc: Martin Peres <martin.peres@labri.fr>, Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121020202846.GA5826@joi.lan>
References: <1724445.dN2yMEzN6d@localhost>
 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
 <20121020092647.GA3186@fancy-poultry.org>
 <50827174.7070109@labri.fr>
 <20121020104238.GA1539@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020104238.GA1539@fritha.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2012 at 12:42:38PM +0200, Heinz Diehl wrote:
> On 20.10.2012, Martin Peres wrote: 
> 
> > Can you test the attached patch too ? I rebased the previous one I sent on
> > top on 3.7-rc1 as I accidentally used an older version.
> 
> Yes, of course.
> 
> Tried it. Unfortunately, the crash remains the same as reported.

Try this one.

Now, the question is: could 3.6 kernel get VBIOS by ACPI?
If yes, please mount debugfs and send vbios.rom to me please.
(cat /sys/kernel/debug/dri/0/vbios.rom > vbios.rom)

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] drm/nouveau: validate vbios size

Without checking, we could detect vbios size as 0, allocate 0-byte array
(kmalloc returns invalid pointer for such allocation) and crash in
nouveau_bios_score while checking for vbios signature.

Reported-by: Heinz Diehl <htd@fritha.org>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
index dcb5c2b..824eea0 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -72,7 +72,7 @@ nouveau_bios_shadow_of(struct nouveau_bios *bios)
 	}
 
 	data = of_get_property(dn, "NVDA,BMP", &size);
-	if (data) {
+	if (data && size) {
 		bios->size = size;
 		bios->data = kmalloc(bios->size, GFP_KERNEL);
 		if (bios->data)
@@ -104,6 +104,9 @@ nouveau_bios_shadow_pramin(struct nouveau_bios *bios)
 		goto out;
 
 	bios->size = nv_rd08(bios, 0x700002) * 512;
+	if (!bios->size)
+		goto out;
+
 	bios->data = kmalloc(bios->size, GFP_KERNEL);
 	if (bios->data) {
 		for (i = 0; i < bios->size; i++)
@@ -155,6 +158,9 @@ nouveau_bios_shadow_prom(struct nouveau_bios *bios)
 
 	/* read entire bios image to system memory */
 	bios->size = nv_rd08(bios, 0x300002) * 512;
+	if (!bios->size)
+		goto out;
+
 	bios->data = kmalloc(bios->size, GFP_KERNEL);
 	if (bios->data) {
 		for (i = 0; i < bios->size; i++)
@@ -194,6 +200,8 @@ nouveau_bios_shadow_acpi(struct nouveau_bios *bios)
 	bios->size = 0;
 	if (nouveau_acpi_get_bios_chunk(data, 0, 3) == 3)
 		bios->size = data[2] * 512;
+	if (!bios->size)
+		return;
 
 	bios->data = kmalloc(bios->size, GFP_KERNEL);
 	for (i = 0; bios->data && i < bios->size; i += cnt) {
@@ -229,12 +237,14 @@ nouveau_bios_shadow_pci(struct nouveau_bios *bios)
 static int
 nouveau_bios_score(struct nouveau_bios *bios, const bool writeable)
 {
-	if (!bios->data || bios->data[0] != 0x55 || bios->data[1] != 0xAA) {
+	if (bios->size < 3 || !bios->data || bios->data[0] != 0x55 ||
+			bios->data[1] != 0xAA) {
 		nv_info(bios, "... signature not found\n");
 		return 0;
 	}
 
-	if (nvbios_checksum(bios->data, bios->data[2] * 512)) {
+	if (nvbios_checksum(bios->data,
+			min_t(u32, bios->data[2] * 512, bios->size))) {
 		nv_info(bios, "... checksum invalid\n");
 		/* if a ro image is somewhat bad, it's probably all rubbish */
 		return writeable ? 2 : 1;
-- 
1.7.12

