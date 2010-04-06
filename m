Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab0DFVp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:45:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:57137 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757045Ab0DFVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:45:45 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18UVrQFB08UxtSrb/swxrxFItfXIrR0gtkQ89Pnbf
	OQWX10y9PFGufx
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch drm-radeon-kms-fix-null-pointer-dereference-if-memory-allocation-failed.patch added to 2.6.33-stable tree
Date: Tue, 6 Apr 2010 23:45:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33-2.slh.1-sidux-686; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, suokkos@gmail.com, airlied@redhat.com,
       stable@kernel.org
References: <1270231240946@site>
In-Reply-To: <1270231240946@site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004062345.40988.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 06 April 2010, gregkh@suse.de wrote:
> This is a note to let you know that we have just queued up the patch titled
> 
>     Subject: drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed.
> 
> to the 2.6.33-stable tree.  Its filename is
> 
>     drm-radeon-kms-fix-null-pointer-dereference-if-memory-allocation-failed.patch
> 
> A git repo of this tree can be found at 
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> 
> From fcbc451ba1948fba967198bd150ecbd10bbb7075 Mon Sep 17 00:00:00 2001
> From: Pauli Nieminen <suokkos@gmail.com>
> Date: Fri, 19 Mar 2010 07:44:33 +0000
> Subject: drm/radeon/kms: Fix NULL pointer dereference if memory allocation failed.
> 
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
