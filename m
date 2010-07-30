Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab0G3ScA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:32:00 -0400
Received: from kroah.org ([198.145.64.141]:58123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886Ab0G3RzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:38 2010
Message-Id: <20100730175138.593506692@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [055/205] drm/i915: add reclaimable to i915 self-reclaimable page allocations
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit cd9f040df6ce46573760a507cb88192d05d27d86 upstream.

The hibernate issues that got fixed in commit 985b823b9192 ("drm/i915:
fix hibernation since i915 self-reclaim fixes") turn out to have been
incomplete.  Vefa Bicakci tested lots of hibernate cycles, and without
the __GFP_RECLAIMABLE flag the system eventually fails to resume.

With the flag added, Vefa can apparently hibernate forever (or until he
gets bored running his automated scripts, whichever comes first).

The reclaimable flag was there originally, and was one of the flags that
were dropped (unintentionally) by commit 4bdadb978569 ("drm/i915:
Selectively enable self-reclaim") that introduced all these problems,
but I didn't want to just blindly add back all the flags in commit
985b823b9192, and it looked like __GFP_RECLAIM wasn't necessary.  It
clearly was.

I still suspect that there is some subtle reason we're missing that
causes the problems, but __GFP_RECLAIMABLE is certainly not wrong to use
in this context, and is what the code historically used.  And we have no
idea what the causes the corruption without it.

Reported-and-tested-by: M. Vefa Bicakci <bicave@superonline.com>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2314,6 +2314,7 @@ i915_gem_object_get_pages(struct drm_gem
 		page = read_cache_page_gfp(mapping, i,
 					   GFP_HIGHUSER |
 					   __GFP_COLD |
+					   __GFP_RECLAIMABLE |
 					   gfpmask);
 		if (IS_ERR(page))
 			goto err_pages;


