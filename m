Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0HSHjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 03:39:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37816 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0HSHjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 03:39:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=lndRn4v7jTIGq2eetd42ZzedBlGsXHnHfx2i/OAMEWTMSRTixVdN2ApmrzyLCo3msg
         gxHLd5mip+oZMHpIEj1HuM/2KbFbrElUUYMU82jBH39OaIQuhYu+T+rCQ7399c2owzMp
         AdC+IfEubrQ2psj91dqfBmIYaOQmO8q1zdiFo=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
Subject: Re: Regarding USB-Serial Device driver
Date: Thu, 19 Aug 2010 09:38:44 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        orest.bond@outpostembedded.com, vijaykumar@zilogic.com
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100819061525.M24093@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008190938.44532.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 19. srpna 2010 08:17:30 Raju Rameshwar Uprade napsal(a):
> Dear Sir,
>          I am trying to write a Pl2303_mcm.c usb-serial device driver which
> will be able to talk to several devices using RS-485 interface card.I have
> modified the standard pl2303.c by which I am able to enable/disable the
> RTS line.
> I am sending 10 bytes of data to the device, data is going out but instead
> of 10 bytes, device driver is sending a large amount of data as seen on
> Lecroy waverunner oscilloscope. Here I am sending the modified file.

Hi, I have no idea why I'm CCed in this, but anyway.

1) could you please update the driver to a more recent kernel (we are 10 kernel 
versions further now)
2) could you please send a diff instead of a whole file? (git diff <file1> 
<file2> > diff.diff ... see man git-diff)

Cheers
> 
> /* Prolific PL2303 USB to serial adaptor driver which will be able to
> communicate with MCM.....for kernel version 2.6.25.14
>    Implementing mcmdriver in pl2303.c  */
> 
> #include <linux/kernel.h>
> #include <linux/errno.h>
> #include <linux/init.h>
> #include <linux/slab.h>
> #include <linux/tty.h>
> #include <linux/tty_driver.h>
> #include <linux/tty_flip.h>
> #include <linux/serial.h>
> #include <linux/module.h>
> #include <linux/moduleparam.h>
> #include <linux/spinlock.h>
> #include <asm/uaccess.h>
> #include <linux/usb.h>
> #include <linux/usb/serial.h>
> #include <linux/delay.h>
> #define PL2303_VENDOR_ID	0x067b
> #define PL2303_PRODUCT_ID	0x2303
> /*
>  * Version Information
>  */
> #define DRIVER_DESC "Prolific PL2303 USB to serial adaptor driver"
> 
> static int debug;
> #define PL2303_CLOSING_WAIT	(30*HZ)
> 
>  /*  Original
> 
> #define PL2303_BUF_SIZE		1024
> #define PL2303_TMP_BUF_SIZE	1024   */
> 
> #define PL2303_BUF_SIZE		100
> #define PL2303_TMP_BUF_SIZE	 100
> 
> struct pl2303_buf {
> 	unsigned int	buf_size;
> 	char		*buf_buf;
> 	char		*buf_get;
> 	char		*buf_put;
> };
> 
> static struct usb_device_id id_table [] = {
> 	{ USB_DEVICE(PL2303_VENDOR_ID, PL2303_PRODUCT_ID) },
> 	{ }					/* Terminating entry */
> };
> 
> MODULE_DEVICE_TABLE(usb, id_table);
> 
> static struct usb_driver pl2303_mcm_driver = {
> 	.name =		"pl2303_mcm",
> 	.probe =	usb_serial_probe,
> 	.disconnect =	usb_serial_disconnect,
> 	.id_table =	id_table,
> 	.suspend =      usb_serial_suspend,
> 	.resume =       usb_serial_resume,
> 	.no_dynamic_id = 	1,
> 	.supports_autosuspend =	1,
> };
> 
> #define SET_LINE_REQUEST_TYPE		0x21
> #define SET_LINE_REQUEST		        0x20
> 
> #define SET_CONTROL_REQUEST_TYPE	    0x21
> #define SET_CONTROL_REQUEST		    0x22
> #define CONTROL_DTR			            0x01
> #define CONTROL_RTS			            0x02
> 
> #define BREAK_REQUEST_TYPE		0x21
> #define BREAK_REQUEST			0x23
> #define BREAK_ON			0xffff
> #define BREAK_OFF			0x0000
> 
> #define GET_LINE_REQUEST_TYPE		0xa1
> #define GET_LINE_REQUEST		0x21
> 
> #define VENDOR_WRITE_REQUEST_TYPE	0x40
> #define VENDOR_WRITE_REQUEST		0x01
> 
> #define VENDOR_READ_REQUEST_TYPE	                    0xc0
> #define VENDOR_READ_REQUEST		                    0x01
> 
> #define UART_STATE			                                   0x08
> #define UART_STATE_TRANSIENT_MASK                    0x74
> #define UART_DCD			                                   0x01
> #define UART_DSR			                                   0x02
> #define UART_BREAK_ERROR	                                   0x04
> #define UART_RING			0x08
> #define UART_FRAME_ERROR		0x10
> #define UART_PARITY_ERROR		0x20
> #define UART_OVERRUN_ERROR		0x40
> #define UART_CTS			0x80
> 
> enum pl2303_type {
> 	type_0,		/* don't know the difference between type 0 and */
> 	type_1,		/* type 1, until someone from prolific tells us... */
> 	HX,		/* HX version of the pl2303 chip */
> };
> 
> struct pl2303_private {
> 	spinlock_t lock;                                           /* spin lock 
*/
> 	struct pl2303_buf *buf;
> 	int write_urb_in_use;
> 	wait_queue_head_t delta_msr_wait;
> 	u8 line_control;                                          /* used as MCR 
(
> modem control register */
> 	u8 line_status;                                           /* used as MSR 
> (modem status register ) */
> 	u8 termios_initialized;
> 	enum pl2303_type type;
> };
> 
> /*
>  * pl2303_buf_alloc
>  *
>  * Allocate a circular buffer and all associated memory.
>  */
> static struct pl2303_buf *pl2303_buf_alloc(unsigned int size)
> {
> 	struct pl2303_buf *pb;
> 
> 	if (size == 0)
> 		return NULL;
> 
> 	pb = kmalloc(sizeof(struct pl2303_buf), GFP_KERNEL);
> 	if (pb == NULL)
> 		return NULL;
> 
> 	pb->buf_buf = kmalloc(size, GFP_KERNEL);
> 	if (pb->buf_buf == NULL) {
> 		kfree(pb);
> 		return NULL;
> 	}
> 
> 	pb->buf_size = size;
> 	pb->buf_get = pb->buf_put = pb->buf_buf;
> 
> 	return pb;
> }
> 
> /*
>  * pl2303_buf_free
>  *
>  * Free the buffer and all associated memory.
>  */
> static void pl2303_buf_free(struct pl2303_buf *pb)
> {
> 	if (pb) {
> 		kfree(pb->buf_buf);
> 		kfree(pb);
> 	}
> }
> 
> /*
>  * pl2303_buf_clear
>  *
>  * Clear out all data in the circular buffer.
>  */
> static void pl2303_buf_clear(struct pl2303_buf *pb)
> {
> 	if (pb != NULL)
> 		pb->buf_get = pb->buf_put;
> 		/* equivalent to a get of all data available */
> }
> 
> /*
>  * pl2303_buf_data_avail
>  *
>  * Return the number of bytes of data available in the circular
>  * buffer.
>  */
> static unsigned int pl2303_buf_data_avail(struct pl2303_buf *pb)
> {
> 	if (pb == NULL)
> 		return 0;
> 
> 	return ((pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size);
> }
> 
> /*
>  * pl2303_buf_space_avail
>  *
>  * Return the number of bytes of space available in the circular
>  * buffer.
>  */
> static unsigned int pl2303_buf_space_avail(struct pl2303_buf *pb)
> {
> 	if (pb == NULL)
> 		return 0;
> 
> 	return ((pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size);
> }
> 
> /*
>  * pl2303_buf_put
>  *
>  * Copy data from a user buffer and put it into the circular buffer.
> 
>  * Restrict to the amount of space available.
>  *
>  * Return the number of bytes copied.
>  */
> static unsigned int pl2303_buf_put(struct pl2303_buf *pb, const char
> *buf,unsigned int count)
> {
> 	unsigned int len;
> 
> 	if (pb == NULL)
> 		return 0;
> 
> 	len  = pl2303_buf_space_avail(pb);
> 	if (count > len)                                  // if count is greater
> than len count = len;
> 
> 	if (count == 0)
> 		return 0;
> 
> 	len = pb->buf_buf + pb->buf_size - pb->buf_put;
> 	if (count > len)
>           {
>                //  memcpy - copy memory area
>                //  void *memcpy(void *dest, const void *src, size_t n);
> 
> 		memcpy(pb->buf_put, buf, len);
> 		memcpy(pb->buf_buf, buf+len, count - len);
> 		pb->buf_put = pb->buf_buf + count - len;
>           }
>           else
>            {
> 		memcpy(pb->buf_put, buf, count);
> 		    if (count < len)
> 			   pb->buf_put += count;
> 		    else /* count == len */
> 			pb->buf_put = pb->buf_buf;
> 	     }
> 
> 	return count;
> }
> 
> /*
>  * pl2303_buf_get
>  *
>  * Get data from the circular buffer and copy to the given buffer.
>  * Restrict to the amount of data available.
>  *
>  * Return the number of bytes copied.
>  */
> static unsigned int pl2303_buf_get(struct pl2303_buf *pb, char *buf,
> unsigned int count) {
> 	unsigned int len;
> 
> 	if (pb == NULL)
> 		return 0;
> 
> 	len = pl2303_buf_data_avail(pb);
> 	if (count > len)
> 		count = len;
> 
> 	if (count == 0)
> 		return 0;
> 
> 	len = pb->buf_buf + pb->buf_size - pb->buf_get;
> 	if (count > len) {
> 
>          //    memcpy - copy memory area
>         //     void *memcpy(void *dest, const void *src, size_t n);
> 
> 		memcpy(buf, pb->buf_get, len);
> 		memcpy(buf+len, pb->buf_buf, count - len);
> 		pb->buf_get = pb->buf_buf + count - len;
> 	} else {
> 		memcpy(buf, pb->buf_get, count);
> 		if (count < len)
> 			pb->buf_get += count;
> 		else /* count == len */
> 			pb->buf_get = pb->buf_buf;
> 	}
> 
> 	return count;
> }
> 
> static int pl2303_vendor_read(__u16 value, __u16 index,
> 		struct usb_serial *serial, unsigned char *buf)
> {
> 	int res = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
> 			VENDOR_READ_REQUEST, VENDOR_READ_REQUEST_TYPE,
> 			value, index, buf, 1, 100);
> 	dbg("0x%x:0x%x:0x%x:0x%x  %d - %x", VENDOR_READ_REQUEST_TYPE,
> 			VENDOR_READ_REQUEST, value, index, res, buf[0]);
> 	return res;
> }
> 
> static int pl2303_vendor_write(__u16 value, __u16 index,
> 		struct usb_serial *serial)
> {
> 	int res = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
> 			VENDOR_WRITE_REQUEST, VENDOR_WRITE_REQUEST_TYPE,
> 			value, index, NULL, 0, 100);
> 	dbg("0x%x:0x%x:0x%x:0x%x  %d", VENDOR_WRITE_REQUEST_TYPE,
> 			VENDOR_WRITE_REQUEST, value, index, res);
> 	return res;
> }
> 
> static int pl2303_startup(struct usb_serial *serial)
> {
> 	struct pl2303_private *priv;
> 	enum pl2303_type type = type_0;
> 	unsigned char *buf;
> 	int i;
> 
> 	buf = kmalloc(10, GFP_KERNEL);
> 	if (buf == NULL)
> 		return -ENOMEM;
> 
> 	if (serial->dev->descriptor.bDeviceClass == 0x02)
> 		type = type_0;
> 	else if (serial->dev->descriptor.bMaxPacketSize0 == 0x40)
> 		type = HX;
> 	else if (serial->dev->descriptor.bDeviceClass == 0x00)
> 		type = type_1;
> 	else if (serial->dev->descriptor.bDeviceClass == 0xFF)
> 		type = type_1;
> 	dbg("device type: %d", type);
> 
> 	for (i = 0; i < serial->num_ports; ++i) {
> 		priv = kzalloc(sizeof(struct pl2303_private), GFP_KERNEL);
> 		if (!priv)
> 			goto cleanup;
> 		spin_lock_init(&priv->lock);
> 		priv->buf = pl2303_buf_alloc(PL2303_BUF_SIZE);
> 		if (priv->buf == NULL) {
> 			kfree(priv);
> 			goto cleanup;
> 		}
> 		init_waitqueue_head(&priv->delta_msr_wait);
> 		priv->type = type;
> 		usb_set_serial_port_data(serial->port[i], priv);
> 	}
> 
> 	pl2303_vendor_read(0x8484, 0, serial, buf);
> 	pl2303_vendor_write(0x0404, 0, serial);
> 	pl2303_vendor_read(0x8484, 0, serial, buf);
> 	pl2303_vendor_read(0x8383, 0, serial, buf);
> 	pl2303_vendor_read(0x8484, 0, serial, buf);
> 	pl2303_vendor_write(0x0404, 1, serial);
> 	pl2303_vendor_read(0x8484, 0, serial, buf);
> 	pl2303_vendor_read(0x8383, 0, serial, buf);
> 	pl2303_vendor_write(0, 1, serial);
> 	pl2303_vendor_write(1, 0, serial);
> 	if (type == HX)
> 		pl2303_vendor_write(2, 0x44, serial);
> 	else
> 		pl2303_vendor_write(2, 0x24, serial);
> 
> 	kfree(buf);
> 	return 0;
> 
> cleanup:
> 	kfree(buf);
> 	for (--i; i>=0; --i) {
> 		priv = usb_get_serial_port_data(serial->port[i]);
> 		pl2303_buf_free(priv->buf);
> 		kfree(priv);
> 		usb_set_serial_port_data(serial->port[i], NULL);
> 	}
> 	return -ENOMEM;
> }
> 
> static int set_control_lines(struct usb_device *dev, u8 value)
> {
> 	int retval;
> 
> 	retval = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> SET_CONTROL_REQUEST, SET_CONTROL_REQUEST_TYPE, value, 0, NULL, 0, 100);
> 	dbg("%s - value = %d, retval = %d", __func__, value, retval);
> 	return retval;
> }
> 
> // struct usb_serial_port include the struct urb which has a variable named
> write_urb .....
> 
> static void pl2303_send(struct usb_serial_port *port)
> {
> 	int count, result;
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
>         u8 control;
>       //  int on = 1;
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 
> 	if (priv->write_urb_in_use)
>             {
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 		return;
> 	   }
> 
> // transfer_buffer    This identifies the buffer to (or from) which the I/O
> request will be performed (unless URB_NO_TRANSFER_DMA_MAP is set). This
> buffer must be suitable for DMA;
>  // ALLOCATE IT WITH KMALLOC OR EQUIVALENT. For transfers to ``in''
> endpoints, contents of this buffer will be modified. This buffer is used
> for the data stage of control transfers.
> // bulk_out_size : the size of the bulk_out_buffer, in bytes
> 
> 	count = pl2303_buf_get(priv->buf, port->write_urb->transfer_buffer,
> port->bulk_out_size);
> 
> 	if (count == 0)
>            {
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 		return;
> 	   }
> 
> 	priv->write_urb_in_use = 1;
> 
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
>              /*   spin_lock_irqsave(&priv->lock, flags);
> 	 	if (on)
> 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
>                 else
> 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
> 	        control = priv->line_control;
> 	       spin_unlock_irqrestore(&priv->lock, flags);
> 	       set_control_lines(port->serial->dev, control); */
> 
> 	usb_serial_debug_data(debug, &port->dev, __func__,
> count,port->write_urb->transfer_buffer);
> 
> 	// port->write_urb->transfer_buffer_length = count;
>         port->write_urb->transfer_buffer_length = count;      // this value
> matters a lot .....
> 	port->write_urb->dev = port->serial->dev;
> 	result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
> 
>       // Following Code hangs the PC
>               /* mdelay(10);
>                spin_lock_irqsave(&priv->lock,flags);
>                 priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
>                 control = priv->line_control;
>         	spin_unlock_irqrestore(&priv->lock, flags);
>         	set_control_lines(port->serial->dev, control);  */
> 	if (result)
>             {
> 		     dev_err(&port->dev, "%s - failed submitting write urb,"" 
error
> %d\n", __func__, result);
> 		     priv->write_urb_in_use = 0;
> 		     // TODO: reschedule pl2303_send
> 	    }
> 
>                  usb_serial_port_softint(port);
> 
>            /*     spin_lock_irqsave(&priv->lock,flags);
>                 priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
>                 control = priv->line_control;
>         	spin_unlock_irqrestore(&priv->lock, flags);
>         	set_control_lines(port->serial->dev, control); */
>         }
> 
> static int pl2303_write(struct usb_serial_port *port, const unsigned char
> *buf,int count) {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
>          u8 control;
> 	dbg("%s - port %d, %d bytes", __func__, port->number, count);
> 
> 	if (!count)
> 		return count;
> 
>      // Following code is included so that We can enable the RTS line to
> high before data transmission
>        //  Tried writing a for loop here to loop the RTS line
> enable/disable , but that also didn't work...
> 
>                   spin_lock_irqsave(&priv->lock, flags);
> 	          priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
>                  control = priv->line_control;
> 	          spin_unlock_irqrestore(&priv->lock, flags);
> 	          set_control_lines(port->serial->dev, control);
> 
> 	     spin_lock_irqsave(&priv->lock, flags);
> 	     count = pl2303_buf_put(priv->buf, buf, count);
> 	     spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	       pl2303_send(port);                              // If I comment
> this , driver dosen't work
> 
> 	//  Following code is included so that We can disable the RTS line to 
low
> after data transmission..
>          // mdelay plays an Important role here....
>           mdelay(5);
>          spin_lock_irqsave(&priv->lock, flags);
>        //   priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS); // this
> doesn't work here... priv->line_control   = 0;   // this work here.....
>          control = priv->line_control;
> 	 spin_unlock_irqrestore(&priv->lock, flags);
> 	 set_control_lines(port->serial->dev,control);
> 
>           return count;   // count is also very IMP b'coz it affect the
> device driver's behaviour.....
> }
> 
> //               Write_room--->  The function that indicates how much of
> the buffer is free. static int pl2303_write_room(struct usb_serial_port
> *port)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	int room = 0;
> 	unsigned long flags;
> 
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	room = pl2303_buf_space_avail(priv->buf);
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	dbg("%s - returns %d", __func__, room);
> 	return room;
> }
> 
> //   chars_in_buffer------>  The function that indicates how much of the
> buffer is full of data.
> static int pl2303_chars_in_buffer(struct usb_serial_port *port)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	int chars = 0;
> 	unsigned long flags;
> 
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	chars = pl2303_buf_data_avail(priv->buf);
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	dbg("%s - returns %d", __func__, chars);
> 	return chars;
> }
> 
> static void pl2303_set_termios(struct usb_serial_port *port,struct ktermios
> *old_termios) {
> 	struct usb_serial *serial = port->serial;
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	unsigned int cflag;
> 	unsigned char *buf;
> 	int baud;
> 	int i;
> 	u8 control;
> 
> 	dbg("%s -  port %d", __func__, port->number);
> 
>          //printk(KERN_ALERT "I M in Set Termios\n");
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	if (!priv->termios_initialized) {
> 		*(port->tty->termios) = tty_std_termios;
> 
> 	/* HUPCL---->   Lower modem control lines after last process closes the
> device (hang up). CLOCAL---->  Ignore modem control lines.
>           CLOCAL------> Ignore modem control lines.
>          CREAD---------> Enable receiver. */
> 
> 	        port->tty->termios->c_cflag = B9600 | CS8 | CREAD | HUPCL |
> CLOCAL; port->tty->termios->c_ispeed = 9600;
> 		port->tty->termios->c_ospeed = 9600;
> 		priv->termios_initialized = 1;
> 	}
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	/* The PL2303 is reported to lose bytes if you change
> 	   serial settings even to the same values as before. Thus
> 	   we actually need to filter in this specific case */
> 
> 	if (!tty_termios_hw_change(port->tty->termios, old_termios))
> 		return;
> 
> 	cflag = port->tty->termios->c_cflag;
> 
> 	buf = kzalloc(7, GFP_KERNEL);
> 	if (!buf) {
> 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
> 		/* Report back no change occurred */
> 		*port->tty->termios = *old_termios;
> 		return;
> 	}
> 
> 	i = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
> 			    GET_LINE_REQUEST, GET_LINE_REQUEST_TYPE,
> 			    0, 0, buf, 7, 100);
> 	dbg("0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x", i,
> 	    buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
> 
> 	if (cflag & CSIZE) {
> 		switch (cflag & CSIZE) {
> 			case CS5:	buf[6] = 5;	break;
> 			case CS6:	buf[6] = 6;	break;
> 			case CS7:	buf[6] = 7;	break;
> 			default:
> 			case CS8:	buf[6] = 8;	break;
> 		}
> 		dbg("%s - data bits = %d", __func__, buf[6]);
> 	}
> 
> 	baud = tty_get_baud_rate(port->tty);;
> 	dbg("%s - baud = %d", __func__, baud);
> 	if (baud) {
> 		buf[0] = baud & 0xff;
> 		buf[1] = (baud >> 8) & 0xff;
> 		buf[2] = (baud >> 16) & 0xff;
> 		buf[3] = (baud >> 24) & 0xff;
> 	}
> 
> 	/* For reference buf[4]=0 is 1 stop bits */
> 	/* For reference buf[4]=1 is 1.5 stop bits */
> 	/* For reference buf[4]=2 is 2 stop bits */
> 	if (cflag & CSTOPB) {
> 		buf[4] = 2;
> 		dbg("%s - stop bits = 2", __func__);
> 	} else {
> 		buf[4] = 0;
> 		dbg("%s - stop bits = 1", __func__);
> 	}
> 
> 	if (cflag & PARENB) {
> 		/* For reference buf[5]=0 is none parity */
> 		/* For reference buf[5]=1 is odd parity */
> 		/* For reference buf[5]=2 is even parity */
> 		/* For reference buf[5]=3 is mark parity */
> 		/* For reference buf[5]=4 is space parity */
> 		if (cflag & PARODD) {
> 			buf[5] = 1;
> 			dbg("%s - parity = odd", __func__);
> 		} else {
> 			buf[5] = 2;
> 			dbg("%s - parity = even", __func__);
> 		}
> 	} else {
> 		buf[5] = 0;
> 		dbg("%s - parity = none", __func__);
> 	}
> 
> 	i = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
> 			    SET_LINE_REQUEST, SET_LINE_REQUEST_TYPE,
> 			    0, 0, buf, 7, 100);
> 	dbg("0x21:0x20:0:0  %d", i);
> 
> 	/* change control lines if we are switching to or from B0 */
> 	spin_lock_irqsave(&priv->lock, flags);
> 	control = priv->line_control;
> 
> /* The zero baud rate, B0, is used to terminate the connection. If B0 is
> specified, the modem control lines shall no longer be asserted. Normally,
> this will disconnect the line */
> 
> 	  if ((cflag & CBAUD) == B0)
> 
> 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
> 	else
> 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
> 	if (control != priv->line_control) {
> 		control = priv->line_control;
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 		set_control_lines(serial->dev, control);
> 	} else {
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 	}
> 
> 	buf[0] = buf[1] = buf[2] = buf[3] = buf[4] = buf[5] = buf[6] = 0;
> 
> 	i = usb_control_msg(serial->dev, usb_rcvctrlpipe(serial->dev, 0),
> 			    GET_LINE_REQUEST, GET_LINE_REQUEST_TYPE,
> 			    0, 0, buf, 7, 100);
> 	dbg("0xa1:0x21:0:0  %d - %x %x %x %x %x %x %x", i,
> 	     buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6]);
> 
> 	    if (cflag & CRTSCTS) {
> 		if (priv->type == HX)
> 			pl2303_vendor_write(0x0, 0x61, serial);
> 		else
> 			pl2303_vendor_write(0x0, 0x41, serial);
> 	} else {
> 		pl2303_vendor_write(0x0, 0x0, serial);
> 	}
> 
> 	/* FIXME: Need to read back resulting baud rate */
> 	if (baud)
> 		tty_encode_baud_rate(port->tty, baud, baud);
> 
> 	kfree(buf);
> }
> 
> /*************
> static void pl2303_dtr_rts(struct usb_serial_port *port, int on)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	u8 control;
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	//  Change DTR and RTS
> 	if (on)
> 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
> 	else
> 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
> 	control = priv->line_control;
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 	set_control_lines(port->serial->dev, control);
> }
> *************/
> static void pl2303_close(struct usb_serial_port *port, struct file *filp)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	unsigned int c_cflag;
> 	int bps;
> 	long timeout;
> 	wait_queue_t wait;
> 
> 	dbg("%s - port %d", __func__, port->number);
>          // Tried to comment from here upto
> schedule_timeout_interruptible(timeout); ..but it doesn't make any
> diffrence...5/8/10
> 	//wait for data to drain from the buffer
> 	 spin_lock_irqsave(&priv->lock, flags);
> 	timeout = PL2303_CLOSING_WAIT;
> 	init_waitqueue_entry(&wait, current);
> 	add_wait_queue(&port->tty->write_wait, &wait);
> 	for (;;) {
> 		set_current_state(TASK_INTERRUPTIBLE);
> 		if (pl2303_buf_data_avail(priv->buf) == 0 ||
> 		    timeout == 0 || signal_pending(current) ||
> 		    port->serial->disconnected)
> 			break;
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 		timeout = schedule_timeout(timeout);
> 		spin_lock_irqsave(&priv->lock, flags);
> 	}
> 	set_current_state(TASK_RUNNING);
> 	remove_wait_queue(&port->tty->write_wait, &wait);
> 	// clear out any remaining data in the buffer
> 	pl2303_buf_clear(priv->buf);
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	// wait for characters to drain from the device (this is long enough for
> the entire 256 byte  pl2303 hardware buffer to drain with no flow
> 	// control for data rates of 1200 bps or more, for lower rates we should
> really know how much  data is in the buffer to compute a delay
> 	// that is not unnecessarily long)
> 	bps = tty_get_baud_rate(port->tty);
>       // if bps is greater than 1200
> 	if (bps > 1200)
> 		timeout = max((HZ*2560)/bps,HZ/10);
> 	else
> 		timeout = 2*HZ;
> 	schedule_timeout_interruptible(timeout);
> 
> 	/* shutdown our urbs */
> 	dbg("%s - shutting down urbs", __func__);
> 	usb_kill_urb(port->write_urb);
> 	usb_kill_urb(port->read_urb);
> 	usb_kill_urb(port->interrupt_in_urb);
> 
> 	if (port->tty) {
> 		c_cflag = port->tty->termios->c_cflag;
> 		if (c_cflag & HUPCL) {
> 			/* drop DTR and RTS */
> 			spin_lock_irqsave(&priv->lock, flags);
> 			priv->line_control = 0;
> 			spin_unlock_irqrestore(&priv->lock, flags);
> 			set_control_lines(port->serial->dev, 0);
> 		}
> 	}
> }
> 
> static int pl2303_open(struct usb_serial_port *port, struct file *filp)
> {
> 	struct ktermios tmp_termios;
> 	struct usb_serial *serial = port->serial;
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	int result;
>         int on =1;
>      // trying to implemet RTS/DTR line settings -------> Raj date
> 14.07.2010
> 
>            u8 control;
>            unsigned long flags;
> 	dbg("%s -  port %d", __func__, port->number);
> 
> 	if (priv->type != HX) {
> 		usb_clear_halt(serial->dev, port->write_urb->pipe);
> 		usb_clear_halt(serial->dev, port->read_urb->pipe);
> 	} else {
> 		// reset upstream data pipes
> 		pl2303_vendor_write(8, 0, serial);
> 		pl2303_vendor_write(9, 0, serial);
> 	}
> 
> 	/* Setup termios */
> 	if (port->tty) {
> 		pl2303_set_termios(port, &tmp_termios);
> 	}
> 
> 	//FIXME: need to assert RTS and DTR if CRTSCTS off
>         // CRTSCTS -----> Hardware flow  control settings......
>         // code written for RTS line setting
>          // Change DTR and RTS
>        // if on =1 ------------> LED glows
>       // if on = 0 -------------> LED doesn't glow
>                //printk(KERN_ALERT "I M just before RTS\n");
>                spin_lock_irqsave(&priv->lock, flags);
> 	 	if (on)
> 		priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
>                 else
> 		priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
> 	        control = priv->line_control;
> 	       spin_unlock_irqrestore(&priv->lock, flags);
> 	       set_control_lines(port->serial->dev, control);
>               // printk(KERN_ALERT "I M just before RTS\n");   */
> 
>  /*    *********************** Code written as per Shri RBS
> guidlines....... Date 26/07/2010 ************/
> 
>    /*     spin_lock_irqsave(&priv->lock,flags);
>         priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
>         control = priv->line_control;
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 	set_control_lines(port->serial->dev, control);
>         mdelay(50);
>        spin_lock_irqsave(&priv->lock,flags);
>         priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
>         control = priv->line_control;
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 	set_control_lines(port->serial->dev, control);  */
> 
> 	dbg("%s - submitting read urb", __func__);
> 	port->read_urb->dev = serial->dev;
> 	result = usb_submit_urb(port->read_urb, GFP_KERNEL);
> 	if (result) {
> 		dev_err(&port->dev, "%s - failed submitting read urb,"" error 
%d\n",
> __func__, result); pl2303_close(port, NULL);
> 		return -EPROTO;
> 	}
> 
> 	 dbg("%s - submitting interrupt urb", __func__);
> 	port->interrupt_in_urb->dev = serial->dev;
> 	result = usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL);
> 	if (result) {
> 		dev_err(&port->dev, "%s - failed submitting interrupt urb,"" 
error %d\n",
> __func__, result);
> 		pl2303_close(port, NULL);
> 		return -EPROTO;
> 	}
> 
>       // Following code snippet is able to disable RTS line......need to
> find out where 2 place this code....( Date 27/7/2010 )
>     // printk(KERN_ALERT "I M just before Mdelay\n");
> 	/*  mdelay(10);
>         spin_lock_irqsave(&priv->lock,flags);
>         priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS);
>          control = priv->line_control;
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 	set_control_lines(port->serial->dev, control); */
> 	return 0;
> }
> 
> static int pl2303_tiocmset(struct usb_serial_port *port, struct file *file,
> 			   unsigned int set, unsigned int clear)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	u8 control;
> 
> 	if (!usb_get_intfdata(port->serial->interface))
> 		return -ENODEV;
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 
> 	if (set & TIOCM_RTS)
> 		priv->line_control |= CONTROL_RTS;        /*  mcr ( priv-> 
line_control =
> 1 */ if (set & TIOCM_DTR)
> 		priv->line_control |= CONTROL_DTR;       /*  mcr ( priv-> 
line_control =
> 1 */ if (clear & TIOCM_RTS)
> 		priv->line_control &= ~CONTROL_RTS;   /*  mcr ( priv-> 
line_control = 0
> */ if (clear & TIOCM_DTR)
> 		priv->line_control &= ~CONTROL_DTR;   /*  mcr ( priv-> 
line_control = 0
> */
> 
> 	      control = priv->line_control;
> 
>                 spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	return set_control_lines(port->serial->dev, control);
> }
> 
> static int pl2303_tiocmget(struct usb_serial_port *port, struct file *file)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	unsigned int mcr;
> 	unsigned int status;
> 	unsigned int result;
> 
> 	dbg("%s (%d)", __func__, port->number);
> 
> 	if (!usb_get_intfdata(port->serial->interface))
> 		return -ENODEV;
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	mcr = priv->line_control;                      /* Modem control register
> */ status = priv->line_status;                   /* Modem status register
> */ spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	result = ((mcr & CONTROL_DTR)? TIOCM_DTR : 0)   /* DTR is set */
> 
> 		  | ((mcr & CONTROL_RTS)	? TIOCM_RTS : 0)     /* RTS is 
set */
> 		  | ((status & UART_CTS)	? TIOCM_CTS : 0)      /* CTS is 
set */
> 		  | ((status & UART_DSR)	? TIOCM_DSR : 0)       /* DSR is 
set */
> 		  | ((status & UART_RING)	? TIOCM_RI  : 0)          /* 
RING INDICATOR is
> 		  | set */ ((status & UART_DCD)	? TIOCM_CD  : 0);        /* 
CARRIER
> 		  | DETECT is set */
> 
> 	dbg("%s - result = %x", __func__, result);
> 
> 	return result;
> }
> 
> /*******
>  static int pl2303_carrier_raised(struct usb_serial_port *port)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	if (priv->line_status & UART_DCD)
> 		return 1;
> 	return 0;
> }
> *********/
> 
> /* TIOCMIWAIT ------>Waits for MSR change. The user asks for this ioctl in
> the unusual circumstances that it wants to sleep within the kernel until
> something happens to the MSR register of                       			
		 the
> tty device.
>  The arg parameter contains the type of event that the user is waiting for.
> This is commonly used to wait until a status line changes, signaling that
> more data is ready to be sent to the device.
> Be careful when implementing this ioctl, and do not use the
> interruptible_sleep_on call, as it is unsafe (there are lots of nasty race
> conditions involved with it). Instead, a wait_queue should be used to
> avoid these problems. */
> 
> static int wait_modem_info(struct usb_serial_port *port, unsigned int arg)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	unsigned int prevstatus;
> 	unsigned int status;
> 	unsigned int changed;
> 
> 	spin_lock_irqsave(&priv->lock, flags);
> 	prevstatus = priv->line_status;
> 	spin_unlock_irqrestore(&priv->lock, flags);
> 
> 	while (1) {
> 		interruptible_sleep_on(&priv->delta_msr_wait);
> 		/* see if a signal did it */
> 		if (signal_pending(current))
> 			return -ERESTARTSYS;
> 
> 		spin_lock_irqsave(&priv->lock, flags);
> 		status = priv->line_status;
> 		spin_unlock_irqrestore(&priv->lock, flags);
> 
> 		changed=prevstatus^status;
> 
> 		if (((arg & TIOCM_RNG) && (changed & UART_RING)) ||
> 		    ((arg & TIOCM_DSR) && (changed & UART_DSR)) ||
> 		    ((arg & TIOCM_CD)  && (changed & UART_DCD)) ||
> 		    ((arg & TIOCM_CTS) && (changed & UART_CTS)) ) {
> 			return 0;
> 		}
> 		prevstatus = status;
> 	}
> 	/* NOTREACHED */
> 	return 0;
> }
> 
> static int pl2303_ioctl(struct usb_serial_port *port, struct file *file,
> 			unsigned int cmd, unsigned long arg)
> {
> 	dbg("%s (%d) cmd = 0x%04x", __func__, port->number, cmd);
> 
> 	switch (cmd) {
> 		case TIOCMIWAIT:     /* Waits for the MSR register change */
> 			dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
> 			return wait_modem_info(port, arg);
> 
> 		default:
> 			dbg("%s not supported = 0x%04x", __func__, cmd);
> 			break;
> 	}
> 
> 	return -ENOIOCTLCMD;
> }
> 
> static void pl2303_break_ctl(struct usb_serial_port *port, int break_state)
> {
> 	struct usb_serial *serial = port->serial;
> 	u16 state;
> 	int result;
> 
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	if (break_state == 0)
> 		state = BREAK_OFF;
> 	else
> 		state = BREAK_ON;
> 	dbg("%s - turning break %s", __func__, state==BREAK_OFF ? "off" : "on");
> 
> 	result = usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
> BREAK_REQUEST, BREAK_REQUEST_TYPE, state, 0, NULL, 0, 100);
> 	  if (result)
> 		dbg("%s - error sending break = %d", __func__, result);
> }
> 
> static void pl2303_shutdown(struct usb_serial *serial)
> {
> 	int i;
> 	struct pl2303_private *priv;
> 
> 	dbg("%s", __func__);
> 
> 	for (i = 0; i < serial->num_ports; ++i) {
> 		priv = usb_get_serial_port_data(serial->port[i]);
> 		if (priv) {
> 			pl2303_buf_free(priv->buf);
> 			kfree(priv);
> 			usb_set_serial_port_data(serial->port[i], NULL);
> 		}
> 	}
> }
> 
> /*  Somewhere in the tty driver’s code that recognizes that the MSR
> register changes, the following line must be called for this code to work
> properly:
>     wake_up_interruptible(&tp->wait);   */
> 
> static void pl2303_update_line_status(struct usb_serial_port *port,
> unsigned char *data, unsigned int actual_length)
> {
> 
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
> 	u8 status_idx = UART_STATE;
> 	u8 length = UART_STATE + 1;
> 	u16 idv, idp;
> 
> 	idv = le16_to_cpu(port->serial->dev->descriptor.idVendor);
> 	idp = le16_to_cpu(port->serial->dev->descriptor.idProduct);
> 
> 	 /* Save off the uart status for others to look at */
> 	spin_lock_irqsave(&priv->lock, flags);
> 	priv->line_status = data[status_idx];
>         spin_unlock_irqrestore(&priv->lock, flags);
>         wake_up_interruptible(&priv->delta_msr_wait);
> }
> 
> /*  urb Callback Function Pointers
> 
> The read_int_callback, read_bulk_callback and write_bulk_callback function
> pointers are all used by the USB serial core to set up the initial
> callbacks for these kinds of USB endpoints. If the driver does not specify
> the read or write bulk callback functions, the generic callbacks are used.
> There is no generic read interrupt callback function, so if your device
> has an interrupt endpoint, you must provide this callback.
> 
> The operation of the generic read bulk callback adds the data received by
> the USB urb to the port's tty buffer, to be sent to user space when read()
> is called. It then resubmits the urb to the device. If your device does
> not need to interpret the data received in any way, I recommend using this
> function instead of writing a new one. The generic bulk write callback is
> much smaller and only wakes up the tty layer (in case it was sleeping,
> waiting for data to be transmitted to the device).
> */
> 
> static void pl2303_read_int_callback(struct urb *urb)
> {
> 	struct usb_serial_port *port =  urb->context;
> 	unsigned char *data = urb->transfer_buffer;
> 	unsigned int actual_length = urb->actual_length;
> 	int status = urb->status;
> 	int retval;
> 
> 	dbg("%s (%d)", __func__, port->number);
> 
> 	switch (status) {
> 	case 0:
> 		/* success */
> 		break;
> 	case -ECONNRESET:
> 	case -ENOENT:
> 	case -ESHUTDOWN:
> 		/* this urb is terminated, clean up */
> 		dbg("%s - urb shutting down with status: %d", __func__,
> 		    status);
> 		return;
> 	default:
> 		dbg("%s - nonzero urb status received: %d", __func__,status);
> 		goto exit;
> 	}
> 
> 	usb_serial_debug_data(debug, &port->dev, __func__, urb->actual_length,
> urb->transfer_buffer);
> 
> 	pl2303_update_line_status(port, data, actual_length); // data == 0 PC 
get
> hanged.
> 
> exit:
> 	retval = usb_submit_urb(urb, GFP_ATOMIC);
> 	if (retval)
> 		dev_err(&urb->dev->dev,"%s - usb_submit_urb failed with result
> %d\n",__func__, retval); }
> 
> static void pl2303_read_bulk_callback(struct urb *urb)
> {
> 	struct usb_serial_port *port =  urb->context;
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	struct tty_struct *tty;
> 	unsigned char *data = urb->transfer_buffer;
> 	unsigned long flags;
> 	int i;
> 	int result;
> 	int status = urb->status;
> 	u8 line_status;
>    //     u8 control;
> 	char tty_flag;
> 
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	if (status)
>         {
> 	  	dbg("%s - urb status = %d", __func__, status);
> 		if (!port->open_count)
>                       {
> 			   dbg("%s - port is closed, exiting.", __func__);
> 		           return;
> 		      }
> 		if (status == -EPROTO)
>                 {
> 			/* PL2303 mysteriously fails with -EPROTO reschedule  
the read */
> 			dbg("%s - caught -EPROTO, resubmitting the urb",
> 			    __func__);
> 			urb->dev = port->serial->dev;
> 			result = usb_submit_urb(urb, GFP_ATOMIC);
> 			if (result)
> 				dev_err(&urb->dev->dev, "%s - failed" " 
resubmitting read urb, error
> %d\n",__func__, result);
> 			return;
> 		 }
> 
>                   dbg("%s - unable to handle the error, exiting.",
> __func__); return;
> 	 }
> 
> 	usb_serial_debug_data(debug, &port->dev, __func__,urb->actual_length,
> data);
> 
> 	/* get tty_flag from status */
> 	tty_flag = TTY_NORMAL;
> 	 spin_lock_irqsave(&priv->lock, flags);
> 	line_status = priv->line_status;
> 	priv->line_status &= ~UART_STATE_TRANSIENT_MASK;
>         spin_unlock_irqrestore(&priv->lock, flags);
>         wake_up_interruptible(&priv->delta_msr_wait);
> 
> 	/* break takes precedence over parity, */
> 	/* which takes precedence over framing errors */
> 	if (line_status & UART_BREAK_ERROR )
> 		tty_flag = TTY_BREAK;
> 	else if (line_status & UART_PARITY_ERROR)
> 		tty_flag = TTY_PARITY;
> 	else if (line_status & UART_FRAME_ERROR)
> 		tty_flag = TTY_FRAME;
> 	dbg("%s - tty_flag = %d", __func__, tty_flag);
> 
> 	tty = port->tty;
> 	if (tty && urb->actual_length) {
> 		tty_buffer_request_room(tty, urb->actual_length + 1);
> 		/* overrun is special, not associated with a char */
> 		if (line_status & UART_OVERRUN_ERROR)
> 			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
> 		for (i = 0; i < urb->actual_length; ++i)
> 			tty_insert_flip_char(tty, data[i], tty_flag);
> 		tty_flip_buffer_push(tty);
> 	}
> 
> 	/* Schedule the next read _if_ we are still open */
>      /*	if (port->open_count)
>          {
> 		urb->dev = port->serial->dev;
> 		result = usb_submit_urb(urb, GFP_ATOMIC);
> 		if (result)
> 			dev_err(&urb->dev->dev, "%s - failed resubmitting"
> 				" read urb, error %d\n", __func__, result);
> 	 } */
>     //     mdelay(5);
> 	return;
> }
> 
> // Implementation of pl2303_write_bulk_callback merely reports if the urb
> was completed successfully or not and then returns.
> 
> static void pl2303_write_bulk_callback(struct urb *urb)
> {
> 	struct usb_serial_port *port =  urb->context;
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	int result;
> 	int status = urb->status;
> 
> 	dbg("%s - port %d", __func__, port->number);
> 
> 	switch (status)
>      {
> 			  case 0:
> 				  /* success */
> 				      break;
> 			   case -ECONNRESET:
> 			   case -ENOENT:
> 			   case -ESHUTDOWN:
> 			    /* this urb is terminated, clean up */
> 			      dbg("%s - urb shutting down with status: %d", 
__func__, status);
> 			      priv->write_urb_in_use = 0;
> 			      return;
> 
> 			    default:
> 		/* error in the urb, so we have to resubmit it */
> 		dbg("%s - Overflow in write", __func__);
> 		dbg("%s - nonzero write bulk status received: %d", 
__func__,status);
> 
>               // Original is this
> 		/* port->write_urb->transfer_buffer_length = 1;
> 		port->write_urb->dev = port->serial->dev;  */
> 
> 	      // I m trying date 2/08/2010
> 		port->write_urb->transfer_buffer_length = 1;
> 		port->write_urb->dev = port->serial->dev;
> 		result = usb_submit_urb(port->write_urb, GFP_ATOMIC);
> 
> 		//Below sentence Hangs the PC....We need 2 restart the PC.
>               //      result = usb_submit_urb(0, GFP_ATOMIC);
> 		if (result)
> 			dev_err(&urb->dev->dev, "%s - failed resubmitting 
write"" urb, error
> %d\n", __func__, result);
> 		else
> 			return;
> 	}
> 
> 	priv->write_urb_in_use = 0;
> 
> 	/* send any buffered data */
> 	pl2303_send(port);
> }
> 
> /* All of the device info needed for the PL2303 SIO serial converter */
> static struct usb_serial_driver pl2303_mcm_device = {
> 	.driver = {
> 		.owner =	THIS_MODULE,
> 		.name =		"pl2303_mcm",
> 	},
> 	.id_table =		id_table,
> 	.usb_driver = 		&pl2303_mcm_driver,
> 	.num_ports =		1,
> 	.open =			pl2303_open,
> 	.close =		pl2303_close,
> 	.write =		pl2303_write,
> 	.ioctl =		pl2303_ioctl,
>     	.break_ctl =		pl2303_break_ctl,
> 	.set_termios =		pl2303_set_termios,
> 	.tiocmget =		pl2303_tiocmget,
> 	.tiocmset =		pl2303_tiocmset,
> 	.read_bulk_callback =	pl2303_read_bulk_callback,
> 	.read_int_callback =	pl2303_read_int_callback,
>         .write_bulk_callback =	pl2303_write_bulk_callback,            
//
> tried commenting write_bulk_callback bt nothing was going out....
> 	.write_room =		pl2303_write_room,
> 	.chars_in_buffer =	pl2303_chars_in_buffer,
> 	.attach =		pl2303_startup,
> 	.shutdown =		pl2303_shutdown,
> };
> 
> static int __init pl2303_init(void)
> {
> 	int retval;
> 
> 	retval = usb_serial_register(&pl2303_mcm_device);
> 	if (retval)
> 		goto failed_usb_serial_register;
> 	retval = usb_register(&pl2303_mcm_driver);
> 	if (retval)
> 		goto failed_usb_register;
> 	info(DRIVER_DESC);
> 	return 0;
> failed_usb_register:
> 	usb_serial_deregister(&pl2303_mcm_device);
> failed_usb_serial_register:
> 	return retval;
> }
> 
> static void __exit pl2303_exit(void)
> {
> 	usb_deregister(&pl2303_mcm_driver);
> 	usb_serial_deregister(&pl2303_mcm_device);
> }
> 
> module_init(pl2303_init);
> module_exit(pl2303_exit);
> 
> MODULE_DESCRIPTION(DRIVER_DESC);
> MODULE_LICENSE("GPL");
> 
> module_param(debug, bool, S_IRUGO | S_IWUSR);
> MODULE_PARM_DESC(debug, "Debug enabled or not");
> 
> kindly Help me sir.
> 
> Thanks & Regards,
> Raju
> ------- End of Forwarded Message -------
> 
> 
> --
> Open WebMail Project (http://openwebmail.org)
