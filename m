Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1ISMHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 08:07:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58306 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1ISMHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 08:07:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110918062144.GF3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
	<1316017900-19918-6-git-send-email-robherring2@gmail.com>
	<CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
	<4E71CE5D.9030900@ti.com>
	<20110916160939.GA2100@arm.com>
	<20110918062144.GF3523@ponder.secretlab.ca>
Date: Mon, 19 Sep 2011 13:07:37 +0100
Message-ID: <CA+wbFddVw5+CDMzNXE9Q4-v4kByQmC6xp-rK5e81ChbYFGVe=A@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
From: Dave Martin <dave.martin@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 7:21 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Sep 16, 2011 at 05:09:39PM +0100, Dave Martin wrote:
>> For now, we express the mapping by putting an interrupt-map in the
>> core-tile DT, but this feels inelegant as well as wasteful -- expressing
>> "+ 32" using a table which is about 1K in size and duplicates that
>> information 43 times.
>>
>> Using a dedicated irq domain or a fake interrupt controller node to
>> encapsulate the motherboard interrupts feels like a cleaner approach,
>> but for now I'm not clear on the best way to do it.
>
> An irq nexus node would indeed be something to investigate for your
> particular case.  Look for examples of interrupt-map.  It is most
> often used for handling IRQ swizzling on PCI busses.

That's what I currently have -- this is logically correct, and it
works; it just feels like a sledgehammer for cracking this particular
nut, because we don't really have 43 independent interrupt mappings
and types.  We have one offset and one type which is applied to all
the interrupts, and this situation is expected to be the same for all
variations of this board, except that offset may change.  I suspect
this situation applies to many platforms -- the number of interrupts
may in general be much larger than the number of independent mappings.

Another way of looking at the problem is that it's difficult to come
up with a one-size-fits-all description of interrupt mappings which is
also efficient.  Requiring a single set of mapping semantics requires
the mappings to be both rather overspecified for most cases, and
flattened into a large, structureless table which may become pretty
large and unwieldy.  If there were 100+ interrupts instead of 43, we'd
really have to be generating the device tree using a script in order
for it to be maintainable (which is not necessarily a problem, but can
be a warning sign)

An alternative approach is to introduce a special interrupt controller
node which serves as the interrupt-parent for the child domain and
maps the interrupts with flexible semantics defined by the node's
bindings; or different kinds of interrupt-map/interrupt-map-mask
properties could be defined.  Bindings could be added as needed to
support different cases -- though really we should only expect to have
a small number at most.  When the interrupt mapping is significantly
complex, using interrupt-map will probably be the best approach
anyway.


This is just a view for discussion.

For now, I'll keep the interrupt-map for VE. since although it feels
inefficient it is at least obviously correct.

Cheers
---Dave
