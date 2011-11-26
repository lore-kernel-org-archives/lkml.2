Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1KZEoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:44:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34937 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab1KZEoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:44:18 -0500
MIME-Version: 1.0
In-Reply-To: <868vn9ieey.fsf@sumi.keithp.com>
References: <1321382968.8791.4.camel@localhost.localdomain>
	<20111121162306.GB3807@phenom.ffwll.local>
	<868vn9ieey.fsf@sumi.keithp.com>
Date: Sat, 26 Nov 2011 10:44:17 +0600
Message-ID: <CADZ9YHgwcjz=mkMxWxV1pT7fH=6hgWTSP1s2wmG7h3N837QUoQ@mail.gmail.com>
Subject: Re: [PATCH] drm, i915: Fix memory leak in i915_gem_busy_ioctl().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 11:16 PM, Keith Packard <keithp@keithp.com> wrote:
> On Mon, 21 Nov 2011 17:23:06 +0100, Daniel Vetter <daniel@ffwll.ch> wrote:
>
>> Indeed, nice catch (albeit totally unlikely to be hit, because the error
>> only happens when the gpu ceases to progress in the ring, so imo not
>> stable material). Keith, please pick this up for fixes, thanks.
>
> It's already there and queued for airlied :-)
>
Thank you guys for reviewing and taking the patch.

Now, while I was looking at the uses of i915_add_request(), I found
the following code :

                        ret = i915_gem_flush_ring(ring, 0,
I915_GEM_GPU_DOMAINS);
                        request = kzalloc(sizeof(*request), GFP_KERNEL);
                        if (ret || request == NULL ||
                            i915_add_request(ring, NULL, request))
                            kfree(request);

>From above code, we might ended up by calling kfree(request) without
allocating request. Though, it's unlikely cause if request is NULL
then BUG_ON will be hit in i915_add_request(). So, to unify the callee
uses of i915_add_request(), I'm proposing the following patch. Please
let me know what do you guys think. If you guys agree, I can sent a
formal patch.

Index: work/modi.linux-3.1.1/drivers/gpu/drm/i915/i915_gem.c
===================================================================
--- work.orig/modi.linux-3.1.1/drivers/gpu/drm/i915/i915_gem.c
+++ work/modi.linux-3.1.1/drivers/gpu/drm/i915/i915_gem.c
@@ -1736,8 +1736,6 @@ i915_add_request(struct intel_ring_buffe
 	int was_empty;
 	int ret;

-	BUG_ON(request == NULL);
-
 	ret = ring->add_request(ring, &seqno);
 	if (ret)
 	    return ret;
@@ -2002,9 +2000,11 @@ i915_gem_retire_work_handler(struct work
 			ret = i915_gem_flush_ring(ring,
 						  0, I915_GEM_GPU_DOMAINS);
 			request = kzalloc(sizeof(*request), GFP_KERNEL);
-			if (ret || request == NULL ||
-			    i915_add_request(ring, NULL, request))
-			    kfree(request);
+			if (request) {
+				ret = i915_add_request(ring, NULL, request);
+				if (ret)
+					kfree(request);
+			}
 		}

 		idle &= list_empty(&ring->request_list);


Thanks,
Rakib
