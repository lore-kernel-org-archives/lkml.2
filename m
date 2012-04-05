Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab2DEVEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:04:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57835 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab2DEVEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:04:48 -0400
Message-ID: <4F7E08EB.5070600@openvz.org>
Date: Fri, 06 Apr 2012 01:04:43 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
References: <20120331091049.19373.28994.stgit@zurg> <20120331092929.19920.54540.stgit@zurg> <20120331201324.GA17565@redhat.com> <20120402230423.GB32299@count0.beaverton.ibm.com> <4F7A863C.5020407@openvz.org> <20120403181631.GD32299@count0.beaverton.ibm.com> <20120403193204.GE3370@moon> <20120405202904.GB7761@count0.beaverton.ibm.com>
In-Reply-To: <20120405202904.GB7761@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Tue, Apr 03, 2012 at 11:32:04PM +0400, Cyrill Gorcunov wrote:
>> On Tue, Apr 03, 2012 at 11:16:31AM -0700, Matt Helsley wrote:
>>> On Tue, Apr 03, 2012 at 09:10:20AM +0400, Konstantin Khlebnikov wrote:
>>>> Matt Helsley wrote:
>>>>> On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
>>>>>> On 03/31, Konstantin Khlebnikov wrote:
>>>>>>>
>>>>>>> comment from v2.6.25-6245-g925d1c4 ("procfs task exe symlink"),
>>>>>>> where all this stuff was introduced:
>>>>>>>
>>>>>>>> ...
>>>>>>>> This avoids pinning the mounted filesystem.
>>>>>>>
>>>>>>> So, this logic is hooked into every file mmap/unmmap and vma split/merge just to
>>>>>>> fix some hypothetical pinning fs from umounting by mm which already unmapped all
>>>>>>> its executable files, but still alive. Does anyone know any real world example?
>>>>>>
>>>>>> This is the question to Matt.
>>>>>
>>>>> This is where I got the scenario:
>>>>>
>>>>> https://lkml.org/lkml/2007/7/12/398
>>>>
>>>> Cyrill Gogcunov's patch "c/r: prctl: add ability to set new mm_struct::exe_file"
>>>> gives userspace ability to unpin vfsmount explicitly.
>>>
>>> Doesn't that break the semantics of the kernel ABI?
>>
>> Which one? exe_file can be changed iif there is no MAP_EXECUTABLE left.
>> Still, once assigned (via this prctl) the mm_struct::exe_file can't be changed
>> again, until program exit.
>
> The prctl() interface itself is fine as it stands now.
>
> As far as I can tell Konstantin is proposing that we remove the unusual
> counter that tracks the number of mappings of the exe_file and require
> userspace use the prctl() to drop the last reference. That's what I think
> will break the ABI because after that change you *must* change userspace
> code to use the prctl(). It's an ABI change because the same sequence of
> system calls with the same input bits produces different behavior.

But common software does not require this at all. I did not found real examples,
only hypothesis by Al Viro: https://lkml.org/lkml/2007/7/12/398
libhugetlbfs isn't good example too, the man proc says: /proc/[pid]/exe is alive until
main thread is alive, but in case libhugetlbfs /proc/[pid]/exe disappears too early.
Also I would not call it ABI, this corner-case isn't documented, I'm afraid only few
people in the world knows about it =)
