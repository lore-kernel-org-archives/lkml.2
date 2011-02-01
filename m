Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab1BAAXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 19:23:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:39635 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1BAAXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 19:23:38 -0500
Subject: Re: call_function_many: fix list delete vs add race
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Milton Miller <miltonm@bga.com>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
In-Reply-To: <1296508677.26581.84.camel@laptop>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296508677.26581.84.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 11:22:44 +1100
Message-ID: <1296519764.2349.325.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 22:17 +0100, Peter Zijlstra wrote:
> That's wrong:
> 
>  ->foo =
>  LOCK
>  UNLOCK
>  ->bar =
> 
> can be re-ordered as:
> 
>  LOCK
>  ->bar =
>  ->foo =
>  UNLOCK

Can it ? I though UNLOCK had a write barrier semantic ? It does on power
at least :-) It should have since it shall prevent stores inside the
lock region to pass the store of the unlock itself anyways.

So yes, ->bar = can leak into the lock, as can ->foo =, but they can't
be re-ordered vs. each other because the implied barrier will keep ->foo
= in the same "domain" as the unlock itself.

Or do other archs do something really nasty here that don't provide this
guarantee ?

Cheers,
Ben.


