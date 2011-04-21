Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1DUBPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:15:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35064 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab1DUBPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SEa7aMMafd/fXATIzPJP1ArDtgARiSQ/PnypiY+LFQvK1EUnKztRr1Q3r4dZyveqHQ
         /wkRPf6ScG+08tom9VIRNGlP0Fwln5/rXS5orSgUBxAjduKPYokdDnyENUEV6yTbnUJp
         8d++U0b7Kh4KY7SMPBFJb86UG0/ZpkJ9vevI0=
MIME-Version: 1.0
In-Reply-To: <4DAEE410.8020000@cam.ac.uk>
References: <BANLkTi=1svkDQt+HyaHgnann1Vre7CLUNQ@mail.gmail.com>
	<BANLkTimFd0ZuP2OQ4A_w7VFbDDN+rsvBtg@mail.gmail.com>
	<BANLkTi=9dROLwWH2J=Y_FmP+t=rkjMLBJg@mail.gmail.com>
	<4DAEE410.8020000@cam.ac.uk>
Date: Thu, 21 Apr 2011 10:15:14 +0900
Message-ID: <BANLkTikGGBCL4wA3gL_W0EaD02yJQDnO9Q@mail.gmail.com>
Subject: Re: SPI read problem
From: "Murali K. Vemuri" <vemuri.muralikrishna@gmail.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: =?UTF-8?B?5b6Q5bu66L6J?= <xujianhui168@gmail.com>,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:48 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> On 04/20/11 05:40, Murali K. Vemuri wrote:
>> On Wed, Apr 20, 2011 at 12:19 PM, 徐建辉 <xujianhui168@gmail.com> wrote:
>>> you can use tasklet.
>>>
>>> 2011/4/19 Murali K. Vemuri <vemuri.muralikrishna@gmail.com>
>>>>
>>>> Hello there,
>>>> I have a device which is Written_to/Read_from using SPI Bus.
>>>>
>>>> I initialize the device like this:
>>>>
>>>> static int __init myDEV_init(void)
>>>> {
>>>>    return spi_register_driver(&myDEV_driver);
>>>> }
>>>> module_init(myDEV_init);
>>>>
>>>> My myDEV_probe() function looks like this:
>>>>
>>>> static int __devinit myDEV_probe(struct spi_device *spi)
>>>> {
>>>> .....
>>>> .....
>>>> /*when my CPU receives a particular IRQ, I have to do a spi_read() and
>>>> do couple of spi_write(), I am using like this:*/
>>>> err = request_threaded_irq (MY_DEV_IRQ, NULL, myDEV_irq_thread,
>>>>            IRQF_TRIGGER_RISING, "MYDEV", NULL);
> This should be fine.  The thread can sleep just fine. We do this
> all over the place.  Could be something to do with the irq
> handling on the device.
>>>>
>>>> return 0;
>>>> }
>>>>
>>>> When the Interrupt is received by the CPU, myDEV_irq_thread is being
>>>> called.
>>>> However, in the ISR I have to do  spi_read(). This is always returning
>>>> "Timed out".
> That's very suspicious.  What spi controller are we dealing with here?
>>>>
>>>> To verify if the device is not at all working, along with registering
>>>> for the IRQ, I also created a char device through I did a IOCTL.
>>>> The IOCTL command in turn does spi_read(). In this case spi_read() is
>>>> successful.
>>>>
>>>> Since it is necessary to do spi_read() in my ISR, I searched around
>>>> and found some information that
>>>> spi_read() is callable only from contexts that can sleep.
>>>>
>>>> How can I make my ISR sleep? or is there any other way of doing this?
>>>>
>>>> Any help is highly appreciated.
>>>> Thanks & regards
>>>> Murali
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>>
>>
>> Hi there,
>>
>> I tried using "tasklet", "workqueue" and semaphore ... all my attempts failed.
>> if there is any other method I should try, please let me know.
> Something nastier is happening here.  It's not a problem with what you've
> presented in this email.  Perhaps a minimum example of the full code surrounding
> the problem may help us diagnose it.
>

Thanks a lot for the inputs. this is the read function I have:
(What  I am trying to do is read register E6 of my device, the
register width is 16 bits.).

static struct spi_device * my_SPI_DEV; (this is populated in the probe function)

static int myDEV_read(u8 * buf, u16 len)
{
    int err;
    err = spi_read(my_SPI_DEV, buf, len);
    return err;
}
static int read_e6()
{
    u8 buf[3];
    int err;
    buf[0] = 0xe6;
    buf[1] = 0x00;
    buf[2] = 0x00;
    err = myDEV_read(buf, 3);
    printk(KERN_ERR "myDEV read returned: %d\n",err);
    return err;
}

Now, this function read_e6() is called from the ISR I mentioned above.

90% of time, the read returns "-5" (I/O Error) and about 10% time it
gets "0".  However I added a little hexdump to check the content in
case the return value is "0". The register content is always "0".

Please let me know if I am doing any mistake.
Thanks & regards
Murali
