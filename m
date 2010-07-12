Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0GLBZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:25:19 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6386 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608Ab0GLBZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:25:18 -0400
Message-ID: <09ac01cb2161$158c4650$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        <andrew.chih.howe.khor@intel.com>, "Intel OTC" <joel.clark@intel.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>
References: <4C204B0D.2030201@dsn.okisemi.com><4C32CB44.9010908@dsn.okisemi.com> <20100709130028.26174aa1.akpm@linux-foundation.org>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
Date: Mon, 12 Jul 2010 10:25:03 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew Morton

> The driver creates a character device /dev/pch_phub.  That device file
> supports the following operations:
>
> read(): <document the read operation - seems to read a serial ROM?>
> write():<document the write operation - seems to write a serial ROM?>
> ioctl():<document the ioctl operation - seems to read/write a MAC address?>
We will add the above.


> I suspect this function will do strange things if passed an initial
> *ppos which is outside the range of the ROM.  It looks like it will write
> a single byte into the ROM then will bale out.
>
>
> > + if (ret_value2) {
> > + err = ret_value2;
> > + goto return_err;
> > + }
> > +
> > + if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
>
> Is this off-by-one?

I understand OROM upper size check is not enough.
If the my understanding true, We will modify like below.
Can  you accept the following our modification ?

+static ssize_t pch_phub_write(struct file *file, const char __user *buf,
+       size_t size, loff_t *ppos)
+{
+ unsigned int data;
+ int ret_value1;
+ int ret_value2;
+ int err;
+ unsigned int addr_offset;
+ loff_t pos = *ppos;
+ int ret;
+
+ ret = mutex_lock_interruptible(&pch_phub_mutex);
+ if (ret) {
+ err = -ERESTARTSYS;
+ goto return_err_nomutex;
+ }
+
+ for (addr_offset = 0; addr_offset < size; addr_offset++) {
+ if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
+ *ppos += addr_offset;
+ goto return_ok;
+ }
+ ret_value1 = get_user(data, &buf[addr_offset]);
+ if (ret_value1) {
+ err = -EFAULT;
+ goto return_err;
+ }
+
+ ret_value2 = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
+ data);
+ if (ret_value2) {
+ err = ret_value2;
+ goto return_err;
+ }
+


Thanks, Ohtake

----- Original Message ----- 
From: "Andrew Morton" <akpm@linux-foundation.org>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>; "Wang, Yong Y" <yong.y.wang@intel.com>; <qi.wang@intel.com>;
<joel.clark@intel.com>; <andrew.chih.howe.khor@intel.com>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML"
<linux-kernel@vger.kernel.org>
Sent: Saturday, July 10, 2010 5:00 AM
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH


> On Tue, 06 Jul 2010 15:20:52 +0900
> Masayuki Ohtak <masa-korg@dsn.okisemi.com> wrote:
>
> > Hi Arnd
> >
> > I have modified for your comments.
> > Please confirm below.
> >
> > Thanks, Ohtake.
> >
> > ---
> > Packet hub driver of Topcliff PCH
> >
> > Topcliff PCH is the platform controller hub that is going to be used in
> > Intel's upcoming general embedded platform. All IO peripherals in
> > Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> > a special converter device in Topcliff PCH that translate AMBA transactions
> > to PCI Express transactions and vice versa. Thus packet hub helps present
> > all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> > Topcliff PCH has MAC address and Option ROM data.
> > These data are in SROM which is connected to PCIE bus.
> > Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> > SROM.
>
> That didn't describe the most important part of the driver: the
> userspace interface.  We should add here something along the lines of
>
> The driver creates a character device /dev/pch_phub.  That device file
> supports the following operations:
>
> read(): <document the read operation - seems to read a serial ROM?>
> write():<document the write operation - seems to write a serial ROM?>
> ioctl():<document the ioctl operation - seems to read/write a MAC address?>
>
> >
> > ...
> >
> > +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> > +       size_t size, loff_t *ppos)
> > +{
> > + unsigned int data;
> > + int ret_value1;
> > + int ret_value2;
> > + int err;
> > + unsigned int addr_offset;
> > + loff_t pos = *ppos;
> > + int ret;
> > +
> > + ret = mutex_lock_interruptible(&pch_phub_mutex);
> > + if (ret) {
> > + err = -ERESTARTSYS;
> > + goto return_err_nomutex;
> > + }
> > +
> > + for (addr_offset = 0; addr_offset < size; addr_offset++) {
> > + ret_value1 = get_user(data, &buf[addr_offset]);
> > + if (ret_value1) {
> > + err = -EFAULT;
> > + goto return_err;
> > + }
> > +
> > + ret_value2 = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
> > + data);
>
> I suspect this function will do strange things if passed an initial
> *ppos which is outside the range of the ROM.  It looks like it will write
> a single byte into the ROM then will bale out.
>
>
> > + if (ret_value2) {
> > + err = ret_value2;
> > + goto return_err;
> > + }
> > +
> > + if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
>
> Is this off-by-one?
>
> > + *ppos += addr_offset;
> > + goto return_ok;
> > + }
> > +
> > + }
> > +
> > + *ppos += addr_offset;
> > +
> > +return_ok:
> > + mutex_unlock(&pch_phub_mutex);
> > + return addr_offset;
> > +
> > +return_err:
> > + mutex_unlock(&pch_phub_mutex);
> > +return_err_nomutex:
> > + return err;
> > +}
> >
> > ...
> >
>



