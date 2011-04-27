Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab1D0QjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:39:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1D0QjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:39:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
Date: Wed, 27 Apr 2011 18:37:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
References: <Pine.LNX.4.44L0.1104271224030.2239-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104271224030.2239-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104271837.53983.arnd@arndb.de>
X-Provags-ID: V02:K0:TYJrut9HgkWWsw+FAIokhmYPrZ3FnbDy38nNUvBme7E
 6nk9yiiOp3S8a/V3hbijFnNeBspID+9n/u4tJdG+En3nT84IjG
 HWG7w5wOAPV49QnR4qZCZGd42/UkTAO7bxGvoAPIgXKLLaoKDA
 BGA/pCaY1msOZbhO1nGq4pWhmj2yoO38n423qKNqCgAUyPd40i
 AZFU9lFwMYae5HDSMzpoQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 18:25:40 Alan Stern wrote:
> On Wed, 27 Apr 2011, Rabin Vincent wrote:
> 
> > On Wed, Apr 27, 2011 at 00:21, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Tue, 26 Apr 2011, Rabin Vincent wrote:
> > >> In my case it's this writel() in ehci-hub.c that gets chopped into
> > >> strbs:
> > >>
> > >> � � � /* force reset to complete */
> > >> � � � ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
> > >> � � � � � � � � � � � � � � � status_reg);
> > >
> > > Why would that get messed up? �The status_reg variable doesn't have any
> > > __atribute__((packed)) associated with it.
> > 
> > The initialization of status_reg is:
> > 
> >       u32 __iomem *status_reg
> >               = &ehci->regs->port_status[(wIndex & 0xff) - 1];
> > 
> > where ehci->regs is a pointer to the packed struct ehci_regs.  So, this
> > is the same problem of casting pointers to stricter alignment.
> 
> Right.  I can understand the compiler complaining about the cast to 
> stricter alignment during the initialization.  But I don't understand 
> why that would affect the code generated for the writel function.

The compiler does not complain, it just silently assumes that it needs
to do byte accesses. There is no way to tell the compiler to ignore
what it knows about the alignment, other than using inline assembly
for the actual pointer dereference. Most architectures today do that,
but on ARM it comes down to "*(u32 *)status_reg = temp".

	Arnd
