Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2DBQUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:20:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38784 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2DBQUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:20:03 -0400
Message-ID: <4F79D1AF.7080100@openvz.org>
Date: Mon, 02 Apr 2012 20:19:59 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
References: <20120331091049.19373.28994.stgit@zurg> <20120331092929.19920.54540.stgit@zurg> <20120331201324.GA17565@redhat.com> <20120331203912.GB687@moon> <4F79755B.3030703@openvz.org> <20120402144821.GA3334@redhat.com>
In-Reply-To: <20120402144821.GA3334@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/02, Konstantin Khlebnikov wrote:
>>
>> In this patch I leave mm->exe_file lockless.
>> After exec/fork we can change it only for current task and only if mm->mm_users == 1.
>>
>> something like this:
>>
>> task_lock(current);
>
> OK, this protects against the race with get_task_mm()
>
>> if (atomic_read(&current->mm->mm_users) == 1)
>
> this means PR_SET_MM_EXE_FILE can fail simply because someone did
> get_task_mm(). Or the caller is multithreaded.

This is sad, seems like we should keep mm->exe_file protection by mm->mmap_sem.
So, I'll rework this patch...

>
>> 	set_mm_exe_file(current->mm, new_file);
>
> No, fput() can sleep.

Yep

>
> Oleg.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

