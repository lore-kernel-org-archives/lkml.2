Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab0FKMZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:25:10 -0400
Received: from web94914.mail.in2.yahoo.com ([203.104.17.188]:23992 "HELO
	web94914.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759976Ab0FKMZI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:25:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Fu/fBL4xeybZDwBDo+6xROL83bzBAGXV2U3mo7oC06W8QyJtt1+AVDJRI223aptNO9U8xnXlEdIhBi4Y7GB3N5KpHks+/JP8FAXC/vwTRGVpENVg4SMbZ7VfJjH4hp6VwYOE2XInIS64tIQSYDpnaz1DfQD5xZur4CvWJ3iRqlY=;
Message-ID: <840278.13741.qm@web94914.mail.in2.yahoo.com>
X-YMail-OSG: cXZZHS8VM1kscD0x1bfl9_AqAXm9bVE5bp6KtvgTi_BjrL2
 cBQA3T7L1BVR9qnpgEq_9yVHI.YjLpEgAwT4O0hYxaGSDOB2gQheD0BS4z8G
 7H5mjbhjtJ0K0V.UKeC5FtLutquwr1EyZILdM5dxnMAk_al.PA9oCqm2ysel
 TNCRdb2yGr1pEd4nvFvtZ0jjshlEhVXoR3EfPi_Mr_a6gcY7UwKiwWIpXnDp
 FMIXRJrFu7Dsck9Qi5pLDE8oCGfbmn7R7A9MJz7rF5FjsRA--
X-Mailer: YahooMailClassic/11.1.3 YahooMailWebService/0.8.103.269680
Date: Fri, 11 Jun 2010 17:55:04 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: RE: [PATCH] drivers: staging: GPS protocol driver for wl128x
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <141474.48175.qm@web94902.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan, (slightly long mail warning..)

as I mentioned before, the problem is how can I know which platform device's registration caused the tty_open to be called ?

Background: [apart from the mail chain below...]
A platform driver by name ST_0 allows registration of certain protocol driver like BT_0 to be registered onto it, and use it as the transport.

This plat driver ST_O now signals the user-space to open up a TTY device and install the ldisc on top of it. (ldisc being ST_0's registered ldisc during it's plat probe).

Now the plat driver's tty_open previously registered is called, but here lies the problem - On what basis do I know that it was because of ST_0 and also How can I send the device number 'x' information in ttySx for user-space application to open/tiocsetd on that device.


All these problems would be solved, if only we could open/tiocsetd a ldisc from the kernel space - basically the ability to claim/use a TTY interface.
something like,

tty_register_ldisc(N_TI_WL, &ldisc_ops, UART_NUM_1);
tty_set_ldisc(); from ldisc drivers itself.. 

please comment...


> Here are the 2 ST platform devices,
> struct platform_device st_device_0 = {
>         .name = "ST_DEV_0",
>         .id = -1,
>         .dev.platform_data =
> &array,
>         .dev.release =
> any_device_release,
> };
> struct platform_device st_device_1 = {
>         .name = "ST_DEV_1",
>         .id = -1,
>         .dev.platform_data =
> &array,
>         .dev.release =
> any_device_release,
> };
>
> BT attaching itself to ST_DEV_0,
> static struct protocol_platform_data bt_data = {
>         .parent_dev =
> &st_device_0,
>         .name = "BT",
> };
>
> static struct platform_device bt_device = {
>         .name = "BT",
>         .id = -1,
>         .dev.platform_data =
> &bt_data,
>         .dev.release =
> bt_device_release,
> };
>
> And FM attaching itself to - ST_DEV_1,
> static struct protocol_platform_data fm_data = {
>         .parent_dev =
> &st_device_1,
>         .name = "FM",
> };
> static struct platform_device fm_device = {
>         .name = "FM",
>         .id = -1,
>         .dev.platform_data =
> &fm_data,
>         .dev.release =
> fm_device_release,
> };
>
> My "ST_REGISTER" would now look like,
> int st_register(struct protocol_platform_data *data)
> {
>         struct st_data_s *st_data;
>         struct platform_device *parent
> = data->parent_dev;
>
>         st_data =
> dev_get_drvdata(&parent->dev);
>
>         printk("%s registering into
> %s\n", data->name, parent->name);
>
>         printk("data got is %s\n",
> st_data->name);
>         st_data->name = "Changed
> Name";
>         return 0;
> }
> EXPORT_SYMBOL(st_register);


