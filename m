Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab0DFTPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:15:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756693Ab0DFTO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:14:58 -0400
Date: Tue, 6 Apr 2010 12:10:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <20100406120315.53ad7390.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004061204320.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com> <1270568096.1814.145.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, Andrew Morton wrote:

> On Tue, 6 Apr 2010 11:28:52 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > For example, maybe some list corruption causes us to do that 
> > "anon_vma_chain_link()" _twice_ on the same avc entry. So we do that 
> > "list_add_tail(&avc->same_anon_vma, &anon_vma->head);" on an entry that 
> > already had "same_anon_vma" on one list.
> 
> The lib/list_debug.c stuff might detect such things.  I wonder if
> either Borislav or Steinar had CONFIG_DEBUG_LIST enabled?

Well, even without CONFIG_LIST_DEBUG we'd catch _some_ things, and 
conversely, even with LIST_DEBUG on we don't catch everything.

For example, doing list_del() twice on the same entry will die with a 
really nice pattern due to poisoning even without LIST_DEBUG.

But list_add() twice on the same entry will sadly silently succeed both 
with and without list debugging (the list debugging will check the target 
list head, but there is no way to check the "new->next/prev" entries).

Anyway, I've not actually found anything wrong in the same_vma locking. 
And I'm not at all convinced there is any list corruption there. My point 
was really only that
 (a) the locking rules seem very unclear and certainly not documented and 
 (b) corruption of one list could easily be the cause of corruption of 
     another list of the same structure.
but I don't actually see anything wrong anywhere.

			Linus
