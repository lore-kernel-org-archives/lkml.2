Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2EAN04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 09:26:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38230 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2EAN0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 09:26:55 -0400
Date: Tue, 1 May 2012 06:25:32 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/3] vmevent: Implement equal-to attribute state
Message-ID: <20120501132531.GA24226@lizard>
References: <20120501132409.GA22894@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120501132409.GA22894@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This complements GT and LT, making it possible to combine GE and LE
operators. We'll use it for blended attributes: the special attributes
will return either 0 or <threshold>, so to make two-way notifications
we will pass LT | EQ bits.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/vmevent.h |    6 +++++-
 mm/vmevent.c            |   22 +++++++++++++++-------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/linux/vmevent.h b/include/linux/vmevent.h
index ca97cf0..aae0d24 100644
--- a/include/linux/vmevent.h
+++ b/include/linux/vmevent.h
@@ -27,9 +27,13 @@ enum {
 	 */
 	VMEVENT_ATTR_STATE_VALUE_GT	= (1UL << 1),
 	/*
+	 * Sample value is equal to user-specified value
+	 */
+	VMEVENT_ATTR_STATE_VALUE_EQ	= (1UL << 2),
+	/*
 	 * One-shot mode.
 	 */
-	VMEVENT_ATTR_STATE_ONE_SHOT	= (1UL << 2),
+	VMEVENT_ATTR_STATE_ONE_SHOT	= (1UL << 3),
 
 	/* Saved state, used internally by the kernel for one-shot mode. */
 	__VMEVENT_ATTR_STATE_VALUE_WAS_LT	= (1UL << 30),
diff --git a/mm/vmevent.c b/mm/vmevent.c
index 47ed448..9f1520b 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -87,28 +87,39 @@ static bool vmevent_match(struct vmevent_watch *watch)
 		u32 state = attr->state;
 		bool attr_lt = state & VMEVENT_ATTR_STATE_VALUE_LT;
 		bool attr_gt = state & VMEVENT_ATTR_STATE_VALUE_GT;
+		bool attr_eq = state & VMEVENT_ATTR_STATE_VALUE_EQ;
 
 		if (!state)
 			continue;
 
-		if (attr_lt || attr_gt) {
+		if (attr_lt || attr_gt || attr_eq) {
 			bool one_shot = state & VMEVENT_ATTR_STATE_ONE_SHOT;
 			u32 was_lt_mask = __VMEVENT_ATTR_STATE_VALUE_WAS_LT;
 			u32 was_gt_mask = __VMEVENT_ATTR_STATE_VALUE_WAS_GT;
 			u64 value = vmevent_sample_attr(watch, attr);
 			bool lt = value < attr->value;
 			bool gt = value > attr->value;
+			bool eq = value == attr->value;
 			bool was_lt = state & was_lt_mask;
 			bool was_gt = state & was_gt_mask;
+			bool was_eq = was_lt && was_gt;
 			bool ret = false;
 
-			if (((attr_lt && lt) || (attr_gt && gt)) && !one_shot)
+			if (((attr_lt && lt) || (attr_gt && gt) ||
+					(attr_eq && eq)) && !one_shot)
 				return true;
 
-			if (attr_lt && lt && was_lt) {
+			if (attr_eq && eq && was_eq) {
 				return false;
-			} else if (attr_gt && gt && was_gt) {
+			} else if (attr_lt && lt && was_lt && !was_eq) {
 				return false;
+			} else if (attr_gt && gt && was_gt && !was_eq) {
+				return false;
+			} else if (eq) {
+				state |= was_lt_mask;
+				state |= was_gt_mask;
+				if (attr_eq)
+					ret = true;
 			} else if (lt) {
 				state |= was_lt_mask;
 				state &= ~was_gt_mask;
@@ -119,9 +130,6 @@ static bool vmevent_match(struct vmevent_watch *watch)
 				state &= ~was_lt_mask;
 				if (attr_gt)
 					ret = true;
-			} else {
-				state &= ~was_lt_mask;
-				state &= ~was_gt_mask;
 			}
 
 			attr->state = state;
-- 
1.7.9.2

