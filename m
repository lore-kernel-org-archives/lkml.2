Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1BNWUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:20:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1BNWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:20:32 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=8JJjOkvMJUzyatM_TIUA:9 a=CbWFksSHX_lBOVFqkEVSqMVPQK0A:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <20110214.134600.179933733.davem@davemloft.net>
References: <1297707868.5226.189.camel@laptop>
	 <1297718964.23343.75.camel@gandalf.stny.rr.com>
	 <1297719576.23343.80.camel@gandalf.stny.rr.com>
	 <20110214.134600.179933733.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 17:20:30 -0500
Message-ID: <1297722030.23343.86.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 13:46 -0800, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Mon, 14 Feb 2011 16:39:36 -0500
> 
> > Thus it is not about global, as global is updated by normal means and
> > will update the caches. atomic_t is updated via the ll/sc that ignores
> > the cache and causes all this to break down. IOW... broken hardware ;)
> 
> I don't see how cache coherency can possibly work if the hardware
> behaves this way.
> 
> In cache aliasing situations, yes I can understand a L1 cache visibility
> issue being present, but with kernel only stuff that should never happen
> otherwise we have a bug in the arch cache flushing support.

I guess the issue is, if you use ll/sc on memory, you must always use
ll/sc on that memory, otherwise any normal read won't read the proper
cache.

The atomic_read() in this arch uses ll to read the memory directly and
skip the cache. If we make atomic_read() like the other archs:

#define atomic_read(v)	(*(volatile int *)&(v)->counter)

This pulls the counter into cache, and it will not be updated by a
atomic_inc() from another CPU.

Ideally, we would like a single atomic_read() but due to these wacky
archs, it may not be possible.

-- Steve


