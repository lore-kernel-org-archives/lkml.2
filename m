Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1AKELp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 23:11:45 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37957 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab1AKELm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 23:11:42 -0500
From: Jeremy Kerr <jeremy.kerr@canonical.com>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: Locking in the clk API
Date: Tue, 11 Jan 2011 12:11:29 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; x86_64; ; )
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "Uwe Kleine-K??nig" <u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org>
In-Reply-To: <20110111031552.GJ3760@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201101111211.30172.jeremy.kerr@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> This looks like a complete disaster, and is also completely inconsistent
> with how the API is being used by the vast majority of users today.

I've been basing this on the mxc clock code, which acquires a mutex for all 
clk_enable()s. This may not be representative of the majority of clock usage.

>From a quick search there are a few other cases of non-atomic clock usage:

tcc:		clk_enable() acquires a global clocks_mutex
tegra:	has a clk_enable_cansleep()
davinci: clk_set_parent() aquires a global clocks_mutex

Excluding the davinci code (we won't worry about set_parent for now...), if we 
can port mxc and tcc to a sleepable clk_enable, perhaps we could just go with 
purely atomic operations.

We'd still need some method of using sleeping clocks though. How about making 
clk_enable() BUG if the clock is not atomic, and add clk_enable_cansleep() for 
the cases where clk->ops.enable may sleep.

Do we need something similar for other parts of the API? (clk_set_rate?)

Cheers,


Jeremy
