Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab1ATQ3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:29:38 -0500
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:46496 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750712Ab1ATQ3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:29:37 -0500
Message-ID: <4D3862DB.5000708@fluff.org>
Date: Thu, 20 Jan 2011 16:29:15 +0000
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111031552.GJ3760@linux-sh.org>
In-Reply-To: <20110111031552.GJ3760@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/11 03:15, Paul Mundt wrote:
> On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
>> * clk_enable: may sleep
>>
>> * clk_disable: may not sleep, but it's possible to make the global
>>   clk_disable() atomic and defer the actual disable (clk->ops.disable()) to a
>>   non-atomic context.
>>
>> * clk_get_rate: may not sleep
>>
>> * clk_set_rate: may sleep
>>
>> As we build up our requirements, we can adjust as suitable.
>>
> This looks like a complete disaster, and is also completely inconsistent
> with how the API is being used by the vast majority of users today. You
> have an API that can or can not sleep with no indication as to which is
> which based off of the API naming, which is just asking for trouble.
> 
> As it is today, most users expect that these are all usable from atomic
> context, and as far as I can tell the only special case you have are for
> some crap busses with insane latencies. In this case you should simply
> pile on _cansleep() versions of the API and make it apparent that those
> drivers are the special cases, not the other way around.

The trouble is not with the drivers, is the fact there could be a clock
tree where, say the closest to the driver is easy to control but the
base of the tree may be a PLL which requires time to settle.

Now, there's a lot of work in the 'embedded' space where the focus is on
the power consumption, so powering down PLLs when they are not needed is
a good thing to have/

> Having half of the API sleepable and the other not with no indication of
> which is which simply makes it completely unusable and error prone for
> both atomic and non-atomic contexts.

I really don't like the fact that people are doing these things in
atomic contexts, and I think we should apply some pressure to move
the atomic caller cases to use systems where they can sleep such as
using threaded-irq handlers (they work very nicely)
