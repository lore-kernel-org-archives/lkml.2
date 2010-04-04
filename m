Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0DDRZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 13:25:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0DDRZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 13:25:27 -0400
Message-ID: <4BB8CB40.5080108@redhat.com>
Date: Sun, 04 Apr 2010 13:24:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>	 <20100402175937.GA19690@liondog.tnic>	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>	 <20100402112428.f46ddc44.akpm@linux-foundation.org>	 <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>	 <4BB66941.1060809@redhat.com> <1270397575.1814.106.camel@barrios-desktop>
In-Reply-To: <1270397575.1814.106.camel@barrios-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2010 12:12 PM, Minchan Kim wrote:

> While I review the code again due to this BUG, I found some strange
> thing.
>
> In anon_vma_fork, if anon_vma_clone is successful but anon_vma_alloc is
> failed, what happens? Parent VMA's anon_vmas have anon_vma_chain which
> has vma which is destroyed.
> I couldn't find any clean routine to remove this garbage.
> I am missing something?

Good catch.  The parent VMA's anon_vmas will get delinked
eventually, but we need to get rid of the newly allocated
child anon_vmas.  You found a hopefully rare memory leak...

We need a call to unlink_anon_vmas(vma) at the error label
to do that.

> But I think it isn't related to this bug because oops point is not
> vma_address but anon_vma_chain.next.

Agreed, it's probably not it.
