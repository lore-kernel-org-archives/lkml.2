Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1AKDSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:18:05 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38512 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1AKDR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:17:58 -0500
Date: Tue, 11 Jan 2011 12:15:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
Subject: Re: Locking in the clk API
Message-ID: <20110111031552.GJ3760@linux-sh.org>
References: <201101111016.42819.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111016.42819.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
> * clk_enable: may sleep
> 
> * clk_disable: may not sleep, but it's possible to make the global
>   clk_disable() atomic and defer the actual disable (clk->ops.disable()) to a
>   non-atomic context.
> 
> * clk_get_rate: may not sleep
> 
> * clk_set_rate: may sleep
> 
> As we build up our requirements, we can adjust as suitable.
> 
This looks like a complete disaster, and is also completely inconsistent
with how the API is being used by the vast majority of users today. You
have an API that can or can not sleep with no indication as to which is
which based off of the API naming, which is just asking for trouble.

As it is today, most users expect that these are all usable from atomic
context, and as far as I can tell the only special case you have are for
some crap busses with insane latencies. In this case you should simply
pile on _cansleep() versions of the API and make it apparent that those
drivers are the special cases, not the other way around.

Having half of the API sleepable and the other not with no indication of
which is which simply makes it completely unusable and error prone for
both atomic and non-atomic contexts.
