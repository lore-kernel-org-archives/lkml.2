Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab2FPPih (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:38:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54167 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab2FPPif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:38:35 -0400
Message-ID: <4FDCA875.6040905@openvz.org>
Date: Sat, 16 Jun 2012 19:38:29 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120608 Firefox/10.0.5 Iceape/2.7.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3.5] c/r: prctl: less paranoid prctl_set_mm_exe_file()
References: <20120616085104.14682.16723.stgit@zurg> <20120616090646.GD32029@moon> <20120616091712.GA2021@moon> <4FDC54FF.3020305@openvz.org> <20120616094714.GF32029@moon>
In-Reply-To: <20120616094714.GF32029@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Sat, Jun 16, 2012 at 01:42:23PM +0400, Konstantin Khlebnikov wrote:
>>> Side note: there is a little nit with this patch actually,
>>> because while when we do c/r we do "right things" and unmap
>>> all vm-executable mappings before we set up new exe_file. But
>>> we can't guarantee that some brave soul would not setup
>>> new exe-file just for it's own, then what we migh have
>>>
>>>   - mm::exe_file set up and points to some file, moreover num_exe_file_vmas might be>   1
>>>   - application calls for prctl_set_mm_exe_file
>>>   - set_mm_exe_file(mm, exe_file) called, and it drops num_exe_file_vmas to 0
>>>   - finally application might call for removed_exe_file_vma
>>>
>>> void removed_exe_file_vma(struct mm_struct *mm)
>>> {
>>> 	mm->num_exe_file_vmas--;
>>> 	if ((mm->num_exe_file_vmas == 0)&&   mm->exe_file) {
>>> 		fput(mm->exe_file);
>>> 		mm->exe_file = NULL;
>>> 	}
>>>
>>> }
>>>
>>> and it does _not_ test for num_exe_file_vmas being 0 before doing decrement,
>>> thus we get inconsistency in counter.
>>
>> No, removed_exe_file_vma() is called only for vma with VM_EXECUTABLE flag,
>> there no way to get such vma other than sys_execve().
>> And this brave soul cannot call prctl_set_mm_exe_file() successfully,
>> just because for vma with VM_EXECUTABLE flag vma->vm_file == mm->exe_file.
>>
>> Anyway, I plan to get rid of mm->num_exe_file_vmas and VM_EXECUTABLE.
>
> Yeah, you've changed !path_equal to path_equal. And yes, getting rid of
> num_exe_file_vmas is good idea. Btw, Konstantin, why do we need to
> call for path_equal? Maybe we can simply test for mm->exe_file == NULL,
> and refuse to change anything if it's not nil value? This will simplify
> the code.

After removing VM_EXECUTABLE and mm->num_exe_file_vmas mm->exe_file
will never becomes NULL automatically. Patch for this not commited yet,
but I hope it will be in 3.6.

>
> 	Cyrill

