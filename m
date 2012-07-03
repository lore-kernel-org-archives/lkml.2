Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2GCKAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 06:00:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43134 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2GCKAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 06:00:21 -0400
From: "Du, Changbin" <changbin.du@gmail.com>
To: "'ABRAHAM, KISHON VIJAY'" <kishon@ti.com>
Cc: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <ben@simtec.co.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <4ff252e7.08d4440a.38ee.ffffd7b9@mx.google.com> <CAAe_U6J84JHSGQ2upXfnS_JPUfZwv9HD_xAyjK+8ybsZtuRpiQ@mail.gmail.com>
In-Reply-To: <CAAe_U6J84JHSGQ2upXfnS_JPUfZwv9HD_xAyjK+8ybsZtuRpiQ@mail.gmail.com>
Subject: RE: [PATCH 1/1] usb: gadget: s3c-hsotg: fix core reset timeout failure
Date: Tue, 3 Jul 2012 18:00:14 +0800
Message-ID: <4ff2c2b3.28d5440a.2b79.5241@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac1Y50Hn+fDDbIl5S8qrA9DzYajtxAAF1+zQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> On Tue, Jul 3, 2012 at 7:33 AM, Du, Changbin <changbin.du@gmail.com>
> wrote:
> > The timeout values were 1000 and timeout issue occured many times on my
> > s3c6410 Soc based board (mostly when booting whith USB cable not
> > connected). This patch increase the values to 10000 to guarantee the
> > success of reset.
> >
> > Having set timeout to 10000, I printed the remained timeout values
> > which can cause timeout issue before this change (tested several times):
> > the first timeout value remained:
> >         timeout = 8079
> >         timeout = 8079
> >         timeout = 8078
> >         timeout = 8081
> > the second timeout value remained:
> >         timeout = 7940
> >         timeout = 7945
> >         timeout = 7940
> >         timeout = 7938
> > Seeing from above values, I think 10000 is big enough.
> >
> > Signed-off-by: Du, Changbin <changbin.du@gmail.com>
> > ---
> >  drivers/usb/gadget/s3c-hsotg.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/usb/gadget/s3c-hsotg.c
b/drivers/usb/gadget/s3c-hsotg.c
> > index f4abb0e..f3e2234 100644
> > --- a/drivers/usb/gadget/s3c-hsotg.c
> > +++ b/drivers/usb/gadget/s3c-hsotg.c
> > @@ -2215,7 +2215,7 @@ static int s3c_hsotg_corereset(struct s3c_hsotg
> > *hsotg)
> >         /* issue soft reset */
> >         writel(GRSTCTL_CSftRst, hsotg->regs + GRSTCTL);
> >
> > -       timeout = 1000;
> > +       timeout = 10000;
> >         do {
> >                 grstctl = readl(hsotg->regs + GRSTCTL);
> >         } while ((grstctl & GRSTCTL_CSftRst) && timeout-- > 0);
> 
> how about msleep inside the loop?

I don't know if that's ok! The datasheet just says:
Once this bit is cleared software must wait at least 3 PHY clocks before
doing any access to the PHY domain.
Software must also check that bit 31 of this register is 1 (AHB Master is
IDLE) before starting any operation.

But it doesn't say how long to wait. I don't know if it can sleep for a
while and then check the register's value.
In fact, sometimes the AHB Master will be IDLE quickly(even only need read
once), but sometimes may need
Much more time. To reduce the risk, keeping it in original way may be
better.

Thanks!
Du, Changbin

> 
> Thanks
> Kishon

