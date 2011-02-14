Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1BNVjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 16:39:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1BNVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 16:39:39 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=K9p1jRLIvV_c4u8UPsIA:9 a=Kw3RcoKiXKX_D-chXc6rHaPKBb4A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Newton <will.newton@gmail.com>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Chris Metcalf <cmetcalf@tilera.com>, dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "heiko.carstens" <heiko.carstens@de.ibm.com>,
        benh <benh@kernel.crashing.org>
In-Reply-To: <1297718964.23343.75.camel@gandalf.stny.rr.com>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <1297452328.5226.89.camel@laptop>
	 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
	 <1297460297.5226.99.camel@laptop> <1297536465.5226.108.camel@laptop>
	 <20110214155113.GA2840@redhat.com> <1297699024.2401.12.camel@twins>
	 <20110214160437.GB2840@redhat.com>
	 <BLU0-SMTP4069A1A89F06CDFF9B28F896D00@phx.gbl>
	 <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com>
	 <1297701438.5226.113.camel@laptop>
	 <1297702013.23343.51.camel@gandalf.stny.rr.com>
	 <1297703892.23343.71.camel@gandalf.stny.rr.com>
	 <1297704447.5226.127.camel@laptop>
	 <AANLkTi=pXqya2vaUv2XNwRr6T==MW8ZtQ_yg6V9sipcy@mail.gmail.com>
	 <1297705428.5226.142.camel@laptop>
	 <AANLkTi=jz+mGru--+YA62EeER17Tuq2DocrkKNaU2k+1@mail.gmail.com>
	 <1297707868.5226.189.camel@laptop>
	 <1297718964.23343.75.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Feb 2011 16:39:36 -0500
Message-ID: <1297719576.23343.80.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 16:29 -0500, Steven Rostedt wrote:

> > while (atomic_read(&foo) != n)
> >   cpu_relax();
> > 
> > and the problem is that cpu_relax() doesn't know which particular
> > cacheline to flush in order to make things go faster, hm?
> 
> But what about any global variable? Can't we also just have:
> 
> 	while (global != n)
> 		cpu_relax();
> 
> ?

Matt Fleming answered this for me on IRC, and I'll share the answer here
(for those that are dying to know ;)

Seems that the atomic_inc() uses ll/sc operations that do not affect the
cache. Thus the problem is only with atomic_read() as

	while(atomic_read(&foo) != n)
		cpu_relax();

Will just check the cache version of foo. But because ll/sc skips the
cache, the foo will never update. That is, atomic_inc() and friends do
not touch the cache, and the CPU spinning in this loop will is only
checking the cache, and will spin forever.

Thus it is not about global, as global is updated by normal means and
will update the caches. atomic_t is updated via the ll/sc that ignores
the cache and causes all this to break down. IOW... broken hardware ;)

Matt, feel free to correct this if it is wrong.

-- Steve


