Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab2K3Iww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:52:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7733 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2K3Iwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:52:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 30 Nov 2012 00:52:24 -0800
Message-ID: <50B874C7.5030208@nvidia.com>
Date: Fri, 30 Nov 2012 10:56:39 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 13:47, Thierry Reding wrote:
> On Thu, Nov 29, 2012 at 12:21:04PM +0200, Terje Bergström wrote:
>> Tegra20 and Tegra30 are compatible, but future chips are not. I was
>> hoping we would be ready in upstream kernel for future chips.
> 
> I think we should ignore that problem for now. Generally planning for
> any possible combination of incompatibilities leads to overgeneralized
> designs that require precisely these kinds of indirections.
> 
> Once some documentation for Tegra 40 materializes we can start thinking
> about how to encapsulate the incompatible code.

I think here our perspectives differ a lot. That is natural considering
the company I work for and company you work for, so let's try to sync
the perspective.

In my reality, whatever is in market is old news and I barely work on
them anymore. Upstreaming activity is the exception. 90% of my time is
spent dealing with future chips which I know cannot be handled without
this split to logical and physical driver parts.

For you, Tegra2 and Tegra3 are the reality.

If we move nvhost in upstream a bit incompatible, that's fine, like
ripping out features or adding new new stuff, like a new memory type.
All of this I can support with a good diff tool to get all the patches
flowing between upstream and downstream.

If we do fundamental changes that prevent bringing the code back to
downstream, like removing this abstraction, the whole process of
upstream and downstream converging hits a brick wall. We wouldn't have
proper continuing co-operation, but just pushing code out and being done
with it.

> I noticed that it was filled with content in one of the subsequent
> patches. Depending on how this gets merged eventually you could postpone
> adding the function until the later patch. But perhaps once the code has
> been properly reviewed we can just squash the patches again. We'll see.

Ok, thanks.

>> True. I might also as well delete the general interrupt altogether, as
>> we don't use it for any real purpose.
> 
> I think it might still be useful for diagnostics. It seems to be used
> when writes time out. That could still be helpful information when
> debugging problems.

It's actually a stale comment. The client units are not signaling
anything useful with the interrupt. There's use for it in downstream,
but that's irrelevant here.

> Making this generic for all modules may not be what we want as it
> doesn't allow devices to handle things themselves if necessary. Clock
> management is just part of the boiler plate that every driver is
> supposed to cope with. Also the number of clocks is usually not higher
> than 2 or 3, so the pain is manageable. =)
> 
> Furthermore doing this in loops may not work for all modules. Some may
> require additional delays between enabling the clocks, others may be
> able to selectively disable one clock but not the other(s).

Yes, but I'll just rip the power management code out, so we can postpone
this until we have validated and verified the runtime PM mechanism
downstream.

>> I could move this to debug.c, but it's debugging aid when a command
>> stream is misbehaving and it spews this to UART when sync point wait is
>> timing out. So not debugfs stuff.
> 
> Okay, in that case it should stay in. Perhaps convert dev_info() to
> dev_dbg(). Perhaps wrapping it in some #ifdef CONFIG_TEGRA_HOST1X_DEBUG
> guards would also be useful. Maybe not.

I could do that for upstream. In downstream it cannot depend on DEBUG
flag, as these spews are an important part of how we debug problems with
customer devices and the DEBUG flag is never on in customer builds.

> The problem is not with autogenerated files in general. The means by
> which they are generated are less important. However, autogenerated
> files often contain a lot of unneeded definitions and contain things
> such as "autogenerated - do not edit" lines.
> 
> So generally if you generate the content using some scripts to make sure
> it corresponds to what engineering gave you, that's okay as long as you
> make sure it has the correct form and doesn't contain any cruft.

I can remove the boilerplate, that's not a problem. In general, we have
tried to be very selective about what we generate, so that it matches
what we're using.

>> I like static inline because I get the benefit of compiler type
>> checking, and gcov shows me which register definitions have been used in
>> different tests.
> 
> Type checking shouldn't be necessary for simple defines. And I wasn't
> aware that you could get the Linux kernel to write out data to be fed to
> gcov.
> 
>> #defines are always messy and I pretty much hate them. But if the
>> general request is to use #define's, even though I don't agree, I can
>> accommodate. It's simple to write a sed script to do the conversion.
> 
> There are a lot of opportunities to abuse #defines but they are harmless
> for register definitions. The Linux kernel is full of them and I haven't
> yet seen any code that uses static inline functions for this purpose.

My problem is just that I know that the code generated is the same. What
we're talking about is that should we let the preprocessor or compiler
take care of this.

My take is that using preprocessor is not wise - it's the last resort if
there's no other proper way of doing things. Preprocessor requires all
sorts of extra parenthesis to protect against its deficiencies, and it
it merely a tool to do search-and-replace. Even multi-line needs special
treatment.

> What you need to consider as well is that many people that work with the
> Linux kernel expect code to be in a certain style. Register accesses of
> the form
> 
>         writel(value, base + OFFSET);
> 
> are very common and expected to look a certain way, so if you write code
> that doesn't comply with these guidelines you make it extra hard for
> people to read the code. And that'll cost extra time, which people don't
> usually have in excess.

But this has nothing to do with static inline vs. #define anymore, right?

> Maybe you can explain the usefulness of this some more. Why would it be
> easier to look at them in sysfs than in debugfs? You could be providing
> a simple list of syncpoints along with min/max, name, requested status,
> etc. in debugfs and it should be as easy to parse for both humans and
> machines as sysfs. I don't think IOCTLs would be any gain as they tend
> to have higher ABI stability requirements than debugfs (which doesn't
> have very strong requirements) or sysfs (which is often considered as a
> public ABI as well and therefore needs to be stable).

debugfs is just a debugging tool, and user space cannot rely on it. Only
developers can rely on existence of debugfs, as they have the means to
enable it.

sysfs is a place for actual APIs as you mention, and user space can rely
on them as proper APIs. That's what the values were exported for.

> I've said this before, and I think that this tries to be overly generic.
> Display controllers for instance work quite well without an attached
> nvhost_channel.

Yes, these structures aren't meant to be used by anything else than
units that are controlled by the host1x driver. DC, for example,
wouldn't have this.

Terje
