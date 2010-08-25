Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0HYXwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:52:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37291 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0HYXwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:52:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dOhQ5lhDTR8IlANTGuvUOkjohv4VLY4YAbEP/YvFZ14cSoC+Ltfr5/16WQtzJQg2HB
         RDXl5BS5KA+jBdNgrP/qSxj2Ws9palx38tL50hdcEvy7BN6cOZvDJwbsJMKJWs4CB8ma
         l83lesS9o2lC2MlDxCA7MbHyYVeKV2UST/CvA=
Date: Thu, 26 Aug 2010 01:52:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100825235229.GC5389@nowhere>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu> <20100824171504.GI26154@erda.amd.com> <20100824172806.GF5723@lenovo> <20100824184658.GB4879@redhat.com> <20100824185458.GG5723@lenovo> <20100824195240.GA5281@lenovo> <20100824202718.GC4879@redhat.com> <20100824204038.GC5281@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824204038.GC5281@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:40:38AM +0400, Cyrill Gorcunov wrote:
> On Tue, Aug 24, 2010 at 04:27:18PM -0400, Don Zickus wrote:
> > On Tue, Aug 24, 2010 at 11:52:40PM +0400, Cyrill Gorcunov wrote:
> > > > I use 2.6.34 atm. Letme try 2.6.36 (which might require some time to recompile).
> > > > 
> > > > 	-- Cyrill
> > > 
> > > Don, for me it fails with somehow unrelated page handling fault - in
> > > reiserfs_evict_inode O_o Fails in __get_cpu_var I suspect might means
> > > a problem either in per-cpu allocator itself or we screw pointer somehow.
> > > Weird.
> > 
> > I just found out (with the help of the crash utility and Dave A.) that
> > Robert's percpu struct nmi clashes with the exception entry point .nmi.
> > I only see this problem in 2.6.36, so I am not sure what changed with
> > regards to compiler flags to confuse variables with text segments.
> > 
> 
> yeah, I suspect name clashes here but then I did grep over per-cpu variables
> in whole kernel and didn't find match so I thought the assumption was wrong,
> but eventually it happens to be true but via other way :) good to know, thanks!
> 
> > But renaming the percpu struct nmi to nmidon fixed the problem for me (I
> > am open to other suggestions :-) ).
> 
> nmi_don_zickus ;) well, I think nmi_pmu or something like that
> might be a bit modest ;)
> 
> > 
> > Regarding your reiserfs, what was the variable's name?
> > 
> 
> It seems to be different, it's pity that I had only 80x25 vga
> mode and was unable to snap the whole log. But actually I didn't
> even check precisely all .config options I had set since I was
> more interested in early stage where per-cpu access should already
> happen rather then real init'ed environmen. But I think I'll be
> moving completely to .36 this week so we will see how it goes.


There was a missing "return" in the end of reiserfs_evict_inode.

It has been fixed there:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f4ae2faa40199b97b12f508234640bc565d166f8

