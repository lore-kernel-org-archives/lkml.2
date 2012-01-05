Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2AEHCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:02:04 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44470 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2AEHCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:02:01 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4F0488AB.6000003@redhat.com>
References: <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com> <20120104145602.GB8333@linux.vnet.ibm.com> <4F0488AB.6000003@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Thu, 05 Jan 2012 12:27:32 +0530
Message-ID: <874nwafxgj.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12010420-0260-0000-0000-00000055B0BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 19:13:15 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 01/04/2012 04:56 PM, Srivatsa Vaddagiri wrote:
> > * Avi Kivity <avi@redhat.com> [2012-01-04 16:41:58]:
> >
> > > > Here are some observation related to Baseline-only(8vm case)
> > > >
> > > >               | ple_gap=128 | ple_gap=64 | ple_gap=256 | ple_window=2048
> > > > --------------+-------------+------------+-------------+----------------
> > > > EbzyRecords/s |    2247.50  |    2132.75 |    2086.25  |      1835.62
> > > > PauseExits    | 7928154.00  | 6696342.00 | 7365999.00  |  50319582.00
> > > >
> > > > With ple_window = 2048, PauseExits is more than 6times the default case
> > > 
> > > So it looks like the default is optimal, at least wrt the cases you
> > > tested and your test workload.
> >
> > The default case still lags considerably behind the results we are seeing with
> > gang scheduling. One more interesting data point would be to see how
> > many PLE exits we are seeing when the vcpu is spinning in
> > flush_tlb_others_ipi(). Is there any easy way to determine that?
> >
> 
> You could get an exit trace (trace-cmd -e kvm:kvm_exit) and filter on
> PLE exits; the trace contains the guest %rip, so you could match it
> against flush_tlb_others_ipi().
> 
Cool, this is much easier, had to do some awk script to extract PLE
exits wrt flush_tlb_others_ipi:

Matched 9382616(86%), Not matched 1453845(14%)

So considerable ple exits are from flush_tlb_others_ipi and even then we
see:

    35.01%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi

Nikunj

