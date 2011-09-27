Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1I0GEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:04:09 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:41069 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752113Ab1I0GEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:04:07 -0400
From: Partha Basak <p-basak2@ti.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>	<1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>	<CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
	<alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com> <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com>
In-Reply-To: <CAP05o4Lwk2uUz5ou84GQsrsBdjW-FEYP-55pBzH+a74hP4g1Dw@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acx8V1LL01JWEhnIQdWzROS/EBue7wAg4v6A
Date: Tue, 27 Sep 2011 11:34:00 +0530
Message-ID: <cbad72cea703d117067f7c628f7db806@mail.gmail.com>
Subject: RE: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
To: Keshava Munegowda <keshava_mgowda@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tero Kristo <t-kristo@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Felipe Balbi <balbi@ti.com>, parthab@india.ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anand Gadiyar <gadiyar@ti.com>,
        sameo@linux.intel.com, tony@atomide.com, Kevin Hilman <khilman@ti.com>,
        johnstul@us.ibm.com, Vishwanath Sripathy <vishwanath.bs@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Munegowda, Keshava [mailto:keshava_mgowda@ti.com]
>Sent: Monday, September 26, 2011 7:49 PM
>To: Paul Walmsley; Tero Kristo; b-cousson@ti.com; balbi@ti.com;
>parthab@india.ti.com
>Cc: linux-usb@vger.kernel.org; linux-omap@vger.kernel.org; linux-
>kernel@vger.kernel.org; gadiyar@ti.com; sameo@linux.intel.com;
>tony@atomide.com; khilman@ti.com; johnstul@us.ibm.com;
>vishwanath.bs@ti.com
>Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod
>structures for omap3
>
>On Sat, Sep 24, 2011 at 12:00 PM, Paul Walmsley <paul@pwsan.com> wrote:
>> On Fri, 23 Sep 2011, Munegowda, Keshava wrote:
>>
>>> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com>
>wrote:
>>>
>>> But the question arises here , why do we need these ehci and ohci as
>two
>>> different hwmods containing only irq and base address? It is required
>>> for future - to implement remote wakeup feature for ehci and ohci
>ports
>>> depending on irq-chain handler patches by Tero. Separate hwmods for
>ehci
>>> and ohci are needed to enable prcm chain-handler to uniquely identify
>>> the wakeup source as ehci or ohci and call only the corresponding
>>> interrupt handler. We will be using omap_hwmod_mux_init for ehci and
>>> ohci hwmods to enable I/O wakeup capability for respective IO-pads.
>>> Depending on the particular wakeup source(ehci/ohci), the
>corresponding
>>> ehci or ohci irq handler will be called.
>>>
>>> If ehci and ohci are combined with usbhs hwmod as a single hwmod ,
>then
>>> for every wakeup (either ehci or ohci port wakeup) only the first
>>> interrupt handler will be called (please look at the function
>>> omap_hwmod_mux_handle_irq of
>>>
>>> /arch/arm/mach-omap2/mux.c file ; in tero's latest patch:
>>> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg53139.html)
>>> , so in this
>>> case, if ehci interrupt is the first interrupt , then even for ohci
>wakeup
>>> , only ehci interrupt will get called; which will break the
>functionality.
>>
>> Any reason why this couldn't be handled either by:
>>
>> 1. adding an IRQ number field to struct omap_hwmod_mux_info, and
>changing
>> _omap_hwmod_mux_handle_irq() to raise that IRQ number?
>
>
>yes, it is possible by changing the existing irq-chain handler by tero
>Kristo
>
>I am looping tero too.
>
>So here are new requirements for the irq-chain handler
>
>1. The hwmod should have have option to have multiple mux structures
>
>This is something like:
>
>The existing mux structure definition in omap_hwmod [file:
>/arch/arm/plat-omap/include/plat/omap_hwmod.h ] structure
>
>	struct omap_hwmod_mux_info	*mux;
>
>it should changed to
>
>	struct omap_hwmod_mux_info	**pmux;
>         U32                                            mux_cnt;
>
>
>pmux - pointers to mux ; array of mux structures.
>mux_cnt - number of mux per hwmod.
>
>
>2. The mux  omap_hwmod_mux_info  structure should have new member
>called irq, like as follows:
>
>struct omap_hwmod_mux_info {
>	int				nr_pads;
>	...
>        ....
>        u32                           irq;
>
>};
>
>Upon wakeup of the I/O pad of the mux , the irq-chain handler should
>invoke the irq handler of the irq numbered <map_hwmod_mux_info.irq>
>
>3.  There should be "SOME WAY" to supply the irqs  from hwmod
>structure (omap_hwmod) to mux structure (omap_hwmod_mux_info)
>
>
>if you , tero and other opensource people are aligned on the proposed
>changes on the irq-handler ;
>then it is possible to have two hwmods ( usbhs and tll) for usbhost
>driver.
>please let me know you comments on the above approach.
>

Hello Tero,

I would like to draw your attention to the following thread:

We need to support the following:
1. Ability to associate multiple mux info to a hwmod.
2. Able to associate a particular irq handler to a mux info.
3. PRCM Chain handler should loop through all mux-info arrays
   for a particular hwmod to identify the possible wakeup source(s)
   and call the appropriate irq handler for that mux-info.
   (It is possible that both mux-info are woken up in which case both
handlers should be called).

To give you a little more perspective, EHCI & OHCI are co-controllers
under UHH/TLL.
They do not get presented separately to the OCP bus, hence do not qualify
as separate hwmods
(Paul had objected to the design approach representing EHCI & OHCI as
different hwmods).

However, we need a mechanism to efficiently identify/distinguish
remote-wakeup, connect/disconnect
On to an EHCI port vs an OHCI port & call only the correct interrupt
handler(EHCI or OHCI).

 To incorporate this, chain handler implementation would need some
enhancements.
 We can look into the details in the next merge window cycle in
conjunction with aggressive clock management support for EHCI/OHCI.
 But fundamentally, if you are aligned to the approach, we can go ahead
collapsing the EHCI & OHCI hwmods into one.
>
>>
>> or
>>
>> 2. using shared interrupts?
>>
>>
>> - Paul
>>
