Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2AZVdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:33:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41187 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2AZVdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <4F204F1C.70908@gmail.com>
References: <1327352870-14687-1-git-send-email-grant.likely@secretlab.ca>
 <4F1DD6DF.4080706@gmail.com> <4F200DFD.7070407@ti.com> <4F204F1C.70908@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 26 Jan 2012 14:33:20 -0700
X-Google-Sender-Auth: Za2tvaPIK3qfm4nVIjUAhnAkbe4
Message-ID: <CACxGe6vA6CSCAU82uuMaycqDBt+JG3KvXzAURDWQ0Deyeg13Ow@mail.gmail.com>
Subject: Re: [RFCv2 00/14]
To: Rob Herring <robherring2@gmail.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Milton Miller <miltonm@bga.com>, benh@kernel.crashing.org,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 11:51 AM, Rob Herring <robherring2@gmail.com> wrote:
> On 01/25/2012 08:13 AM, Cousson, Benoit wrote:
>> On 1/23/2012 10:53 PM, Rob Herring wrote:
>>> On 01/23/2012 03:07 PM, Grant Likely wrote:
>>>>
>>>> Hey everyone,
>>>>
>>>> Here's the second RFC for the irq_domain patches.  I could use some
>>>> help testing now.  I still expect there will be a few bugs.  The
>>>> series is based on v3.3-rc1, and I've pushed it out to my git server:
>>>>
>>>> git://git.secretlab.ca/git/linux-2.6.git irqdomain/next
>>>
>>> Can you post to linux-arm-kernel too so people are aware of this work
>>> and stop posting dead-end irqdomain patches.
>>
>> Good point, I have two pending series that are using the
>> irq_domain_add() so far, so it will be good to have that branch pulled
>> in arm-soc.
>>
>>> I tested what you had as of this morning and it works fine for me. Looks
>>> like the only diff is the VExpress code. I'm working on rebasing my
>>> domain support for generic irqchip now.
>>
>> In fact your generic irqchip should even avoid us to use
>> irq_domain_add_legacy() since both GPIO and OMAP3 intc are already using
>> the irqchip.
>>
>> I guess you are not going to change the interface so the patches I did
>> on your previous branch to try them should be good already, isn't it?
>
> I've got it rebased on top of Grant's tree. I will send it out soon.
>
> One problem that still remains is it breaks x86 and any platform using
> generic irq chip, but not selecting IRQ_DOMAIN. Grant, do you plan to
> enable IRQ_DOMAIN for x86 in your series? MIPS may also need fixing.

I've got the x86 fix in my tree now.  It will be part of the next
merge.  MIPS, Microblaze and OpenRISC cannot turn on CONFIG_IRQ_DOMAIN
without rework.  I just hacked together the microblaze version, but
Michal will have to verify that it is correct.  I just posted it.  It
will be similar for the other two.

The real problem is sparc which does something entirely different for
irqs.  Rather than resolving irqs on-demand, it calculates the Linux
irq numbers at boot time for every node in the tree.  The irq_domains
will need to be set up for all interrupt controllers before sparc
begins it's big walk of the tree to resolve interrupts.  I haven't dug
into everything that needs to be done to support this.

I don't think you can count on turning on IRQ_DOMAIN on all
architectures just yet.  Adding irq_domain support directly to
irq_generic_chip is going to be difficult for that reason.  However,
it would be useful to have an irq_domain+irq_generic_chip wrapper that
can be enabled only when IRQ_DOMAIN is enabled.

g.
