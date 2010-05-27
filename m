Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab0E0Vxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:53:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64700 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab0E0Vxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=EB5YclqbkSy8k4SkoRW0lic9NCY1EzleCyaaXFvG1UyXFcMWEXOuXpSbHZSWqOZS/k
         Cqlpfx5RAuYkzec2IRxlBm4ZXT7o90BRpxRFHD4VnoeqtMgpghIN4cuLU8rt1jIzlNa0
         Yna++YHOVd+epvnfDKUChD0bOEwvB4DEHF6iI=
Date: Thu, 27 May 2010 18:53:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Arun Sharma <aruns@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
Message-ID: <20100527215333.GM9874@ghostprotocols.net>
References: <20100503203813.GA17886@sharma-home.net>
 <1272919356.1642.154.camel@laptop>
 <w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
 <1272964598.5605.133.camel@twins>
 <20100505181612.GA5091@sharma-home.net>
 <20100527184135.GL9874@ghostprotocols.net>
 <AANLkTim4UdMxxPkhHjVd_433Uk2QoVXBTy44KUlRBNSX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim4UdMxxPkhHjVd_433Uk2QoVXBTy44KUlRBNSX@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 01:54:46PM -0700, Arun Sharma escreveu:
> On Thu, May 27, 2010 at 11:41 AM, Arnaldo Carvalho de Melo
> <acme@ghostprotocols.net> wrote:
> > Em Wed, May 05, 2010 at 11:16:12AM -0700, Arun Sharma escreveu:
> >> On Tue, May 04, 2010 at 11:16:38AM +0200, Peter Zijlstra wrote:
> >> > > In a shared multi-core environment, users want to analyze why their
> >> > > program was slow. In particular, if the code ran slower only on
> >> > > certain CPUs due to interference from other programs or kernel
> >> > > threads, they want to know that.

> >> > But for that you use perf record -a, right? So you record all cpus
> >> > allways -- otherwise there is no telling what was happening to make it
> >> > go slow.

> >> The updated patch records the CPU only in the system_wide mode.

> > I think this should be done only if you'll actually need it, as in,
> > "cpu" is one of the sort keys, but that can be done as a followup patch,
> > but there is another thing I think you need to change, see below.

> How would you know if the user is going to sort by cpu at "perf record" time?

Excellent point, but as time goes on we may end up selecting all the
optionally selectable fields, so perhaps we should tell that to record
and then check at report time if it is present?

For instance, PERF_SAMPLE_TIME would be interesting too to check if
there is no reordering of events, etc, but should we have it always
enabled?

If we used something like:

perf record --sort cpu,comm ...

We would be able for instance, to avoid having MMAP events that wouldn't
be used at all, reducing PERF_SAMPLE_TID too, I guess, and then the per
event cost would be reduced, on the other hand, if we want to have
maximum flexibility at 'report' time, we could use:

perf record --sort all

With the default remaining the one we have.

perf record --sort +cpu

could be used to add one field to the set of fields in place, whatever
we get the default to be at any point in time.

perf record could as well, if no --sort is presented, infer a reasonable
one from the set of fields present in sample_type, etc.

Of course the feature implemented as-is by your patch is useful and we
need to support it, it can even be like you posted, but I wanted to
express this feeling about per event cost.
 
> Thanks for taking care of the second part.

Will try to get it done now and will send for review.

- Arnaldo
