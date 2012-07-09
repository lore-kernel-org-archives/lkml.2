Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2GINwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:52:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58026 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab2GINwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
References: <20120708040009.GA8363@localhost>
	<CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
	<alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
Date: Mon, 9 Jul 2012 22:52:41 +0900
Message-ID: <CAAmzW4PRYtsY33JTiOr496cj__PHJNZ5ZY5X+Co1FGYcebu8Ww@mail.gmail.com>
Subject: Re: WARNING: __GFP_FS allocations with IRQs disabled (kmemcheck_alloc_shadow)
From: JoonSoo Kim <js1304@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rus <rus@sfinxsoft.com>, Ben Hutchings <ben@decadent.org.uk>,
        Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/9 David Rientjes <rientjes@google.com>:
> On Mon, 9 Jul 2012, JoonSoo Kim wrote:
>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 8c691fa..5d41cad 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -1324,8 +1324,14 @@ static struct page *allocate_slab(struct
>> kmem_cache *s, gfp_t flags, int node)
>>                 && !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>>                 int pages = 1 << oo_order(oo);
>>
>> +               if (flags & __GFP_WAIT)
>> +                       local_irq_enable();
>> +
>>                 kmemcheck_alloc_shadow(page, oo_order(oo), flags, node);
>>
>> +               if (flags & __GFP_WAIT)
>> +                       local_irq_disable();
>> +
>>                 /*
>>                  * Objects from caches that have a constructor don't get
>>                  * cleared when they're allocated, so we need to do it here.
>
> This patch is suboptimal when the branch is taken since you just disabled
> irqs and now are immediately reenabling them and then disabling them
> again.  (And your patch is also whitespace damaged, has no changelog, and
> isn't signed off so it can't be applied.)

My intent is just to provide reference, because there is no replay to
this thread when I see it.


> The correct fix is what I proposed at
> http://marc.info/?l=linux-kernel&m=133754837703630 and was awaiting
> testing.  If Rus, Steven, or Fengguang could test this then we could add
> it as a stable backport as well.

Your patch looks good to me.
