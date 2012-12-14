Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab2LNJUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 04:20:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:9608 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab2LNJUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 04:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,279,1355126400"; 
   d="scan'208";a="180828664"
Message-ID: <1355476799.31620.89.camel@smile>
Subject: Re: [PATCH 2/2] dmatest: check for dma mapping error
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Date: Fri, 14 Dec 2012 11:19:59 +0200
In-Reply-To: <20121214003328.46cba41c.akpm@linux-foundation.org>
References: <1355139464-6855-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1355139464-6855-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20121213153437.b8b0198d.akpm@linux-foundation.org>
	 <CAHp75VfxyyqaAOTsXQfEaiQm8tPetG2JZUm-XrezzdL01qoYiA@mail.gmail.com>
	 <20121214003328.46cba41c.akpm@linux-foundation.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 00:33 -0800, Andrew Morton wrote: 
> On Fri, 14 Dec 2012 09:06:03 +0200 Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> 
> > On Fri, Dec 14, 2012 at 1:34 AM, Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > > On Mon, 10 Dec 2012 13:37:44 +0200
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > >
> > >> We get a warning if CONFIG_DMA_API_DEBUG=y
> > >>
> > >> [   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> > >> [   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]
> > 
> > >> --- a/drivers/dma/dmatest.c
> > >> +++ b/drivers/dma/dmatest.c
> > >> @@ -378,15 +378,35 @@ static int dmatest_func(void *data)
> > >>
> > >>                       dma_srcs[i] = dma_map_single(dev->dev, buf, len,
> > >>                                                    DMA_TO_DEVICE);
> > >> +                     ret = dma_mapping_error(dev->dev, dma_srcs[i]);
> > >> +                     if (ret) {
> > >> +                             unmap_src(dev->dev, dma_srcs, len, i);
> > >> +                             pr_warn("%s: #%u: mapping error %d with "
> > >> +                                     "src_off=0x%x len=0x%x\n",
> > >> +                                     thread_name, total_tests - 1, ret,
> > >> +                                     src_off, len);
> > >> +                             failed_tests++;
> > >> +                             continue;
> > >> +                     }
> > >
> > > The changelog and the code don't match.  Which one is out of date?
> > 
> > I'm afraid I didn't get what is wrong.
> > 
> 
> The above code will not emit the string "dw_dmac dw_dmac.0: DMA-API:
> device driver failed to check map error[device
> address=0x0000000035698305] [size=14365 bytes] [mapped as single]".
> 
> Oh I see what you did.  That string is emitted by the kernel at
> present, and the patch prevents this.  And it also emits a new warning
> if the mapping attempt failed, and that new warning wasn't described.

Ah, okay, thank you.

> I updated the changelog:

Yes, you right, the changelog in my case describes  only part of the
problem.

> : The kernel emits a warning if CONFIG_DMA_API_DEBUG=y:
> : 
> : [   28.150631] WARNING: at lib/dma-debug.c:933 check_unmap+0x5d6/0x6ac()
> : [   28.157058] dw_dmac dw_dmac.0: DMA-API: device driver failed to check map error[device address=0x0000000035698305] [size=14365 bytes] [mapped as single]
> : 
> : Fix this by adding the required checking of the dma_map_single() return
> : value.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
