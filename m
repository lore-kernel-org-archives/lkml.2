Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1LVIkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:40:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52291 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1LVIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:39:59 -0500
Date: Thu, 22 Dec 2011 08:39:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111222083952.GN23916@ZenIV.linux.org.uk>
References: <4EF09D34.1060607@linux.vnet.ibm.com>
 <20111220175919.GE23916@ZenIV.linux.org.uk>
 <4EF0DE04.6030604@linux.vnet.ibm.com>
 <20111220195806.GF23916@ZenIV.linux.org.uk>
 <4EF24C71.6000609@linux.vnet.ibm.com>
 <20111221141229.7f691c43.akpm@linux-foundation.org>
 <20111222070214.GK23916@ZenIV.linux.org.uk>
 <20111221232047.3c3c63d3.akpm@linux-foundation.org>
 <20111222080856.GM23916@ZenIV.linux.org.uk>
 <20111222081757.GC11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222081757.GC11715@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 09:17:57AM +0100, Andi Kleen wrote:

> The costly operations here are the atomics and nothing really changes
> for them. So I don't expect any measurable difference.
> 
> I actually have an idea to remove them for the common case, but not in 
> that patchkit or cycle :)
> 
> I can run a ftrace if you want, but I expect any difference to be below
> the measurement inaccuracy.

What I'm concerned with is not the cost of extra dereference per se; it's
more about cacheline bouncing - note that with this fix in place you'll
end up with spinlock in the same cacheline as the pointer to per-cpu stuff.
Hell knows; it might not matter at all, since we take it only for
br_write_lock() (and definitely rare CPU up/down), but still, I'd like to
see the data.  In any case, that's not -stable material.  The race fix,
OTOH, is...
