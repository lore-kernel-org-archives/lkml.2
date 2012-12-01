Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2LALbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:31:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12034 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2LALbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:31:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 01 Dec 2012 03:30:47 -0800
Message-ID: <50B9EA76.10803@nvidia.com>
Date: Sat, 1 Dec 2012 13:31:02 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2012 12:38, Thierry Reding wrote:
> * PGP Signed by an unknown key
> The above implies that when you submit code it shouldn't contain pieces
> that prepare for possible future extensions which may or may not be
> submitted (the exception being if such changes are part of a series
> where subsequent patches actually use them). The outcome is that the
> amount of cruft in the mainline kernel is kept to a minimum. And that's
> a very good thing.

We're now talking about actually a separation of logical and physical
driver. I can't see why that's a bad thing. Especially considering that
it's standard practice in well written drivers. Let's try to find a
technical clean solution instead of debating politics. The latter should
never be part of Linux kernel reviews.

>> I could do that for upstream. In downstream it cannot depend on DEBUG
>> flag, as these spews are an important part of how we debug problems with
>> customer devices and the DEBUG flag is never on in customer builds.
> 
> So I've just looked through these patches once more and I can't find
> where this functionality is actually used. The host1x_syncpt_debug()
> function is assigned to the nvhost_syncpt_ops.debug member, which in
> turn is only used by nvhost_syncpt_debug(). The latter, however is
> never used (not even by the debug infrastructure introduced in patch
> 4).

I have accidentally used the syncpt_op().debug() version directly. I'll
fix that.

> Okay, so what you're sayingCan here is that a huge number of people haven't
> been wise in using the preprocessor for register definitions all these
> years. That's a pretty bold statement. Now I obviously haven't looked at
> every single line in the kernel, but I have never come across this usage
> for static inline functions used for this. So, to be honest, I don't
> think this is really up for discussion. Of course if you come up with an
> example where this is done in a similar way I could be persuaded
> otherwise.

We must've talked about a bit different things. For pure register defs,
I can accommodate changing to #defines. We'd lose the code coverage
analysis, though, but if the parentheses are a make-or-break question to
upstreaming, I can change.

I was thinking of definitions like this:

static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v)
{
	return (v & 0x1ff) << 0;
}

versus

#define host1x_sync_cfpeek_ctrl_cfpeek_addr_f(v) ((v) >> 16) & 0x3ff

Both of these produce the same machine code and have same usage, but the
latter has type checking and code coverage analysis and the former is
(in my eyes) clearer. In both of these cases the usage is like this:

writel(host1x_sync_cfpeek_ctrl_cfpeek_ena_f(1)
		| host1x_sync_cfpeek_ctrl_cfpeek_channr_f(chid)
		| host1x_sync_cfpeek_ctrl_cfpeek_addr_f(rd_ptr),
	m->sync_aperture + host1x_sync_cfpeek_ctrl_r());

> But I don't see how that's relevant here. Let me quote what you said
> originally:
> 
>> This is actually the only interface to read the max value to user space,
>> which can be useful for doing some comparisons that take wrapping into
>> account. But we could just add IOCTLs and remove the sysfs entries.
> 
> To me that sounded like it was only used for debugging purposes. If you
> actually need to access this from a userspace driver then, as opposed to
> what I said earlier, this should be handled by some IOCTL.

There's a use for production code to know both the max and min, but I
think we can just scope that use out from this patch sest.

User space can use these two for checking if one of their fences has
already passed by comparing if the current value is between min and
fence, taking wrapping into account. In these cases user space can f.ex.
leave a host1x wait out from a command stream.

Terje
