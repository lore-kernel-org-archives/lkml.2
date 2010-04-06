Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0DFQdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:33:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab0DFQdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:33:11 -0400
Date: Tue, 6 Apr 2010 09:28:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
In-Reply-To: <1270571019.1814.163.camel@barrios-desktop>
Message-ID: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>  <1270568096.1814.145.camel@barrios-desktop> 
 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Minchan Kim wrote:
> > 
> > However, that made me look at the PAGE_MIGRATION case. That seems to be 
> > just broken. It's doing that page_anon_vma() + spin_lock without holding 
> > any RCU locks, so there is no guarantee that anon_vma there is at all 
> > valid.
> 
> FYI, recently there is a patch about migration case. 
> http://lkml.org/lkml/2010/4/2/145

No, I'm talking about rmap_walk_anon():

        anon_vma = page_anon_vma(page);
        if (!anon_vma)
                return ret;
        spin_lock(&anon_vma->lock);

which seems to be simply buggy. The anon_vma may not exist any more, 
because an RCU event might have really freed the page between looking it 
up and locking it.

			Linus
