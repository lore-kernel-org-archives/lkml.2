Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2I0XeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 19:34:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39144 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2I0XeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 19:34:01 -0400
Date: Thu, 27 Sep 2012 16:31:17 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Input: Add in-kernel input events transformation framework
Message-ID: <20120927233116.GA31448@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new driver allows to perform various input events transformations
in kernel, e.g. remap one key (or combination) to another key.

The driver uses configfs (/sys/kernel/config/input_xfrm) and includes
this small readme:

  The transformation files (map, modmap) accept writes in this form:
  	<+/-> <keycode-map-from> <keycode-map-to>
  Plus sign to add, and minus sign to remove an entry.
  Keycodes can be found in /usr/include/linux/input.h
  For example, to remap KEY_LEFTMETA (125) to KEY_LEFTALT (56):
  	# echo + 125 56 > map
  Special mappings with a modifier key can be also created.
  For example, to remap capslock+left to home key:
  	# echo 58 42 > modkeys
  	# echo + 105 102 > modmap
  The first commands maps KEY_CAPSLOCK (58) to a modifier key,
  the second command creates the mapping. The second argument (42,
  which is KEY_LEFTSHIFT) to modkeys specifies the unmodifier key:
  when pressed together with the modifier key, the mappings will
  temporary turn off. That is, pressing capslock+leftshift will let
  use capslock as normal again.

So far it's not possible to switch keys, but if/when needed, it's
pretty easy to implement: just need to create a virtual input device,
and pass events through it.

Note that the other approach of these transformations would be to
export input filters to the userland, then intercept events there, and
pass the transformed events back (or to the uinput instance). But this
needlessly requires too much efforts for the simple task.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

In v2:

- Small fixup: subsys.su_mutex has to be initialized manually, I missed
  this part in the RFC.

 drivers/input/misc/Kconfig      |  10 +
 drivers/input/misc/Makefile     |   1 +
 drivers/input/misc/input_xfrm.c | 428 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 439 insertions(+)
 create mode 100644 drivers/input/misc/input_xfrm.c

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7c0f1ec..181e8cb 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -600,4 +600,14 @@ config INPUT_XEN_KBDDEV_FRONTEND
 	  To compile this driver as a module, choose M here: the
 	  module will be called xen-kbdfront.
 
+config INPUT_XFRM
+	tristate "Input events transformation framework"
+	depends on CONFIGFS_FS
+	help
+	  This driver allows to perform various input events transformations
+	  in kernel, e.g. remap one key (or combination) to another key.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called input_xfrm.
+
 endif
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 83fe6f5..b1b5a01 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -55,4 +55,5 @@ obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
 obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wistron_btns.o
 obj-$(CONFIG_INPUT_WM831X_ON)		+= wm831x-on.o
 obj-$(CONFIG_INPUT_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
+obj-$(CONFIG_INPUT_XFRM)		+= input_xfrm.o
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
diff --git a/drivers/input/misc/input_xfrm.c b/drivers/input/misc/input_xfrm.c
new file mode 100644
index 0000000..85f86fa
--- /dev/null
+++ b/drivers/input/misc/input_xfrm.c
@@ -0,0 +1,428 @@
+/*
+ * Input events transformation framework
+ *
+ * Copyright 2012  Anton Vorontsov <cbouatmailru@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mod_devicetable.h>
+#include <linux/printk.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/interrupt.h>
+#include <linux/kfifo.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/configfs.h>
+
+#define IXFRM_FIFO_SIZE 8 /* eight should be enough for anyone */
+
+struct ixfrm_event {
+	uint type;
+	uint code;
+	uint val;
+};
+
+struct ixfrm {
+	struct input_handle handle;
+	struct tasklet_struct tlet;
+	int xfrming;
+	bool unxfrm;
+	STRUCT_KFIFO(struct ixfrm_event, IXFRM_FIFO_SIZE) events;
+};
+
+struct ixfrm_map {
+	uint from;
+	uint to;
+	struct list_head node;
+};
+
+struct ixfrm_cfg {
+	struct configfs_subsystem subsys;
+	struct list_head map;
+	struct list_head modmap;
+	uint modkey;
+	uint unmodkey;
+};
+CONFIGFS_ATTR_STRUCT(ixfrm_cfg);
+
+static void ixfrm_event_sender(ulong data)
+{
+	struct ixfrm *ix = (void *)data;
+	struct ixfrm_event ev;
+
+	while (kfifo_out(&ix->events, &ev, 1)) {
+		input_inject_event(&ix->handle, ev.type, ev.code, ev.val);
+		input_inject_event(&ix->handle, EV_SYN, SYN_REPORT, 1);
+	}
+}
+
+static void ixfrm_queue_event(struct ixfrm *ix, uint type, uint code, uint val)
+{
+	struct ixfrm_event event = { type, code, val };
+
+	kfifo_in(&ix->events, &event, 1);
+	tasklet_schedule(&ix->tlet);
+}
+
+static bool ixfrm_do_xfrm(struct ixfrm *ixfrm, struct list_head *list,
+			  uint code, uint val)
+{
+	struct ixfrm_map *map;
+	uint to = KEY_CNT;
+
+	list_for_each_entry(map, list, node) {
+		if (map->from != code)
+			continue;
+		to = map->to;
+		break;
+	}
+
+	if (to == KEY_CNT)
+		return 0;
+
+	ixfrm_queue_event(ixfrm, EV_KEY, to, val);
+	return 1;
+}
+
+static struct ixfrm_cfg ixfrm_cfg;
+
+static bool ixfrm_filter(struct input_handle *handle, uint type, uint code,
+			 int val)
+{
+	struct ixfrm *ix = handle->private;
+	bool ret;
+
+	ret = ixfrm_do_xfrm(ix, &ixfrm_cfg.map, code, val);
+	if (ret)
+		return ret;
+
+	if (code == ixfrm_cfg.modkey) {
+		/* Is the event a part of mode switch seq? Ignore. */
+		if (ix->xfrming > 1)
+			return 1;
+		ix->xfrming = val;
+	} else if (code == ixfrm_cfg.unmodkey && ix->xfrming) {
+		ix->xfrming += val;
+		if (val)
+			return 1;
+		ix->xfrming = 0;
+		ix->unxfrm = !ix->unxfrm;
+		return 1;
+	}
+
+	/* In un-transform mode we behave like normal, pass events thru. */
+	if (ix->unxfrm)
+		return 0;
+
+	/* In transform mode never pass the mod key. */
+	if (code == ixfrm_cfg.modkey)
+		return 1;
+
+	/* Not transforming -> nothing to do, pass events thru. */
+	if (!ix->xfrming)
+		return 0;
+
+	return ixfrm_do_xfrm(ix, &ixfrm_cfg.modmap, code, val);
+}
+
+static int ixfrm_connect(struct input_handler *handler, struct input_dev *dev,
+			 const struct input_device_id *id)
+{
+	struct ixfrm *ix;
+	int ret;
+
+	ix = kzalloc(sizeof(*ix), GFP_KERNEL);
+	if (!ix)
+		return -ENOMEM;
+
+	INIT_KFIFO(ix->events);
+	tasklet_init(&ix->tlet, ixfrm_event_sender, (ulong)ix);
+
+	ix->handle.dev = dev;
+	ix->handle.handler = handler;
+	ix->handle.name = handler->name;
+	ix->handle.private = ix;
+
+	ret = input_register_handle(&ix->handle);
+	if (ret) {
+		pr_err("%s: unable to register input handler: %d\n",
+		       handler->name, ret);
+		goto err_reg;
+	}
+
+	ret = input_open_device(&ix->handle);
+	if (ret) {
+		pr_err("%s: unable to open input device: %d\n",
+		       handler->name, ret);
+		goto err_open;
+	}
+
+	return 0;
+err_open:
+	input_unregister_handle(&ix->handle);
+err_reg:
+	kfree(ix);
+	return ret;
+}
+
+static void ixfrm_disconnect(struct input_handle *handle)
+{
+	struct ixfrm *ix = handle->private;
+
+	tasklet_kill(&ix->tlet);
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(ix);
+}
+
+static const struct input_device_id ixfrm_ids[] = {
+	{
+		.flags	= INPUT_DEVICE_ID_MATCH_EVBIT |
+			  INPUT_DEVICE_ID_MATCH_KEYBIT,
+		.evbit	= { BIT_MASK(EV_KEY) },
+	},
+	{},
+};
+
+static struct input_handler ixfrm_handler = {
+	.name		= "input_xfrm",
+	.id_table	= ixfrm_ids,
+	.filter		= ixfrm_filter,
+	.connect	= ixfrm_connect,
+	.disconnect	= ixfrm_disconnect,
+};
+
+static inline struct ixfrm_cfg *to_ixfrm_cfg(struct config_item *item)
+{
+	if (!item)
+		return NULL;
+	return container_of(to_configfs_subsystem(to_config_group(item)),
+						  struct ixfrm_cfg, subsys);
+}
+
+static ssize_t __ixfrm_cfg_read_map(struct list_head *map, char *buf)
+{
+	struct ixfrm_map *ent;
+	ssize_t ret = 0;
+
+	list_for_each_entry(ent, map, node) {
+		ssize_t left = PAGE_SIZE - ret;
+		int c;
+
+		if (left <= 0)
+			return 0;
+
+		c = snprintf(buf, left, "%u %u\n", ent->from, ent->to);
+		if (c < 0)
+			return -EIO;
+
+		buf += c;
+		ret += c;
+	}
+	return ret;
+}
+
+static void ixfrm_try_unregister_handler(void)
+{
+	if (!list_empty(&ixfrm_cfg.map) || !list_empty(&ixfrm_cfg.modmap))
+		return;
+	input_unregister_handler(&ixfrm_handler);
+}
+
+static int ixfrm_try_register_handler(void)
+{
+	if (!list_empty(&ixfrm_cfg.map) || !list_empty(&ixfrm_cfg.modmap))
+		return 0;
+	return input_register_handler(&ixfrm_handler);
+}
+
+static int ixfrm_cfg_del_map(struct list_head *map, uint from)
+{
+	struct ixfrm_map *ent;
+
+	list_for_each_entry(ent, map, node) {
+		if (ent->from != from)
+			continue;
+		list_del(&ent->node);
+		kfree(ent);
+		ixfrm_try_unregister_handler();
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int ixfrm_cfg_add_map(struct list_head *map, uint from, uint to)
+{
+	struct ixfrm_map *ent;
+	int ret;
+
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+
+	ent->from = from;
+	ent->to = to;
+
+	ret = ixfrm_try_register_handler();
+	if (ret)
+		goto err_reg;
+
+	list_add(&ent->node, map);
+	return 0;
+err_reg:
+	kfree(ent);
+	return ret;
+}
+
+static ssize_t __ixfrm_cfg_store_map(struct list_head *map, const char *buf,
+				     size_t c) {
+	uint from;
+	uint to;
+	int ret;
+
+	if (sscanf(buf, "+ %u %u", &from, &to) == 2) {
+		ret = ixfrm_cfg_add_map(map, from, to);
+		if (ret)
+			return ret;
+	} else if (sscanf(buf, "- %u", &from) == 1) {
+		ret = ixfrm_cfg_del_map(map, from);
+		if (ret)
+			return ret;
+	}
+	return c;
+}
+
+static ssize_t ixfrm_cfg_read_map(struct ixfrm_cfg *ic, char *buf)
+{
+	return __ixfrm_cfg_read_map(&ic->map, buf);
+}
+
+static ssize_t ixfrm_cfg_store_map(struct ixfrm_cfg *ic, const char *buf,
+				   size_t c)
+{
+	return __ixfrm_cfg_store_map(&ic->map, buf, c);
+}
+
+static ssize_t ixfrm_cfg_read_modmap(struct ixfrm_cfg *ic, char *buf)
+{
+	return __ixfrm_cfg_read_map(&ic->modmap, buf);
+}
+
+static ssize_t ixfrm_cfg_store_modmap(struct ixfrm_cfg *ic, const char *buf,
+				      size_t c)
+{
+	return __ixfrm_cfg_store_map(&ic->modmap, buf, c);
+}
+
+static ssize_t ixfrm_cfg_read_modkeys(struct ixfrm_cfg *ic, char *buf)
+{
+	return sprintf(buf, "%u %u\n", ic->modkey, ic->unmodkey);
+}
+
+static ssize_t ixfrm_cfg_store_modkeys(struct ixfrm_cfg *ic, const char *buf,
+				       size_t c)
+{
+	if (sscanf(buf, "%u %u", &ic->modkey, &ic->unmodkey) != 2)
+		return -EINVAL;
+	return c;
+}
+
+static ssize_t ixfrm_cfg_readme(struct ixfrm_cfg *ic, char *buf)
+{
+	return sprintf(buf,
+	  "The transformation files (map, modmap) accept writes in this form:\n"
+	  "	<+/-> <keycode-map-from> <keycode-map-to>\n"
+	  "Plus sign to add, and minus sign to remove an entry.\n"
+	  "Keycodes can be found in /usr/include/linux/input.h\n"
+	  "For example, to remap KEY_LEFTMETA (125) to KEY_LEFTALT (56): \n"
+	  "	# echo + 125 56 > map\n"
+	  "Special mappings with a modifier key can be also created.\n"
+	  "For example, to remap capslock+left to home key:\n"
+	  "	# echo 58 42 > modkeys\n"
+	  "	# echo + 105 102 > modmap\n"
+	  "The first commands maps KEY_CAPSLOCK (58) to a modifier key, \n"
+	  "the second command creates the mapping. The second argument (42, \n"
+	  "which is KEY_LEFTSHIFT) to modkeys specifies the unmodifier key: \n"
+	  "when pressed together with the modifier key, the mappings will \n"
+	  "temporary turn off. That is, pressing capslock+leftshift will let \n"
+	  "use capslock as normal again.\n");
+}
+
+#define IXFRM_CFG_ATTR(_name, _mode, _show, _store) \
+	static struct ixfrm_cfg_attribute ixfrm_cfg_attr_##_name = \
+		__CONFIGFS_ATTR(_name, _mode, _show, _store)
+IXFRM_CFG_ATTR(map, 0600, ixfrm_cfg_read_map, ixfrm_cfg_store_map);
+IXFRM_CFG_ATTR(modmap, 0600, ixfrm_cfg_read_modmap, ixfrm_cfg_store_modmap);
+IXFRM_CFG_ATTR(modkeys, 0600, ixfrm_cfg_read_modkeys, ixfrm_cfg_store_modkeys);
+IXFRM_CFG_ATTR(readme, 0400, ixfrm_cfg_readme, NULL);
+
+static struct configfs_attribute *ixfrm_cfg_attrs[] = {
+	&ixfrm_cfg_attr_map.attr,
+	&ixfrm_cfg_attr_modmap.attr,
+	&ixfrm_cfg_attr_modkeys.attr,
+	&ixfrm_cfg_attr_readme.attr,
+	NULL,
+};
+
+CONFIGFS_ATTR_OPS(ixfrm_cfg);
+
+static struct configfs_item_operations ixfrm_cfg_item_ops = {
+	.show_attribute		= ixfrm_cfg_attr_show,
+	.store_attribute	= ixfrm_cfg_attr_store,
+};
+
+static struct config_item_type ixfrm_cfg_type = {
+	.ct_item_ops	= &ixfrm_cfg_item_ops,
+	.ct_attrs	= ixfrm_cfg_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct ixfrm_cfg ixfrm_cfg = {
+	.subsys.su_group.cg_item.ci_namebuf	= "input_xfrm",
+	.subsys.su_group.cg_item.ci_type	= &ixfrm_cfg_type,
+	.map = LIST_HEAD_INIT(ixfrm_cfg.map),
+	.modmap = LIST_HEAD_INIT(ixfrm_cfg.modmap),
+};
+
+static int ixfrm_module_init(void)
+{
+	config_group_init(&ixfrm_cfg.subsys.su_group);
+	mutex_init(&ixfrm_cfg.subsys.su_mutex);
+	return configfs_register_subsystem(&ixfrm_cfg.subsys);
+}
+module_init(ixfrm_module_init);
+
+static void ixfrm_module_exit(void)
+{
+	struct ixfrm_map *ent;
+	struct ixfrm_map *tmp;
+
+	configfs_unregister_subsystem(&ixfrm_cfg.subsys);
+
+	list_for_each_entry_safe(ent, tmp, &ixfrm_cfg.map, node) {
+		list_del(&ent->node);
+		kfree(ent);
+	}
+
+	list_for_each_entry_safe(ent, tmp, &ixfrm_cfg.modmap, node) {
+		list_del(&ent->node);
+		kfree(ent);
+	}
+
+	ixfrm_try_unregister_handler();
+}
+module_exit(ixfrm_module_exit);
+
+MODULE_DESCRIPTION("Input events transformation framework");
+MODULE_AUTHOR("Anton Vorontsov <cbouatmailru@gmail.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.12
