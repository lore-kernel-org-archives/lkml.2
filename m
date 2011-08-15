Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1HOKLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:11:49 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44103 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1HOKLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:11:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110814083618.GE4986@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	<20110814083618.GE4986@n2100.arm.linux.org.uk>
Date: Mon, 15 Aug 2011 12:11:46 +0200
Message-ID: <CACRpkdYdXz=Xt6QU_jDvw=j4EAEH+kapcq2CU97QF5giCqVjQw@mail.gmail.com>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>
Cc: pratyush.anand@st.com, rajeev-dlh.kumar@st.com, bhupesh.sharma@st.com,
        shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 10:36 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jul 29, 2011 at 04:19:26PM +0530, Viresh Kumar wrote:
>> Untill now, sg_len greater than one is not supported. This patch adds support to
>> do that.
>
> I'm not sure that this is the correct approach.  memcpy()s can only be
> used with one single buffer, so the sg stuff for that (and the unmapping
> support) doesn't make sense at all.

I agree, that part is fishy.

> The only place where this makes sense is the slave sg stuff.  I wonder
> whether we can better deal with that by having the LLI setup code deal
> with one SG list entry at a time, and chain each together.
>
> Something I've also been pondering which is related to this is linking
> together DMA operations using the LLI chaining when interrupts and
> callbacks aren't required.  It's a very similar problem.  Other DMA
> engine drivers do this.

Yeah. Viresh can you hold this patch off for the moment, move it to
the end of the series and see if we can find some more optimal
approach for this?

> Finally, note that some of the PL08x code assumes that for any TXD,
> the LLI list is a contiguous array.  See the first part of
> pl08x_getbytes_chan(). That needs fixing as soon as we start going to
> more than one SG list entry.

Actually, after the removal of the phantom boundary in the PL08x
driver, the LLI handling code starts to resemble the stuff inside
the coh901318.c driver an *awful lot*, so I'm now ever more
convinced that that thing is a PL08x derivate. (I have asked the
hardware designers but the people who made it are unreachable.)

And the coh901318 code handles this by properly walking the LLIs
in memory IIRC, so could be a good inspiration.

I am aware that we need to consolidate that LLI handling so
the coh901318 and PL08x share the same LLI code atleast, or I
may even be able to merge all into pl08x.c. I have a mental note
to get to that once we've got PL08x into shape, until then it
can atleast be used for inspiration.

Thanks,
Linus Walleij
