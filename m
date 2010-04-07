Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab0DGONu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:13:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757864Ab0DGONt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:13:49 -0400
Message-ID: <4BBC92D6.6040403@redhat.com>
Date: Wed, 07 Apr 2010 10:12:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <20100402175937.GA19690@liondog.tnic>	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>	 <20100406173754.7E5A.A69D9226@jp.fujitsu.com> <4BBB475A.7070002@redhat.com>	   <1270568096.1814.145.camel@barrios-desktop>	 <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org>	 <1270571019.1814.163.camel@barrios-desktop>	 <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>	 <1270572327.1711.3.camel@barrios-desktop>	 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>	 <4BBB69A9.5090906@redhat.com>	 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <1270629403.5109.552.camel@twins>
In-Reply-To: <1270629403.5109.552.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 04:36 AM, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 11:28 -0700, Linus Torvalds wrote:

>>          if (empty)
>>                  anon_vma_free(anon_vma);
>>
>> *before* unlink_anon_vma's has actually does that
>>
>>          list_del(&avc->same_vma);
>>
>> and what we essentially have is a stale anon_vma_chain entry that still
>> exists on that same_vma list, and points to an anon_vma that already got
>> deleted.
>>
>> Does it matter? I really can't see that it does.
>
> I think it does, the anon_vma thing has an RCU destroyed slab, but that
> doesn't mean the anon_vma object itself is rcu delayed. The moment we
> free it it can be re-used. So the above use after free is a bug.

Peter, the avc is an anon_vma_chain, which is a different
object than the anon_vma itself.  There is no use after free
of an anon_vma object in unlink_anon_vmas + anon_vma_unlink.
