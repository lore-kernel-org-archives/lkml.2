Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2K3Hh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:37:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2414 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2K3Hh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:37:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 29 Nov 2012 23:37:30 -0800
Message-ID: <50B8633A.6010302@nvidia.com>
Date: Fri, 30 Nov 2012 09:41:46 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/8] video: tegra: Add syncpoint wait and interrupts
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-3-git-send-email-tbergstrom@nvidia.com> <20121129084400.GA28781@avionic-0098.adnet.avionic-design.de> <50B73B5B.8030008@nvidia.com> <20121130072200.GE26474@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121130072200.GE26474@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just replying to part of your mail.

On 30.11.2012 09:22, Thierry Reding wrote:
> Actually for the display controller we want just a notification when the
> VBLANK happens. I'm not sure if we want to do that with syncpoints at
> all since it works quite well using regular interrupts.

VBLANK isn't actually a very good example of dc's use of sync points.
That can easily be done with regular interrupts, as you mention.

More important is when we have double buffering enabled. When you draw
something to a surface, and flip it to display, you want DC to notify
when the flip has been done and rendering can continue to the back buffer.

So, what you can do is return a fence from DC when initiating a flip,
and place that fence into 2D stream as a host wait so that 2D will
patiently wait for buffer to become free before it renders.

> What I'm proposing is to leave it up to each host1x client how they want
> to handle this. For display controllers it may be enough to have their
> callback run in interrupt context but other clients may need to do more
> work so they can queue it themselves.

DC doesn't need to worry about host1x interrupts at all. It's all
internal to the host1x driver, so we're now just talking about the
internal implementation of host1x.

We have two scenarios for the syncpt interrupts. One is that a job got
finished and we need to clean up the queue and free up resources. This
must be done in threads. Other is releasing a thread that is blocked by
a syncpt wait.

It's simpler if both of these are handled with the same infrastructure,
and we've shown that latency is very good even if we handle all events
in a thread.

> I know that this looks like it might be more work, but if it turns out
> that many drivers need to do the exact same thing, that functionality
> can be factored out into a helper. But it may just as well turn out that
> the requirements for each module are slightly different that forcing a
> workqueue on them could result in ugly workarounds because it doesn't
> quite work for them.

This is just driver internal, so there's no need for other drivers to
access this part.

> If we move responsibility of managing the workqueue out of host1x as I
> proposed above, maybe a lot of this code can be removed. Maybe you can
> explain a bit what they are used for exactly in your write-up.

It's going to be a big bad boy. :-)

Terje

