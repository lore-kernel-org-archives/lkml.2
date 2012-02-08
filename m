Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab2BHMay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:30:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917Ab2BHMax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:30:53 -0500
Message-ID: <4F326AF7.3060203@redhat.com>
Date: Wed, 08 Feb 2012 12:30:47 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org> <20120203162519.GB805@google.com> <4F2C0F13.70709@parallels.com> <20120203165132.GA5636@redhat.com> <4F31848A.9070406@redhat.com> <20120207205639.GJ27437@moon> <4F31945B.5000304@redhat.com> <20120207215121.GB29773@moon>
In-Reply-To: <20120207215121.GB29773@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 09:51 PM, Cyrill Gorcunov wrote:
> On Tue, Feb 07, 2012 at 09:15:07PM +0000, Pedro Alves wrote:
>> On 02/07/2012 08:56 PM, Cyrill Gorcunov wrote:
>>> On Tue, Feb 07, 2012 at 08:07:38PM +0000, Pedro Alves wrote:
>>>> On 02/03/2012 04:51 PM, Oleg Nesterov wrote:
>>>>> On 02/03, Pavel Emelyanov wrote:
>>>>
>>>>>> Because there's no need for current to get this value of himself, but can
>>>>>> be useful for e.g. gdb.
>>>>>
>>>>> OK, perhaps this makes sense, I do not know.
>>>>>
>>>>> Jan, Pedro, do you think gdb can use PTRACE_GET_TID_ADDRESS (returns
>>>>> tracee->clear_child_tid) ?
>>>>
>>>> Off hand, I'm not picturing a use.  But that may well just mean I'm lacking
>>>> imagination.  Andrew, Pavel, did you have a particular idea in mind when you
>>>> said it may be useful for debugging a multithreading program / gdb?
>>>>
>>>
>>> Might not we set up hw watchpoint on this address and get interrupt
>>> before pthread-join will find it? (To be fair I'm not sure if such
>>> trick will work, didn't test ;)
>>
>> For a debugger wanting to know when a pthread_join was about to return?
>> Might be simpler to put a breakpoint (or stap probe, or some such) inside
>> pthread_join.
> 
> Yes, could be, but it means you have to install pthread debug libs, right?
> (have no idea actually since I personally use debug printing instead of
>  breakpoints).

Not really more than what we need today.  Just some exported function name
in the elf symbol tables.  Assuming a the program is using clear_child_tid
address for pthread_join as glibc is may not be a good idea.  It's doing
things at the wrong layer.  Also, hardware watchpoints are a scarse
resource.

>> It's the kernel that writes to this address, so I've no
>> idea if the watchpoint trap ends up visible on userspace. Which thread
>> would it be reported to, given that this is cleared when the child
>> is gone, I have no idea either.
> 
> Yeah, need some help from someone who wrote hw-breakpoints support in
> kernel (i don't remember the details).

I just tried it.  This is &pthread->tid in glibc/libpthread, so with debug
info it's easy to figure out where to set the watchpoint manually with gdb
without asking the kernel.  Doesn't work.  ptrace doesn't show any trap
for the kernel writes.

-- 
Pedro Alves
