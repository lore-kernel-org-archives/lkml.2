Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab0EHChI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 22:37:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58219 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0EHChG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 22:37:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bLnKyjfQyUBsKtsbHfb3f5e3+JvT0SzAkqf6uLOWtoI+nNHqaAOXcKkHLcSISOV12q
         4QGotwX4ia/yu/cOJG9pbphJ9hMEFcSAht9ZVXKk1mTJZdjQOams9vM+lbXAxNDLIZXf
         ZSD/A3RASIhQWKJ8k50cFN7rRJnYEHiPr0D/Y=
MIME-Version: 1.0
In-Reply-To: <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
References: <1272848060-28049-1-git-send-email-linus.walleij@stericsson.com>
	 <i2t63386a3d1005070213u2ad32613w694be1ecbeb46856@mail.gmail.com>
	 <20100507093256.GB19936@n2100.arm.linux.org.uk>
	 <x2j63386a3d1005070443yfadbaf3ct8686a8f7aae6412f@mail.gmail.com>
	 <j2r1b68c6791005070531u57b4b1basc56d45d0e06b1d04@mail.gmail.com>
	 <k2k63386a3d1005070910kcdb516dcga60c24043b1b44de@mail.gmail.com>
Date: Sat, 8 May 2010 11:37:02 +0900
Message-ID: <m2u1b68c6791005071937s5b2bbb60p6de395a6c06a963e@mail.gmail.com>
Subject: Re: [PATCH 0/7] DMAENGINE: fixes and PrimeCells
From: jassi brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>,
       Dan Williams <dan.j.williams@intel.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 8, 2010 at 1:10 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> Surely circular linked buffers and other goodies can be retrofitted into the
> DMAengine without a complete redesign? I only see a new slave call
> to support that really, in addition to the existing sglist interface.
well, before taking up the PL330 dma api driver, 'async' character of it
was the only concern I had in mind. That still is, but I came across a
a few more peculiarities while implementing the driver.

a) Async:- For lazy transfers of mem to mem this may be ok.
  But there might be devices the employ DMA to do extensive M2M transfers
  (say dedicated multimedia oriented devices) the 'async' nature might be
  a bottleneck. So too for M<=>D with a fast device with shallow FIFO.
  There may be clients that don't wanna do much upon DMA done, but they
  do need notifications ASAP.  By definition, this API forbids such
expectations.
 IMHO, a DMA api should be as quick as possible - callbacks done in IRQ context.
 But since there maybe clients that need to do sleepable stuff in
callbacks, the API
 may do two callbacks - 'quick' in irq context and 'lazy' from
tasklets scheduled from
 the IRQ. Most clients will provide either, while some may provide
both callback functions.

b) There seems to be no clear way of reporting failed transfers. The
device_tx_status
    can get FAIL/SUCSESS but the call is open ended and can be performed
    without any time bound after tx_submit. It is not very optimal for
DMAC drivers
    to save descriptors of all failed transactions until the channel
is released.
    IMHO, provision of status checking by two mechanisms: cookie and dma-done
   callbacks is complication more than a feature. Perhaps the dma
engine could provide
   a default callback, should the client doesn't do so, and track
done/pending xfers
  for such requests?

c) Conceptually, the channels are tightly coupled with the DMACs,
there seems to be
   no way to be able to schedule a channel among more than one DMACs
in the runtime,
   that is if more then one DMAC support the same channel/peripheral.
   For example, Samsung's S5Pxxxx have many channels available on more
than 1 DMAC
   but for this dma api we have to statically assign channels to
DMACs, which may result in
   a channel acquire request rejected just because the DMAC we chose
for it is already
   fully busy while another DMAC, which also supports the channel, is idling.
   Unless we treat the same peripheral as, say, I2STX_viaDMAC1 and
I2STX_viaDMAC2
   and allocate double resources for these "mutually exclusive" channels.

d) Something like circular-linked-request is highly desirable for one
of the important DMA
   clients i.e, audio.

e) There seems to be no ScatterGather support for Mem to Mem transfers.

Or these are just due to my cursory understanding of the DMA Engine core?...

Of course, there are many good features of this API which any API
should provide.

regards.
