Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2EXLwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 07:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab2EXLwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 07:52:38 -0400
Date: Thu, 24 May 2012 13:52:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
Message-ID: <20120524115206.GB1775@m.brq.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
 <1337853048.9783.92.camel@laptop>
 <CABPqkBR9hewjNUJf9ByD-jHc42e_qwQiKoP68RyL7BU8Q7BGgQ@mail.gmail.com>
 <1337856142.9783.104.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337856142.9783.104.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:42:22PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-24 at 12:06 +0200, Stephane Eranian wrote:
> 
> > > What are we doing here and why?
> > >
> > I think this is related to a discusion we had earlier about which
> > machine state you want
> > to sample.
> > 
> > There are 3 possible machine states:
> >   1- user level (even when sample is in kernel AND assuming you did
> > not hit a kernel only thread)
> >   2- interrupted state (@ PMU interrupt)
> >   3- precise state (state captured by PEBS on Intel, for instance)
> > 
> > Jiri is only interested in 1/. I am interested in the other two as well.
> > 
> > Question: is there a situation where we could need more than one machine
> > state per sample?
> 
> Well, IIRC you always wanted both 2 and 3 at the same time to compute
> skid, thus:
> 
> > If not, then a single bitmask is enough.
> 
> Indeed, so then we get to multiple bitmasks and unless you want to be
> restricted to the same bitmap for all these types this setup won't
> actually work.

My intention was to make this general. I could just add
bitmask for each type (user regs mask for now) but I wanted
to be consistent with other SAMPLE_* stuff..

So current patch adds PERF_SAMPLE_REGS sample_type bit.
Once it is set, the 'sample_regs' value is checked for what
type of registers you want for sample.

Each type then has separate bitmask in case you want different
registers for each type. Allowing whatever combination of regs dump
being added to the sample, since it seems there's no firm
decision on what combination might be needed.

Sure we can make the same with bitmasks for each regs type,
and check the presence in sample by bitmask being not empty.
