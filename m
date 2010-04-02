Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0DBWDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 18:03:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab0DBWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 18:03:03 -0400
Message-ID: <4BB66941.1060809@redhat.com>
Date: Fri, 02 Apr 2010 18:01:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100402112428.f46ddc44.akpm@linux-foundation.org> <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 02:37 PM, Linus Torvalds wrote:
> On Fri, 2 Apr 2010, Andrew Morton wrote:
>> On Fri, 2 Apr 2010 11:09:14 -0700 (PDT) Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>>
>>>
>>> I think this is likely due to the new scalable anon_vma linking by Rik.
>>
>> Similar to https://bugzilla.kernel.org/show_bug.cgi?id=15680
>
> Yup, looks like the same thing, except that bugzilla entry was due to
> swapping rather than hibernation and memory shrinking. But same end
> result, just different reasons for why we were trying to shrink the page
> lists.

Interesting that it is a null pointer dereference, given
that we do not zero out the anon_vma_chain structs before
freeing them.

Page_referenced_anon() takes the anon_vma->lock before
walking the list.  The three places where we modify the
anon_vma_chain->same_anon_vma list, we also hold the
lock.

No doubt something in mm/ is doing something silly, but
I have not found anything yet :(

If I had to guess, I'd say maybe we got one of the
mprotect & vma_adjust cases wrong.  Maybe a page stayed
around in the LRU (and in a process?) after its anon_vma
already got freed?

There has to be a reason why a very heavy AIM7 workload
and some other stress tests did not trigger it, but a few
people are able to trigger it on their systems...
