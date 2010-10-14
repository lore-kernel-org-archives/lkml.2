Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab0JNNsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:48:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0JNNsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=skIkziXMlaORoXTUd+MONn+l9Fw3pXcWL0SO5JmYBW190zmo3vJ467ToTWzYJdrC2e
         65j6BjHpiWJdnkGaqT8l+VAYCg4Obi9ulMyIxRuaz0v7TlBMVTc0ryAf/r4AnPWTHNci
         /dY2T4AFOHYHptbJMZ3cpR2ZM1MGtmE9VntIw=
MIME-Version: 1.0
In-Reply-To: <13B9B4C6EF24D648824FF11BE896716203D760F19C@dlee02.ent.ti.com>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<20101008231926.GA28235@kroah.com>
	<alpine.LFD.2.00.1010082242390.3107@xanadu.home>
	<AANLkTi=BvXROFEnzYykoUQNbU05Q=mWoV3t7qKDk7+vL@mail.gmail.com>
	<13B9B4C6EF24D648824FF11BE896716203D760F19C@dlee02.ent.ti.com>
Date: Thu, 14 Oct 2010 16:48:00 +0300
Message-ID: <AANLkTinu3wL536szc2mxe3HTAz9yduDHnOU+oP_wOHT-@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Arnd Hannemann <arnd@arndnet.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Pedanekar, Hemant" <hemantp@ti.com>, Greg KH <greg@kroah.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 7:17 PM, Woodruff, Richard <r-woodruff2@ti.com> wrote:
>> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
>> bounces@lists.infradead.org] On Behalf Of Felipe Contreras
>> Sent: Saturday, October 09, 2010 5:01 AM
>
>> That's not true, drivers on ARMv6 and above do work. I still wonder
>> how exactly to trigger the issue, and how often does this happen,
>> because I've never seen it.
>
> On a Cortex-A8 if you enable auxcr.asa speculative accesses will be allowed to happen more broadly (cross outside of L2).  There are few failures which have been seen in testing which go away with its disable. Most Linux kernels have this feature off.  They still prefetch but with reduced scope.

I see, do you have some pointers as how to enable this to try it out?

> On Cortex-A9 to get performance there are prefetches at both A9 level and PL310 (L2 controller) level. Enabling them for some things gives a very good boost. It will increase your chances of hitting issues as it activates D-Side prefetch along with increasing the amount I side prefetch.  An A9 doesn't have auxcr to limit its prefetch to L2 like A8.  If there is a MMU table with a valid TLB its free game to speculate against and bring data in (for non device memory maps).
>
> I'm told A15 gets much more aggressive here. It has dedicated hardware resources (fill buffers ++) for speculation and not just competing against the current instruction stream for these resources.
>
> Having incoherent views and/or copies of data is not what you want. SMP should amplify the badness by doubling speculation sources and adding extra l1 caches. Killing the alias from ioremap is a good thing and something people should want for production.

Thanks for clarifying the situation.

However, nobody is proposing to not kill the ioremap() double alias,
only to make it a warning for now. One argument against this is that
would cause corruption on other parts of the system which doesn't seem
to be the case.

I take it you don't have a problem with making this a warning on .36,
and disable completely on .37 (or later). Right?

The real issue is the drivers relying on this behavior, which need to
be fixed regardless of this decision to warn, or disable.

-- 
Felipe Contreras
