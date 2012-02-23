Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab2BWKAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:00:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41260 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782Ab2BWKAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:00:02 -0500
Date: Thu, 23 Feb 2012 10:59:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Roberto Agostino Vitillo <ravitillo@lbl.gov>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, acme@redhat.com, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling to
 perf report
Message-ID: <20120223095922.GC24310@elte.hu>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
 <1328826068-11713-14-git-send-email-eranian@google.com>
 <20120222111501.GA23068@elte.hu>
 <CABPqkBQz0G6DQfAfzD2=1mCDvmVsaZhFjW0qEh4y+rNxtbLC4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBQz0G6DQfAfzD2=1mCDvmVsaZhFjW0qEh4y+rNxtbLC4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Wed, Feb 22, 2012 at 12:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Stephane Eranian <eranian@google.com> wrote:
> >
> >> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> >>
> >> This patch adds support for taken branch sampling, i.e, the
> >> PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
> >> words, to display histograms based on taken branches rather
> >> than executed instructions addresses.
> >>
> >> The new option is called -b and it takes no argument. To
> >> generate meaningful output, the perf.data must have been
> >> obtained using perf record -b xxx ... where xxx is a branch
> >> filter option.
> >>
> >> The output shows symbols, modules, sorted by 'who branches
> >> where' the most often. The percentages reported in the first
> >> column refer to the total number of branches captured and
> >> not the usual number of samples.
> >>
> >> Here is a quick example.
> >> Here branchy is simple test program which looks as follows:
> >>
> >> void f2(void)
> >> {}
> >> void f3(void)
> >> {}
> >> void f1(unsigned long n)
> >> {
> >>   if (n & 1UL)
> >>     f2();
> >>   else
> >>     f3();
> >> }
> >> int main(void)
> >> {
> >>   unsigned long i;
> >>
> >>   for (i=0; i < N; i++)
> >>    f1(i);
> >>   return 0;
> >> }
> >>
> >> Here is the output captured on Nehalem, if we are
> >> only interested in user level function calls.
> >>
> >> $ perf record -b any_call,u -e cycles:u branchy
> >>
> >> $ perf report -b --sort=symbol
> >>     52.34%  [.] main                   [.] f1
> >>     24.04%  [.] f1                     [.] f3
> >>     23.60%  [.] f1                     [.] f2
> >>      0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
> >>      0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
> >>      0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
> >>      0.01%  [k] __printf               [k] _IO_vfprintf_internal
> >>      0.01%  [k] main                   [k] __printf
> >
> > Ok, nice feature.
> >
> > One detail needs to be fixed though, if someone does:
> >
> >  perf record -b ...
> >
> > then 'perf report' should *default* to the above branch stack
> > output style, without having to specify -b again.
> >
> Fair enough.
> 
> I'll check how we could do that. It's not so obvious as the code
> stands. I think we may need to add a new feature bit for that.
> It would avoid having to sniff either the cmdline, the event desc
> or worst the samples themselves.

Yeah, a feature bit for that looks like the ideal solution 
anyway.

Btw., the exact perf record command line ought to be 
reproducible from the metadata stored in the perf.data.

It should be possible to type:

   perf record --replay

or so, which takes a look at the perf.data and repeats that 
exact measurement. Something like this:

   perf record -R -F 10000

could be used to repeat the last measurement, with higher 
frequency sampling.

Thanks,

	Ingo
