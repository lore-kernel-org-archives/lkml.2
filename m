Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab2CGQac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:30:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:35382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758505Ab2CGQaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:30:30 -0500
Message-ID: <1331137823.11248.353.camel@twins>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <roland@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Mar 2012 17:30:23 +0100
In-Reply-To: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 18:19 -0800, Roland Dreier wrote:
> Is this expected behavior? 

Its not unexpected.. although I had hoped we'd not suck quite as bad.

The 'idea' is that scale_rt_power() will decrease the cpu_power of cpus
that run RT tasks and the rest of the load-balancing will then dtrt.

Clearly its not quite working.

>  I can believe that we brought this on ourselves by
> misconfiguring things, but in that case it would be good to know what we could
> do to avoid this problem. 

hard-affine everything.. eg. create a system cpuset and only give it
cpu23 (although cpu0 would be more typical) and run only a single task
on every other cpu.

Once you do that, it doesn't really matter if your one task is FIFO or
not, with the exception that system tasks (like ksoftirqd, kworker/n
etc..) can still run when required.

Running FIFO spinners is known to break stuff due to those system tasks
not getting run. Fixing this is somewhat non-trivial :/

Alternatively you can of course play with stuff like commit 4a6184ce


