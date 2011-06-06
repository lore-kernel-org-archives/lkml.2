Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1FFTm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:42:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58621 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab1FFTmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:42:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110604095138.GA708@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com> <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com> <20110603150636.GA9492@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106031823310.3078@ionos> <irq-locate-ack@mdm.bga.com> <20110604095138.GA708@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 6 Jun 2011 13:42:33 -0600
X-Google-Sender-Auth: 9P-EXsAGchgbx0dPASo0xCf2FRo
Message-ID: <BANLkTi=MTWcKz0jd_p_n3Yz3DJQp4rs1Sg@mail.gmail.com>
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 4, 2011 at 3:51 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jun 03, 2011 at 07:23:24PM -0500, Milton Miller wrote:
>> On Fri, 3 Jun 2011 about 16:06:36 +0100, Mark Brown wrote:
>
>> > I need either a specific IRQ or an allocated one.  This is just a very
>> > standard driver with an interrupt controller
>
>> I don't know that I'd call an interrupt controller a standard driver
>> today, but agree we are heading towards that.
>
> Pretty much any modern ARM system will have a PMIC with an interrupt
> controller in it.
>
>> > The driver assumes it's going to get a contiguous range, it'd be a lot
>> > of bookkeeping for no gain to have to cope with them being splattered
>> > all over the place.
>
>> The irq domain concept addresses mapping, but a simple fully allocated
>> block will be one of the options.  Having 60 irqdesc might be
>> pushing the limit for some platforms but that can be addressed later
>> when irq domains are upstream.
>
> I'm not really sure what an IRQ domain is (the patch series you pointed
> at before does rather appear to assume one knows already)

(obviously I need to write some documentation).  irq_domains is some
infrastructure to make managing a range of irq numbers easier, and
also to handle the mapping of hw irq numbers to linux irq numbers.

> but given that
> we're allocating from within a 32 bit type it seems like we should be
> using a few orders of magnitude more interrupts in a system than we do
> presently before this becomes much of an issue.

Also, with sparse irqs, irq numbers are effectively free.  It may be
valuable to implement deferred allocation of the actual irq_desc
structures, but ranges of irq numbers are really cheap for discrete
irq controllers (say in the range of 1-256 irq inputs).  It may be
different for MSI controllers that have programmable hw irq numbers,
but in that case the solution is to allocated them one at a time as
needed, or allocate a pool that the MSI controller driver can manage
on its own.

>
>> > If the user cares they can just pick a number for the base; if they're
>> > going to pick a number they may as well pick the actual number.
>
>> I'd argue the user is the wrong level to make this decision.  However,
>> saying the platform decides is valid, and the excerpt you had earlier
>> implied you were getting the irq argument from platform data, not the
>> user (eg via a module parameter)..
>
> It's platform data.  Having interrupt numbers specified as module
> parameters strikes me as insane - the particular integers we map
> individual interrupts onto are very much an implementation decision of
> the kernel.

More and more irq numbers are becoming internal implementation details
of the kernel.  We should be moving in the direction of irq numbers
have less to no impact on anything in userspace or the bootloader.
There probably isn't much to be done about /proc/interrupts, but it
definitely sounds insane to specify irq numbers as module parameters.
or in the device tree.  or anything else not linked directly to the
kernel.

>> I should point out that several archtectures currently allocate irqs
>> in a architecture layer before calling the irq allocator asking for
>> the exact irq they choose on what they thought was free.  Among these
>> are x86 and powerpc.   Not calling the architecture layer will causein
>> all future allocations by other drivers using the architecture layer
>> to fail..

Yes they do, but no it should not stay that way.  The architectures
currently do this because there wasn't common code to handle it
sanely.  Now that irq_alloc_desc*() does exist, the arch specific
allocation of irqs needs to be dropped and the architecture code
should rely entirely on irq_alloc_desc*() for managing ranges of irqs.
 It does not make sense for drivers needing to allocating irq_descs
(gpio controllers are an excellent example) to call into arch code.
irq_alloc_desc*() is more than sufficient.  Milton, later in your
email you mention changing the way powerpc allocates irqs.  Is this
what you were talking about?

>
> That sounds like we should join the two IRQ allocators up with each
> other.

yes.
