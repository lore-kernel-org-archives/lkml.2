Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab2JQTi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:38:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62782 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab2JQTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:38:57 -0400
Date: Wed, 17 Oct 2012 12:38:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, bhutchings@solarflare.com,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.7] mm, mempolicy: fix printing stack contents in
 numa_maps
In-Reply-To: <20121017193229.GC16805@redhat.com>
Message-ID: <alpine.DEB.2.00.1210171237130.28214@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com> <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com> <CAHGf_=pemT6rcbu=dBVSJE7GuGWwVFP+Wn-mwkcsZ_gBGfaOsg@mail.gmail.com>
 <alpine.DEB.2.00.1210161657220.14014@chino.kir.corp.google.com> <alpine.DEB.2.00.1210161714110.17278@chino.kir.corp.google.com> <20121017040515.GA13505@redhat.com> <alpine.DEB.2.00.1210162222100.26279@chino.kir.corp.google.com> <20121017181413.GA16805@redhat.com>
 <alpine.DEB.2.00.1210171219010.28214@chino.kir.corp.google.com> <20121017193229.GC16805@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2012, Dave Jones wrote:

>  > Sounds good.  Is it possible to verify that policy_cache isn't getting 
>  > larger than normal in /proc/slabinfo, i.e. when all processes with a 
>  > task mempolicy or shared vma policy have exited, are there still a 
>  > significant number of active objects?
> 
> Killing the fuzzer caused it to drop dramatically.
> 
> Before:
> (15:29:59:davej@bitcrush:trinity[master])$ sudo cat /proc/slabinfo  | grep policy
> shared_policy_node   2931   2967    376   43    4 : tunables    0    0    0 : slabdata     69     69      0
> numa_policy         2971   6545    464   35    4 : tunables    0    0    0 : slabdata    187    187      0
> 
> After:
> (15:30:16:davej@bitcrush:trinity[master])$ sudo cat /proc/slabinfo  | grep policy
> shared_policy_node      0    215    376   43    4 : tunables    0    0    0 : slabdata      5      5      0
> numa_policy           15    175    464   35    4 : tunables    0    0    0 : slabdata      5      5      0
> 

Excellent, thanks.  This shows that the refcounting is working properly 
and we're not leaking any references as a result of this change causing 
the mempolicies to never be freed.  ("numa_policy" turns out to be 
policy_cache in the code, so thanks for checking both of them.)

Could I add your tested-by?
