Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab0DFRGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 13:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab0DFRF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 13:05:57 -0400
Message-ID: <4BBB69A9.5090906@redhat.com>
Date: Tue, 06 Apr 2010 13:04:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <20100402175937.GA19690@liondog.tnic>  <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>  <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>   <1270568096.1814.145.camel@barrios-desktop>  <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>  <1270571019.1814.163.camel@barrios-desktop>  <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 12:53 PM, Linus Torvalds wrote:
> On Wed, 7 Apr 2010, Minchan Kim wrote:
>>
>> unmap_and_move
>> 	remove_migration_ptes
>> 		rmap_walk
>> 			rmap_walk_anon
>>
>> We always has rcu_read_lock about anon page in unmap_and_move.
>> So I think it's not buggy. What am I missing?
>
> Ok, in that case it's fine.
>
> However, it does bring back my comment about all those anonvma changes:
> the locking is totally undocumented.
>
> Why isn't there a thing _saying_ that it's ok because of this?
>
> Why is there no comment about the locking of that 'same_vma' /
> 'vma->anon_vma_chain' except for the totally nonsensical one about
> page_table_lock (which doesn't protect _any_ of the other cases)?

Which other cases? When do we ever walk the "same_vma" list
not from the context of the process owning the vma?

This bug in page_referenced is walking the "same_anon_vma" list,
which is locked with the anon_vma->lock.
