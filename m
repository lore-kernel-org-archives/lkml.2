Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0IONnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:43:04 -0400
Received: from relay03-haj2.antispameurope.com ([83.246.65.53]:45699 "EHLO
	relay03-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab0IONnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:43:01 -0400
Message-ID: <4C90CD36.6020602@iis.fraunhofer.de>
Date: Wed, 15 Sep 2010 15:42:14 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add sc16is7x2 driver
References: <4C80F419.5070601@iis.fraunhofer.de>	<20100913172544.a81e8422.akpm@linux-foundation.org>	<4C8F7381.50300@iis.fraunhofer.de> <20100914072746.4dad4e34@bike.lwn.net>
In-Reply-To: <20100914072746.4dad4e34@bike.lwn.net>
Content-Type: multipart/mixed;
 boundary="------------020507020101050802050307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020507020101050802050307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OK, here is an implementation with threaded irqs. Still not sure about 
the locking stuff. Maybe someone experienced with uart drivers can help?

Am 14.09.2010 15:27, schrieb Jonathan Corbet:
> On Tue, 14 Sep 2010 15:07:13 +0200
> Manuel Stahl<manuel.stahl@iis.fraunhofer.de>  wrote:
>
>> Where can I find some example how to use the new threaded irqs?
>
> Basic description here: http://lwn.net/Articles/302043/
>
> If you grep request_threaded_irq() in drivers/, you'll certainly find
> some real-world examples.
>
> jon



--------------020507020101050802050307
Content-Type: text/plain;
 name="sc16is7x2-use-threaded-irqs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="sc16is7x2-use-threaded-irqs.patch"

sc16is7x2: use threaded irqs

Signed-off-by: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
---
 drivers/serial/sc16is7x2.c |  115 +++++++++++++++----------------------------
 1 files changed, 40 insertions(+), 75 deletions(-)

diff --git a/drivers/serial/sc16is7x2.c b/drivers/serial/sc16is7x2.c
index a9bcd03..04cb1ad 100644
--- a/drivers/serial/sc16is7x2.c
+++ b/drivers/serial/sc16is7x2.c
@@ -92,28 +92,13 @@ struct sc16is7x2_channel {
 struct sc16is7x2_chip {
 	struct spi_device *spi;
 	struct gpio_chip gpio;
-	struct mutex	 lock;
 	struct sc16is7x2_channel channel[2];
 
-	/* for handling irqs: need workqueue since we do spi_sync */
-	struct workqueue_struct *workqueue;
-	struct work_struct work;
-	/* set to 1 to make the workhandler exit as soon as possible */
-	int force_end_work;
-	/* need to know we are suspending to avoid deadlock on workqueue */
-	int suspending;
-
+	/* set to true to make the work thread exit as soon as possible */
+	bool force_end_work;
 	struct spi_message fifo_message;
 
-#define UART_BUG_TXEN	BIT(1)	/* UART has buggy TX IIR status */
-#define UART_BUG_NOMSR	BIT(2)	/* UART has buggy MSR status bits (Au1x00) */
-#define UART_BUG_THRE	BIT(3)	/* UART has buggy THRE reassertion */
-	u16		bugs;		/* port bugs */
-
-#define LSR_SAVE_FLAGS UART_LSR_BRK_ERROR_BITS
-	u8		lsr_saved_flags;
-#define MSR_SAVE_FLAGS UART_MSR_ANY_DELTA
-	u8		msr_saved_flags;
+	struct mutex	io_lock;	/* lock for GPIO functions */
 	u8		io_dir;		/* cache for IODir register */
 	u8		io_state;	/* cache for IOState register */
 	u8		io_gpio;	/* PIN is GPIO */
@@ -451,7 +436,7 @@ static void sc16is7x2_shutdown(struct uart_port *port)
 	BUG_ON(!chan);
 	BUG_ON(!ts);
 
-	if (ts->suspending)
+	if (ts->force_end_work)
 		return;
 
 	/* Disable interrupts from this port */
@@ -639,7 +624,7 @@ static void sc16is7x2_release_port(struct uart_port *port)
 	struct sc16is7x2_chip *ts = chan->chip;
 
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
-	ts->force_end_work = 1;
+	ts->force_end_work = true;
 }
 
 static int sc16is7x2_request_port(struct uart_port *port)
@@ -709,7 +694,7 @@ static int sc16is7x2_gpio_request(struct gpio_chip *gpio, unsigned offset)
 	BUG_ON(offset > 8);
 	dev_dbg(&ts->spi->dev, "%s: offset = %d\n", __func__, offset);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	/* GPIO 0:3 and 4:7 can only be controlled as block */
 	ts->io_gpio |= BIT(offset);
@@ -720,7 +705,7 @@ static int sc16is7x2_gpio_request(struct gpio_chip *gpio, unsigned offset)
 		ret = sc16is7x2_write(ts->spi, REG_IOC, 0, ts->io_control);
 	}
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 
 	return ret;
 }
@@ -734,7 +719,7 @@ static void sc16is7x2_gpio_free(struct gpio_chip *gpio, unsigned offset)
 
 	BUG_ON(offset > 8);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	/* GPIO 0:3 and 4:7 can only be controlled as block */
 	ts->io_gpio &= ~BIT(offset);
@@ -746,7 +731,7 @@ static void sc16is7x2_gpio_free(struct gpio_chip *gpio, unsigned offset)
 		sc16is7x2_write(ts->spi, REG_IOC, 0, ts->io_control);
 	}
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 }
 
 static int sc16is7x2_direction_input(struct gpio_chip *gpio, unsigned offset)
@@ -757,12 +742,12 @@ static int sc16is7x2_direction_input(struct gpio_chip *gpio, unsigned offset)
 
 	BUG_ON(offset > 8);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	ts->io_dir &= ~BIT(offset);
 	io_dir = ts->io_dir;
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 
 	return sc16is7x2_write_async(ts->spi, REG_IOD, 0, io_dir);
 }
@@ -776,7 +761,7 @@ static int sc16is7x2_direction_output(struct gpio_chip *gpio, unsigned offset,
 
 	BUG_ON(offset > 8);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	if (value)
 		ts->io_state |= BIT(offset);
@@ -791,7 +776,7 @@ static int sc16is7x2_direction_output(struct gpio_chip *gpio, unsigned offset,
 		sc16is7x2_add_write_cmd(&cmds[1], REG_IOD, 0, ts->io_dir);
 	}
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 
 	return sc16is7x2_spi_async(ts->spi, cmds, 2);
 }
@@ -804,7 +789,7 @@ static int sc16is7x2_get(struct gpio_chip *gpio, unsigned offset)
 
 	BUG_ON(offset > 8);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	if (ts->io_dir & BIT(offset)) {
 		/* Output: return cached level */
@@ -818,7 +803,7 @@ static int sc16is7x2_get(struct gpio_chip *gpio, unsigned offset)
 		}
 	}
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 
 	return level;
 }
@@ -831,7 +816,7 @@ static void sc16is7x2_set(struct gpio_chip *gpio, unsigned offset, int value)
 
 	BUG_ON(offset > 8);
 
-	mutex_lock(&ts->lock);
+	mutex_lock(&ts->io_lock);
 
 	if (value)
 		ts->io_state |= BIT(offset);
@@ -839,7 +824,7 @@ static void sc16is7x2_set(struct gpio_chip *gpio, unsigned offset, int value)
 		ts->io_state &= ~BIT(offset);
 	io_state = ts->io_state;
 
-	mutex_unlock(&ts->lock);
+	mutex_unlock(&ts->io_lock);
 
 	sc16is7x2_write_async(ts->spi, REG_IOS, 0, io_state);
 }
@@ -971,7 +956,7 @@ static bool sc16is7x2_msg_add_fifo_tx(struct sc16is7x2_chip *ts, unsigned ch)
 	}
 
 	txlvl = sc16is7x2_read(ts->spi, REG_TXLVL, ch);
-	if (txlvl <= 0) {
+	if (txlvl == 0) {
 		dev_dbg(&ts->spi->dev, " fifo full\n");
 		return false;
 	}
@@ -1066,21 +1051,18 @@ static bool sc16is7x2_handle_channel(struct sc16is7x2_chip *ts, unsigned ch)
 	return (chan->iir & UART_IIR_NO_INT) == 0x00;
 }
 
-static void sc16is7x2_work(struct work_struct *w)
+static irqreturn_t sc16is7x2_work(int irq, void *data)
 {
-	struct sc16is7x2_chip *ts =
-			container_of(w, struct sc16is7x2_chip, work);
+	struct sc16is7x2_chip *ts = (struct sc16is7x2_chip *)data;
 	unsigned pending = 0;
 	unsigned ch = 0;
 
 	dev_dbg(&ts->spi->dev, "%s\n", __func__);
-	BUG_ON(!w);
 	BUG_ON(!ts);
 
-
 	if (ts->force_end_work) {
 		dev_dbg(&ts->spi->dev, "%s: force end!\n", __func__);
-		return;
+		return IRQ_NONE;
 	}
 
 	if (ts->channel[0].active)
@@ -1089,29 +1071,28 @@ static void sc16is7x2_work(struct work_struct *w)
 		pending |= BIT(1);
 
 	do {
-		mutex_lock(&(ts->channel[ch].lock));
 		if (pending & BIT(ch) && ts->channel[ch].active) {
 			if (!sc16is7x2_handle_channel(ts, ch))
 				pending &= ~BIT(ch);
 		}
-		mutex_unlock(&(ts->channel[ch].lock));
 		ch ^= 1;	/* switch channel */
-	} while (!ts->force_end_work && !freezing(current) && pending);
+	} while (!ts->force_end_work && pending);
 
 	dev_dbg(&ts->spi->dev, "%s finished\n", __func__);
+
+	return IRQ_HANDLED;
 }
 
-static irqreturn_t sc16is7x2_interrupt(int irq, void *dev_id)
+static irqreturn_t sc16is7x2_irq(int irq, void *data)
 {
-	struct sc16is7x2_chip *ts = dev_id;
-
-	dev_dbg(&ts->spi->dev, "%s\n", __func__);
+	struct sc16is7x2_chip *ts = (struct sc16is7x2_channel *)data;
 
-	if (!ts->force_end_work && !work_pending(&ts->work) &&
-	    !freezing(current) && !ts->suspending)
-		queue_work(ts->workqueue, &ts->work);
-
-	return IRQ_HANDLED;
+	/* It takes too long to read the regs over SPI,
+	 * so just wake up the thread */
+	if (ts->channel[0].active || ts->channel[1].active)
+		return IRQ_WAKE_THREAD;
+	else
+		return IRQ_NONE;
 }
 
 /* ******************************** INIT ********************************* */
@@ -1229,16 +1210,16 @@ static int __devinit sc16is7x2_probe(struct spi_device *spi)
 	if (!ts)
 		return -ENOMEM;
 
-	mutex_init(&ts->lock);
+	mutex_init(&ts->io_lock);
 	spi_set_drvdata(spi, ts);
 	ts->spi = spi;
-	ts->force_end_work = 1;
+	ts->force_end_work = true;
 
 	/* Reset the chip TODO: and disable IRQ output */
 	sc16is7x2_write(spi, REG_IOC, 0, IOC_SRESET);
 
-	ret = request_irq(spi->irq, sc16is7x2_interrupt,
-			IRQF_TRIGGER_FALLING | IRQF_SHARED, "sc16is7x2", ts);
+	ret = request_threaded_irq(spi->irq, sc16is7x2_irq, sc16is7x2_work,
+			IRQF_TRIGGER_FALLING | IRQF_SHARED, DRIVER_NAME, ts);
 	if (ret) {
 		dev_warn(&ts->spi->dev, "cannot register interrupt\n");
 		goto exit_destroy;
@@ -1255,14 +1236,7 @@ static int __devinit sc16is7x2_probe(struct spi_device *spi)
 	if (ret)
 		goto exit_uart1;
 
-	ts->workqueue = create_freezeable_workqueue(DRIVER_NAME);
-	if (!ts->workqueue) {
-		dev_warn(&ts->spi->dev, "cannot create workqueue\n");
-		ret = -EBUSY;
-		goto exit_gpio;
-	}
-	INIT_WORK(&ts->work, sc16is7x2_work);
-	ts->force_end_work = 0;
+	ts->force_end_work = false;
 
 	printk(KERN_INFO DRIVER_NAME " at CS%d (irq %d), 2 UARTs, 8 GPIOs\n"
 			"    eser%d, eser%d, gpiochip%d\n",
@@ -1272,9 +1246,6 @@ static int __devinit sc16is7x2_probe(struct spi_device *spi)
 
 	return ret;
 
-exit_gpio:
-	ret = gpiochip_remove(&ts->gpio);
-
 exit_uart1:
 	sc16is7x2_unregister_uart_port(ts, 1);
 
@@ -1286,7 +1257,7 @@ exit_irq:
 
 exit_destroy:
 	dev_set_drvdata(&spi->dev, NULL);
-	mutex_destroy(&ts->lock);
+	mutex_destroy(&ts->io_lock);
 	kfree(ts);
 	return ret;
 }
@@ -1299,14 +1270,8 @@ static int __devexit sc16is7x2_remove(struct spi_device *spi)
 	if (ts == NULL)
 		return -ENODEV;
 
+	ts->force_end_work = true;
 	free_irq(spi->irq, ts);
-	ts->force_end_work = 1;
-
-	if (ts->workqueue) {
-		flush_workqueue(ts->workqueue);
-		destroy_workqueue(ts->workqueue);
-		ts->workqueue = NULL;
-	}
 
 	ret = sc16is7x2_unregister_uart_port(ts, 0);
 	if (ret)
@@ -1321,7 +1286,7 @@ static int __devexit sc16is7x2_remove(struct spi_device *spi)
 		goto exit_error;
 	}
 
-	mutex_destroy(&ts->lock);
+	mutex_destroy(&ts->io_lock);
 	kfree(ts);
 
 exit_error:
-- 
1.7.2.3


--------------020507020101050802050307--
