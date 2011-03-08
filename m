Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1CHKx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 05:53:57 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:51789 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1CHKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 05:53:55 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D760AF6.7030809@cam.ac.uk>
Date: Tue, 08 Mar 2011 10:54:46 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: Moving staging:iio over to threaded interrupts.
References: <4D6FCC99.6090202@cam.ac.uk> <alpine.LFD.2.00.1103081055160.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103081055160.2787@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/11 10:30, Thomas Gleixner wrote:
> On Thu, 3 Mar 2011, Jonathan Cameron wrote:
>> So to my mind two solutions exist.
>> 1) A single thread per trigger.  Everything prior to the work queue
>> calls is moved into a handler that goes in the 'fast' list which stays
>> in our top half handler.  The work queue bits are called one after
>> another in the bottom half.
>>
>> 2) Allow each consumer to attach it's own thread to the trigger
>> controller and basically implement our own variant of the core threaded
>> interrupt code that allows for a list of threads rather than a single one.
>>
>> I rather like the idea of 2.  It might even end up with different
>> devices being queried from different processor cores simultaneously
>> which is quite cute.  The question is whether a simple enough
>> implementation is possible that the originators of the threaded interrupt
>> code would be happy with it (as it bypasses or would mean additions to their
>> core code).
> 
> Don't implement another threading model. Look at the trigger irq as a
> demultiplexing interrupt. So if you have several consumers of a single
> trigger, then you can implement a pseudo irq_chip and register the sub
> devices as separate interrupts.
> 
> That means your main trigger interrupt would look like this:
> 
> irqreturn_t hardirq_handler(int irq, void *dev)
> {
>      iio_trigger_dev *idev = dev;
>      int i;
> 
>      store_state_as_necessary(idev);
> 
>      for (i = 0; i < idev->nr_subirqs; i++) {
>      	    if (idev->subirqs[i].enabled)
> 		generic_handle_irq(idev->subirq_base + i);
>      }
> }
> 
> And you'd have an irq_chip implementation which does:
> 
> static void subirq_mask(struct irq_data *d)
> {
>      iio_trigger_dev *idev = irq_data_get_irq_chip_data(d);
>      int idx = d->irq - idev->subirq_base;
> 
>      idev->subirqs[idx].enabled = false;
> }
> 
> static void subirq_unmask(struct irq_data *d)
> {
>      iio_trigger_dev *idev = irq_data_get_irq_chip_data(d);
>      int idx = d->irq - idev->subirq_base;
> 
>      idev->subirqs[idx].enabled = true;
> }
> 
> static struct irq_chip subirq_chip = {
>        .name = "iiochip",
>        .mask = subirq_mask,
>        .unmask = subirq_unmask,
> };
> 
> init()
> {
> 	for_each_subirq(i)
> 		irq_set_chip_and_handler(i, &subirq_chip, handle_simple_irq);
> }
> 
> So now you can request the interrupts for your subdevices with
> request_irq or request_threaded_irq.
> 
> You can also implement #1 this way, you just mark the sub device
> interrupts as IRQ_NESTED_THREAD, and then call the handlers from the
> main trigger irq thread.
Excellent.  I hadn't thought of doing it that way at all and it certainly looks
like a much cleaner option than what we have now let alone the mess I was suggesting
above.

Will have a go at implementing this asap.

Thanks for the advice,

Jonathan

