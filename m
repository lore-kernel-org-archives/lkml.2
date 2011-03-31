Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1CaOz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:55:57 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57419 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063Ab1CaOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 11/21] staging:iio: Remove legacy event handling.
Date: Thu, 31 Mar 2011 15:54:05 +0100
Message-Id: <1301583255-28468-12-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This requires all drivers to change slightly

- need to check what from the lis3l02dq should be in earlier patches!
---
 drivers/staging/iio/accel/lis3l02dq_core.c |   33 +---
 drivers/staging/iio/chrdev.h               |   21 ---
 drivers/staging/iio/iio.h                  |   90 +----------
 drivers/staging/iio/industrialio-core.c    |  250 +++-------------------------
 drivers/staging/iio/sysfs.h                |  129 --------------
 5 files changed, 38 insertions(+), 485 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 96cdb82..70b1ae0 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -415,10 +415,9 @@ static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
 
 static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("280 560 1120 4480");
 
-static irqreturn_t lis3l02dq_event_handler(int irq, void *_int_info)
+static irqreturn_t lis3l02dq_event_handler(int irq, void *private)
 {
-	struct iio_interrupt *int_info = _int_info;
-	struct iio_dev *indio_dev = int_info->dev_info;
+	struct iio_dev *indio_dev = private;
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
@@ -442,13 +441,13 @@ static irqreturn_t lis3l02dq_event_handler(int irq, void *_int_info)
 static struct iio_chan_spec lis3l02dq_channels[] = {
 	IIO_CHAN_EV(IIO_ACCEL, 'x', LIS3L02DQ_INFO_MASK,
 		    0, 0, IIO_ST('s', 12, 16, 0),
-		    LIS3L02DQ_EVENT_MASK, NULL),
+		    LIS3L02DQ_EVENT_MASK),
 	IIO_CHAN_EV(IIO_ACCEL, 'y', LIS3L02DQ_INFO_MASK,
 		    1, 1, IIO_ST('s', 12, 16, 0),
-		    LIS3L02DQ_EVENT_MASK, NULL),
+		    LIS3L02DQ_EVENT_MASK),
 	IIO_CHAN_EV(IIO_ACCEL, 'z', LIS3L02DQ_INFO_MASK,
 		    2, 2, IIO_ST('s', 12, 16, 0),
-		    LIS3L02DQ_EVENT_MASK, NULL),
+		    LIS3L02DQ_EVENT_MASK),
 	IIO_CHAN_SOFT_TIMESTAMP(3)
 };
 
@@ -507,7 +506,7 @@ int lis3l02dq_disable_all_events(struct iio_dev *indio_dev)
 		goto error_ret;
 
 	if (irqtofree)
-		free_irq(st->us->irq, indio_dev->interrupts[0]);
+		free_irq(st->us->irq, indio_dev);
 
 	ret = control;
 error_ret:
@@ -516,7 +515,6 @@ error_ret:
 
 static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					int event_code,
-					struct iio_event_handler_list *list_el,
 					int state)
 {
 	struct iio_sw_ring_helper_state *h
@@ -558,7 +556,7 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					  &lis3l02dq_event_handler,
 					  IRQF_TRIGGER_RISING,
 					  "lis3l02dq_event",
-					  indio_dev->interrupts[0]);
+					  indio_dev);
 			if (ret)
 				goto error_ret;
 		}
@@ -579,7 +577,7 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 
 		/* remove interrupt handler if nothing is still on */
 		if (!(val & 0x3f))
-			free_irq(st->us->irq, indio_dev->interrupts[0]);
+			free_irq(st->us->irq, indio_dev);
 	}
 
 error_ret:
@@ -743,16 +741,9 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 
 	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
 		st->inter = 0;
-		ret = iio_register_interrupt_line(spi->irq,
-						  st->help.indio_dev,
-						  0,
-						  IRQF_TRIGGER_RISING,
-						  "lis3l02dq");
-		if (ret)
-			goto error_uninitialize_ring;
 		ret = lis3l02dq_probe_trigger(st->help.indio_dev);
 		if (ret)
-			goto error_unregister_line;
+			goto error_uninitialize_ring;
 	}
 
 	/* Get the device into a sane initial state */
@@ -764,9 +755,6 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 error_remove_trigger:
 	if (st->help.indio_dev->modes & INDIO_RING_TRIGGERED)
 		lis3l02dq_remove_trigger(st->help.indio_dev);
-error_unregister_line:
-	if (st->help.indio_dev->modes & INDIO_RING_TRIGGERED)
-		iio_unregister_interrupt_line(st->help.indio_dev, 0);
 error_uninitialize_ring:
 	iio_ring_buffer_unregister(st->help.indio_dev->ring);
 error_unreg_ring_funcs:
@@ -831,9 +819,6 @@ static int lis3l02dq_remove(struct spi_device *spi)
 	flush_scheduled_work();
 
 	lis3l02dq_remove_trigger(indio_dev);
-	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
-		iio_unregister_interrupt_line(indio_dev, 0);
-
 	iio_ring_buffer_unregister(indio_dev->ring);
 	lis3l02dq_unconfigure_ring(indio_dev);
 	iio_device_unregister(indio_dev);
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index c1e86a9..8e76dd4 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -78,28 +78,7 @@ struct iio_event_interface {
 	void					*private;
 	char					_name[35];
 	char					_attrname[20];
-
-	struct list_head event_attr_list;
 	struct list_head dev_attr_list;
 };
 
-/**
- * struct iio_event_handler_list - element in list of handlers for events
- * @list:		list header
- * @refcount:		as the handler may be shared between multiple device
- *			side events, reference counting ensures clean removal
- * @exist_lock:		prevents race conditions related to refcount useage.
- * @handler:		event handler function - called on event if this
- *			event_handler is enabled.
- *
- * Each device has one list of these per interrupt line.
- **/
-struct iio_event_handler_list {
-	struct list_head	list;
-	int			refcount;
-	struct mutex		exist_lock;
-	int (*handler)(struct iio_dev *dev_info, int index, s64 timestamp,
-		       int no_test);
-};
-
 #endif
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 341724f..fb6caae 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -74,7 +74,6 @@ enum iio_chan_info_enum {
  * @info_mask:	what information is to be exported about this channel.
  *		This includes calibbias, scale etc.
  * @event_mask:	what events can this channel produce.
- * @shared_handler: single handler for the events registered.
  */
 struct iio_chan_spec {
 	enum iio_chan_type type;
@@ -90,9 +89,6 @@ struct iio_chan_spec {
 	} scan_type;
 	const long info_mask;
 	const long event_mask;
-	/* TODO: investigate pushing shared event handling out to
-	 * the drivers */
-	struct iio_event_handler_list *shared_handler;
 };
 /* Meant for internal use only */
 void __iio_device_attr_deinit(struct device_attribute *dev_attr);
@@ -116,14 +112,13 @@ int __iio_device_attr_init(struct device_attribute *dev_attr,
 			.scan_index = _si, .scan_type = _stype }
 
 #define IIO_CHAN_EV(_type, _chan, _inf_mask, _address, _si,		\
-		    _stype, _event_mask, _shared_h)			\
+		    _stype, _event_mask)				\
 	{ .type = _type,						\
 			.channel = _chan,				\
 			.info_mask = _inf_mask,				\
 			.address = _address,				\
 			.scan_index = _si, .scan_type = _stype,		\
-			.event_mask = _event_mask,			\
-			.shared_handler = _shared_h }
+			.event_mask = _event_mask }
 
 #define IIO_CHAN_COMPOUND(_type, _chan1, _chan2, _inf_mask,		\
 			  _address, _si, _stype)			\
@@ -133,14 +128,13 @@ int __iio_device_attr_init(struct device_attribute *dev_attr,
 			.scan_index = _si, .scan_type = _stype }
 
 #define IIO_CHAN_COMPOUND_EV(_type, _chan1, _chan2, _inf_mask,		\
-			     _address, _si, _stype, _event_mask, _shared_h) \
+			     _address, _si, _stype, _event_mask)	\
 	{ .type = _type,						\
 			.channel = _chan1, .channel2 = _chan2,		\
 			.info_mask = _inf_mask,				\
 			.address = _address,				\
 			.scan_index = _si, .scan_type = _stype,		\
-			.event_mask = _event_mask,			\
-			.shared_handler = _shared_h}
+			.event_mask = _event_mask }
 
 #define IIO_CHAN_SOFT_TIMESTAMP(_si)					\
 	{ .type = IIO_TIMESTAMP, .channel = -1,				\
@@ -175,26 +169,6 @@ static inline s64 iio_get_time_ns(void)
 	return timespec_to_ns(&ts);
 }
 
-/**
- * iio_add_event_to_list() - Wraps adding to event lists
- * @el:		the list element of the event to be handled.
- * @head:	the list associated with the event handler being used.
- *
- * Does reference counting to allow shared handlers.
- **/
-void iio_add_event_to_list(struct iio_event_handler_list *el,
-			   struct list_head *head);
-
-/**
- * iio_remove_event_from_list() - Wraps removing from event list
- * @el:		element to be removed
- * @head:	associate list head for the interrupt handler.
- *
- * Does reference counting to allow shared handlers.
- **/
-void iio_remove_event_from_list(struct iio_event_handler_list *el,
-				struct list_head *head);
-
 /* Device operating modes */
 #define INDIO_DIRECT_MODE		0x01
 #define INDIO_RING_TRIGGERED		0x02
@@ -217,7 +191,6 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
  * @driver_module:	[DRIVER] module structure used to ensure correct
  *			ownership of chrdevs etc
  * @num_interrupt_lines:[DRIVER] number of physical interrupt lines from device
- * @interrupts:		[INTERN] interrupt line specific event lists etc
  * @event_attrs:	[DRIVER] event control attributes
  * @event_conf_attrs:	[DRIVER] event configuration attributes
  * @event_interfaces:	[INTERN] event chrdevs associated with interrupt lines
@@ -238,7 +211,6 @@ struct iio_dev {
 	struct module			*driver_module;
 
 	int				num_interrupt_lines;
-	struct iio_interrupt		**interrupts;
 	struct attribute_group		*event_attrs;
 	struct attribute_group		*event_conf_attrs;
 
@@ -266,7 +238,6 @@ struct iio_dev {
 
 	int (*write_event_config)(struct iio_dev *indio_dev,
 				  int event_code,
-				  struct iio_event_handler_list *listel,
 				  int state);
 
 	int (*read_event_value)(struct iio_dev *indio_dev,
@@ -290,49 +261,6 @@ int iio_device_register(struct iio_dev *dev_info);
 void iio_device_unregister(struct iio_dev *dev_info);
 
 /**
- * struct iio_interrupt - wrapper used to allow easy handling of multiple
- *			physical interrupt lines
- * @dev_info:		the iio device for which the is an interrupt line
- * @line_number:	associated line number
- * @id:			ida allocated unique id number
- * @irq:		associate interrupt number
- * @ev_list:		event handler list for associated events
- * @ev_list_lock:	ensure only one access to list at a time
- **/
-struct iio_interrupt {
-	struct iio_dev			*dev_info;
-	int				line_number;
-	int				id;
-	int				irq;
-	struct list_head		ev_list;
-	spinlock_t			ev_list_lock;
-};
-
-#define to_iio_interrupt(i) container_of(i, struct iio_interrupt, ev_list)
-
-/**
- * iio_register_interrupt_line() - Tell IIO about interrupt lines
- *
- * @irq:		Typically provided via platform data
- * @dev_info:		IIO device info structure for device
- * @line_number:	Which interrupt line of the device is this?
- * @type:		Interrupt type (e.g. edge triggered etc)
- * @name:		Identifying name.
- **/
-int iio_register_interrupt_line(unsigned int			irq,
-				struct iio_dev			*dev_info,
-				int				line_number,
-				unsigned long			type,
-				const char			*name);
-
-void iio_unregister_interrupt_line(struct iio_dev *dev_info,
-				   int line_number);
-
-
-/* temporarily exported to allow moving of interrupt requesting into drivers */
-irqreturn_t iio_interrupt_handler(int irq, void *_int_info);
-
-/**
  * iio_push_event() - try to add event to the list for userspace reading
  * @dev_info:		IIO device structure
  * @ev_line:		Which event line (hardware interrupt)
@@ -345,16 +273,6 @@ int iio_push_event(struct iio_dev *dev_info,
 		  s64 timestamp);
 
 /**
- * __iio_push_event() - tries to add an event to the list associated with a chrdev
- * @ev_int:		the event interface to which we are pushing the event
- * @ev_code:		the outgoing event code
- * @timestamp:		timestamp of the event
- **/
-int __iio_push_event(struct iio_event_interface *ev_int,
-		     int ev_code,
-		     s64 timestamp);
-
-/**
  * iio_setup_ev_int() - configure an event interface (chrdev)
  * @name:		name used for resulting sysfs directory etc.
  * @ev_int:		interface we are configuring
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 7cee697..0473f55 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -66,16 +66,13 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_CALIBBIAS_SHARED/2] = "calibbias",
 };
 
-/* Used both in the interrupt line put events and the ring buffer ones */
-
-/* Note that in it's current form someone has to be listening before events
- * are queued. Hence a client MUST open the chrdev before the ring buffer is
- * switched on.
- */
-int __iio_push_event(struct iio_event_interface *ev_int,
-		     int ev_code,
-		     s64 timestamp)
+int iio_push_event(struct iio_dev *dev_info,
+		   int ev_line,
+		   int ev_code,
+		   s64 timestamp)
 {
+	struct iio_event_interface *ev_int
+		= &dev_info->event_interfaces[ev_line];
 	struct iio_detected_event_list *ev;
 	int ret = 0;
 
@@ -105,76 +102,8 @@ int __iio_push_event(struct iio_event_interface *ev_int,
 error_ret:
 	return ret;
 }
-EXPORT_SYMBOL(__iio_push_event);
-
-int iio_push_event(struct iio_dev *dev_info,
-		   int ev_line,
-		   int ev_code,
-		   s64 timestamp)
-{
-	return __iio_push_event(&dev_info->event_interfaces[ev_line],
-				ev_code, timestamp);
-}
 EXPORT_SYMBOL(iio_push_event);
 
-/* Generic interrupt line interrupt handler */
-irqreturn_t iio_interrupt_handler(int irq, void *_int_info)
-{
-	struct iio_interrupt *int_info = _int_info;
-	struct iio_dev *dev_info = int_info->dev_info;
-	struct iio_event_handler_list *p;
-	s64 time_ns;
-	unsigned long flags;
-
-	spin_lock_irqsave(&int_info->ev_list_lock, flags);
-	if (list_empty(&int_info->ev_list)) {
-		spin_unlock_irqrestore(&int_info->ev_list_lock, flags);
-		return IRQ_NONE;
-	}
-
-	time_ns = iio_get_time_ns();
-	list_for_each_entry(p, &int_info->ev_list, list) {
-		disable_irq_nosync(irq);
-		p->handler(dev_info, 1, time_ns, !(p->refcount > 1));
-	}
-	spin_unlock_irqrestore(&int_info->ev_list_lock, flags);
-
-	return IRQ_HANDLED;
-}
-EXPORT_SYMBOL(iio_interrupt_handler);
-
-static struct iio_interrupt *iio_allocate_interrupt(void)
-{
-	struct iio_interrupt *i = kmalloc(sizeof *i, GFP_KERNEL);
-	if (i) {
-		spin_lock_init(&i->ev_list_lock);
-		INIT_LIST_HEAD(&i->ev_list);
-	}
-	return i;
-}
-
-/* Confirming the validity of supplied irq is left to drivers.*/
-int iio_register_interrupt_line(unsigned int irq,
-				struct iio_dev *dev_info,
-				int line_number,
-				unsigned long type,
-				const char *name)
-{
-	int ret = 0;
-
-	dev_info->interrupts[line_number] = iio_allocate_interrupt();
-	if (dev_info->interrupts[line_number] == NULL) {
-		ret = -ENOMEM;
-		goto error_ret;
-	}
-	dev_info->interrupts[line_number]->line_number = line_number;
-	dev_info->interrupts[line_number]->irq = irq;
-	dev_info->interrupts[line_number]->dev_info = dev_info;
-
-error_ret:
-	return ret;
-}
-EXPORT_SYMBOL(iio_register_interrupt_line);
 
 /* This turns up an awful lot */
 ssize_t iio_read_const_attr(struct device *dev,
@@ -185,52 +114,6 @@ ssize_t iio_read_const_attr(struct device *dev,
 }
 EXPORT_SYMBOL(iio_read_const_attr);
 
-/* Before this runs the interrupt generator must have been disabled */
-void iio_unregister_interrupt_line(struct iio_dev *dev_info, int line_number)
-{
-	/* make sure the interrupt handlers are all done */
-	flush_scheduled_work();
-	kfree(dev_info->interrupts[line_number]);
-}
-EXPORT_SYMBOL(iio_unregister_interrupt_line);
-
-/* Reference counted add and remove */
-void iio_add_event_to_list(struct iio_event_handler_list *el,
-			  struct list_head *head)
-{
-	unsigned long flags;
-	struct iio_interrupt *inter = to_iio_interrupt(head);
-
-	/* take mutex to protect this element */
-	mutex_lock(&el->exist_lock);
-	if (el->refcount == 0) {
-		/* Take the event list spin lock */
-		spin_lock_irqsave(&inter->ev_list_lock, flags);
-		list_add(&el->list, head);
-		spin_unlock_irqrestore(&inter->ev_list_lock, flags);
-	}
-	el->refcount++;
-	mutex_unlock(&el->exist_lock);
-}
-EXPORT_SYMBOL(iio_add_event_to_list);
-
-void iio_remove_event_from_list(struct iio_event_handler_list *el,
-			       struct list_head *head)
-{
-	unsigned long flags;
-	struct iio_interrupt *inter = to_iio_interrupt(head);
-
-	mutex_lock(&el->exist_lock);
-	el->refcount--;
-	if (el->refcount == 0) {
-		/* Take the event list spin lock */
-		spin_lock_irqsave(&inter->ev_list_lock, flags);
-		list_del_init(&el->list);
-		spin_unlock_irqrestore(&inter->ev_list_lock, flags);
-	}
-	mutex_unlock(&el->exist_lock);
-}
-EXPORT_SYMBOL(iio_remove_event_from_list);
 
 static ssize_t iio_event_chrdev_read(struct file *filep,
 				     char __user *buf,
@@ -798,15 +681,14 @@ static ssize_t iio_ev_state_store(struct device *dev,
 				  size_t len)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
 	int ret;
 	unsigned long val;
 	ret = strict_strtoul(buf, 10, &val);
 	if (ret || val < 0 || val > 1)
 		return -EINVAL;
 
-	ret = indio_dev->write_event_config(indio_dev, this_attr->mask,
-					    this_attr->listel,
+	ret = indio_dev->write_event_config(indio_dev, this_attr->address,
 					    val);
 	return (ret < 0) ? ret : len;
 }
@@ -816,8 +698,8 @@ static ssize_t iio_ev_state_show(struct device *dev,
 				 char *buf)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
-	int val = indio_dev->read_event_config(indio_dev, this_attr->mask);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	int val = indio_dev->read_event_config(indio_dev, this_attr->address);
 
 	if (val < 0)
 		return val;
@@ -863,67 +745,6 @@ static ssize_t iio_ev_value_store(struct device *dev,
 	return len;
 }
 
-static int __iio_add_chan_event_attr(const char *postfix,
-				     const char *group,
-				     struct iio_chan_spec *chan,
-				     unsigned int mask,
-				     struct device *dev,
-				     struct list_head *attr_list)
-{
-	char *name_format;
-	int ret;
-	struct iio_event_attr *iio_ev_attr;
-
-	iio_ev_attr = kzalloc(sizeof *iio_ev_attr, GFP_KERNEL);
-	if (iio_ev_attr == NULL) {
-		ret = -ENOMEM;
-		goto error_ret;
-	}
-
-	sysfs_attr_init(&iio_ev_attr->dev_attr.attr);
-
-	name_format = kasprintf(GFP_KERNEL, "%s_%s",
-				iio_chan_type_name_spec[chan->type],
-				postfix);
-	if (name_format == NULL) {
-		ret = -ENOMEM;
-		goto error_free_attr;
-	}
-
-	iio_ev_attr->dev_attr.attr.name = kasprintf(GFP_KERNEL,
-						    name_format,
-						    chan->channel,
-						    chan->channel2);
-	if (iio_ev_attr->dev_attr.attr.name == NULL) {
-		ret = -ENOMEM;
-		goto error_free_name_format;
-	}
-
-	iio_ev_attr->dev_attr.attr.mode = S_IRUGO | S_IWUSR;
-	iio_ev_attr->dev_attr.show = &iio_ev_state_show;
-	iio_ev_attr->dev_attr.store = &iio_ev_state_store;
-	iio_ev_attr->mask = mask;
-	iio_ev_attr->listel = chan->shared_handler;
-	ret = sysfs_add_file_to_group(&dev->kobj,
-				      &iio_ev_attr->dev_attr.attr,
-				      group);
-	if (ret < 0)
-		goto error_free_name;
-	list_add(&iio_ev_attr->l, attr_list);
-	kfree(name_format);
-	return 0;
-
-error_free_name:
-	kfree(iio_ev_attr->dev_attr.attr.name);
-error_free_name_format:
-	kfree(name_format);
-error_free_attr:
-	kfree(iio_ev_attr);
-error_ret:
-	return ret;
-}
-
-
 static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
 				      struct iio_chan_spec *chan)
 {
@@ -957,18 +778,21 @@ static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
 		default:
 			printk("currently unhandled\n");
 		}
-		ret = __iio_add_chan_event_attr(postfix,
-						NULL,
-						chan,
-						mask,
-						/*HACK. - limits us to one
-						  event interface - fix by
-						  extending the bitmask - but
-						  how far*/
-						&dev_info->event_interfaces[0]
-						.dev,
-						&dev_info->event_interfaces[0].
-						event_attr_list);
+		ret = __iio_add_chan_devattr(postfix,
+					     NULL,
+					     chan,
+					     &iio_ev_state_show,
+					     iio_ev_state_store,
+					     mask,
+					     /*HACK. - limits us to one
+					       event interface - fix by
+					       extending the bitmask - but
+					       how far*/
+					     0,
+					     &dev_info->event_interfaces[0]
+					     .dev,
+					     &dev_info->event_interfaces[0].
+					     dev_attr_list);
 		kfree(postfix);
 		if (ret)
 			goto error_ret;
@@ -1004,7 +828,6 @@ static inline void __iio_remove_all_event_sysfs(struct iio_dev *dev_info,
 						int num)
 {
 	struct iio_dev_attr *p, *n;
-	struct iio_event_attr *q, *m;
 	list_for_each_entry_safe(p, n,
 				 &dev_info->event_interfaces[num].
 				 dev_attr_list, l) {
@@ -1015,23 +838,12 @@ static inline void __iio_remove_all_event_sysfs(struct iio_dev *dev_info,
 		kfree(p->dev_attr.attr.name);
 		kfree(p);
 	}
-	list_for_each_entry_safe(q, m,
-				 &dev_info->event_interfaces[num].
-				 event_attr_list, l) {
-		sysfs_remove_file_from_group(&dev_info
-					     ->event_interfaces[num].dev.kobj,
-					     &q->dev_attr.attr,
-					     groupname);
-		kfree(q->dev_attr.attr.name);
-		kfree(q);
-	}
 }
 
 static inline int __iio_add_event_config_attrs(struct iio_dev *dev_info, int i)
 {
 	int j;
 	int ret;
-	/*p for adding, q for removing */
 	struct attribute **attrp, **attrq;
 
 	if (dev_info->event_conf_attrs && dev_info->event_conf_attrs[i].attrs) {
@@ -1047,7 +859,6 @@ static inline int __iio_add_event_config_attrs(struct iio_dev *dev_info, int i)
 			attrp++;
 		}
 	}
-	INIT_LIST_HEAD(&dev_info->event_interfaces[0].event_attr_list);
 	INIT_LIST_HEAD(&dev_info->event_interfaces[0].dev_attr_list);
 	/* Dynically created from the channels array */
 	if (dev_info->channels) {
@@ -1118,14 +929,6 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 		goto error_ret;
 	}
 
-	dev_info->interrupts = kzalloc(sizeof(struct iio_interrupt *)
-				       *dev_info->num_interrupt_lines,
-				       GFP_KERNEL);
-	if (dev_info->interrupts == NULL) {
-		ret = -ENOMEM;
-		goto error_free_event_interfaces;
-	}
-
 	for (i = 0; i < dev_info->num_interrupt_lines; i++) {
 		dev_info->event_interfaces[i].owner = dev_info->driver_module;
 
@@ -1183,8 +986,6 @@ error_remove_sysfs_interfaces:
 error_free_setup_ev_ints:
 	for (j = 0; j < i; j++)
 		iio_free_ev_int(&dev_info->event_interfaces[j]);
-	kfree(dev_info->interrupts);
-error_free_event_interfaces:
 	kfree(dev_info->event_interfaces);
 error_ret:
 
@@ -1207,7 +1008,6 @@ static void iio_device_unregister_eventset(struct iio_dev *dev_info)
 
 	for (i = 0; i < dev_info->num_interrupt_lines; i++)
 		iio_free_ev_int(&dev_info->event_interfaces[i]);
-	kfree(dev_info->interrupts);
 	kfree(dev_info->event_interfaces);
 }
 
diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
index 1a2e46e..bec000d 100644
--- a/drivers/staging/iio/sysfs.h
+++ b/drivers/staging/iio/sysfs.h
@@ -15,22 +15,6 @@
 #include "iio.h"
 
 /**
- * struct iio_event_attr - event control attribute
- * @dev_attr:	underlying device attribute
- * @mask:	mask for the event when detecting
- * @listel:	list header to allow addition to list of event handlers
-*/
-struct iio_event_attr {
-	struct device_attribute dev_attr;
-	int mask;
-	struct iio_event_handler_list *listel;
-	struct list_head l;
-};
-
-#define to_iio_event_attr(_dev_attr) \
-	container_of(_dev_attr, struct iio_event_attr, dev_attr)
-
-/**
  * struct iio_dev_attr - iio specific device attribute
  * @dev_attr:	underlying device attribute
  * @address:	associated register address
@@ -184,85 +168,6 @@ struct iio_const_attr {
 #define IIO_CONST_ATTR_TEMP_SCALE(_string)		\
 	IIO_CONST_ATTR(temp_scale, _string)
 
-/**
- * IIO_EVENT_SH - generic shared event handler
- * @_name: event name
- * @_handler: handler function to be called
- *
- * This is used in cases where more than one event may result from a single
- * handler.  Often the case that some alarm register must be read and multiple
- * alarms may have been triggered.
- **/
-#define IIO_EVENT_SH(_name, _handler)					\
-	static struct iio_event_handler_list				\
-	iio_event_##_name = {						\
-		.handler = _handler,					\
-		.refcount = 0,						\
-		.exist_lock = __MUTEX_INITIALIZER(iio_event_##_name	\
-						  .exist_lock),		\
-		.list = {						\
-			.next = &iio_event_##_name.list,		\
-			.prev = &iio_event_##_name.list,		\
-		},							\
-	};
-
-/**
- * IIO_EVENT_ATTR_SH - generic shared event attribute
- * @_name: event name
- * @_ev_list: event handler list
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- *
- * An attribute with an associated IIO_EVENT_SH
- **/
-#define IIO_EVENT_ATTR_SH(_name, _ev_list, _show, _store, _mask)	\
-	static struct iio_event_attr					\
-	iio_event_attr_##_name						\
-	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR,		\
-			       _show, _store),				\
-	    .mask = _mask,						\
-	    .listel = &_ev_list };
-
-#define IIO_EVENT_ATTR_NAMED_SH(_vname, _name, _ev_list, _show, _store, _mask) \
-	static struct iio_event_attr					\
-	iio_event_attr_##_vname						\
-	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR,		\
-			       _show, _store),				\
-	    .mask = _mask,						\
-	    .listel = &_ev_list };
-
-/**
- * IIO_EVENT_ATTR - non-shared event attribute
- * @_name: event name
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- * @_handler: handler function to be called
- **/
-#define IIO_EVENT_ATTR(_name, _show, _store, _mask, _handler)		\
-	IIO_EVENT_SH(_name, _handler);					\
-	static struct							\
-	iio_event_attr							\
-	iio_event_attr_##_name						\
-	= { .dev_attr = __ATTR(_name, S_IRUGO | S_IWUSR,		\
-			       _show, _store),				\
-	    .mask = _mask,						\
-	    .listel = &iio_event_##_name };				\
-
-/**
- * IIO_EVENT_ATTR_DATA_RDY - event driven by data ready signal
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- * @_handler: handler function to be called
- *
- * Not typically implemented in devices where full triggering support
- * has been implemented.
- **/
-#define IIO_EVENT_ATTR_DATA_RDY(_show, _store, _mask, _handler) \
-	IIO_EVENT_ATTR(data_rdy, _show, _store, _mask, _handler)
-
 /* must match our channel defs */
 #define IIO_EV_CLASS_IN			IIO_IN
 #define IIO_EV_CLASS_ACCEL		IIO_ACCEL
@@ -320,38 +225,4 @@ struct iio_const_attr {
 
 #define IIO_EVENT_CODE_EXTRACT_MODIFIER(mask) ((mask >> 13) & 0x7)
 
-/**
- * IIO_EVENT_ATTR_RING_50_FULL - ring buffer event to indicate 50% full
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- * @_handler: handler function to be called
- **/
-#define IIO_EVENT_ATTR_RING_50_FULL(_show, _store, _mask, _handler)	\
-	IIO_EVENT_ATTR(ring_50_full, _show, _store, _mask, _handler)
-
-/**
- * IIO_EVENT_ATTR_RING_50_FULL_SH - shared ring event to indicate 50% full
- * @_evlist: event handler list
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- **/
-#define IIO_EVENT_ATTR_RING_50_FULL_SH(_evlist, _show, _store, _mask)	\
-	IIO_EVENT_ATTR_SH(ring_50_full, _evlist, _show, _store, _mask)
-
-/**
- * IIO_EVENT_ATTR_RING_75_FULL_SH - shared ring event to indicate 75% full
- * @_evlist: event handler list
- * @_show: output method for the attribute
- * @_store: input method for the attribute
- * @_mask: mask used when detecting the event
- **/
-#define IIO_EVENT_ATTR_RING_75_FULL_SH(_evlist, _show, _store, _mask)	\
-	IIO_EVENT_ATTR_SH(ring_75_full, _evlist, _show, _store, _mask)
-
-#define IIO_EVENT_CODE_RING_50_FULL	IIO_BUFFER_EVENT_CODE(0)
-#define IIO_EVENT_CODE_RING_75_FULL	IIO_BUFFER_EVENT_CODE(1)
-#define IIO_EVENT_CODE_RING_100_FULL	IIO_BUFFER_EVENT_CODE(2)
-
 #endif /* _INDUSTRIAL_IO_SYSFS_H_ */
-- 
1.7.3.4

