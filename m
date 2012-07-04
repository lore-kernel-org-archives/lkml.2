Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab2GDXE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 19:04:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2GDXEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 19:04:55 -0400
Date: Thu, 5 Jul 2012 01:03:50 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 06/40] autonuma: x86 pte_numa() and pmd_numa()
Message-ID: <20120704230350.GN25743@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
 <1340888180-15355-7-git-send-email-aarcange@redhat.com>
 <4FEDC391.5030502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEDC391.5030502@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 11:02:41AM -0400, Rik van Riel wrote:
> On 06/28/2012 08:55 AM, Andrea Arcangeli wrote:
> 
> >   static inline int pte_file(pte_t pte)
> >   {
> > -	return pte_flags(pte)&  _PAGE_FILE;
> > +	return (pte_flags(pte)&  _PAGE_FILE) == _PAGE_FILE;
> >   }
> 
> Wait, why is this change made?  Surely _PAGE_FILE is just
> one single bit and this change is not useful?
> 
> If there is a reason for this change, please document it.

I splitted it off to a separated patch with proper commit log here.

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=7b2292c7ab86205f3d630533dc9987449fea6347

I haven't checked if it spawns the same warning without the patchset
applied, but I need the build not to show warnings, so while it may be
irrelevant warning for upstream, I don't like to have warnings.

> >   static inline int pte_hidden(pte_t pte)
> > @@ -415,7 +417,46 @@ static inline int pte_hidden(pte_t pte)
> >
> >   static inline int pmd_present(pmd_t pmd)
> >   {
> > -	return pmd_flags(pmd)&  _PAGE_PRESENT;
> > +	return pmd_flags(pmd)&  (_PAGE_PRESENT | _PAGE_PROTNONE |
> > +				 _PAGE_NUMA_PMD);
> > +}
> 
> Somewhat subtle. Better documentation in patch 5 will
> help explain this.

It's as subtle as PROTNONE but I added more explanation below as well
as in patch 5.

> > +#ifdef CONFIG_AUTONUMA
> > +static inline int pte_numa(pte_t pte)
> > +{
> > +	return (pte_flags(pte)&
> > +		(_PAGE_NUMA_PTE|_PAGE_PRESENT)) == _PAGE_NUMA_PTE;
> > +}
> > +
> > +static inline int pmd_numa(pmd_t pmd)
> > +{
> > +	return (pmd_flags(pmd)&
> > +		(_PAGE_NUMA_PMD|_PAGE_PRESENT)) == _PAGE_NUMA_PMD;
> > +}
> > +#endif
> 
> These could use a little explanation of how _PAGE_NUMA_* is
> used and what the flags mean.

Added:

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=0e6537227de32c40bbf0a5bc6b11d27ba5779e68

> > +static inline pte_t pte_mknotnuma(pte_t pte)
> > +{
> > +	pte = pte_clear_flags(pte, _PAGE_NUMA_PTE);
> > +	return pte_set_flags(pte, _PAGE_PRESENT|_PAGE_ACCESSED);
> > +}
> > +
> > +static inline pmd_t pmd_mknotnuma(pmd_t pmd)
> > +{
> > +	pmd = pmd_clear_flags(pmd, _PAGE_NUMA_PMD);
> > +	return pmd_set_flags(pmd, _PAGE_PRESENT|_PAGE_ACCESSED);
> > +}
> > +
> > +static inline pte_t pte_mknuma(pte_t pte)
> > +{
> > +	pte = pte_set_flags(pte, _PAGE_NUMA_PTE);
> > +	return pte_clear_flags(pte, _PAGE_PRESENT);
> > +}
> > +
> > +static inline pmd_t pmd_mknuma(pmd_t pmd)
> > +{
> > +	pmd = pmd_set_flags(pmd, _PAGE_NUMA_PMD);
> > +	return pmd_clear_flags(pmd, _PAGE_PRESENT);
> >   }
> 
> These functions could use some explanation, too.
> 
> Why do the top ones set _PAGE_ACCESSED, while the bottom ones
> leave _PAGE_ACCESSED alone?
> 
> I can guess the answer, but it should be documented so it is
> also clear to people with less experience in the VM.

Added too in prev link.
