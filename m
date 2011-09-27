Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1I0U0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:26:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24462 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1I0U0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:26:17 -0400
MIME-Version: 1.0
Message-ID: <93d51294-ba6f-43e5-bf79-15c966a6c8ec@default>
Date: Tue, 27 Sep 2011 13:25:39 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: RE: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too
 far
References: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default>
 <4E81F278.5040107@citrix.com> <f42e2a83-15f6-4767-a7df-8a23ceac239e@default
 4E820316.6070101@citrix.com>
In-Reply-To: <4E820316.6070101@citrix.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090206.4E823164.00B8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Vrabel [mailto:david.vrabel@citrix.com]
> Cc: Konrad Wilk; linux-kernel@vger.kernel.org; xen-devel@lists.xensource.com; Jeremy Fitzhardinge
> Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too far
> 
> On 27/09/11 17:19, Dan Magenheimer wrote:
> >> From: David Vrabel [mailto:david.vrabel@citrix.com]
> >> Subject: Re: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too far
> >>
> >> On 27/09/11 16:03, Dan Magenheimer wrote:
> >>> Note: This patch is also now in a git tree at:
> >>>
> >>> git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v2
> >>>
> >>> The balloon driver's "current_pages" is very different from
> >>> totalram_pages.  Self-ballooning needs to be driven by
> >>> the latter.
> >
> > Hi David --
> >
> > Thanks for the feedback!
> >
> >> I don't think this part of the change makes any difference. It looks like it
> >> rearranges the maths without changing the end result (other than
> >> slightly increasing the rate of change).
> >> I think this (partial, untested) patch is equivalent:
> >
> > Actually it does.
> 
> Really?
> 
> Both patched and unpatched the new target, S, is (eventually):
> 
>    S = V + F + C - T
> 
> where V is vm_committed_as, F is frontswap_curr_pages(), C is
> balloon_stats.current_pages, and T = totalram_pages.

Sorry, in my haste to shoot off a quick reply while my mind
was somewhere else, I see my reply was poor and misleading.

Yes, "S", the value passed to balloon_set_new_target(), is
the same in most cases.  However, it is V+F, not S, that must
be compared against M (= the floor function); the "target"
of selfballooning, the value that the kernel cares about
(not the value that Xen cares about) is max(V+F,M).  This
gets converted to Xen-cares-about, IOW:

	S = max(V+F,M) + C - T

where S is passed to balloon_set_new_target.

> Perhaps the refactoring of the maths is a good idea (I don't think so)
> but it shouldn't be part of this patch and it shouldn't be described as
> a fix.

The refactored version makes sense now from a kernel perspective,
though I can see how it might be confusing from a Xen perspective,
especially to a balloon driver expert such as yourself.

It is most definitely a fix because the formula is different
and OOMs that previously happened no longer happen.  I don't
think the commit comment describes the *refactoring* as a fix,
just says that self-ballooning needs to be driven by kernel-
cares-about values (even if it has to interface to the
Xen balloon driver with a Xen-cares-about parameter).

Hopefully that makes more sense?

Dan
