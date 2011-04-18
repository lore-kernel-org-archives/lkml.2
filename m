Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1DRWHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 18:07:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:34376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1DRWHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 18:07:38 -0400
Subject: Re: [RFC][PATCH 4/7] lockdep: Seperate lock ids for read/write
 acquires
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gautham R Shenoy <gautshen@cmi.ac.in>
In-Reply-To: <20110417095507.123045423@chello.nl>
References: <20110417094505.865828233@chello.nl>
	 <20110417095507.123045423@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Apr 2011 00:07:00 +0200
Message-ID: <1303164420.32491.908.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-17 at 11:45 +0200, Peter Zijlstra wrote:
> In order to support recursive read locks we need to support the
> previously mentioned lock state conflict matrix:
> 
>  Conflicting_states(WRITE):             RECURSIVE_READ | READ | WRITE
>  Conflicting_states(READ):                               READ | WRITE
>  Conflicting_states(RECURSIVE_READ):                            WRITE
> 
> Since this introduces asymmetry between recursive read and write, we
> need to split the lock dependency chains such that we can traverse
> WRITE chains without observing RECURSIVE_READ|READ chains. 

So while we split off the WRITE chain from the RECURSIVE_READ|READ
chains, shouldn't we split it in three, because the READ conflict state
only has READ|WRITE, not RECURSIVE_READ.

Therefore a RECURSIVE_READ dependency in the READ chain could throw the
regular READ cycle detector, no?


 A(r) -> B(r) -> C(rr)

 C(w) -> B(r)

would close the cycle and report a problem, but doesn't match the
conflict states.
