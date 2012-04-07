Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab2DGFTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 01:19:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2DGFTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 01:19:10 -0400
Message-ID: <4F7FCC8A.6050707@openvz.org>
Date: Sat, 07 Apr 2012 09:11:38 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Oleg Nesterov <oleg@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm: account VMA before forced-COW via /proc/pid/mem
References: <20120402153631.5101.44091.stgit@zurg> <20120403143752.GA5150@redhat.com> <4F7C1B67.6030300@openvz.org> <20120404154148.GA7105@redhat.com> <4F7D5859.5050106@openvz.org> <alpine.LSU.2.00.1204062104090.4297@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1204062104090.4297@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 5 Apr 2012, Konstantin Khlebnikov wrote:
>> Oleg Nesterov wrote:
>>> On 04/04, Konstantin Khlebnikov wrote:
>>>> Oleg Nesterov wrote:
>>>>> On 04/02, Konstantin Khlebnikov wrote:
>>>>>>
>>>>>> Currently kernel does not account read-only private mappings into
>>>>>> memory commitment.
>>>>>> But these mappings can be force-COW-ed in get_user_pages().
>>>>>
>>>>> Heh. tail -n3 Documentation/vm/overcommit-accounting
>>>>> may be you should update it then.
>>>>
>>>> I just wonder how fragile this accounting...
>>>
>>> I meant, this patch could also remove this "TODO" from the docs.
>>
>> Actually I dug into this code for killing VM_ACCOUNT vma flag.
>> Currently we cannot do this only because asymmetry in mprotect_fixup():
>> it account vma on read-only ->  writable conversion, but keep on backward
>> operation.
>> Probably we can kill this asymmetry, and after that we can recognize
>> accountable vma
>> by its others flags state, so we don't need special VM_ACCOUNT for this.
>
> (I believe the VM_ACCOUNT flag will need to stay.)
>
> But this is just a quick note to say that I'm not ignoring you: I have
> a strong interest in this, but only now found time to look through the
> thread and ponder, and I'm not yet ready to decide.
>
> I've long detested that behaviour of GUP write,force, and my strong
> preference would be not to layer more strangeness upon strangeness,
> but limit the damage by making GUP write,force fail in that case,
> instead of inserting a PageAnon page into a VM_SHARED mapping.
>
> I think it's unlikely that it will cause a regression in real life
> (it already fails if you did not open the mmap'ed file for writing),
> but it would be a user-visible change in behaviour, and I've research
> to do before arriving at a conclusion.

Agree, but this stuff is very weak. Even if sysctl vm.overcommit_memory=2,
probably we should fixup accounting in /proc/pid/mem only for this case,
because vm.overcommit_memory=2 supposed to protect against overcommit, but it does not.

>
> Hugh

