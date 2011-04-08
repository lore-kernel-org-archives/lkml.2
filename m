Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab1DHPNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 11:13:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56989 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1DHPNn (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 8 Apr 2011 11:13:43 -0400
Date: Fri, 8 Apr 2011 11:12:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110408151256.GD9971@dumpdata.com>
References: <20110323125105.GA6599@dumpdata.com>
 <4D89F2DE.7020209@shipmail.org>
 <20110323145246.GA7546@dumpdata.com>
 <4D8AF834.8040700@shipmail.org>
 <20110324142509.GA32416@dumpdata.com>
 <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com>
 <20110324162135.GA835@dumpdata.com>
 <4D8CF46F.2070206@shipmail.org>
 <20110331154954.GA7695@dumpdata.com>
 <4D9F224A.60902@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F224A.60902@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D9F25FC.0066:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 04:57:14PM +0200, Thomas Hellstrom wrote:
> Konrad,
> 
> Sorry for waiting so long to answer. Workload is quite heavy ATM.
> Please see inline.

OK. Thank you for taking a look... some questions before you
depart on vacation.

> >  1). Get in the patch that passed in 'struct dev' to the dma_alloc_coherent
> >   for 2.6.39 so that PowerPC folks can use the it with radeon cards. My
> >   understanding is that the work you plan on to isn't going in 2.6.39
> >   but rather in 2.6.40 - and if get my stuff ready (the other phases)
> >   we can work out the kinks together. This way also the 'struct dev'
> >   is passed in the TTM layer.
> 
> I'm not happy with this solution. If something goes in, it should be
> complete, otherwise future work need to worry about not breaking
> something that's already broken. Also it adds things to TTM api's

<nods>
> that are not really necessary.
> 
> 
> I'd like to see a solution that  encapsulates all device-dependent
> stuff (including the dma adresses) in the ttm backend, so the TTM
> backend code is the only code that needs to worry about device

I am a bit confused here. The usual "ttm backend" refers to the
device specific hooks (so the radeon/nouveau/via driver), which
use this structure: ttm_backend_func

That is not what you are referring to right?
> dependent stuff. Core ttm should only need to worry about whether
> pages can be transferrable to other devices, and whether pages can
> be inserted into the page cache.

Ok. So the core ttm would need to know the 'struct dev' to figure
out what the criteria are for transferring the page (ie, it is
Ok for a 64-bit card to use a 32-bit card's pages, but not the other
way around)..

> 
> This change should be pretty straightforward. We move the ttm::pages
> array into the backend, and add ttm backend functions to allocate
> pages and to free pages. The backend is then completely free to keep
> track of page types and dma addresses completely hidden from core
> ttm, and we don't need to shuffle those around. This opens up both
> for completely device-private coherent memory and for "dummy device"
> coherent memory.

The 'dummy device' is a bit of hack thought? Why not get rid
of that idea and just squirrel away the the 'struct dev' and let the
ttm::backend figure out how to allocate the pages?

> 
> In the future, when TTM needs to move a ttm to another device, or
> when it needs to insert pages into the page cache, pages that are
> device specific will be copied and then freed. "Dummy device" pages
> can be transferred to other devices, but not inserted into the page
> cache.

OK. That would require some extra function in the ttm::backend to
say "dont_stick_this_in_page_cache".
