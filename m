Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1JaDLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:11:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33631 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1JaDLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:11:45 -0400
Date: Mon, 31 Oct 2011 11:11:36 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Frank =?utf-8?B?U2No77+9ZmVy?= <fschaefer.oss@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on device removal when using a workqueue and
 delayed_work
Message-ID: <20111031031136.GA18057@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <4EADA32E.6030200@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EADA32E.6030200@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 08:19:10PM +0100, Frank Sch�fer wrote:
> Hi,
> 
> with the following simple kernel module, I have a good chance to get
> a kernel panic when I unplug the device:
> 
> 
> #include <linux/workqueue.h>
> #include <linux/usb.h>
> #include <linux/module.h>
> 
> MODULE_AUTHOR("Nobody");
> MODULE_DESCRIPTION("example driver for causing kernel panic");
> MODULE_LICENSE("GPL");
> 
> static struct delayed_work poll_work;
> 
> static void poll(struct work_struct *work)
> {
>     schedule_delayed_work(&poll_work,
>                   msecs_to_jiffies(100));
> }
> 
> static int test_probe(struct usb_interface *intf,
>               const struct usb_device_id *id)
> {
>     INIT_DELAYED_WORK(&poll_work, poll);
>     schedule_delayed_work(&poll_work,
>                   msecs_to_jiffies(100));
>     return 0;
> }
> 
> static void test_disconnect(struct usb_interface *intf)
> {
>     cancel_delayed_work_sync(&poll_work);
> }
> 
> static const struct usb_device_id device_table[] = {
>     {USB_DEVICE(0x1234, 0x5678)},
>     {}
> };
> 
> MODULE_DEVICE_TABLE(usb, device_table);
> 
> static struct usb_driver test_driver = {
>     .name       = "test",
>     .id_table   = device_table,
>     .probe      = test_probe,
>     .disconnect = test_disconnect,
> };
> 
> static int __init test_mod_init(void)
> {
>     return usb_register(&test_driver);
> }
> 
> static void __exit test_mod_exit(void)
> {
>     usb_deregister(&test_driver);
> }
> 
> module_init(test_mod_init);
> module_exit(test_mod_exit);
> 
> 
> 
> 
> A picture of the backtrace (the machine immediately turns off
> without saving a backtrace) can be found at
> 
> http://imageshack.us/photo/my-images/823/img075gv.jpg
> 
> Kernel version is 3.1.0.
> 
> 
> This is the first time I'm using a workqueue, so there is a good
> chance that I missed something...

You should cancel the work you have armed before exit.
See cancel_delayed_work().

> Or is this a kernel bug ?

I don't think so.

Thanks,
Yong
