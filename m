Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1J3TSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 15:18:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1J3TSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 15:18:35 -0400
Message-ID: <4EADA32E.6030200@googlemail.com>
Date: Sun, 30 Oct 2011 20:19:10 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel panic on device removal when using a workqueue and delayed_work
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with the following simple kernel module, I have a good chance to get a 
kernel panic when I unplug the device:


#include <linux/workqueue.h>
#include <linux/usb.h>
#include <linux/module.h>

MODULE_AUTHOR("Nobody");
MODULE_DESCRIPTION("example driver for causing kernel panic");
MODULE_LICENSE("GPL");

static struct delayed_work poll_work;

static void poll(struct work_struct *work)
{
     schedule_delayed_work(&poll_work,
                   msecs_to_jiffies(100));
}

static int test_probe(struct usb_interface *intf,
               const struct usb_device_id *id)
{
     INIT_DELAYED_WORK(&poll_work, poll);
     schedule_delayed_work(&poll_work,
                   msecs_to_jiffies(100));
     return 0;
}

static void test_disconnect(struct usb_interface *intf)
{
     cancel_delayed_work_sync(&poll_work);
}

static const struct usb_device_id device_table[] = {
     {USB_DEVICE(0x1234, 0x5678)},
     {}
};

MODULE_DEVICE_TABLE(usb, device_table);

static struct usb_driver test_driver = {
     .name       = "test",
     .id_table   = device_table,
     .probe      = test_probe,
     .disconnect = test_disconnect,
};

static int __init test_mod_init(void)
{
     return usb_register(&test_driver);
}

static void __exit test_mod_exit(void)
{
     usb_deregister(&test_driver);
}

module_init(test_mod_init);
module_exit(test_mod_exit);




A picture of the backtrace (the machine immediately turns off without 
saving a backtrace) can be found at

http://imageshack.us/photo/my-images/823/img075gv.jpg

Kernel version is 3.1.0.


This is the first time I'm using a workqueue, so there is a good chance 
that I missed something...
Or is this a kernel bug ?


Regards,
Frank Schaefer

