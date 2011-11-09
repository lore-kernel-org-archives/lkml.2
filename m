Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1KILwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:52:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34489 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1KILwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:52:13 -0500
MIME-Version: 1.0
Date: Wed, 9 Nov 2011 20:52:12 +0900
Message-ID: <CAME+iuf1xWb=oJkaP9Dm0G2Tbrx_TUGD+DJ58mNfROeovE3+sQ@mail.gmail.com>
Subject: worker thread - filp_close() problem
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have a device driver where in I have to do like this:

(I am using Kernel 2.6.32, and unfortunately cannot upgrade).

1. Register for an interrupt.
2. When I receive the interrupt, I do some processing, and schedule a
worker for further processing after 25 msec.
(The device data sheet says I have to give a minimum of 20 m sec).
3. The worker thread has to do some processing and then program
another device connected to the serial port.

Problem:
1. as long as I don't call the program_serial_dev() from
my_dev_task(), everything is fine.
2. When I call the program_serial_dev(), I am, getting the error
(console freezes as well):
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:485 flush_cpu_workqueue+0x34/0x88()
[<c003f92c>] (unwind_backtrace+0x0/0xd8) from [<c006404c>]
(warn_slowpath_common+0x48/0x60)
[<c006404c>] (warn_slowpath_common+0x48/0x60) from [<c0072ce4>]
(flush_cpu_workqueue+0x34/0x88)
[<c0072ce4>] (flush_cpu_workqueue+0x34/0x88) from [<c0214988>]
(tty_ldisc_release+0x20/0x68)
[<c0214988>] (tty_ldisc_release+0x20/0x68) from [<c0210340>]
(tty_release+0x3c0/0x420)
[<c0210340>] (tty_release+0x3c0/0x420) from [<c00b8a84>] (__fput+0x104/0x1d8)
[<c00b8a84>] (__fput+0x104/0x1d8) from [<c00b5b94>] (filp_close+0x6c/0x78)
[<c00b5b94>] (filp_close+0x6c/0x78) from [<c00731f0>]
(worker_thread+0x150/0x1c4)
[<c00731f0>] (worker_thread+0x150/0x1c4) from [<c0076194>] (kthread+0x78/0x80)
[<c0076194>] (kthread+0x78/0x80) from [<c003ae60>] (kernel_thread_exit+0x0/0x8)
---[ end trace 1b75b31a2719ed1e ]---

3. I isolated the program_serial_dev() and called that function
through an IOCTL, it works fine.

However, I have to achieve this only within the driver code, since
application is not in a position to do this ioctl.
How can I achieve this?

Thanks in advance
Murali

static DECLARE_DELAYED_WORK(my_dev_work, my_dev_task);

static unsigned char config[]=
{
    0xFC,0xF3,0x3B,0x1E,0x3A,0x80,0x00,
    0xFC,0xF3,0x3B,0x1E,0x32,0x00,0x00,
    0xFC,0xF3,0x3B,0x1E,0x41,0x00,0x02,
    0xFC,0xF3,0x3B,0x1E,0x3E,0x02,0x00,
    0xFC,0xF3,0x3B,0x1E,0x44,0x01,0xC7,
    0xFC,0xF3,0x3B,0x1E,0x86,0x00,0x0F,
    0xFC,0xF3,0x3B,0x1F,0x87,0x00,0x08,
    0xFC,0xF3,0x3B,0x1E,0x3A,0x00,0x00,
    0xFC,0xF3,0x37,0x1E,0xE8,
    0xFC,0xF3,0x60,0x26,
    0xFC,0xF3,0x60,0x25
};

static int my_dev_write(struct file *f, unsigned char *buf, int count)
{
    int result;
    mm_segment_t oldfs;

    oldfs = get_fs();
    set_fs(KERNEL_DS);
    f->f_pos = 0;
    result = f->f_op->write(f, buf, count, &f->f_pos);
    set_fs(oldfs);
    return result;
}

void program_serial_dev(void)
{
    int ret;
    struct file * se_port;

    se_port = filp_open( "dev/ttyS1", O_RDWR | O_NOCTTY | O_NONBLOCK, 0);
    if (IS_ERR(se_port))
    {
        printk(KERN_ERR "Serial port open error\n");
        return;
    }
    else
    {
        ret = my_dev_write(se_port, config, sizeof(config));
        filp_close(se_port, 0);
    }
}

static void my_dev_task(struct work_struct * unused)
{
    // do something...
    program_serial_dev();
}

static irqreturn_t my_irq_thread(int irq, void *data)
{
    //Check GPIO status etc..
    //my dev data sheet says I have to do this 25 milli seconds later...
    schedule_delayed_work(&dev_work,msecs_to_jiffies(25));
    return IRQ_HANDLED;
}

static int __devinit my_dev_probe(struct spi_device *spi)
{
    //do some init stuff.

    err = request_threaded_irq (MYDEV_IRQ, NULL, my_irq_thread,
            IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING, "MY_DEV", NULL);
    //finish other stuff
}
