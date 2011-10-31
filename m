Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab1JaK0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:26:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55226 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689Ab1JaK0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:26:23 -0400
Message-ID: <4EAE77F2.80102@googlemail.com>
Date: Mon, 31 Oct 2011 11:26:58 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: kernel panic on device removal when using a workqueue and delayed_work
References: <4EADA32E.6030200@googlemail.com> <20111031031136.GA18057@zhy>
In-Reply-To: <20111031031136.GA18057@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2011 04:11, schrieb Yong Zhang:
> On Sun, Oct 30, 2011 at 08:19:10PM +0100, Frank Sch�fer wrote:
>> Hi,
>>
>> with the following simple kernel module, I have a good chance to get
>> a kernel panic when I unplug the device:
>>
>>
>> #include<linux/workqueue.h>
>> #include<linux/usb.h>
>> #include<linux/module.h>
>>
>> MODULE_AUTHOR("Nobody");
>> MODULE_DESCRIPTION("example driver for causing kernel panic");
>> MODULE_LICENSE("GPL");
>>
>> static struct delayed_work poll_work;
>>
>> static void poll(struct work_struct *work)
>> {
>>      schedule_delayed_work(&poll_work,
>>                    msecs_to_jiffies(100));
>> }
>>
>> static int test_probe(struct usb_interface *intf,
>>                const struct usb_device_id *id)
>> {
>>      INIT_DELAYED_WORK(&poll_work, poll);
>>      schedule_delayed_work(&poll_work,
>>                    msecs_to_jiffies(100));
>>      return 0;
>> }
>>
>> static void test_disconnect(struct usb_interface *intf)
>> {
>>      cancel_delayed_work_sync(&poll_work);
>> }
...
>> static const struct usb_device_id device_table[] = {
>>      {USB_DEVICE(0x1234, 0x5678)},
>>      {}
>> };
>>
>> MODULE_DEVICE_TABLE(usb, device_table);
>>
>> static struct usb_driver test_driver = {
>>      .name       = "test",
>>      .id_table   = device_table,
>>      .probe      = test_probe,
>>      .disconnect = test_disconnect,
>> };
>>
>> static int __init test_mod_init(void)
>> {
>>      return usb_register(&test_driver);
>> }
>>
>> static void __exit test_mod_exit(void)
>> {
>>      usb_deregister(&test_driver);
>> }
>>
>> module_init(test_mod_init);
>> module_exit(test_mod_exit);
>>
>>
>>
>>
>> A picture of the backtrace (the machine immediately turns off
>> without saving a backtrace) can be found at
>>
>> http://imageshack.us/photo/my-images/823/img075gv.jpg
>>
>> Kernel version is 3.1.0.
>>
>>
>> This is the first time I'm using a workqueue, so there is a good
>> chance that I missed something...
> You should cancel the work you have armed before exit.
> See cancel_delayed_work().
That's what I'm doing (see above).
Did you read the code ? ;-)

Regards,
Frank Schaefer
>> Or is this a kernel bug ?
> I don't think so.
>
> Thanks,
> Yong

