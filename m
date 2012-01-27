Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab2A0OvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:51:16 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16644 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2A0OvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:51:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Date: Fri, 27 Jan 2012 15:51:09 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory
 Allocator
In-reply-to: <CAO8GWqnQg-W=TEc+CUc8hs=GrdCa9XCCWcedQx34cqURhNwNwA@mail.gmail.com>
To: "'Clark, Rob'" <rob@ti.com>
Cc: "'Ohad Ben-Cohen'" <ohad@wizery.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jonathan Corbet'" <corbet@lwn.net>, "'Mel Gorman'" <mel@csn.ul.ie>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Dave Hansen'" <dave@linux.vnet.ibm.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <010301ccdd03$1ad15ab0$50741010$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Aczc/9N/Cw3RTRnfSzy0/R+u+SrJPwAAqCog
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
 <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com>
 <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com>
 <CAO8GWqnQg-W=TEc+CUc8hs=GrdCa9XCCWcedQx34cqURhNwNwA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, January 27, 2012 3:28 PM Clark, Rob wrote:

> 2012/1/27 Marek Szyprowski <m.szyprowski@samsung.com>:
> > Hi Ohad,
> >
> > On Friday, January 27, 2012 10:44 AM Ohad Ben-Cohen wrote:
> >
> >> With v19, I can't seem to allocate big regions anymore (e.g. 101MiB).
> >> In particular, this seems to fail:
> >>
> >> On Thu, Jan 26, 2012 at 11:00 AM, Marek Szyprowski
> >> <m.szyprowski@samsung.com> wrote:
> >> > +static int cma_activate_area(unsigned long base_pfn, unsigned long count)
> >> > +{
> >> > +       unsigned long pfn = base_pfn;
> >> > +       unsigned i = count >> pageblock_order;
> >> > +       struct zone *zone;
> >> > +
> >> > +       WARN_ON_ONCE(!pfn_valid(pfn));
> >> > +       zone = page_zone(pfn_to_page(pfn));
> >> > +
> >> > +       do {
> >> > +               unsigned j;
> >> > +               base_pfn = pfn;
> >> > +               for (j = pageblock_nr_pages; j; --j, pfn++) {
> >> > +                       WARN_ON_ONCE(!pfn_valid(pfn));
> >> > +                       if (page_zone(pfn_to_page(pfn)) != zone)
> >> > +                               return -EINVAL;
> >>
> >> The above WARN_ON_ONCE is triggered, and then the conditional is
> >> asserted (page_zone() retuns a "Movable" zone, whereas zone is
> >> "Normal") and the function fails.
> >>
> >> This happens to me on OMAP4 with your 3.3-rc1-cma-v19 branch (and a
> >> bunch of remoteproc/rpmsg patches).
> >>
> >> Do big allocations work for you ?
> >
> > I've tested it with 256MiB on Exynos4 platform. Could you check if the
> > problem also appears on 3.2-cma-v19 branch (I've uploaded it a few hours
> > ago) and 3.2-cma-v18? Both are available on our public repo:
> > git://git.infradead.org/users/kmpark/linux-samsung/
> >
> > The above code has not been changed since v16, so I'm really surprised
> > that it causes problems. Maybe the memory configuration or layout has
> > been changed in 3.3-rc1 for OMAP4?
> 
> is highmem still an issue?  I remember hitting this WARN_ON_ONCE() but
> went away after I switched to a 2g/2g vm split (which avoids highmem)

No, it shouldn't be an issue. I've tested CMA v19 on a system with 1GiB of
the memory and general purpose (global) cma region was allocated correctly
at the end of low memory. For device private regions you should take care 
of correct placement by yourself, so maybe this is an issue in this case?

Ohad, could you tell a bit more about your issue? Does this 'large region'
is a device private region (declared with dma_declare_contiguous()) or is it
a global one (defined in Kconfig or cma= kernel boot parameter)? 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


