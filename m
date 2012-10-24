Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab2JXALs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:11:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:61587 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab2JXALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:11:46 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: Re: [RFC PATCH 02/06] input/rmi4: Core files
Date: Tue, 23 Oct 2012 17:11:41 -0700
Message-ID: <5515083.K7EXLgnYa6@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50872C54.4090505@synaptics.com>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com> <20121011081351.GA32175@core.coreip.homeip.net> <50872C54.4090505@synaptics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 23, 2012 04:46:28 PM Christopher Heiny wrote:
> On 10/11/2012 01:13 AM, Dmitry Torokhov wrote:
> > On Thu, Oct 11, 2012 at 04:15:56AM +0000, Christopher Heiny wrote:
> >> On Thursday, October 11, 2012 02:21:53 AM you wrote:
> >>> On Sat, Oct 6, 2012 at 6:09 AM, Christopher Heiny <cheiny@synaptics.com> 
wrote:
> >>>> +
> >>>> +/** This is here because all those casts made for some ugly code.
> >>>> + */
> >>>> +static void u8_and(u8 *dest, u8 *target1, u8 *target2, int nbits)
> >>>> +{
> >>>> +       bitmap_and((long unsigned int *) dest,
> >>>> +                  (long unsigned int *) target1,
> >>>> +                  (long unsigned int *) target2,
> >>>> +                  nbits);
> >>>> +}
> >>> 
> >>> Hm, getting rid of unreadable casts is a valid case.
> >>> 
> >>> I'll be OK with this but maybe the real solution is to introduce such
> >>> helpers into <linux/bitmap.h>?
> >> 
> >> Hmmm.  We'll give that some thought.  Thought I'd like to get the RMI4
> >> driver nailed down, just to keep the area of change small.  Once we've
> >> got all the kinks worked out here, we'll look at bitmap.h helpers.
> > 
> > The question is why you are using u8 for bitmaps instead of doing
> > DECALRE_BITMAP() and using it instead? Then you would not need silly
> > wrappers around existing APIs.
> 
> OK, we'll look into that.  My big concern is whether the bit-order in
> bitmask.h will be the same as the bit order in the RMI4 sensor
> registers.  If that works out OK, we'll switch.

I think if you properly convert data to/from cpu-endianness it will clear 
matters a lot.


> 
> >>> (...)
> >>> 
> >>>> +static int process_interrupt_requests(struct rmi_device *rmi_dev)
> >>>> +{
> >>>> +       struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
> >>>> +       struct device *dev = &rmi_dev->dev;
> >>>> +       struct rmi_function_container *entry;
> >>>> +       u8 irq_status[data->num_of_irq_regs];
> >>> 
> >>> Looking at this...
> >>> 
> >>> What does the data->num_of_irq_regs actually contain?
> >>> 
> >>> I just fear that it is something constant like always 2 or always 4,
> >>> so there is actually, in reality, a 16 or 32 bit register hiding in
> >>> there.
> >>> 
> >>> In that case what you should do is to represent it as a u16 or u32 here,
> >>> just or the bits into a status word, and then walk over that status
> >>> word with something like ffs(bitword); ...
> >> 
> >> Nope, it's not constant.  In theory, and RMI4 based sensor can have up
> >> to 128 functions (in practice, it's far fewer), and each function can
> >> have as many as 7 interrupts.  So the number of IRQ registers can vary
> >> from RMI4 sensor to RMI4 sensor, and needs to be computed during the
> >> scan of the product descriptor table.
> > 
> > Is it a good idea to have it on stack then? Should it be part of
> > rmi_device instead?
> 
> It's not coming off the stack.  We're allocating it via devm_kzalloc()
> in rmi_driver_probe().

No, look at the part of the code that was quoted. "u8 irq_status[data-
>num_of_irq_regs];" is on stack.

Thanks.

-- 
Dmitry
