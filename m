Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab0G3RgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:36:06 -0400
Received: from kroah.org ([198.145.64.141]:35701 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759401Ab0G3Ref (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.892310896@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: [046/140] drm/i915: fix hibernation since i915 self-reclaim fixes
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 985b823b919273fe1327d56d2196b4f92e5d0fae upstream.

Since commit 4bdadb9785696439c6e2b3efe34aa76df1149c83 ("drm/i915:
Selectively enable self-reclaim"), we've been passing GFP_MOVABLE to the
i915 page allocator where we weren't before due to some over-eager
removal of the page mapping gfp_flags games the code used to play.

This caused hibernate on Intel hardware to result in a lot of memory
corruptions on resume.  See for example

  http://bugzilla.kernel.org/show_bug.cgi?id=13811

Reported-by: Evengi Golov (in bugzilla)
Signed-off-by: Dave Airlie <airlied@redhat.com>
Tested-by: M. Vefa Bicakci <bicave@superonline.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2288,7 +2288,7 @@ i915_gem_object_get_pages(struct drm_gem
 	mapping = inode->i_mapping;
 	for (i = 0; i < page_count; i++) {
 		page = read_cache_page_gfp(mapping, i,
-					   mapping_gfp_mask (mapping) |
+					   GFP_HIGHUSER |
 					   __GFP_COLD |
 					   gfpmask);
 		if (IS_ERR(page))


