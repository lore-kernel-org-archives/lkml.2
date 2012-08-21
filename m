Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2HUHps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:45:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2HUHpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:45:07 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
Date: Tue, 21 Aug 2012 07:44:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, "spear-devel" <spear-devel@list.st.com>
References: <502BC31E.4070200@yahoo.es> <503326CE.40301@yahoo.es> <CAKohponN16krs-WWw6Abh1fLPO3+iYndTaxsPDfeXCoS9OHufQ@mail.gmail.com>
In-Reply-To: <CAKohponN16krs-WWw6Abh1fLPO3+iYndTaxsPDfeXCoS9OHufQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208210744.53370.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:7P91Y9Vw5VAiESIq3GWtrALBXAEvRileFvI5e9uusYH
 pYicf8H2VuwawZ92ZLP/04lnCcanRruah4YkLk0S1MW7kGRu55
 gPT4pD8Y3Sw91TrN21TFerN4+FHyCIHV4iLAo1Og2V8eseFJtj
 yqesT3vWz52rxFyFh1Rg9MdnxZEQ3n57fHFk5mLQLM7O8Q7mGL
 Q5q1NmqrKEi6UizpokJ0Z8rW2UwPkwP18+KU/PNTuMNfIBS83K
 mJAqedR7D92cmhIYxD4RN/LTDgfogVe/RK4Bib1O1b12LVREgS
 VeY2JfS5z9FNXqc7yB5q14kbYiHtAfuAFIClq5nqtqjIdvqKSi
 B5WAhYdtlYtUQvPun44xPT2dogKoK8G12YE14z+eM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 August 2012, Viresh Kumar wrote:
> On 21 August 2012 11:42, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> 
> > On 8/21/2012 12:42 PM, viresh kumar wrote:
> > > Ahhhh!! Firstly we can't use __raw* for architectures >= ARMv6. It is not
> > > only for endianess but for memory barriers. Why are they getting swapped
> > > for your case? Does your processor and dw_dmac have different endianess?
> >
> > If I'm not wrong: the __raw_* functions will access the i/o memory in
> > native endianess.
> > As far as I know, all AVR32 drivers are currently using the __raw*
> > functions. I never
> > encountered  a problem with that.
> >
> 
> I don't have the best knowledge in this area :( and so cc-ing Arnd who can
> help us here.
> So my perception of these routines is:
> 
> readl is defined generically as:
> 
> #define readl(addr) __le32_to_cpu(__raw_readl(addr))
> 
> Which converts to a simple __raw_readl() for little endian systems and
> swapped bytes for a big endian system.

readl does much more than that:

* It guarantees that read accesses arrive at the device in the order they
  are written in the source code
* It maintains ordering between DMA and MMIO accesses
* It computes the correct address to dereference from an __iomem token.
* It guarantees that the access is done in a single atomic load, rather
  than a series of byte accesses.

All this is necessary to make device drivers work in general, although
on many simple (strictly ordered) architectures a pointer dereference
will do the same thing. Device drivers should never use the __raw_*
accessors themselves. Some architectures define their own bus-specific
accessors, but not everyone thinks that is a good idea.

> You wrote in the beginning
> >> - After 2.6.39, the registers were accessed using readl/writel
> >>   in stead of the __raw_readl and __raw_writel causing a 16-bit
> >>   swap of all values (little endian access)
> 
> What's this 16-bit swap here? It should be a 8 bit swap by __swab32()
> routine.
> 
> Is AVR32 a big-endian system? Probably big-endian, that's why values are
> getting
> swapped. And dw_dmac is the standard one, can call it little endian for the
> time being.
> 
> @Arnd: What should we do here?

Yes, AVR32 is big-endian. I assume that dw_dmac can be either configured
as little-endian or big-endian and that it is configured as big-endian
on AVR32.

To solve this, we can either make the endianess of dw_dmac run-time
detected, or we add a configuration symbol for it and use either
ioread32_be() or readl(), depending how this is set. This symbol
can be hardwired by architectures on which it is known in advance.
I've also seen some devices that can be configured into either
endianess, so if this is true for the dw_dmac, we could just force
it to be little-endian all the time.

	Arnd
