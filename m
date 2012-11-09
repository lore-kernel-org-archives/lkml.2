Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2KIGLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 01:11:35 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52889 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2KIGLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 01:11:31 -0500
MIME-Version: 1.0
In-Reply-To: <201210301021.42803.b.zolnierkie@samsung.com>
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
	<1351504796-24788-5-git-send-email-b.zolnierkie@samsung.com>
	<CABb+yY1Ztu2n38ObXJq+shOoXw6yk0YK39QUHhDN_pJKziAFQg@mail.gmail.com>
	<201210301021.42803.b.zolnierkie@samsung.com>
Date: Fri, 9 Nov 2012 11:41:30 +0530
Message-ID: <CAJe_ZhdOt+T65FdkE0SpQ37uGsS8SkFyJ9hHM3B_8S8f7GQAcQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] DMA: PL330: add device tree property for DMA_MEMCPY capability
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, kgene.kim@samsung.com,
        pawel.moll@arm.com, vinod.koul@intel.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
        dinguyen@altera.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 October 2012 14:51, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> On Monday 29 October 2012 22:45:48 Jassi Brar wrote:
>> On Mon, Oct 29, 2012 at 10:59 AM, Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com> wrote:
>> > * Add device tree (DT) property ("pl330,dma-memcpy") for DMA_MEMCPY
>> >   capability and instead of setting this capability unconditionally
>> >   in pl330_probe() do it only when property is present.
>> >
>> Perhaps we should pass the array of peripheral interfaces via DT, the
>> lack of which could imply MEMCPY capability ? (while it works, I doubt
>> if pl330 is supposed to have SLAVE and MEMCPY capabilities in any
>> instance)
>
> In case of PL330 on EXYNOS4 we have two interfaces with SLAVE capability
> and one interface with MEMCPY capability.  Could you please explain more
> the idea of passing the array of peripherals through DT so we can detect
> which interface has MEMCPY capability?
>
The DT node of a 'pdma' should have the array of indices of
peripherals it caters to (what is currently peri_id of 'struct
dma_pl330_platdata'). The array would be missing in the DT node of
'mdma' since all channels are equal.
During probe if the array, say as property 'peri_map', is missing from
DT node of the dmac, that would imply the dmac is 'mdma' and hence the
pl330.c sets DMA_MEMCPY in its cap_mask. Otherwise the peri_map
implies a 'pdma' and hence SLAVE|CYCLIC is set.


>> That would also be a step towards discarding "struct dma_pl330_platdata".
>
> I don't know if getting rid of "struct dma_pl330_platdata" is possible
> but we still need to come up with some way to pass the needed information
> through DT.  Do you have an idea how it could be done?
>
struct dma_pl330_platdata {
  u8 nr_valid_peri;
  u8 *peri_id;
      As explain above, these two should move to DT node of the dma controller.

  dma_cap_mask_t cap_mask;
      Should be set in pl330.c : MEMCPY for mdma,  SLAVE|CYCLIC for pdma

  unsigned mcbuf_sz;
      Currently unused and already safe enough default value set in driver.
}
