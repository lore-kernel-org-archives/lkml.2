Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2FPJm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 05:42:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64982 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab2FPJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 05:42:28 -0400
Message-ID: <4FDC54FF.3020305@openvz.org>
Date: Sat, 16 Jun 2012 13:42:23 +0400
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
References: <20120616085104.14682.16723.stgit@zurg> <20120616090646.GD32029@moon> <20120616091712.GA2021@moon>
In-Reply-To: <20120616091712.GA2021@moon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> On Sat, Jun 16, 2012 at 01:06:46PM +0400, Cyrill Gorcunov wrote:
>> On Sat, Jun 16, 2012 at 12:51:04PM +0400, Konstantin Khlebnikov wrote:
>>> "no other files mapped" requirement from my previous patch
>>> (c/r: prctl: update prctl_set_mm_exe_file() after mm->num_exe_file_vmas removal)
>>> is too paranoid, it forbids operation even if there mapped one shared-anon vma.
>>>
>>> Let's check that current mm->exe_file already unmapped, in this case exe_file
>>> symlink already outdated and its changing is reasonable.
>>>
>>> Plus, this patch fixes exit code in case operation success.
>>>
>>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>> Reported-by: Cyrill Gorcunov<gorcunov@openvz.org>
>>> Cc: Oleg Nesterov<oleg@redhat.com>
>>> Cc: Matt Helsley<matthltc@us.ibm.com>
>>> Cc: Kees Cook<keescook@chromium.org>
>>> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Tejun Heo<tj@kernel.org>
>>> Cc: Pavel Emelyanov<xemul@parallels.com>
>>> ---
>>
>> Ack! Thanks again, Konstantin!
>
> Side note: there is a little nit with this patch actually,
> because while when we do c/r we do "right things" and unmap
> all vm-executable mappings before we set up new exe_file. But
> we can't guarantee that some brave soul would not setup
> new exe-file just for it's own, then what we migh have
>
>   - mm::exe_file set up and points to some file, moreover num_exe_file_vmas might be>  1
>   - application calls for prctl_set_mm_exe_file
>   - set_mm_exe_file(mm, exe_file) called, and it drops num_exe_file_vmas to 0
>   - finally application might call for removed_exe_file_vma
>
> void removed_exe_file_vma(struct mm_struct *mm)
> {
> 	mm->num_exe_file_vmas--;
> 	if ((mm->num_exe_file_vmas == 0)&&  mm->exe_file) {
> 		fput(mm->exe_file);
> 		mm->exe_file = NULL;
> 	}
>
> }
>
> and it does _not_ test for num_exe_file_vmas being 0 before doing decrement,
> thus we get inconsistency in counter.

No, removed_exe_file_vma() is called only for vma with VM_EXECUTABLE flag,
there no way to get such vma other than sys_execve().
And this brave soul cannot call prctl_set_mm_exe_file() successfully,
just because for vma with VM_EXECUTABLE flag vma->vm_file == mm->exe_file.

Anyway, I plan to get rid of mm->num_exe_file_vmas and VM_EXECUTABLE.

>
> 	Cyrill

