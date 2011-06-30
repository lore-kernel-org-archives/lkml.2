Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1F3Nah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 09:30:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43334 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1F3Nab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 09:30:31 -0400
Date: Thu, 30 Jun 2011 14:30:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Per Forlin <per.forlin@linaro.org>,
        Nickolay Nickolaev <nicknickolaev@gmail.com>
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
Message-ID: <20110630133003.GZ21898@n2100.arm.linux.org.uk>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org> <201106301512.46788.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106301512.46788.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 03:12:46PM +0200, Arnd Bergmann wrote:
> I think this looks good enough to merge into the linux-mmc tree, the code is
> clean and the benefits are clear.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> One logical follow-up as both a cleanup and performance optimization would be
> to get rid of the mmc_queue_thread completely. When mmc_blk_issue_rq() is
> non-blocking always, you can call it directly from the mmc_request()
> function, instead of waking up another thread to do it for you.

It isn't anywhere near that - because you need to wait for the
request to complete, then analyze the results and if there has been
an error, send more commands and wait for their response.

To do all that in an asynchronous fashion will just create a mess of
small little functions with hard to understand code.  It's far better
to do all that in a clear procedural way in a thread.

We've been here before - with PCMCIA's card insertion code, where you
have to go through a sequence of events (insert, power up, reset, etc).
The PCMCIA code used to have a collection of small functions to do
each step, one chained after the other in a state machine fashion.
The result was horrid.  That's exactly what you'll end up with here.

Threads have their place, and this is one of them.
