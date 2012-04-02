Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2DBJqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:46:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51229 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2DBJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:46:08 -0400
Message-ID: <4F79755B.3030703@openvz.org>
Date: Mon, 02 Apr 2012 13:46:03 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Matt Helsley <matthltc@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
References: <20120331091049.19373.28994.stgit@zurg> <20120331092929.19920.54540.stgit@zurg> <20120331201324.GA17565@redhat.com> <20120331203912.GB687@moon>
In-Reply-To: <20120331203912.GB687@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Sat, Mar 31, 2012 at 10:13:24PM +0200, Oleg Nesterov wrote:
>>
>> Add Cyrill. This conflicts with
>> c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch in -mm.
>
> Thanks for CC'ing, Oleg. I think if thise series go in it won't
> be a problem to update my patch accordingly.

In this patch I leave mm->exe_file lockless.
After exec/fork we can change it only for current task and only if mm->mm_users == 1.

something like this:

task_lock(current);
if (atomic_read(&current->mm->mm_users) == 1)
	set_mm_exe_file(current->mm, new_file);
else
	ret = -EBUSY;
task_unlock(current);

task_lock() protect this code against get_task_mm()
