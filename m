Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2F1OnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:43:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58449 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab2F1Om7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:42:59 -0400
Message-ID: <4FEC6D44.8080807@zytor.com>
Date: Thu, 28 Jun 2012 07:42:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: cyclonusj@gmail.com, marmarek@invisiblethingslab.com,
        xen-devel@lists.xensource.com, x86@kernel.org,
        Jason Garrett-Glaser <jason@x264.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, tglx@linutronix.de,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [Xen-devel] [PATCH] x86 fixes for 3.3 impacting distros (v1).
References: <1328888091-9692-1-git-send-email-konrad.wilk@oracle.com> <CABS55+BFrDUV-WR=nx+d6+ZJngpuZnh41DZ3NYU4adFqaxqaNA@mail.gmail.com> <20120510153457.GB6389@phenom.dumpdata.com> <20120627231755.GA1021@gmail.com> <20120628142836.GE8956@phenom.dumpdata.com>
In-Reply-To: <20120628142836.GE8956@phenom.dumpdata.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 07:28 AM, Konrad Rzeszutek Wilk wrote:
> 
> Peter mentioned to me had some ideas about software PAT table lookup. I am not
> exactly sure what he meant by that.
> 

I could see the kernel have programmable PAT values rather than fixed if
and only if it can be showed to have no measurable performance impact.

> Just to summarize, there were two ways proposed to fix this:
> 
>  1). Make __page_change_attr_set_clr use a new wrapper: pte_attr, that calls
>      pte_val (pvops call) instead of pte_flag (native). Here is the patch:
>      http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commitdiff;h=4f93aa02acd0e34806d4ac9c3a700bb5d040eab6
>      (no perf regressions across all platforms)
> 
>  2). Introduce a new pvops call - pte_flags, which would make pte_flags
>      (which currently is doing just a bit mask) be pvops-fied.
>      http://darnok.org/results/baseline_pte_flags_pte_attrs/0001-x86-paravirt-xen-Introduce-pte_flags.patch
>      http://darnok.org/results/baseline_pte_flags_pte_attrs/0002-x86-paravirt-xen-Optimize-pte_flags-by-marking-it-as.patch
>      (weird results on AMD, other platforms had no perf degradations)
> 
>   3). (not posted), was to do 2), but alter the alternative_asm and instead use asm_goto to
>      make the compiler use less registers and hopefully reduce the code:
>      http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=shortlog;h=refs/heads/devel/mmu-perf
>      But the results I got showed worst performance on baremetal.. which was weird?
>      Perhaps it is compiler related - never got to follow up on it.
> 

OK, let me be blunt: I will unconditionally veto any of these.

> 
> I also chatted with the core Xen hypervisor folks about adding in the context switch code
> to alter the PAT layout - but they were not keen a about it - and I am not sure how much
> CPU cycles one loses by doing a wrmsr to the PAT register on every guest context switch
> (worst case when on has a pvops kernel and a old-style one - where the WC bit would differ)?
> 

And you're comparing that to a bunch of new pvops calls?  The discussion
shouldn't even have started until you had ruled out this solution and
had data to show it.

	-hpa
