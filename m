Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1DDRte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:49:34 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:54858 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1DDRtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:49:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9A050A.3060209@cam.ac.uk>
Date: Mon, 04 Apr 2011 18:51:06 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: michael.hennerich@analog.com,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [RFC PATCH 00/21] IIO: Channel registration rework, buffer chardev
 combining and rewrite of triggers as 'virtual' irq_chips.
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk> <4D99B34B.9050309@analog.com> <4D99C4D7.1010706@cam.ac.uk> <201104041649.24309.arnd@arndb.de>
In-Reply-To: <201104041649.24309.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/11 15:49, Arnd Bergmann wrote:
> On Monday 04 April 2011, Jonathan Cameron wrote:
>> On 04/04/11 13:02, Michael Hennerich wrote:
>>>> 2) Flattening together of (some) of the chardevs (buffer related ones).
>>>>    As Arnd pointed out, there is really a use case for having multiple
>>>>    watershed type events from ring buffers.  Much better to have a
>>>>    single one (be that at a controllable point).  Firstly this removes
>>>>    the need for the event escalation code.  Second, this single 'event'
>>>>    can then be indicated to user space purely using polling on the
>>>>    access chrdev.  This approach does need an additional attribute to
>>>>    tell user space what the poll succeeding indicates (tbd).
>>>>
>>>>    I haven't for now merged the ring handling with the more general
>>>>    event handling as Arnd suggested.  This is for two reasons
>>>>    1) It's much easier to debug this done in a couple of steps
>>>>    2) The approach Arnd suggested may work well, but it is rather
>>>>    different to how other bits of the kernel pass event type data
>>>>    to user space.  It's an interesting idea, but I'd rather any
>>>>    discussion of that approach was separate from the obviously
>>>>    big gains seen here.
>>>>
>>>>    Patches 4, 5, 6, 7, 17
>>>>   
>>> I appreciate the removal of the buffer event chardev. Adding support for
>>> poll is also a good thing to do.
>>> However support for a blocking read might also fit some use cases.
>> Good point. I guess blocking on any content and poll for the watershead
>> gives the best of both worlds.  The blocking read is more down to the
>> individual implementations than a core feature though - so one to do
>> after this patch set.
> 
7> You should implement both blocking and non-blocking read in the core, IMO.
> This is how pipes generally work and what the opn()/read() man pages say it
> works.
I misphrased what I said above.  The key thing here is that this is partly
core support and partly a matter of individual buffer implementations being
able to support this.  Note we are playing unconventional games with poll
as the poll will only succeed when a threshold on how much data is in the
buffer is passed (not this threshold may be 1, but usually isn't).
In some buffers we don't know if there is new data until this value is passed
or a hardware read occurs.

My feeling is we should have blocking reads block on the absense of any data not
on the threshold as we are doing with poll.  Thus not all buffers will support
blocking reads - if they don't the core should fail on the attempt to open
the character devicce.

Anyhow, all I was really suggesting is that this is postponed for now
and handled in a later patch set.  I'm far from keen to keep adding stuff
to ring_sw given I want to ditch the thing entirely!  What we have in this
series to handle poll in that buffer implementation is a pretty dirty hack.

> 
>>>> 3) Reworking the triggering infrastructure to use 'virtual' irq_chips
>>>>    This approach was suggested by Thomas Gleixner.
>>>>    Before we had explicit trigger consumer lists.  This made for a very
>>>>    clunky implementation when we considered moving things over to
>>>>    threaded interrupts.  Thomas pointed out we were reinventing the
>>>>    wheel and suggested more or less what we have here (I hope ;)
>>>>   
>>> Using threaded interrupts, greatly reduces use of additional workqueues
>>> and excessive interrupt enable and disables.
>> There is a nasty side issue here.  What do we do if we are getting triggers
>> faster than all of the consumers can work at?  Right now things tend to
>> stall.  I think we just want to gracefully stop the relevant trigger
>> if this happens.  I'm not quite sure how we can notify userspace that this
>> has happened... Perhaps POLLERR? 
> 
> I'd say use POLLERR to signal to user space that something bad has happened,
> then return the status in an ioctl().
Yup, that's what I had in mind.  Again, may be in a later patch set.  This one
is pretty unmanageable as it is!
> 
>>>>    Patches 9 and 10 are minor rearrangements of code in the one
>>>>    driver I know of where the physical interrupt line for events
>>>>    is the same as that for data ready signals (though not at the
>>>>    same time).
>>>>   
>>> I wouldn't consider this being a corner case. I know quite a few devices
>>> that trigger data availability,
>>> and other events from the same physical interrupt line, and they may do
>>> it at the same time.
>> If they do it at the same time things may get a bit nasty. Things are somewhat
>> simpler after some of the later patches, as the irq requests are entirely
>> handled in the drivers.  Thus the driver could have one interrupt handler.
>> The restriction will be that it would only be able to do nested irq calls
>> limiting us to not having a top half for anything triggered from such an
>> interrupt. This is because identifying whether we have a dataready or
>> other event will require querying the device and hence sleeping. Note
>> the sysfs trigger driver will also have this restriction (as posted yesterday).
>>
>> For devices where they share the line but cannot happen at the same time I'd
>> prefer to do what we have in the lis3l02dq and completely separate the two
>> uses of the interrupt line.
> 
> Can't you just have callback functions in the core that get called for a
> specific event, and let the device driver take care of seperating the
> sources?
> 
That's more or less what is happening currently, it's just occurring via two
separate interrupt handlers only one of which is active at a time. This was
mainly done because it allowed me to separate the rewriting of the buffer
handling entirely from that of the events.

To summarize the situation for the lis3l02dq

1) If dataready is enabled no other events are generated (hardware constraint).
2) Other events require a bus read to identify them (hence sleep). Technically
the driver can know if there is only one such event, but it still needs to
acknowledge it.

The dataready acts as an input to the irq_chip based trigger demultiplexing.
As no sleep is needed, we can do non nested irqs, thus allowing other devices
that trigger off this to have top halves.  These top halves are typically used
for flipping gpio connected 'capture now' lines. If the device doesn't have one
of these it typically only has a thread function.  Note, if you need to sleep,
to trigger a hardware capture pin then it defeats the object anyway!

Thus by the end of the set this thread contains, the event interrupt and the
dataready interrupts were treated as two separate entities that just happened
to use the same physical wire (but not at the same time).

An alternative is the following applied on top of this series (more or less,
it's on my working tree so there might be some fuzz).
I guess this is marginally cleaner so might as well go with it.  Technically
I had the events as oneshot before and they aren't any more. They didn't
actually need to be.

[PATCH] staging:iio:lis3l02dq remerge the two interrupt handlers.

Does add a small burden to both handlers, but the gain is somewhat
simpler code.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    5 +++
 drivers/staging/iio/accel/lis3l02dq_core.c |   50 +++++++++++----------------
 drivers/staging/iio/accel/lis3l02dq_ring.c |   29 +++++++---------
 3 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index e7f64bd..b0ace13 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -162,6 +162,7 @@ struct lis3l02dq_state {
 	u8				*tx;
 	u8				*rx;
 	struct mutex			buf_lock;
+	bool				trigger_on;
 };
 
 #define lis3l02dq_h_to_s(_h)				\
@@ -202,7 +203,11 @@ void lis3l02dq_unconfigure_ring(struct iio_dev *indio_dev);
 #define lis3l02dq_alloc_buf iio_kfifo_allocate
 #define lis3l02dq_register_buf_funcs iio_kfifo_register_funcs
 #endif
+irqreturn_t lis3l02dq_data_rdy_trig_poll(int irq, void *private);
+#define lis3l02dq_th lis3l02dq_data_rdy_trig_poll
+
 #else /* CONFIG_IIO_RING_BUFFER */
+#define lis3l02dq_th lis3l02dq_noring
 
 static inline void lis3l02dq_remove_trigger(struct iio_dev *indio_dev)
 {
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 46f0633..9a2f870 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -37,6 +37,11 @@
  * It's in the likely to be added comment at the top of spi.h.
  * This means that use cannot be made of spi_write etc.
  */
+/* direct copy of the irq_default_primary_handler */
+static irqreturn_t lis3l02dq_noring(int irq, void *private)
+{
+	return IRQ_WAKE_THREAD;
+}
 
 /**
  * lis3l02dq_spi_read_reg_8() - read single byte from a single register
@@ -533,19 +538,13 @@ static ssize_t lis3l02dq_read_event_config(struct iio_dev *indio_dev,
 
 int lis3l02dq_disable_all_events(struct iio_dev *indio_dev)
 {
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	int ret;
 	u8 control, val;
-	bool irqtofree;
 
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_2_ADDR,
 				       &control);
 
-	irqtofree = !!(control & LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
-
 	control &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT;
 	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_2_ADDR,
@@ -566,9 +565,6 @@ int lis3l02dq_disable_all_events(struct iio_dev *indio_dev)
 	if (ret)
 		goto error_ret;
 
-	if (irqtofree)
-		free_irq(st->us->irq, indio_dev);
-
 	ret = control;
 error_ret:
 	return ret;
@@ -578,9 +574,6 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					int event_code,
 					int state)
 {
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	int ret = 0;
 	u8 val, control;
 	u8 currentlyset;
@@ -612,18 +605,6 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 	}
 
 	if (changed) {
-		if (!(control & LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT)) {
-			ret = request_threaded_irq(st->us->irq,
-						   NULL,
-						   &lis3l02dq_event_handler,
-						   IRQF_TRIGGER_RISING |
-						   IRQF_ONESHOT,
-						   "lis3l02dq_event",
-						   indio_dev);
-			if (ret)
-				goto error_ret;
-		}
-
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 						&val);
@@ -637,10 +618,6 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					       &control);
 		if (ret)
 			goto error_ret;
-
-		/* remove interrupt handler if nothing is still on */
-		if (!(val & 0x3f))
-			free_irq(st->us->irq, indio_dev);
 	}
 
 error_ret:
@@ -725,9 +702,18 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 	}
 
 	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
-		ret = lis3l02dq_probe_trigger(st->help.indio_dev);
+		ret = request_threaded_irq(st->us->irq,
+					   &lis3l02dq_th,
+					   &lis3l02dq_event_handler,
+					   IRQF_TRIGGER_RISING,
+					   "lis3l02dq",
+					   st->help.indio_dev);
 		if (ret)
 			goto error_uninitialize_ring;
+
+		ret = lis3l02dq_probe_trigger(st->help.indio_dev);
+		if (ret)
+			goto error_free_interrupt;
 	}
 
 	/* Get the device into a sane initial state */
@@ -739,6 +725,9 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 error_remove_trigger:
 	if (st->help.indio_dev->modes & INDIO_RING_TRIGGERED)
 		lis3l02dq_remove_trigger(st->help.indio_dev);
+error_free_interrupt:
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+		free_irq(st->us->irq, st->help.indio_dev);
 error_uninitialize_ring:
 	iio_ring_buffer_unregister(st->help.indio_dev->ring);
 error_unreg_ring_funcs:
@@ -801,7 +790,8 @@ static int lis3l02dq_remove(struct spi_device *spi)
 		goto err_ret;
 
 	flush_scheduled_work();
-
+	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0)
+		free_irq(st->us->irq, indio_dev);
 	lis3l02dq_remove_trigger(indio_dev);
 	iio_ring_buffer_unregister(indio_dev->ring);
 	lis3l02dq_unconfigure_ring(indio_dev);
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index a611778..de2c602 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -31,11 +31,17 @@ static inline u16 combine_8_to_16(u8 lower, u8 upper)
 /**
  * lis3l02dq_data_rdy_trig_poll() the event handler for the data rdy trig
  **/
-static irqreturn_t lis3l02dq_data_rdy_trig_poll(int irq, void *private)
+irqreturn_t lis3l02dq_data_rdy_trig_poll(int irq, void *private)
 {
-	iio_trigger_poll(private, iio_get_time_ns());
+	struct iio_dev *indio_dev = private;
+	struct iio_sw_ring_helper_state *h =  iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	return IRQ_HANDLED;
+	if (st->trigger_on) {
+		iio_trigger_poll(st->trig, iio_get_time_ns());
+		return IRQ_HANDLED;
+	} else
+		return IRQ_WAKE_THREAD;
 }
 
 /**
@@ -203,8 +209,7 @@ __lis3l02dq_write_data_ready_config(struct device *dev, bool state)
 						&valold);
 		if (ret)
 			goto error_ret;
-
-		free_irq(st->us->irq, st->trig);
+		st->trigger_on = false;
 /* Enable requested */
 	} else if (state && !currentlyset) {
 		/* if not set, enable requested */
@@ -215,22 +220,13 @@ __lis3l02dq_write_data_ready_config(struct device *dev, bool state)
 
 		valold = ret |
 			LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
-		ret = request_irq(st->us->irq,
-				  lis3l02dq_data_rdy_trig_poll,
-				  IRQF_TRIGGER_RISING, "lis3l02dq_datardy",
-				  st->trig);
-		if (ret)
-			goto error_ret;
-
+		st->trigger_on = true;
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
 						&valold);
-		if (ret) {
-			free_irq(st->us->irq, st->trig);
+		if (ret)
 			goto error_ret;
-		}
 	}
 
 	return 0;
 
-- 
1.7.3.4

