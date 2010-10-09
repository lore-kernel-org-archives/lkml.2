Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab0JIK2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 06:28:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45123 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0JIK2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 06:28:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MVq7jtHS6qMxxG+H1vXOovHuGssJXPWQ5QNvJv8ttsTIEgQVuvWsG7xAnudq06rHUy
         fXa44bwE93ig5/2o0rW0LEoi4JZBIw8GiREyKvfCo9fmRceEGRTcrdy6cU+p0K4THxKu
         EqWn/Z/D0L1NAGybpGVdOzAyDf6kGfkdIKXDI=
MIME-Version: 1.0
In-Reply-To: <20101009092127.GB20975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
Date: Sat, 9 Oct 2010 13:28:19 +0300
Message-ID: <AANLkTimtdV8THgnQL1RxaqLzCUwO27AZSMPi=UtgpML7@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 12:21 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Oct 09, 2010 at 03:56:23AM +0300, Felipe Contreras wrote:
>> 2010/10/9 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> > On Fri, Oct 08, 2010 at 04:25:39PM -0700, Greg KH wrote:
>> >> Also, how can we fix this in a driver, what is the proper steps to do
>> >> so?
>> >
>> > On April 23rd:
>> > | I think a viable safe solution is to set aside some RAM at boot (which
>> > | the kernel doesn't manage at all) and then use ioremap on that; that
>> > | approach will still work with this patch in place.
>> >
>> > On April 30th when discussing the omapfb driver:
>> > | There's really one option for this - in the machine's fixup handler, you
>> > | can walk the meminfo array and kick out some memory from that.  This will
>> > | prevent the kernel mapping that memory and make pfn_valid() fail for that
>> > | memory range.  Another advantage of this is that it won't break when we
>> > | switch to LMB.
>>
>> These are not solutions, these are pointers to find the solutions.
>>
>> How do you set aside some RAM at boot for that? Is there anything like
>> memblock to do that? Or do you expect to set aside some memory with
>> mem=X, and manually specify the address in the .config?
>
> Which bit of "walk the meminfo array and kick out some memory from that"
> says "use memblock" or "use mem=X" ?
>
> static unsigned long reserve_mem(struct meminfo *mi, unsigned long size)
> {
>        unsigned long addr = ~0;
>        int i;
>
>        for (i = mi->nr_banks - 1; i >= 0; i--)
>                if (mi->bank[i].size >= size) {
>                        mi->bank[i].size -= size;
>                        addr = mi->bank[i].start + mi->bank[i].size;
>                        break;
>                }
>
>        return addr;
> }
>
> static void __init my_fixup(struct machine_desc *desc, struct tag *tags,
>                            char **cmdline, struct meminfo *mi)
> {
>        omapfb_buffer_phys = reserve_mem(mi, 32*1048576);
>        if (omapfb_buffer_phys == ~0)
>                pr_warn("Unable to allocate omapfb buffer\n");
> }
>
> Then later:
>
>        omapfb_buffer = ioremap(omapfb_buffer_phys, 32*1048576);
>
> That's a damned simple and direct implementation of exactly what I
> described, and results in something which is much more architecturally
> correct than what's going on today.

This is only for omapfb, isn't it? Or is this a generic solution?

If it's a generic solution can we put this into arch/arm/mm? What is
simple and direct for you is something that would take a long long
time for other people to come with (if ever).

>> > Unfortunately, what I fear is that nothing will happen because people
>> > want the ioremap-on-system-RAM to just work, and then we'll hit this
>> > exact same issue again in three months time.
>>
>> Nobody has ever said, or suggested anything like that.
>>
>> What people want is:
>> 1) A solution in place
>> 2) Time to implement that solution in their drivers
>
> Six months, and by your own emails, everyone reverting the change rather
> than fixing producing their drivers.  That says it all about what kind
> of attitude driver writers have towards architectural issues.
>
> If they've been reverting the change, then they _do_ know about the issue,
> so why have there been _zero_ patches from these people who are reverting
> the change?  Maybe you should be asking these people why they haven't done
> any work to fix the drivers when one of the solutions starts off as about
> 15 lines of code.

No, I said people _will_ revert the patch. I'm pretty sure the vast
majority of people haven't even realized this change yet.

What you should have done IMO is only warn first. This would have had
no problem getting into 2.6.35, as it doesn't break anything, then
most people would have noticed this by now.

Also, what do you think is the right attitude? Do you think *all*
driver writers should follow each and every patch on the mailing list
or always try release candidates? Even if they all did (some do),
there's no generic solution, so they all are scratching their heads
about how to solve this. It might be crystal clear for you how such
generic solution could be implemented, or perhaps how some of these
drivers can be fixed individually, if so, why don't you come with a
proposal to mitigate the pain of fixing such drivers.

If you don't have time to write such a generic solution, that's fine,
that's why my proposal is to only warn for now.

I think saying "hey, it turns out you were using the API wrongly, I am
officially totally breaking you all, and I'm not bothering with
providing an example of what you should be doing instead, also, you
should follow all the patches in linux-arm-kernel, and try the release
candidates, because you should expect to get broken at any time" is
the wrong attitude.

>> And since you did, let me say what I fear: that many more people will
>> find drivers totally broken on 2.6.36.
>
> I've reverted the change, so now you can go back to violating the
> requirements of the architecture and have your data silently corrupted.

This is unreasonable, we need the warning at least on one release.

-- 
Felipe Contreras
