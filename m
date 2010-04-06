Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0DFPfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:35:13 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:48836 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab0DFPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v2s/NYkfR6/ymkoIZrn1iM0usx/IGpX/yOI/GcWi+tGTPWrVgmWqAGQ4Xc9ZiMFyOo
         FqROw44ypslp/HULB4XW58/minWo8rTn6qR/lnMd14IocN92dpAT2KikSWewzleUUN6t
         aAkYFCG+ycmtEmi2BZ4ZB60tmhMPvbjKPYfCo=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <4BBB475A.7070002@redhat.com>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 00:34:55 +0900
Message-ID: <1270568096.1814.145.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 10:38 -0400, Rik van Riel wrote:
> On 04/06/2010 04:53 AM, KOSAKI Motohiro wrote:
> 
> > Today, I've reviewed this patch carefully. but I haven't found any bug.
> 
> > Also, I've runned stress workload with shrink_all_memory() today. but
> > I couldn't reproduce the issue. hmm..  (perhaps I'm no lucky guy.
> > I'm frequently fail to reproduce)
> >
> > I'll continue to work.
> 
> My status with this bug is the same - I have gone through
> the code from all angles, but have not found any other bugs
> yet (except for that leak - which could leave invalid
> pointers behind).

Let's see the unlink_anon_vmas. 

1. list_for_each_entry_safe(avc,next, vma->anon_vma_chain, same_vma)
2. 	anon_vma_unlink
3. 		spin_lock(anon_vma->lock) <-- HERE LOCK.
4.		list_del(anon_vma_chain->same_anon_vma);

What if anon_vma is destroyed and reuse by SLAB_XXX_RCU for another
anon_vma object between 2 and 3?
I mean how to make sure 3) does lock valid anon_vma? 

I hope it is culprit.


-- 
Kind regards,
Minchan Kim


