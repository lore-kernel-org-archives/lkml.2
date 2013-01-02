Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab3ABKBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 05:01:42 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52465 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3ABKBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 05:01:39 -0500
Date: Wed, 2 Jan 2013 02:01:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting memory
Message-ID: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I suggested using "mount -o remount,mpol=local /tmp" in NUMA
mempolicy testing.  Very nasty.  Reading /proc/mounts, /proc/pid/mounts
or /proc/pid/mountinfo may then corrupt one bit of kernel memory, often
in a page table (causing "Bad swap" or "Bad page map" warning or "Bad
pagetable" oops), sometimes in a vm_area_struct or rbnode or somewhere
worse.  "mpol=prefer" and "mpol=prefer:Node" are equally toxic.

Recent NUMA enhancements are not to blame: this dates back to 2.6.35,
when commit e17f74af351c "mempolicy: don't call mpol_set_nodemask()
when no_context" skipped mpol_parse_str()'s call to mpol_set_nodemask(),
which used to initialize v.preferred_node, or set MPOL_F_LOCAL in flags.
With slab poisoning, you can then rely on mpol_to_str() to set the bit
for node 0x6b6b, probably in the next page above the caller's stack.

mpol_parse_str() is only called from shmem_parse_options(): no_context
is always true, so call it unused for now, and remove !no_context code.
Set v.nodes or v.preferred_node or MPOL_F_LOCAL as mpol_to_str() might
expect.  Then mpol_to_str() can ignore its no_context argument also,
the mpol being appropriately initialized whether contextualized or not.
Rename its no_context unused too, and let subsequent patch remove them
(that's not needed for stable backporting, which would involve rejects).

I don't understand why MPOL_LOCAL is described as a pseudo-policy:
it's a reasonable policy which suffers from a confusing implementation
in terms of MPOL_PREFERRED with MPOL_F_LOCAL.  I believe this would be
much more robust if MPOL_LOCAL were recognized in switch statements
throughout, MPOL_F_LOCAL deleted, and MPOL_PREFERRED use the (possibly
empty) nodes mask like everyone else, instead of its preferred_node
variant (I presume an optimization from the days before MPOL_LOCAL).
But that would take me too long to get right and fully tested.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org
---

 mm/mempolicy.c |   64 +++++++++++++++++++----------------------------
 1 file changed, 26 insertions(+), 38 deletions(-)

--- 3.8-rc1/mm/mempolicy.c	2012-12-22 09:43:27.636015582 -0800
+++ linux/mm/mempolicy.c	2013-01-01 23:44:10.715017466 -0800
@@ -2595,8 +2595,7 @@ void numa_default_policy(void)
  */
 
 /*
- * "local" is pseudo-policy:  MPOL_PREFERRED with MPOL_F_LOCAL flag
- * Used only for mpol_parse_str() and mpol_to_str()
+ * "local" is implemented internally by MPOL_PREFERRED with MPOL_F_LOCAL flag.
  */
 static const char * const policy_modes[] =
 {
@@ -2610,28 +2609,21 @@ static const char * const policy_modes[]
 
 #ifdef CONFIG_TMPFS
 /**
- * mpol_parse_str - parse string to mempolicy
+ * mpol_parse_str - parse string to mempolicy, for tmpfs mpol mount option.
  * @str:  string containing mempolicy to parse
  * @mpol:  pointer to struct mempolicy pointer, returned on success.
- * @no_context:  flag whether to "contextualize" the mempolicy
+ * @unused:  redundant argument, to be removed later.
  *
  * Format of input:
  *	<mode>[=<flags>][:<nodelist>]
  *
- * if @no_context is true, save the input nodemask in w.user_nodemask in
- * the returned mempolicy.  This will be used to "clone" the mempolicy in
- * a specific context [cpuset] at a later time.  Used to parse tmpfs mpol
- * mount option.  Note that if 'static' or 'relative' mode flags were
- * specified, the input nodemask will already have been saved.  Saving
- * it again is redundant, but safe.
- *
  * On success, returns 0, else 1
  */
-int mpol_parse_str(char *str, struct mempolicy **mpol, int no_context)
+int mpol_parse_str(char *str, struct mempolicy **mpol, int unused)
 {
 	struct mempolicy *new = NULL;
 	unsigned short mode;
-	unsigned short uninitialized_var(mode_flags);
+	unsigned short mode_flags;
 	nodemask_t nodes;
 	char *nodelist = strchr(str, ':');
 	char *flags = strchr(str, '=');
@@ -2719,24 +2711,23 @@ int mpol_parse_str(char *str, struct mem
 	if (IS_ERR(new))
 		goto out;
 
-	if (no_context) {
-		/* save for contextualization */
-		new->w.user_nodemask = nodes;
-	} else {
-		int ret;
-		NODEMASK_SCRATCH(scratch);
-		if (scratch) {
-			task_lock(current);
-			ret = mpol_set_nodemask(new, &nodes, scratch);
-			task_unlock(current);
-		} else
-			ret = -ENOMEM;
-		NODEMASK_SCRATCH_FREE(scratch);
-		if (ret) {
-			mpol_put(new);
-			goto out;
-		}
-	}
+	/*
+	 * Save nodes for mpol_to_str() to show the tmpfs mount options
+	 * for /proc/mounts, /proc/pid/mounts and /proc/pid/mountinfo.
+	 */
+	if (mode != MPOL_PREFERRED)
+		new->v.nodes = nodes;
+	else if (nodelist)
+		new->v.preferred_node = first_node(nodes);
+	else
+		new->flags |= MPOL_F_LOCAL;
+
+	/*
+	 * Save nodes for contextualization: this will be used to "clone"
+	 * the mempolicy in a specific context [cpuset] at a later time.
+	 */
+	new->w.user_nodemask = nodes;
+
 	err = 0;
 
 out:
@@ -2756,13 +2747,13 @@ out:
  * @buffer:  to contain formatted mempolicy string
  * @maxlen:  length of @buffer
  * @pol:  pointer to mempolicy to be formatted
- * @no_context:  "context free" mempolicy - use nodemask in w.user_nodemask
+ * @unused:  redundant argument, to be removed later.
  *
  * Convert a mempolicy into a string.
  * Returns the number of characters in buffer (if positive)
  * or an error (negative)
  */
-int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int no_context)
+int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol, int unused)
 {
 	char *p = buffer;
 	int l;
@@ -2788,7 +2779,7 @@ int mpol_to_str(char *buffer, int maxlen
 	case MPOL_PREFERRED:
 		nodes_clear(nodes);
 		if (flags & MPOL_F_LOCAL)
-			mode = MPOL_LOCAL;	/* pseudo-policy */
+			mode = MPOL_LOCAL;
 		else
 			node_set(pol->v.preferred_node, nodes);
 		break;
@@ -2796,10 +2787,7 @@ int mpol_to_str(char *buffer, int maxlen
 	case MPOL_BIND:
 		/* Fall through */
 	case MPOL_INTERLEAVE:
-		if (no_context)
-			nodes = pol->w.user_nodemask;
-		else
-			nodes = pol->v.nodes;
+		nodes = pol->v.nodes;
 		break;
 
 	default:
