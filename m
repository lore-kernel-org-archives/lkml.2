Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2JQTuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:50:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57418 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2JQTuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:50:23 -0400
Date: Wed, 17 Oct 2012 12:50:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
In-Reply-To: <CAHGf_=rCbH7=6FX+PhhPUbixw-0TstdpTNzMEmXgQALbNAkGRg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210171246290.28214@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com> <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
 <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com> <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com>
 <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <507E4531.1070700@jp.fujitsu.com> <CAHGf_=rCbH7=6FX+PhhPUbixw-0TstdpTNzMEmXgQALbNAkGRg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, KOSAKI Motohiro wrote:

> > I think this refcounting is better than using task_lock().
> 
> I don't think so. get_vma_policy() is used from fast path. In other
> words, number of
> atomic ops is sensible for allocation performance.

There are enhancements that we can make with refcounting: for instance, we 
may want to avoid doing it in the super-fast path when the policy is 
default_policy and then just do

	if (mpol != &default_policy)
		mpol_put(mpol);

> Instead, I'd like
> to use spinlock
> for shared mempolicy instead of mutex.
> 

Um, this was just changed to a mutex last week in commit b22d127a39dd 
("mempolicy: fix a race in shared_policy_replace()") so that sp_alloc() 
can be done with GFP_KERNEL, so I didn't consider reverting that behavior.  
Are you nacking that patch, which you acked, now?
