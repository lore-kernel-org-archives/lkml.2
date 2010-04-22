Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0DVT7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:59:45 -0400
Received: from kroah.org ([198.145.64.141]:59396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756656Ab0DVT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:38 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:05 2010
Message-Id: <20100422195405.561243344@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Lippers-Hollmann <s.l-h@gmx.de>,
       Pauli Nieminen <suokkos@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [007/139] drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed in a simple way
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


> From: Pauli Nieminen <suokkos@gmail.com>
> Date: Fri, 19 Mar 2010 07:44:33 +0000
> Subject: drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed.
>
2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------
 
> From: Pauli Nieminen <suokkos@gmail.com>
> 
> commit fcbc451ba1948fba967198bd150ecbd10bbb7075 upstream.
> 
> When there is allocation failure in radeon_cs_parser_relocs parser->nrelocs
> is not cleaned. This causes NULL pointer defeference in radeon_cs_parser_fini
> when clean up code is trying to loop over the relocation array and free the
> objects.
> 
> Fix adds a check for a possible NULL pointer in clean up code.
[...]

This patch breaks compiling kernel 2.6.33 + the current stable queue:

  CC [M]  drivers/gpu/drm/radeon/radeon_cs.o
/tmp/buildd/linux-sidux-2.6-2.6.33/debian/build/source_amd64_none/drivers/gpu/drm/radeon/radeon_cs.c: In function 'radeon_cs_parser_fini':
/tmp/buildd/linux-sidux-2.6-2.6.33/debian/build/source_amd64_none/drivers/gpu/drm/radeon/radeon_cs.c:200: error: implicit declaration of function 'drm_gem_object_unreference_unlocked'
make[6]: *** [drivers/gpu/drm/radeon/radeon_cs.o] Error 1

as it depends on the introduction of drm_gem_object_unreference_unlocked()
in:

Commit:     c3ae90c099bb62387507e86da7cf799850444b08
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Tue Feb 9 05:49:11 2010 +0000

    drm: introduce drm_gem_object_[handle_]unreference_unlocked
    
    This patch introduces the drm_gem_object_unreference_unlocked
    and drm_gem_object_handle_unreference_unlocked functions that
    do not require holding struct_mutex.
    
    drm_gem_object_unreference_unlocked calls the new
    ->gem_free_object_unlocked entry point if available, and
    otherwise just takes struct_mutex and just calls ->gem_free_object

which in turn suggests:

Commit:     bc9025bdc4e2b591734cca17697093845007b63d
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Tue Feb 9 05:49:12 2010 +0000

    Use drm_gem_object_[handle_]unreference_unlocked where possible
    
    Mostly obvious simplifications.
    
    The i915 pread/pwrite ioctls, intel_overlay_put_image and
    nouveau_gem_new were incorrectly using the locked versions
    without locking: this is also fixed in this patch.

which don't really look like candidates for 2.6.33-stable.

> --- a/drivers/gpu/drm/radeon/radeon_cs.c
> +++ b/drivers/gpu/drm/radeon/radeon_cs.c
> @@ -193,11 +193,13 @@ static void radeon_cs_parser_fini(struct
>  		radeon_bo_list_fence(&parser->validated, parser->ib->fence);
>  	}
>  	radeon_bo_list_unreserve(&parser->validated);
> -	for (i = 0; i < parser->nrelocs; i++) {
> -		if (parser->relocs[i].gobj) {
> -			mutex_lock(&parser->rdev->ddev->struct_mutex);
> -			drm_gem_object_unreference(parser->relocs[i].gobj);
> -			mutex_unlock(&parser->rdev->ddev->struct_mutex);
> +	if (parser->relocs != NULL) {
   	^ the only important part, the rest merely covers the new indentation 
  	  level

> +		for (i = 0; i < parser->nrelocs; i++) {
> +			if (parser->relocs[i].gobj) {
> +				mutex_lock(&parser->rdev->ddev->struct_mutex);
> +				drm_gem_object_unreference_unlocked(parser->relocs[i].gobj);
  				^ drm_gem_object_unreference_unlocked() doesn't exist in 2.6.33, yet
  				  we can use drm_gem_object_unreference() instead.

> +				mutex_unlock(&parser->rdev->ddev->struct_mutex);
> +			}
>  		}
>  	}
>  	kfree(parser->track);

As a consequence, I'd suggest to merely backport the NULL pointer check,
while ignoring the simplification of using the newly introduced
drm_gem_object_unreference_unlocked() from 2.6.34:

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Pauli Nieminen <suokkos@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_cs.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -193,11 +193,13 @@ static void radeon_cs_parser_fini(struct
 		radeon_bo_list_fence(&parser->validated, parser->ib->fence);
 	}
 	radeon_bo_list_unreserve(&parser->validated);
-	for (i = 0; i < parser->nrelocs; i++) {
-		if (parser->relocs[i].gobj) {
-			mutex_lock(&parser->rdev->ddev->struct_mutex);
-			drm_gem_object_unreference(parser->relocs[i].gobj);
-			mutex_unlock(&parser->rdev->ddev->struct_mutex);
+	if (parser->relocs != NULL) {
+		for (i = 0; i < parser->nrelocs; i++) {
+			if (parser->relocs[i].gobj) {
+				mutex_lock(&parser->rdev->ddev->struct_mutex);
+				drm_gem_object_unreference(parser->relocs[i].gobj);
+				mutex_unlock(&parser->rdev->ddev->struct_mutex);
+			}
 		}
 	}
 	kfree(parser->track);


