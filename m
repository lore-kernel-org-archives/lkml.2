Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2LDCI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 21:08:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2LDCI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 21:08:56 -0500
Message-ID: <50BD5B29.7020409@gmail.com>
Date: Tue, 04 Dec 2012 10:08:41 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B874C7.5030208@nvidia.com> <20121130103850.GA28367@avionic-0098.adnet.avionic-design.de> <50BCFB7E.4020007@wwwdotorg.org> <20121203210328.GA20884@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121203210328.GA20884@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 05:03 AM, Thierry Reding wrote:
[...]
>> I think there's room for letting Terje's complete knowledge of future
>> chips guide the design of the current code that's sent upstream.
>> Certainly we shouldn't add a ton of unnecessary abstraction layers
>> right now that aren't needed for Tegra20/30, but if there's some
>> decision that doesn't affect the bloat, opaqueness, ... of the current
>> code but one choice is better for future development without serious
>> negatives for the current code, it's pretty reasonable to make that
>> decision rather than the other.
> 
> The original point was that the current design stashes every function of
> host1x into an ops structure and you have to go through those ops to get
> at the functionality. I can understand the need to add an ops structure
> to cope with incompatibilities between versions, but as you say there
> should to be a reason for them being introduced. If such reasons exists,
> then I think they at least warrant a comment somewhere.
> 
> Furthermore this is usually best handled by wrapping the ops accesses in
> a public API, so that the ops structure can be hidden within the driver.
> For example, submitting a job to a channel should have a public API such
> as:
> 
> 	int host1x_channel_submit(struct host1x_channel *channel,
> 				  struct host1x_job *job)
> 	{
> 		...
> 	}
> 
> An initial implementation would just add the code into this function. If
> it turns out some future version requires special incantations to submit
> a job, only then should we introduce an ops structure, with only the one
> function:
> 
> 	struct host1x_channel_ops {
> 		int (*submit)(struct host1x_channel *channel,
> 			      struct host1x_job *job);
> 	};
> 
> But since only the public API above has been used, access to the special
> implementation can be hidden from the user. So the public function could
> be modified in this way:
> 
> 	int host1x_channel_submit(struct hostx1_channel *channel,
> 				  struct host1x_job *job)
> 	{
> 		if (channel->ops && channel->ops->submit)
> 			return channel->ops->submit(channel, job);
> 
> 		...
> 	}
> 

I guess we do this in exactly this way at the beginning. Then we
realized that we need to define callbacks to make different tegra has
different logics. So that's why we see the codes have lots of function
ops right now.

If so, this will make Terje modify the code back to the original
version, and this is not an interesting work.

Just my personal guess, no offence.

Mark
> And then you have two choices: either you keep the code for previous
> generations after the if block or you provide a separate ops structure
> for older generations as well and handle them via the same code path.
> 
> One other thing that such a design can help with is refactoring common
> code or parameterizing code. Maybe newer generations are not compatible
> but can easily be made to work with existing code by introducing a
> variable such as register stride or something.
> 
> What's really difficult to follow is if an ops structure is accessed via
> some global macro. It also breaks encapsulation because you have a
> global ops structure. That may even work fine for now, but it will break
> once you have more than a single host1x in a system. I know this will
> never happen, but all of a sudden it happens anyway and the code breaks.
> Doing this right isn't very hard and it will lead to a better design and
> is less likely to break at some point.
> 
> Thierry
> 
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
