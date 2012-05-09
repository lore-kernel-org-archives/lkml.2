Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab2EIQlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:41:09 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:45216 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756989Ab2EIQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205081417120.27713@router.home>
References: <1336503339-18722-1-git-send-email-pshelar@nicira.com>
	<1336504276.3752.2600.camel@edumazet-glaptop>
	<alpine.DEB.2.00.1205081417120.27713@router.home>
Date: Wed, 9 May 2012 09:41:05 -0700
Message-ID: <CALnjE+pExzAS4bk89RD4XJtHtSyB2g0qMsqdrGWPuD27axiNBw@mail.gmail.com>
Subject: Re: [PATCH] mm: sl[auo]b: Use atomic bit operations to update page-flags.
From: Pravin Shelar <pshelar@nicira.com>
To: Christoph Lameter <cl@linux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 12:22 PM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 8 May 2012, Eric Dumazet wrote:
>
>> On Tue, 2012-05-08 at 11:55 -0700, Pravin B Shelar wrote:
>> > Transparent huge pages can change page->flags (PG_compound_lock)
>> > without taking Slab lock. So sl[auo]b need to use atomic bit
>> > operation while changing page->flags.
>> > Specificly this patch fixes race between compound_unlock and slab
>> > functions which does page-flags update. This can occur when
>> > get_page/put_page is called on page from slab object.
>>
>>
>> But should get_page()/put_page() be called on a page own by slub ?
>
> Can occur in slab allocators if the slab memory is used for DMA. I dont
> like the performance impact of the atomics. In particular slab_unlock() in
> slub is or used to be a hot path item. It is still hot on arches that do
> not support this_cpu_cmpxchg_double. With the cmpxchg_double only the
> debug mode is affected.
>

I agree this would impact performance. I am not sure how else we can
fix this issue. As far as slab_unlock in hot path case is concerned,
it is more likely to corrupt page->flags in that case.
