Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1C2JQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:16:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47243 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324Ab1C2JQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:16:08 -0400
Date: Tue, 29 Mar 2011 10:16:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: advice sought: practicality of SMP cache coherency implemented
 in assembler (and a hardware detect line)
Message-ID: <20110329101630.1f1f0364@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
	<20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
	<20110328180655.GI2287@linux.vnet.ibm.com>
	<AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
	<20110328231818.2297408f@lxorguk.ukuu.org.uk>
	<AANLkTimXztH_4f1=7-Ez6j-7UESroqwBvVuDNW7Fmewb@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  hmmm, the question is, therefore: would the MOSIX DSM solution be
> preferable, which i presume assumes that memory cannot be shared at
> all, to a situation where you *could* at least get cache coherency in
> userspace, if you're happy to tolerate a software interrupt handler
> flushing the cache line manually?

In theory DSM goes further than this. One way to think about DSM is cache
coherency in software with a page size granularity. So you could imagine
a hypothetical example where the physical MMU of each node and a memory
manager layer comnunicating between them implemented a virtualised
machine on top which was cache coherent.

The detail (and devil no doubt) is in the performance.

Basically however providing your MMU can trap both reads and writes you
can implement a MESI cache in software. Mosix just took this to an
extreme as part of a distributed Unix (originally V7 based).

So you've got

Modified: page on one node, MMU set to fault on any other so you can
	  fix it up

Exclusive: page on one node, MMU set to fault on any other or on writes
	   by self (latter taking you to modified so you know to write
	   back)

Shared:    any write set to be caught by the MMU, the fun bit then is
	   handling invalidating across other nodes with the page in
	   cache. (and the fact multiple nodes may fault the page at once)

Invalid:   our copy is invalid (its M or E elsewhere probably), MMU set so
	   we fault on any access. For shared this is also relevant so
	   you can track for faster invalidates

and the rest is a software problem.
