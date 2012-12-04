Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2LDDDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 22:03:06 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43240 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab2LDDDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 22:03:04 -0500
Date: Mon, 03 Dec 2012 22:03:02 -0500 (EST)
Message-Id: <20121203.220302.468583955499233871.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: torvalds@linux-foundation.org, monstr@monstr.eu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: sigaltstack fun
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121126051544.GD4939@ZenIV.linux.org.uk>
References: <20121118.222724.1495808364736017374.davem@davemloft.net>
	<20121126051002.GB4939@ZenIV.linux.org.uk>
	<20121126051544.GD4939@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Mon, 26 Nov 2012 05:15:44 +0000

> On Mon, Nov 26, 2012 at 05:10:02AM +0000, Al Viro wrote:
>> On Sun, Nov 18, 2012 at 10:27:24PM -0500, David Miller wrote:
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>> > 
>> > Applied, thanks.
>> 
>> Hmm...  There's something odd going on with {rt_,}sigaction on sparc -
>> we *do* have sa_restorer in struct sigaction and struct old_sigaction,
>> but it's not used for anything whatsoever.  There's also a separately
>> passed restorer pointer for rt_sigaction() and *that* is used instead,
>> but not reported via *oact.
>> 
>> What's the reason for that weirdness?  I understand why we do that on
>> alpha (we have no sa_restorer in struct sigaction we'd inherited from
>> OSF/1), but sparc always had perfectly normal sigaction->sa_restorer
>> field all along - even for old sigaction(2)...
> 
> PS: speaking of weirdness, what's the reason for sparc and ppc (and nothing
> else) expecting the first argument of sigaction(2) to be minus signal
> number?  ABI archaeology is fun...

It's because of stupidity.

We had two sigaction interpretations, and distinguished the two cases
by whether the signal passed in was positive or negative.

The positive code got phased out and simply deleted, leaving only
the negative case.

If you look into ancient trees (f.e. 2.4.x) you'll see stuff like
this:

	if (sig < 0) {
		current->thread.new_signal = 1;
		sig = -sig;
	}

in sparc_sigaction().

The main problem is that, originally, I didn't pass a siginfo into the
signal handler.  I didn't want to break applications that made use of
the arguments I did provide.  So this was the compatability facility.

If you passed in a negative signal number, I passed the signal()
handler args as they are documented in sigaction(2).  Otherwise
I passed in whatever I had passed previously.


