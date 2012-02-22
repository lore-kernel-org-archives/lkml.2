Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2BVLPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 06:15:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab2BVLPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 06:15:33 -0500
Date: Wed, 22 Feb 2012 12:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>,
        Roberto Agostino Vitillo <ravitillo@lbl.gov>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling to
 perf report
Message-ID: <20120222111501.GA23068@elte.hu>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
 <1328826068-11713-14-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328826068-11713-14-git-send-email-eranian@google.com>
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

> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
> 
> This patch adds support for taken branch sampling, i.e, the
> PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
> words, to display histograms based on taken branches rather
> than executed instructions addresses.
> 
> The new option is called -b and it takes no argument. To
> generate meaningful output, the perf.data must have been
> obtained using perf record -b xxx ... where xxx is a branch
> filter option.
> 
> The output shows symbols, modules, sorted by 'who branches
> where' the most often. The percentages reported in the first
> column refer to the total number of branches captured and
> not the usual number of samples.
> 
> Here is a quick example.
> Here branchy is simple test program which looks as follows:
> 
> void f2(void)
> {}
> void f3(void)
> {}
> void f1(unsigned long n)
> {
>   if (n & 1UL)
>     f2();
>   else
>     f3();
> }
> int main(void)
> {
>   unsigned long i;
> 
>   for (i=0; i < N; i++)
>    f1(i);
>   return 0;
> }
> 
> Here is the output captured on Nehalem, if we are
> only interested in user level function calls.
> 
> $ perf record -b any_call,u -e cycles:u branchy
> 
> $ perf report -b --sort=symbol
>     52.34%  [.] main                   [.] f1
>     24.04%  [.] f1                     [.] f3
>     23.60%  [.] f1                     [.] f2
>      0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
>      0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
>      0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
>      0.01%  [k] __printf               [k] _IO_vfprintf_internal
>      0.01%  [k] main                   [k] __printf

Ok, nice feature.

One detail needs to be fixed though, if someone does:

  perf record -b ...

then 'perf report' should *default* to the above branch stack 
output style, without having to specify -b again.

Having --branch/--no-branch present in perf report is fine if 
someone wants to force either direction, but the default 
absolutely must be picked up from the perf.data and should be 
the obvious behavior.

Other than that it looks good to me, so if this detail is fixed 
(can be a delta patch on top of the existing series) and there's 
no problems with it I can pick it up for v3.4.

Thanks,

	Ingo
