Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2HUJGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:06:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53320 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2HUJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:05:57 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
Date: Tue, 21 Aug 2012 09:05:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <502BC31E.4070200@yahoo.es> <201208210847.18700.arnd.bergmann@linaro.org> <CAKohpokoeSLBtLdh8hr4GKv8VOxzK8Vq5SoqLE3yC-TDyjYA9w@mail.gmail.com>
In-Reply-To: <CAKohpokoeSLBtLdh8hr4GKv8VOxzK8Vq5SoqLE3yC-TDyjYA9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208210905.52145.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:sOsSMvnMqM7J7247oe6kUha7TnFGcSZHn4B1nfKRiqG
 4uuUKWi7T7Q41daQOoOnRE5ox0uLN5IaKE3vBNpPi8sPA0JQYO
 hQfNNk86LFZMh0UZH3trY2XSBlIMJGcP3h4OkkrcBLoriXpS40
 QnN5iqs6axHJhsd8Pdb1Lfaogjs4Ta0rpj6sJyaLXsRMHk3o9v
 Nea8hpHWiHzGcTaeUM9C0qMsZbV8AISr1hjSRB454hgjiAW261
 7vOsggboCjtrMAyvsaywLKb4eOzt1zNhGzSwd8sZhYgftviLjX
 nXpEOUJylk0BlVnhQUoUKaOO0J9HpoHndFze3pdG+4KDPcRgNi
 J5wLQF93fP/KGzG1wzfQDbrpBAtD1pQR0fGmGQCih
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Viresh Kumar wrote:
> On 21 August 2012 14:17, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> 
> > On Tuesday 21 August 2012, Viresh Kumar wrote:
> > > On 21 August 2012 14:04, Arnd Bergmann <arnd.bergmann@linaro.org> wrote:
> > >
> > > > Yes, this is very strange. Maybe the compiler already splits the
> > > > access into two 16-byte loads and that confuses the device?
> > >
> > > @Arnd: Is compiler allowed to do that even when we have volatile
> > specified
> > > for the access? It shouldn't optimize the access at all i believe.
> >
> > Yes. The "volatile" keyword implies that the compiler has to do the access
> > exactly once and that it cannot reorder the access with others on the same
> > address, or read more data than is specified, but it can (and does) split
> > the access if there is a reason for that, e.g. when the address might
> > be misaligned and the architecture cannot do misaligned loads.
> 
> 
> But that can't be the case here. Isn't it? So we shouldn't have got such
> results.

It should be easy to tell from the object code whether this happened
or not. If it did, then we can investigate why gcc did that, otherwise
something else caused the strange byte swap.

The safe way to define the readl() function in asm/io.h is to
use an inline assembly that prevents the access from getting split,
but avr32 just uses a pointer dereference here.

I think I just found the answer elsewhere in
arch/avr32/mach-at32ap/include/mach/io.h, which defines

# define __mem_ioswabl(a, x)    swahb32(x)

and that apparently does the halfword swap when CONFIG_AP700X_16_BIT_SMC
is set. This explains why Havard said it's wrong to use readl on
internal deviceson avr32, but unfortunately that rule conflicts with how
we define the accessors on ARM.

	Arnd
