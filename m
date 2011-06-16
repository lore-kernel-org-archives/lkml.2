Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab1FPHJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:09:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48209 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490Ab1FPHFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:05:39 -0400
X-Sasl-enc: 5fbaRlElli3a5IMSOuRJkZ+hfRBqUzJBdxK19W7dT4x5 1308207937
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:16:11 2011
Message-Id: <20110616001611.887734901@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:15:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [26/91] PCI: allow matching of prefetchable resources to
In-Reply-To: <20110616001900.GA25375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------
 non-prefetchable windows

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8c8def26bfaa704db67d515da3eb92cf26067548 upstream.

I'm not entirely sure it needs to go into 32, but it's probably the right
thing to do. Another way of explaining the patch is:

 - we currently pick the _first_ exactly matching bus resource entry, but
   the _last_ inexactly matching one. Normally first/last shouldn't
   matter, but bus resource entries aren't actually all created equal: in
   a transparent bus, the last resources will be the parent resources,
   which we should generally try to avoid unless we have no choice. So
   "first matching" is the thing we should always aim for.

 - the patch is a bit bigger than it needs to be, because I simplified the
   logic at the same time. It used to be a fairly incomprehensible

	if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
		best = r;       /* Approximating prefetchable by non-prefetchable */

   and technically, all the patch did was to make that complex choice be
   even more complex (it basically added a "&& !best" to say that if we
   already gound a non-prefetchable window for the prefetchable resource,
   then we won't override an earlier one with that later one: remember
   "first matching").

 - So instead of that complex one with three separate conditionals in one,
   I split it up a bit, and am taking advantage of the fact that we
   already handled the exact case, so if 'res->flags' has the PREFETCH
   bit, then we already know that 'r->flags' will _not_ have it. So the
   simplified code drops the redundant test, and does the new '!best' test
   separately. It also uses 'continue' as a way to ignore the bus
   resource we know doesn't work (ie a prefetchable bus resource is _not_
   acceptable for anything but an exact match), so it turns into:

	/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
	if (r->flags & IORESOURCE_PREFETCH)
		continue;
	/* .. but we can put a prefetchable resource inside a non-prefetchable one */
	if (!best)
		best = r;

   instead. With the comments, it's now six lines instead of two, but it's
   conceptually simpler, and I _could_ have written it as two lines:

	if ((res->flags & IORESOURCE_PREFETCH) && !best)
		best = r;	/* Approximating prefetchable by non-prefetchable */

   but I thought that was too damn subtle.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/pci/pci.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -373,8 +373,12 @@ pci_find_parent_resource(const struct pc
 			continue;	/* Wrong type */
 		if (!((res->flags ^ r->flags) & IORESOURCE_PREFETCH))
 			return r;	/* Exact match */
-		if ((res->flags & IORESOURCE_PREFETCH) && !(r->flags & IORESOURCE_PREFETCH))
-			best = r;	/* Approximating prefetchable by non-prefetchable */
+		/* We can't insert a non-prefetch resource inside a prefetchable parent .. */
+		if (r->flags & IORESOURCE_PREFETCH)
+			continue;
+		/* .. but we can put a prefetchable resource inside a non-prefetchable one */
+		if (!best)
+			best = r;
 	}
 	return best;
 }


