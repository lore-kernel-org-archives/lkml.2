Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2JUSDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 14:03:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54685 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab2JUSDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 14:03:46 -0400
Date: Sun, 21 Oct 2012 20:03:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf: SNB exclusive PMU access for
 INST_RETIRED:PREC_DIST
Message-ID: <20121021180341.GA4128@gmail.com>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
 <1350658326-14715-3-git-send-email-eranian@google.com>
 <1350664077.2768.32.camel@twins>
 <CABPqkBQ5kCyGByFS-D62RYg2VUf_W-rJKDH=AzyrcaBPVY-eFQ@mail.gmail.com>
 <1350665152.2768.41.camel@twins>
 <20121019172018.GA2095@tassilo.jf.intel.com>
 <20121021165523.GA29247@gmail.com>
 <CABPqkBR_BSf6Akzxn+2gOrksUMXmAgPi3xY0KJUbhT0Eddo3Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR_BSf6Akzxn+2gOrksUMXmAgPi3xY0KJUbhT0Eddo3Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Sun, Oct 21, 2012 at 6:55 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Andi Kleen <ak@linux.intel.com> wrote:
> >
> >> > > > This isn't limited to admin, right? So the above turns into a DoS on the
> >> > > > console.
> >> > > >
> >> > > Ok, so how about a WARN_ON_ONCE() instead?
> >> >
> >> > That should be fine I guess ;-)
> >>
> >> imho there is need for a generic mechanism to return an error
> >> string to the user program without such hacks.
> >
> > Agreed - we could return an 'extended errno' long error return
> > value, which in reality is a pointer to an error string (in
> > perf_attr::error_str), and copy that string to user-space at
> > perf syscall return time.
> >
> I assume by perf_attr:error_str, you actually mean:
> 
> struct perf_event_attr {
>    char error_str[PERF_ERR_LEN];
> };
> 
> Right?

I don't think we should allocate space in the attr, instead we 
should use something like:

	u8 __user	*err_str;
	u32		 err_str_len;

which would be filled in by tooling with a string and a max_len 
value, and strncpy_to_user() could do the rest on the kernel 
side. [ A minor complication is that we don't have a 
strncpy_to_user() method at the moment. ]

Static strings could be handled this way.

[ Dynamic strings could be supported too with a few tricks, 
  although I doubt it matters in practice. ]

> > Thus error-string aware tooling could print the error string.
> >
> > So PMU drivers could do something obvious like:
> >
> >         return (long)"perf: INST_RETIRED.PREC_DIST only works in exclusive mode";
> >
> > The perf syscall notices these pointers by noticing that the
> > error code returned is outside the errno range.
>
> Is that always the case on all archs?

I think yes - and if not then it can be solved via some trivial 
offset value added to it on such an architecture, without 
complicating the code on normal architectures.

Thanks,

	Ingo
