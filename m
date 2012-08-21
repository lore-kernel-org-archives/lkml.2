Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2HUPFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:05:44 -0400
Received: from bosmailout04.eigbox.net ([66.96.189.4]:42377 "EHLO
	bosmailout04.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2HUPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:05:42 -0400
X-Greylist: delayed 2398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2012 11:05:41 EDT
X-Authority-Analysis: v=2.0 cv=XvJNzy59 c=1 sm=1
 a=lghRLfjGutYZE2O92ubooA==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=TNaJx8l5llIA:10 a=Q9fys5e9bTEA:10 a=ZbotsqAEwLAA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=5qXBsl0AVB-Z9rD9sl8A:9 a=PUjeQqilurYA:10
 a=eBvjjtMVdWwtQGedh7GyLg==:117
X-EN-OrigOutIP: 10.20.18.5
X-EN-IMPSID: pSRf1j00D06Zqne01SRfVQ
Message-ID: <50339A0B.6080803@yahoo.es>
Date: Tue, 21 Aug 2012 22:24:11 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd.bergmann@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] Fixes for dw_dmac and atmel-mci for AP700x
References: <502BC31E.4070200@yahoo.es> <201208210847.18700.arnd.bergmann@linaro.org> <CAKohpokoeSLBtLdh8hr4GKv8VOxzK8Vq5SoqLE3yC-TDyjYA9w@mail.gmail.com> <201208210905.52145.arnd.bergmann@linaro.org>
In-Reply-To: <201208210905.52145.arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.110
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/2012 5:05 PM, Arnd Bergmann wrote:
> It should be easy to tell from the object code whether this happened
> or not. If it did, then we can investigate why gcc did that, otherwise
> something else caused the strange byte swap.
>
> The safe way to define the readl() function in asm/io.h is to
> use an inline assembly that prevents the access from getting split,
> but avr32 just uses a pointer dereference here.
>
> I think I just found the answer elsewhere in
> arch/avr32/mach-at32ap/include/mach/io.h, which defines
>
> # define __mem_ioswabl(a, x)    swahb32(x)
>
> and that apparently does the halfword swap when CONFIG_AP700X_16_BIT_SMC
> is set. This explains why Havard said it's wrong to use readl on
> internal deviceson avr32, but unfortunately that rule conflicts with how
> we define the accessors on ARM.

I already thought the 16-bit swap might be related to the 16-bit SMC
configuration. SMC will fetch each u32 word in 2 different 16-bit banks
of SDRAM.

In a meanwhile I tried dw_dmac using iowrite32be/ioread32be, and it worked
equally well! Which isn't surprising because for AVR32 they were defined as:

#define iowrite32be(v,p)    __raw_writel(v, p)
#define ioread32be(p)        ((unsigned int)__raw_readl(p))

The 'relaxed' versions won't work because:

#define readl_relaxed            readl

The object code confirms what was expected:

    u32 val = ioread32be (((unsigned*)0x100)); /* Same as __raw_readl */
    ld.w  r8,pc[256]

    iowrite32be (val, ((unsigned*)0x104)); /* same as __raw_writel */
    st.w  pc[260],r8

    val = readl (((unsigned*)0x108)); /* __raw_readl + swahb32 */
    ld.w  r8,pc[264]
    lsl   r9,r8,0x10  /* 16-bit swap */
    or    r9,r9,r8>>0x10

    writel (val, ((unsigned*)0x10C)); /* swahb32 + __raw_writel */
    lsl   r8,r9,0x10  /* 16-bit swap */
    or    r8,r8,r9>>0x10
    st.w  pc[268],r8


Hein
