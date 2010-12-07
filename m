Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab0LGKyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 05:54:55 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:47195 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0LGKyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 05:54:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=muRfEqQkIWBhko/CxCJjf+DteNZk5WehD2O/Or0EuypN+sigAmHV5fxpzMu3QW39IP
         n5ZsSP4FR4NIP5HtZXZ9siyBklBRoHp9J8FXetuV0bxjKoJuZ30jxPcsc043UVD9z+25
         NsG/tsc7yFp3ulhXkmSFxsiH0zY1GuIj+0PN8=
Date: Tue, 7 Dec 2010 08:54:46 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
Message-ID: <20101207105446.GA6911@ghostprotocols.net>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
 <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com>
 <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6>
 <1291637998-sup-4601@au1.ibm.com>
 <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
 <1291640985-sup-4443@au1.ibm.com>
 <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6>
 <1291679635-sup-9860@au1.ibm.com>
 <alpine.LFD.2.00.1012070942070.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012070942070.2653@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 07, 2010 at 11:47:35AM +0100, Thomas Gleixner escreveu:
> On Tue, 7 Dec 2010, Ian Munsie wrote:
> > Makes sense. I did something similar in the report layer that I was
> > about to send when I saw this email, but this way we have a generic
> > solution for other parts of perf that might want this.
> > The problem here is that we only get the PERF_RECORD_HEADER_ATTR if perf
> > record has been piped somewhere, so running perf record <load>; perf
> > report on an unpatched kernel results in the COMM, MMAP, etc events
> > being processed last (timestamp -1ULL) and no userspace samples are
> > attributed at all:
> 
> Ok. We need to treat timestamp ~0ULL the same as timestamp 0ULL then.

Right.
  
> > > +    event__parse_sample(event, session, &sample);
> > > +    if (dump_trace)
> > > +        perf_session__print_tstamp(session, event, &sample);
> > 
> > Moving this here after the dump_printf("%#Lx [%#x]: PERF_RECORD_%s"...
> > changes the output of perf report -D in a bad way. Changing the spacing
> > in dump_printf can make up for it, or juggle the code around some more.
> 
> Crap. I wanted to restrict the sample parsing to the real events w/o
> having this magic comparison in place as we filter out the synth stuff
> in the switch case already. 
> 
> > How do you want to proceed? At this point either version of the patches
> > are pretty functionally equivelant. Mine does the perf report -D
> 
> Hmm. Arnaldo merged my version already.
> 
> > reordering as well, but that isn't really necessary to solve the bug.
> > Either way we only have a few minor fixups left.
> 
> Having time ordered output of -D needs more than fixing the time stamp
> issue. The dump_printf/dump_trace stuff is scattered all over the
> place. So that needs more code churn, as you want to output the non
> synth events when the ordered queue is drained.

We can fix that, but then it was supposed to be a dump, something as it
comes from the perf.data file.

Perhaps we need something new, that does ordered dumps, I think we can
just move all the dump_fprintf stuff to one place, and have calls for
those where it is now (unordered) and another one from the ordered
place, but looking at different debug variables?

- Arnaldo
