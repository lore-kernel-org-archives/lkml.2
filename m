Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab0DJXca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 19:32:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50635 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104Ab0DJXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 19:32:29 -0400
Date: Sun, 11 Apr 2010 00:35:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, Peter Zijlstra <peterz@infradead.org>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
 spinning
Message-ID: <20100411003529.28fe5c3b@lxorguk.ukuu.org.uk>
In-Reply-To: <j2ia36005b51004061034p8c59ecag87c4d90660f33562@mail.gmail.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	<4BBA5305.7010002@redhat.com>
	<4BBA5C00.4090703@us.ibm.com>
	<4BBA6279.20802@redhat.com>
	<4BBA6B6F.7040201@us.ibm.com>
	<4BBB36FA.4020008@redhat.com>
	<1270560931.1595.342.camel@laptop>
	<20100406145128.6324ac9a@lxorguk.ukuu.org.uk>
	<4BBB531A.4070500@us.ibm.com>
	<20100406174459.60088461@lxorguk.ukuu.org.uk>
	<j2ia36005b51004061034p8c59ecag87c4d90660f33562@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The non-swappable part will be tricky.  One doesn't know how many
> threads will be created in a process.  This mechanism shouldn't put an
> arbitrary limit in place.  So where to allocate the memory?  Perhaps
> it's better to implicitly mark the memory page pointed to by the new
> syscall as non-swappable?  This could mean one page per thread...

You only need one page per 4096 threads or so if you make it create the
page on the first request, tied to say the signals and the like in
threaded tasks, and you then allocate 'slots' in the page for future
calls until you've got 4096 live.

ie you'd see something like

	addr = set_tid_notifier_addr();

	[1st call
	 map page at x to x + 4095, probably R/O]
	[returns x]

next thread
	addr = set_tid_notifier_addr()

	[returns x + 1]

Alan
