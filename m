Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab0DGWOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:14:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753778Ab0DGWOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:14:49 -0400
Date: Wed, 7 Apr 2010 15:09:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <4BBCFE8A.1030602@redhat.com>
Message-ID: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
 <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org> <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org> <4BBCFE8A.1030602@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Rik van Riel wrote:
> 
> One of the issues with your patch is that anon_vma_prepare
> can fail and this patch ignores its return value.

Yes. The failure point is too late to do anything really interesting with, 
and the old code also just causes a SIGBUS. My intention was to change the 

	WARN_ONCE(!vma->anon_vma);

into returning that SIGBUS - which is not wonderful, but is no different 
from old failures.

In the long run, it would be nicer to actually return an error from the 
mmap() that fails, but that's more complicated, and as mentioned, it's not 
what the old code used to do either (since the failure point was always at 
the page fault stage).

> Having anon_vma-prepare fail after an mremap or mprotect
> might result in messing up the VMAs of a process, or having
> to undo the VMA changes that were made.

We really aren't any worse off than we have always been.

If anon_vma_prepare() fails, the vma list will be valid, but no new pages 
can be added to that vma. That used to be true before too.

			Linus
