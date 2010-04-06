Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab0DFQpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:45:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33763 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab0DFQpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GbuHo+79FIYwWcoV7DulG+JYOS9Wuh2C3nIlKcvfB4MIDJlNDexX4nB2CbnXg3tTM0
         OzujLNojAS9/y6dQVQOLTD7qugQE9Jc6y3bYbz99Lvzuov0XM8sr7mKjYDrwDVYnS2YH
         pV4uEE03jg+1Z4jglW16S/+HRVHxJGA0wheCI=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
References: <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>
	  <1270568096.1814.145.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>
	 <1270571019.1814.163.camel@barrios-desktop>
	 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 01:45:27 +0900
Message-ID: <1270572327.1711.3.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 09:28 -0700, Linus Torvalds wrote:
> 
> On Wed, 7 Apr 2010, Minchan Kim wrote:
> > > 
> > > However, that made me look at the PAGE_MIGRATION case. That seems to be 
> > > just broken. It's doing that page_anon_vma() + spin_lock without holding 
> > > any RCU locks, so there is no guarantee that anon_vma there is at all 
> > > valid.
> > 
> > FYI, recently there is a patch about migration case. 
> > http://lkml.org/lkml/2010/4/2/145
> 
> No, I'm talking about rmap_walk_anon():
> 
>         anon_vma = page_anon_vma(page);
>         if (!anon_vma)
>                 return ret;
>         spin_lock(&anon_vma->lock);
> 
> which seems to be simply buggy. The anon_vma may not exist any more, 
> because an RCU event might have really freed the page between looking it 
> up and locking it.
> 
> 			Linus

unmap_and_move
	remove_migration_ptes
		rmap_walk
			rmap_walk_anon

We always has rcu_read_lock about anon page in unmap_and_move.
So I think it's not buggy. What am I missing?


-- 
Kind regards,
Minchan Kim


