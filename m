Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2HLVkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:40:47 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:57847 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2HLVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:48 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1OAHUhKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIIhAQUnLxMBDxAISTkKFAYBEogRtjoUkS8DmzaNBg
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="168687036"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 10/19] Input: MT - Add in-kernel tracking
Date: Sun, 12 Aug 2012 23:42:28 +0200
Message-Id: <1344807757-2217-11-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the INPUT_MT_TRACK flag set, the function input_mt_assign_slots()
can be used to match a new set of contacts against the currently used
slots. The algorithm used is based on Lagrange relaxation, and performs
very well in practice; slower than mtdev for a few corner cases, but
faster in most commonly occuring cases.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/input/input-mt.c | 144 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/input/mt.h |  21 +++++++
 2 files changed, 163 insertions(+), 2 deletions(-)

diff --git a/drivers/input/input-mt.c b/drivers/input/input-mt.c
index 21b105e..36c93d7 100644
--- a/drivers/input/input-mt.c
+++ b/drivers/input/input-mt.c
@@ -46,7 +46,7 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 
 	mt = kzalloc(sizeof(*mt) + num_slots * sizeof(*mt->slots), GFP_KERNEL);
 	if (!mt)
-		return -ENOMEM;
+		goto err_mem;
 
 	mt->num_slots = num_slots;
 	mt->flags = flags;
@@ -74,6 +74,12 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 	}
 	if (flags & INPUT_MT_DIRECT)
 		__set_bit(INPUT_PROP_DIRECT, dev->propbit);
+	if (flags & INPUT_MT_TRACK) {
+		unsigned int n2 = num_slots * num_slots;
+		mt->red = kcalloc(n2, sizeof(*mt->red), GFP_KERNEL);
+		if (!mt->red)
+			goto err_mem;
+	}
 
 	/* Mark slots as 'unused' */
 	for (i = 0; i < num_slots; i++)
@@ -81,6 +87,9 @@ int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 
 	dev->mt = mt;
 	return 0;
+err_mem:
+	kfree(mt);
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(input_mt_init_slots);
 
@@ -93,7 +102,10 @@ EXPORT_SYMBOL(input_mt_init_slots);
  */
 void input_mt_destroy_slots(struct input_dev *dev)
 {
-	kfree(dev->mt);
+	if (dev->mt) {
+		kfree(dev->mt->red);
+		kfree(dev->mt);
+	}
 	dev->mt = NULL;
 }
 EXPORT_SYMBOL(input_mt_destroy_slots);
@@ -247,3 +259,131 @@ void input_mt_sync_frame(struct input_dev *dev)
 	mt->frame++;
 }
 EXPORT_SYMBOL(input_mt_sync_frame);
+
+static int adjust_dual(int *begin, int step, int *end, int eq)
+{
+	int f, *p, s, c;
+
+	if (begin == end)
+		return 0;
+
+	f = *begin;
+	p = begin + step;
+	s = p == end ? f + 1 : *p;
+
+	for (; p != end; p += step)
+		if (*p < f)
+			s = f, f = *p;
+		else if (*p < s)
+			s = *p;
+
+	c = (f + s + 1) / 2;
+	if (c == 0 || (c > 0 && !eq))
+		return 0;
+	if (s < 0)
+		c *= 2;
+
+	for (p = begin; p != end; p += step)
+		*p -= c;
+
+	return (c < s && s <= 0) || (f >= 0 && f < c);
+}
+
+static void find_reduced_matrix(int *w, int nr, int nc, int nrc)
+{
+	int i, k, sum;
+
+	for (k = 0; k < nrc; k++) {
+		for (i = 0; i < nr; i++)
+			adjust_dual(w + i, nr, w + i + nrc, nr <= nc);
+		sum = 0;
+		for (i = 0; i < nrc; i += nr)
+			sum += adjust_dual(w + i, 1, w + i + nr, nc <= nr);
+		if (!sum)
+			break;
+	}
+}
+
+static int input_mt_set_matrix(struct input_mt *mt,
+			       const struct input_mt_pos *pos, int num_pos)
+{
+	const struct input_mt_pos *p;
+	struct input_mt_slot *s;
+	int *w = mt->red;
+	int x, y;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (!input_mt_is_active(s))
+			continue;
+		x = input_mt_get_value(s, ABS_MT_POSITION_X);
+		y = input_mt_get_value(s, ABS_MT_POSITION_Y);
+		for (p = pos; p != pos + num_pos; p++) {
+			int dx = x - p->x, dy = y - p->y;
+			*w++ = dx * dx + dy * dy;
+		}
+	}
+
+	return w - mt->red;
+}
+
+static void input_mt_set_slots(struct input_mt *mt,
+			       int *slots, int num_pos)
+{
+	struct input_mt_slot *s;
+	int *w = mt->red, *p;
+
+	for (p = slots; p != slots + num_pos; p++)
+		*p = -1;
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (!input_mt_is_active(s))
+			continue;
+		for (p = slots; p != slots + num_pos; p++)
+			if (*w++ < 0)
+				*p = s - mt->slots;
+	}
+
+	for (s = mt->slots; s != mt->slots + mt->num_slots; s++) {
+		if (input_mt_is_active(s))
+			continue;
+		for (p = slots; p != slots + num_pos; p++)
+			if (*p < 0) {
+				*p = s - mt->slots;
+				break;
+			}
+	}
+}
+
+/**
+ * input_mt_assign_slots() - perform a best-match assignment
+ * @dev: input device with allocated MT slots
+ * @slots: the slot assignment to be filled
+ * @pos: the position array to match
+ * @num_pos: number of positions
+ *
+ * Performs a best match against the current contacts and returns
+ * the slot assignment list. New contacts are assigned to unused
+ * slots.
+ *
+ * Returns zero on success, or negative error in case of failure.
+ */
+int input_mt_assign_slots(struct input_dev *dev, int *slots,
+			  const struct input_mt_pos *pos, int num_pos)
+{
+	struct input_mt *mt = dev->mt;
+	int nrc;
+
+	if (!mt || !mt->red)
+		return -ENXIO;
+	if (num_pos > mt->num_slots)
+		return -EINVAL;
+	if (num_pos < 1)
+		return 0;
+
+	nrc = input_mt_set_matrix(mt, pos, num_pos);
+	find_reduced_matrix(mt->red, num_pos, nrc / num_pos, nrc);
+	input_mt_set_slots(mt, slots, num_pos);
+
+	return 0;
+}
+EXPORT_SYMBOL(input_mt_assign_slots);
diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
index a11d485..10bb77c 100644
--- a/include/linux/input/mt.h
+++ b/include/linux/input/mt.h
@@ -18,6 +18,8 @@
 #define INPUT_MT_POINTER	0x0001	/* pointer device, e.g. trackpad */
 #define INPUT_MT_DIRECT		0x0002	/* direct device, e.g. touchscreen */
 #define INPUT_MT_DROP_UNUSED	0x0004	/* drop contacts not seen in frame */
+#define INPUT_MT_TRACK		0x0008	/* use in-kernel tracking */
+
 /**
  * struct input_mt_slot - represents the state of an input MT slot
  * @abs: holds current values of ABS_MT axes for this slot
@@ -34,6 +36,7 @@ struct input_mt_slot {
  * @num_slots: number of MT slots the device uses
  * @flags: input_mt operation flags
  * @frame: increases every time input_mt_sync_frame() is called
+ * @red: reduced cost matrix for in-kernel tracking
  * @slots: array of slots holding current values of tracked contacts
  */
 struct input_mt {
@@ -41,6 +44,7 @@ struct input_mt {
 	int num_slots;
 	unsigned int flags;
 	unsigned int frame;
+	int *red;
 	struct input_mt_slot slots[];
 };
 
@@ -56,6 +60,11 @@ static inline int input_mt_get_value(const struct input_mt_slot *slot,
 	return slot->abs[code - ABS_MT_FIRST];
 }
 
+static inline bool input_mt_is_active(const struct input_mt_slot *slot)
+{
+	return input_mt_get_value(slot, ABS_MT_TRACKING_ID) >= 0;
+}
+
 int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
 			unsigned int flags);
 void input_mt_destroy_slots(struct input_dev *dev);
@@ -88,4 +97,16 @@ void input_mt_report_pointer_emulation(struct input_dev *dev, bool use_count);
 
 void input_mt_sync_frame(struct input_dev *dev);
 
+/**
+ * struct input_mt_pos - contact position
+ * @x: horizontal coordinate
+ * @y: vertical coordinate
+ */
+struct input_mt_pos {
+	s16 x, y;
+};
+
+int input_mt_assign_slots(struct input_dev *dev, int *slots,
+			  const struct input_mt_pos *pos, int num_pos);
+
 #endif
-- 
1.7.11.4

