Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1HSVjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:39:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46585 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357Ab1HSVjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:39:42 -0400
Date: Fri, 19 Aug 2011 22:38:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Pavel Ivanov <paivanof@gmail.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Mahmood Naderan <nt_mahmood@yahoo.com>,
        David Rientjes <rientjes@google.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: running of out memory => kernel crash
Message-ID: <20110819223810.0f02016e@lxorguk.ukuu.org.uk>
In-Reply-To: <4E4ED366.1090104@genband.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
	<CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
	<1313075625.50520.YahooMailNeo@web111715.mail.gq1.yahoo.com>
	<201108111938.25836.vda.linux@googlemail.com>
	<CAG1a4rsO7JDqmYiwyxPrAHdLNbJt+wqymSzU9i1dv5w5C2OFog@mail.gmail.com>
	<CAK1hOcM5u-zB7fUnR5QVJGBrEnLMhK9Q+EmWBknThga70UQaLw@mail.gmail.com>
	<CAG1a4rus+VVhhB3ayuDF2pCQDusLekGOAxf33+u_uzxC1yz1MA@mail.gmail.com>
	<CAF_S4t--+Ufkb2bVrt9e59R=yty5U5Cb=Kt5RbjPjraM_equog@mail.gmail.com>
	<4E4ED366.1090104@genband.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Indeed.  From the point of view of the OS, it's running everything on 
> the system without a problem.  It's deep into swap, but it's running.

Watchdogs can help here

> If there are application requirements on grade-of-service, it's up to 
> the application to check whether those are being met and if not to do 
> something about it.

Or it can request such a level of service from the kernel using the
various memory control interfaces provided but not enabled by
distributors in default configurations.

In particular you can tell the kernel to stop the system hitting the
point where it runs near to out of memory + swap and begins to thrash
horribly. For many workloads you will need a lot of pretty much excess
swap, but disk is cheap. It's like banking, you can either pretend it's
safe in which case you do impressions of the US banking system now and
then and the government has to reboot it, or you can do traditional
banking models where you have a reserve which is sufficient to cover the
worst case of making progress. Our zero overcommit isn't specifically
aimed at the page rate problem but is sufficiently related it usually
does the trick.

http://opsmonkey.blogspot.com/2007/01/linux-memory-overcommit.html

I would btw disagree strongly that this is a 'sorry we can't help'
situation. Back when memory was scarce and systems habitually ran at high
memory loads 4.2 and 4.3BSD coped just fine with very high fault rates
that make modern systems curl up and die. That was entirely down to
having good paging and swap policies linked to scheduling behaviour so
they always made progress. Your latency went through the roof but work
got done which meant that if it was transient load the system would feel
like treacle then perk up again where these days it seems the fashion of
most OS's to just explode messily.

In particular they did two things
- Actively tried to swap out all the bits of entire process victims to
  make space to do work under very high load
- When a process was pulled in it got time to run before it as opposed
  to someone else got dumped out

That has two good effects. Firstly the system could write out the process
data very efficiently and get it back likewise. Secondly the system ended
up in a kick one out, do work in the space we have to breath, stop, kick
next out, do work, and in most cases had little CPU contention so could
make good progress in each burst, albeit with the high latency cost.

Alan
