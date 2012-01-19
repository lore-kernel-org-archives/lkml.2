Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2ASPhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:37:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61603 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab2ASPhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:37:39 -0500
Date: Thu, 19 Jan 2012 15:37:32 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
Message-ID: <20120119153732.GB20558@arm.com>
References: <gi39bcyff8.fsf@mx10.gouders.net>
 <20120119110121.GC9268@arm.com>
 <gi1uqvsx8n.fsf@karga.hank.lab>
 <20120119140058.GA19036@arm.com>
 <gik44nrc52.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gik44nrc52.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 02:38:01PM +0000, Dirk Gouders wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
> >> Catalin Marinas <catalin.marinas@arm.com> writes:
> >> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
> >> >> Freeing unused kernel memory: 608k freed
> >> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> >> >> BUG: unable to handle kernel paging request at ffffffff818b232b
> >> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
> > ...
> >> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> >> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
> >> >
> >> > I don't really see how kmemleak could cause such error (or any of the
> >> > recent changes I have made). It looks like some of the code in the
> >> > .init.text section is not executable.
> >
> > Ah, the interesting part - 0xcc is the poison value for freed initmem.
> > And from the kernel logs you posted Linux frees the initmem and later
> > calls kmemleak_late_init() which should have been in the .init.text
> > section.
> >
> > The kmemleak_late_init() function is defined as:
> >
> > static int __init kmemleak_late_init(void)
> > {
> > ...
> > }
> > late_initcall(kmemleak_late_init);
> >
> > and it must *not* be called after the initmem has been freed. Was there
> > any change in the x86 or generic code with regards to the freeing of the
> > init memory?
> 
> I tried to re-bisect this problem by marking commit
> 029aeff5db879afd7760f11214b6fea45f76b58e
> "kmemleak: Add support for memory hotplug" (that I previously considered
> good, because it produces a different output) bad.  The attached output
> shows that kmemleak_late_init is also involved but bisect did not bring
> me a step further:
> 
> $ git bisect good f1c84dae0e
> Bisecting: a merge base must be tested
> [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1

If you bisect to one of the kmemleak commits, they are based on 3.2-rc4
so you miss any commits that may have been merged during the merge
window.

> ------------------------------------------------------------------------
> Freeing unused kernel memory: 676k freed
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle kernel paging request at ffffffff81892482
> IP: [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
> PGD 17cd067 PUD 17d1063 PMD 3c5c8063 PTE 8000000001892163
> Oops: 0011 [#1] SMP 

Similar behaviour, the init memory is freed before the initcalls, so
doesn't look like a kmemleak problem.

Could you pass initcall_debug on the kernel command line and see how may
commits are called before and after the free_initmem() call?

You could also try to revert (git revert) the kmemleak commits from the
latest git tree, without bisecting.

-- 
Catalin
