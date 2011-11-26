Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab1KZRaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 12:30:46 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:63337 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1KZRal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 12:30:41 -0500
Date: Sat, 26 Nov 2011 18:30:31 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org
Cc: federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: [RFC PATCH 2/7] include/linux: add headers for drivers/zio
Message-ID: <09c2b3834c06fc45d8cca26d980482c8dad7af5a.1322328075.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1322328073.git.rubini@gnudd.com>
In-Reply-To: <cover.1322328073.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header files for the beta3 release of zio.
The files match commit 7d37663 in git://ohwr.org/misc/zio.git .

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Samuel Iglesias Gonsalvez <siglesia@cern.ch>
Acked-By: Manohar Vanga <manohar.vanga@cern.ch>
---
 include/linux/zio-buffer.h  |  246 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/zio-sysfs.h   |  122 +++++++++++++++++++++
 include/linux/zio-trigger.h |   99 +++++++++++++++++
 include/linux/zio.h         |  244 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 711 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/zio-buffer.h
 create mode 100644 include/linux/zio-sysfs.h
 create mode 100644 include/linux/zio-trigger.h
 create mode 100644 include/linux/zio.h

diff --git a/include/linux/zio-buffer.h b/include/linux/zio-buffer.h
new file mode 100644
index 0000000..2e5500c
--- /dev/null
+++ b/include/linux/zio-buffer.h
@@ -0,0 +1,246 @@
+/* Alessandro Rubini, Federico Vaga for CERN, 2011, GNU GPLv2 or later */
+#ifndef __ZIO_BUFFER_H__
+#define __ZIO_BUFFER_H__
+
+/*
+ * Data transfers on the control channel only happen by half a kB.
+ * This is fixed for forward compatibility; zio_control may have more
+ * fields in the future, and current apps should handle it.
+ */
+#define ZIO_CONTROL_SIZE	512
+
+/*
+ * The timestamp is mostly app-specific. It cam be timspec-alike but
+ * indidual devices may do whatever they want to match hardware.
+ */
+struct zio_timestamp {
+	uint64_t secs;
+	uint64_t ticks;
+	uint64_t bins;
+};
+
+/*
+ * The following data item is the control structure that is being exchanged
+ * on the control device associated to each data device. The size of each
+ * fields is fixed to ease portability of binary dumps (esp i386/x86-64).
+ * The endianness, however, is native for speed reasons.
+ */
+
+struct zio_control {
+	/* byte 0 */
+	uint8_t major_version;
+	uint8_t minor_version;
+	uint8_t unused[2];
+	/* byte 4*/
+	uint32_t seq_num;	/* block sequence number */
+	uint32_t flags;		/* endianness etc, see below */
+	uint32_t nsamples;	/* number of samples in this data block */
+	/* byte 16 */
+	uint16_t ssize;		/* sample-size for each of them, in bytes */
+	uint16_t sbits;		/* sample-bits: number of valid bits */
+	uint16_t cset_i;	/* index of channel-set within device */
+	uint16_t chan_i;	/* index of channel within cset */
+
+	/* byte 24 */
+	/* The control block includes what device the data belong to */
+	char devname[ZIO_NAME_LEN];
+
+	/* byte 56 */
+	/* Each data block is associated with a trigger and its features */
+	char triggername[ZIO_NAME_LEN];
+
+	/* byte 88 */
+	struct zio_timestamp tstamp;
+
+	/* byte 112 */
+	uint32_t ext_attr_mask;	/* mask of active extended attributes */
+	uint32_t std_attr_mask;	/* mask of active standard attributes */
+	/* byte 120 */
+	uint32_t std_attrs[32];	/* value of each standard attribute */
+	uint32_t ext_attrs[32];	/* value of each extended attribute */
+
+	/* This filler must be updated if you change fields above */
+	uint8_t __fill_end[ZIO_CONTROL_SIZE - 120 - 4 * (32 + 32)];
+};
+
+/* The following flags are used in the control structure */
+#define ZIO_CONTROL_LITTLE_ENDIAN	0x01000001
+#define ZIO_CONTROL_BIG_ENDIAN		0x02000002
+
+#define ZIO_CONTROL_MSB_ALIGN		0x00000004 /* for analog data */
+#define ZIO_CONTROL_LSB_ALIGN		0x00000008 /* for analog data */
+
+#ifdef __KERNEL__
+#include <linux/module.h>
+#include <linux/kobject.h>
+#include <linux/slab.h>
+#include <linux/zio.h>
+#include <linux/gfp.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+#define ZIO_DEFAULT_BUFFER "kmalloc" /* For devices with no own buffer type */
+
+/* Compile-time check that the control structure is the right size */
+static inline void __unused_check_size(void)
+{
+	/* if zio_control is smaller then ZIO_CONTROL_SIZE, compile error */
+	static int __used v1[sizeof(struct zio_control) - ZIO_CONTROL_SIZE];
+	/* if zio_control is greater then ZIO_CONTROL_SIZE, compile error */
+	static int __used v2[ZIO_CONTROL_SIZE - sizeof(struct zio_control)];
+
+	BUILD_BUG_ON(sizeof(struct zio_control) != ZIO_CONTROL_SIZE);
+}
+
+/* FIXME: use a kmem_cache and real functions for control alloc/free */
+static inline struct zio_control *zio_alloc_control(gfp_t gfp)
+{
+	struct zio_control *ctrl;
+
+	ctrl = kzalloc(sizeof(*ctrl), gfp);
+	if (!ctrl)
+		return NULL;
+	ctrl->major_version = ZIO_MAJOR_VERSION;
+	ctrl->minor_version = ZIO_MINOR_VERSION;
+	if (ntohl(1) == 1)
+		ctrl->flags |= ZIO_CONTROL_BIG_ENDIAN;
+	else
+		ctrl->flags |= ZIO_CONTROL_LITTLE_ENDIAN;
+	return ctrl;
+}
+static inline void zio_free_control(struct zio_control *ctrl)
+{
+	kfree(ctrl);
+}
+
+/*
+ * The following structure defines a buffer type, with methods.
+ * An instance is created for each channel using it
+ */
+struct zio_buffer_operations;
+struct zio_buffer_type {
+	struct zio_obj_head	head;
+	struct module		*owner;
+	struct list_head	list; /* instances, and list lock */
+	struct spinlock		lock;
+	unsigned long		flags; /* to be defined */
+
+	/* file operations (read/write etc) are buffer-specific too */
+	const struct zio_sys_operations		*s_op;
+	const struct zio_buffer_operations	*b_op;
+	const struct file_operations		*f_op;
+
+	/* default attributes for instance */
+	struct zio_attribute_set		zattr_set;
+	/* FIXME: how "own" devices are listed (here or elsewhere?) */
+	struct zio_device	*zdev_owner;
+	unsigned int		n_zdev_owner;
+};
+#define to_zio_buf(obj) container_of(obj, struct zio_buffer, head.kobj)
+
+/* read and write may often be the generic ones */
+ssize_t zio_generic_read(struct file *, char __user *,
+			 size_t, loff_t *);
+ssize_t zio_generic_write(struct file *, const char __user *,
+			  size_t, loff_t *);
+unsigned int zio_generic_poll(struct file *, struct poll_table_struct *);
+int zio_generic_release(struct inode *inode, struct file *f);
+
+
+int __must_check zio_register_buf(struct zio_buffer_type *zbuf,
+				  const char *name);
+void zio_unregister_buf(struct zio_buffer_type *zbuf);
+
+struct zio_bi {
+	struct zio_obj_head	head;
+	struct list_head	list;		/* instance list */
+	struct zio_channel	*chan;
+	struct zio_cset		*cset;		/* short for chan->cset */
+
+	/* Those using generic_read need this information */
+	unsigned long flags;			/* input or output, etc */
+	wait_queue_head_t q;			/* for reading or writing */
+
+	/* Standard and extended attributes for this object */
+	struct zio_attribute_set		zattr_set;
+
+	const struct zio_buffer_operations	*b_op;
+	const struct file_operations		*f_op;
+};
+#define to_zio_bi(_kobj) container_of(_kobj, struct zio_bi, head.kobj)
+
+/* The block is the basic data item being transferred */
+struct zio_block {
+	unsigned long		ctrl_flags;
+	void			*data;
+	size_t			datalen;
+	size_t			uoff;
+};
+
+/*
+ * We must know whether the ctrl block has been filled/read or not: "cdone"
+ * No "set_ctrl" or "clr_cdone" are needed, as cdone starts 0 and is only set
+ */
+#define zio_get_ctrl(block) ((struct zio_control *)((block)->ctrl_flags & ~1))
+#define zio_set_ctrl(block, ctrl) ((block)->ctrl_flags = (unsigned long)(ctrl))
+#define zio_is_cdone(block)  ((block)->ctrl_flags & 1)
+#define zio_set_cdone(block)  ((block)->ctrl_flags |= 1)
+
+
+/*
+ * Each buffer implementation must provide the following methods, because
+ * internal management of individual data instances is left to each of them.
+ *
+ * "store" is for input and "retr" for output (called by low-level driver).
+ * After store, the block is ready for user space and freed internally;
+ * after retr, it's the low level driver that must cal the free method.
+ * The "alloc" method is called on trigger setup (activate), because the
+ * data storage must be available when data transfer really happens (thus,
+ * a DMA-only device will have its own buffer as the preferred one).
+ * The buffer may use its own alloc for blocks created at write(2) time.
+ *
+ * Note that each buffer type will need more information, so the block
+ * is usually inside a custom structure, reached by container_of().
+ * Thus, all blocks for a buffer type must be allocated and freed using
+ * the methods of that specific buffer type.
+ */
+struct zio_buffer_operations {
+	struct zio_block *	(*alloc_block)(struct zio_bi *bi,
+					       struct zio_control *ctrl,
+					       size_t datalen, gfp_t gfp);
+	void			(*free_block)(struct zio_bi *bi,
+					      struct zio_block *block);
+
+	int			(*store_block)(struct zio_bi *bi,
+					       struct zio_block *block);
+	struct zio_block *	(*retr_block) (struct zio_bi *bi);
+
+	struct zio_bi *		(*create)(struct zio_buffer_type *zbuf,
+					  struct zio_channel *chan,
+					  fmode_t f_flags);
+	void			(*destroy)(struct zio_bi *bi);
+};
+
+/*
+ * This is the structure we place in f->private_data at open time.
+ * Note that the buffer_create function is called by zio-core.
+ */
+enum zio_cdev_type {
+	ZIO_CDEV_CTRL,
+	ZIO_CDEV_DATA,
+};
+struct zio_f_priv {
+	struct zio_channel *chan; /* where current block and buffer live */
+	enum zio_cdev_type type;
+};
+
+ssize_t zio_generic_read(struct file *f, char __user *ubuf,
+			 size_t count, loff_t *offp);
+ssize_t zio_generic_write(struct file *f, const char __user *ubuf,
+			  size_t count, loff_t *offp);
+unsigned int zio_generic_poll(struct file *f, struct poll_table_struct *w);
+
+#endif /* __KERNEL__ */
+#endif /* __ZIO_BUFFER_H__ */
diff --git a/include/linux/zio-sysfs.h b/include/linux/zio-sysfs.h
new file mode 100644
index 0000000..376b992
--- /dev/null
+++ b/include/linux/zio-sysfs.h
@@ -0,0 +1,122 @@
+/* Federico Vaga for CERN, 2011, GNU GPLv2 or later */
+#ifndef ZIO_SYSFS_H_
+#define ZIO_SYSFS_H_
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+
+#include <linux/zio.h>
+
+/*
+ * zio_attribute: the attribute to access device parameters.
+ *
+ * Many devices store configuration in hardware registers, and thus
+ * many configuration steps can be reduced to a read/write from/to a
+ * particular device register, located at a specific address.
+ *
+ * A zio_attribute provides a generic way to access those registers
+ *
+ * @attribute: standard attribute structure used to create a sysfs access
+ * @priv.reg: register address to use as is
+ * @priv.reg_descriptor: a generic pointer used to specify how access to a
+ *	particular register on device. This is defined by driver developer
+ * @value: is the value stored on device
+ * @show: is equivalent to info_get from zio_operations
+ * @store: is equivalent to  conf_set from zio_operations
+ */
+struct zio_attribute {
+	struct attribute			attr;
+	union { /* priv is sometimes a pointer and sometimes an hw addr */
+		void				*ptr;
+		unsigned long			addr;
+	} priv;
+	uint32_t				value;
+	const struct zio_sys_operations		*s_op;
+};
+
+struct zio_sys_operations {
+	int (*info_get)(struct kobject *kobj, struct zio_attribute *zattr,
+			uint32_t *usr_val);
+	int (*conf_set)(struct kobject *kobj, struct zio_attribute *zattr,
+			uint32_t  usr_val);
+};
+
+/* attribute -> zio_attribute */
+#define to_zio_zattr(aptr) container_of(aptr, struct zio_attribute, attr)
+
+/*
+ * Every object has both std attributes (whole length is known)
+ * and extended attributes (as we need to be told how many).
+ * Then, the sysfs attribute_groups are what we build to actually register
+ */
+struct zio_attribute_set {
+	struct zio_attribute	*std_zattr;
+	unsigned int		n_std_attr;
+	struct attribute_group	std_group;
+	struct zio_attribute	*ext_zattr;
+	unsigned int		n_ext_attr;
+	struct attribute_group	ext_group;
+};
+
+enum zattr_standard_zdev {
+	ZATTR_NBIT,	/* number of bits per sample */
+	ZATTR_GAIN,	/* gain for signal, integer in 0.001 steps */
+	ZATTR_OFFSET,	/* microvolts */
+	ZATTR_MAXRATE,	/* hertz */
+	ZATTR_VREFTYPE,	/* source of Vref (0 = default) */
+	ZATTR_STD_NUM_ZDEV,		/* used to size arrays */
+};
+enum zattr_standard_trig {
+	ZATTR_TRIG_REENABLE = 0,/* re-arm trigger */
+	ZATTR_TRIG_NSAMPLES,	/* samples for each transfer */
+	ZATTR_STD_NUM_TRIG,	/* used to size arrays */
+};
+enum zattr_standard_zbuf {
+	ZATTR_ZBUF_MAXLEN = 0,	/* max number of element in buffer */
+	ZATTR_STD_NUM_ZBUF,	/* used to size arrays */
+};
+
+extern const char zio_zdev_attr_names[ZATTR_STD_NUM_ZDEV][ZIO_NAME_LEN];
+extern const char zio_trig_attr_names[ZATTR_STD_NUM_TRIG][ZIO_NAME_LEN];
+extern const char zio_zbuf_attr_names[ZATTR_STD_NUM_ZBUF][ZIO_NAME_LEN];
+
+
+/* FIXME: check this DECLARE stuff */
+#define DEFINE_ZATTR_STD(_type, _name) struct zio_attribute \
+	_name[ZATTR_STD_NUM_##_type]
+
+/*
+ * @ZATTR_REG: define a zio attribute with address register
+ * @ZATTR_PRV: define a zio attribute with private register
+ * @ZATTR_EXT_REG: define a zio extended attribute with address register
+ * @ZATTR_EXT_PRV: define a zio extended attribute with private register
+ */
+#define ZATTR_REG(zobj, _type, _mode, _add, _val)[_type] = {		\
+		.attr = {						\
+			.name = zio_##zobj##_attr_names[_type],		\
+			.mode = _mode					\
+		},							\
+		.priv.addr = _add,					\
+		.value = _val,						\
+}
+#define ZATTR_PRV(zobj, _type, _mode, _add, _val)[_type] = {		\
+		.attr = {						\
+			.name = zio_##zobj##_attr_names[_type],		\
+			.mode = _mode					\
+		},							\
+		.priv.ptr = _add,					\
+		.value = _val,						\
+}
+#define ZATTR_EXT_REG(_name, _mode, _add, _val) {			\
+		.attr = {.name = _name, .mode = _mode},			\
+		.priv.addr = _add,					\
+		.value = _val,						\
+}
+#define ZATTR_EXT_PRV(_name, _mode, _add, _val) {			\
+		.attr = {.name = _name, .mode = _mode},			\
+		.priv.ptr = _add,					\
+		.value = _val,						\
+}
+
+#endif /* ZIO_SYSFS_H_ */
diff --git a/include/linux/zio-trigger.h b/include/linux/zio-trigger.h
new file mode 100644
index 0000000..6afacfe
--- /dev/null
+++ b/include/linux/zio-trigger.h
@@ -0,0 +1,99 @@
+/* Federico Vaga for CERN, 2011, GNU GPLv2 or later */
+#ifndef __ZIO_TRIGGER_H__
+#define __ZIO_TRIGGER_H__
+
+#include <linux/zio.h>
+#include <linux/zio-buffer.h>
+
+#define ZIO_DEFAULT_TRIGGER "timer" /* FIXME: app-request */
+
+struct zio_trigger_type {
+	struct zio_obj_head	head;
+	struct module		*owner;
+	struct list_head	list; /* instances, and list lock */
+	struct spinlock		lock;
+	unsigned long		flags; /* to be defined */
+
+	/* file_operations because the trigger may override the buffer */
+	const struct zio_sys_operations		*s_op;
+	const struct zio_trigger_operations	*t_op;
+	const struct file_operations		*f_op;
+
+	/* default attributes for instance */
+	struct zio_attribute_set		zattr_set;
+
+	/* FIXME: how "own" devices are listed (here or elsewhere?) */
+	struct zio_device	*zdev_owner;
+	unsigned int		n_zdev_owner;
+};
+#define to_zio_trig(_kobj) container_of(_kobj, struct zio_trigger, head.kobj)
+
+int __must_check zio_register_trig(struct zio_trigger_type *ztrig,
+				   const char *name);
+void zio_unregister_trig(struct zio_trigger_type *trig);
+
+struct zio_ti {
+	struct zio_obj_head	head;
+	struct list_head	list;		/* instance list */
+	struct zio_cset		*cset;
+
+	unsigned long		flags;		/* input or output, etc */
+	struct zio_control	*current_ctrl;	/* the active one */
+	/* This is for software stamping */
+	struct timespec		tstamp;
+	uint64_t tstamp_extra;
+
+	/* Standard and extended attributes for this object */
+	struct zio_attribute_set		zattr_set;
+
+	const struct zio_trigger_operations	*t_op;
+	const struct file_operations		*f_op;
+
+};
+#define to_zio_ti(_kobj) container_of(_kobj, struct zio_ti, head.kobj)
+void zio_fire_trigger(struct zio_ti *ti);
+
+/*
+ * When a buffer has a complete block of data, it can send it to the trigger
+ * using push_block. The trigger can either accept it (returns 0) or not
+ * (returns -EBUSY). This because an output  trigger has only one pending
+ * data transfer. When the block is consumed, the trigger may bi->retr_block
+ * to get the next one. Buffering is in the buffer, not in the trigger.
+ *
+ * For input channels, a buffer may call pull_block. The trigger may thus
+ * fire input directly and later have a block. In the normal case, the trigger
+ * runs by itself and it will call bi->store_block when a new block
+ * happens to be ready. In this case the pull_block method here may be null.
+ *
+ * Input and output in the device is almost always asynchronous, so when
+ * the data has been transferred for the cset, the device calls back the
+ * trigger. For output, data_done frees the blocks and prepares new
+ * blocks if possible; for input, data_done pushes material to the buffers.
+ *
+ * Then, a trigger instance is configured either by sysfs (and this means
+ * the conf_set callback runs and the instance is notified) or by writing
+ * a whole control to the control device. In this case the config method
+ * is called by the write method.
+ */
+struct zio_trigger_operations {
+	int			(*push_block)(struct zio_ti *ti,
+					      struct zio_channel *chan,
+					      struct zio_block *block);
+	void			(*pull_block)(struct zio_ti *ti,
+					      struct zio_channel *chan);
+
+	void			(*data_done)(struct zio_cset *cset);
+
+	int			(*config)(struct zio_ti *ti,
+					  struct zio_control *ctrl);
+
+	struct zio_ti *		(*create)(struct zio_trigger_type *trig,
+					  struct zio_cset *cset,
+					  struct zio_control *ctrl,
+					  fmode_t flags);
+	void			(*destroy)(struct zio_ti *ti);
+};
+
+void zio_generic_data_done(struct zio_cset *cest);
+
+#endif /* __ZIO_TRIGGER_H__ */
diff --git a/include/linux/zio.h b/include/linux/zio.h
new file mode 100644
index 0000000..992994b
--- /dev/null
+++ b/include/linux/zio.h
@@ -0,0 +1,244 @@
+
+/* Federico Vaga for CERN, 2011, GNU GPLv2 or later */
+#ifndef __ZIO_H__
+#define __ZIO_H__
+
+/* ZIO_VERSION: is a zio_class attribute to identify the framework version*/
+#define ZIO_MAJOR_VERSION 0
+#define ZIO_MINOR_VERSION 2
+
+#define ZIO_NAME_LEN 32 /* full name */
+
+#ifdef __KERNEL__ /* Nothing more is for user space */
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/string.h>
+
+#include <linux/zio-sysfs.h>
+
+/* These two maxima are kept low by now to test overflow situations */
+#define ZIO_CSET_MAXNUM 16
+#define ZIO_CHAN_MAXNUM 16
+
+#define ZIO_NMAX_CSET_MINORS (ZIO_CHAN_MAXNUM * 2)
+#define ZIO_NAME_OBJ 12 /* name for registered object */
+
+/* Name the data structures */
+struct zio_device; /* both type (a.k.a. driver) and instance (a.k.a. device) */
+struct zio_channel; struct zio_cset;
+struct zio_buffer_type; struct zio_bi; struct zio_block;
+struct zio_trigger_type; struct zio_ti;
+
+struct zio_device_operations;
+struct zio_buffer_operations;
+struct zio_trigger_operations;
+
+/*
+ * We use the same functions to deal with attributes, but the structures
+ * we act on may be different (dev, cset, channel). Thus, all structures
+ * begin with the type identifier, and zio_obj_head is used in container_of
+ */
+enum zio_object_type {
+	ZNONE = 0,	/* reserved for non zio object */
+	ZDEV, ZCSET, ZCHAN,
+	ZTRIG, ZTI,	/* trigger and trigger instance */
+	ZBUF, ZBI,	/* buffer and buffer instance */
+};
+
+/* zio_obj_head is for internal use only, as explained above */
+struct zio_obj_head {
+	struct kobject		kobj;
+	enum zio_object_type	zobj_type;
+	char			name[ZIO_NAME_LEN];
+};
+#define to_zio_head(_kobj) container_of(_kobj, struct zio_obj_head, kobj)
+#define to_zio_dev(_kobj) container_of(_kobj, struct zio_device, head.kobj)
+#define to_zio_cset(_kobj) container_of(_kobj, struct zio_cset, head.kobj)
+#define to_zio_chan(_kobj) container_of(_kobj, struct zio_channel, head.kobj)
+
+static inline enum zio_object_type __zio_get_object_type(struct kobject *kobj)
+{
+	return to_zio_head(kobj)->zobj_type;
+}
+
+/* Bits 0..3 are reserved for use in all objects. By now only bit 1 is used */
+enum zobj_flags {
+	ZIO_DISABLED		= 0x1,	/* 0 (default) is enabled */
+	ZIO_DIR			= 0x2,	/* 0 is input  - 1 is output*/
+	ZIO_DIR_INPUT		= 0x0,
+	ZIO_DIR_OUTPUT		= 0x2,
+};
+
+/*
+ * zio_device -- the top-level hardware description
+ */
+struct zio_device {
+	struct zio_obj_head			head;
+	struct module				*owner;
+	spinlock_t				lock; /* for all attr ops */
+	unsigned long				flags;
+	struct zio_attribute_set		zattr_set;
+	const struct zio_sys_operations		*s_op;
+	const struct zio_device_operations	*d_op;
+
+	/* The full device is an array of csets */
+	struct zio_cset			*cset;
+	unsigned int			n_cset;
+
+	/* We can state what its preferred buffer and trigger are (NULL ok) */
+	char *preferred_buffer;
+	char *preferred_trigger;
+};
+
+struct zio_device_operations {
+	int (*input_cset)(struct zio_cset *cset);
+	int (*output_cset)(struct zio_cset *cset);
+};
+
+int __must_check zio_register_dev(struct zio_device *zdev, const char *name);
+void zio_unregister_dev(struct zio_device *zio_dev);
+
+/*
+ * zio_cset -- channel set: a group of channels with the same features
+ */
+struct zio_cset {
+	struct zio_obj_head	head;
+	struct zio_device	*zdev;		/* parent zio device */
+	struct zio_buffer_type	*zbuf;		/* buffer type for bi */
+	struct zio_trigger_type *trig;		/* trigger type for ti*/
+	struct zio_ti		*ti;		/* trigger instance */
+	unsigned		ssize;		/* sample size (bytes) */
+	unsigned		index;		/* index within parent */
+	unsigned long		flags;
+	struct zio_attribute_set zattr_set;
+	struct zio_attribute_set zattr_set_chan; /* model for channel attrs */
+
+	/* The cset is an array of channels */
+	struct zio_channel	*chan;
+	unsigned int		n_chan;
+
+	int (*init)(struct zio_cset *zcset);
+	void (*exit)(struct zio_cset *zcset);
+
+	struct list_head	list_cset;	/* for cset global list */
+	dev_t			basedev;	/* base for the minors */
+	char			zbuf_name[ZIO_NAME_OBJ];
+	char			trig_name[ZIO_NAME_OBJ];
+
+	struct zio_attribute	*cset_attrs; /* FIXME: set buf, set trig */
+};
+
+/* first 4bit are reserved for zio object universal flags */
+enum zcset_flags {
+	ZCSET_TYPE		= 0x10,	/* 0 is digital - 1 is analog*/
+	ZCSET_TYPE_DIGITAL	= 0x00,
+	ZCSET_TYPE_ANALOG	= 0x10,
+	ZCSET_CHAN_ALLOC	= 0x20, /* 1 if channels are allocated by zio*/
+	ZCSET_CHAN_ALLOC_ON	= 0x20,
+	ZCSET_CHAN_ALLOC_OFF	= 0x00,
+};
+
+/*
+ * zio_channel -- an individual channel within the cset
+ */
+
+struct zio_channel {
+	struct zio_obj_head	head;
+	struct zio_cset		*cset;		/* parent cset */
+	struct zio_ti		*ti;		/* cset trigger instance */
+	struct zio_bi		*bi;		/* buffer instance */
+	unsigned int		index;		/* index within parent */
+	unsigned long		flags;
+	struct zio_attribute_set zattr_set;
+
+	struct device		*ctrl_dev;	/* control char device */
+	struct device		*data_dev;	/* data char device */
+
+	struct zio_block	*user_block;	/* being transferred w/ user */
+	struct zio_block	*active_block;	/* being managed by hardware */
+};
+
+/* first 4bit are reserved for zio object universal flags */
+enum zchan_flag_mask {
+	ZCHAN_POLAR		= 0x10,	/* 0 is positive - 1 is negative*/
+	ZCHAN_POLAR_POSITIVE	= 0x00,
+	ZCHAN_POLAR_NEGATIVE	= 0x10,
+};
+
+/* get each channel from cset */
+static inline struct zio_channel *__first_enabled_chan(struct zio_cset *cset,
+						struct zio_channel *chan)
+{
+	if (unlikely(chan - cset->chan >= cset->n_chan))
+		return NULL;
+	while (1) {
+		if (!(chan->flags & ZIO_DISABLED))
+			return chan; /* if is enabled, use this */
+		if (chan->index+1 == cset->n_chan)
+			return NULL; /* no more channels */
+		chan++;
+	}
+}
+#define cset_for_each(cset, cptr)				\
+		for (cptr = cset->chan;				\
+		     (cptr = __first_enabled_chan(cset, cptr));	\
+		     cptr++)
+
+#ifdef __ZIO_INTERNAL__
+
+/* This list is used in the core to keep track of registered objects */
+struct zio_object_list {
+	struct kobject		*kobj;	/* for sysfs folder, no attrs */
+	enum zio_object_type	zobj_type;
+	struct list_head	list;
+};
+struct zio_object_list_item {
+	struct list_head	list;
+	char			name[ZIO_NAME_OBJ]; /* object name copy*/
+	struct module		*owner;
+	struct zio_obj_head	*obj_head;
+};
+
+/* Global framework status (i.e., globals in zio-core) */
+struct zio_status {
+	/* a pointer to set up standard ktype with create */
+	struct kobject		*kobj;
+	/*
+	 * The bmask represent the minors region for zio; each bit is
+	 * a block of minors available for a single cset. When a new cset
+	 * is declared, zio look for the first available block of minors:
+	 * set 1 to the correspondent bit on bitmask to set the block
+	 * as busy
+	 */
+	DECLARE_BITMAP(cset_minors_mask, ZIO_CSET_MAXNUM);
+	struct cdev		chrdev;
+	dev_t			basedev;
+	spinlock_t		lock;
+
+	/* List of cset, used to retrieve a cset from a minor base*/
+	struct list_head	list_cset;
+
+	/* The three lists of registered devices, with owner module */
+	struct zio_object_list	all_devices;
+	struct zio_object_list	all_trigger_types;
+	struct zio_object_list	all_buffer_types;
+};
+
+extern struct zio_status zio_global_status;
+int __zio_minorbase_get(struct zio_cset *zcset);
+void __zio_minorbase_put(struct zio_cset *zcset);
+
+int __zio_register_cdev(void);
+void __zio_unregister_cdev(void);
+
+int zio_create_chan_devices(struct zio_channel *zchan);
+void zio_destroy_chan_devices(struct zio_channel *zchan);
+#endif /* INTERNAL */
+
+#endif /* __KERNEL__ */
+#endif /* __ZIO_H__ */
-- 
1.7.7.2
