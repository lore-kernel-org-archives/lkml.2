Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2DPXYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:24:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49949 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab2DPXYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:24:10 -0400
MIME-Version: 1.0
In-Reply-To: <1334617382.25353.14.camel@pasglop>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca> <1334617382.25353.14.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Apr 2012 17:23:50 -0600
X-Google-Sender-Auth: mYbwoa_J87fOY2_35IcIYMvXoZU
Message-ID: <CACxGe6tgoSwKbioaTo7Ma8c4R-=0s_7dOjYRR8Gj-og5EVqMfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx
 interrupt controller
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:
>> The mpc8xx driver uses a reference to NR_IRQS that is buggy.  It uses
>> NR_IRQs for the array size of the ppc_cached_irq_mask bitmap, but
>> NR_IRQs could be smaller than the number of hardware irqs that
>> ppc_cached_irq_mask tracks.
>>
>> Also, while fixing that problem, it became apparent that the interrupt
>> controller only supports 32 interrupt numbers, but it is written as if
>> it supports multiple register banks which is more complicated.
>>
>> This patch pulls out the buggy reference to NR_IRQs and fixes the size
>> of the ppc_cached_irq_mask to match the number of HW irqs.  It also
>> drops the now-unnecessary code since ppc_cached_irq_mask is no longer
>> an array.
>
> Can you rename ppc_cached_irq_mask while at it ? I think it was written
> that way because it was all copy/pasted from powermac/pic.c which -does-
> need it to be an array (and has the same bugs btw) :-)
>
> I wonder if we can get rid of the cached mask alltogether... I have the
> feeling that we could just rely on the irq_desc fields nowadays for
> that... this code is ancient.

The irq_desc fields aren't ideal because they are per-irq and would
need to be &'ed together for each mask/unmask/ack operation.  We could
store something in the irq_domain I suppose, but I'm not convinced it
is worth it for an interrupt controller that will only ever have one
instance in the system.  If I were to refactor any deeper than I have,
then I'm move this driver over to use irq_generic_chip instead.

g.
