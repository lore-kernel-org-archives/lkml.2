Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0HCHo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:44:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0HCHo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QHu+IBZ0c1zF7m8I1BH+Wnuvhw2M7dAnOly3L++btL8rwUy0tFvY/0aiDiyvK7oDau
         H93R+ytbIb0kE1eRMtQB3jNFAGw5lU//cyIP+e0/tAMOYhxRpEJ0PjDXT39eP22LGgPR
         m1cyEvxMBfyVnoNbJ2drdPE4esLNt/Ruda2ag=
MIME-Version: 1.0
In-Reply-To: <m1zkx4w3hx.fsf@fess.ebiederm.org>
References: <AANLkTikuUi=i6Lk-ZpE65Gr0tWOeVnrnpWPe85T=J=Ph@mail.gmail.com> 
	<m1zkx4w3hx.fsf@fess.ebiederm.org>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 3 Aug 2010 15:44:35 +0800
Message-ID: <AANLkTi=-By6ZWjo9bW0s4MndFftHegROO7oa0jbpnCho@mail.gmail.com>
Subject: Re: [PATCH] kexec: set prstatus.pr_pid to cpu id when current->pid is 
	0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        gdb@sourceware.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 15:37, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Hui Zhu <teawater@gmail.com> writes:
>
>> Hi,
>>
>> I found that from gdb 7.1 to gdb-cvs-head cannot analyze the core file
>> that get from kdump.
>> What I got:
>> [New <main task>]
>> [New Thread 2719]
>> ../../src/gdb/thread.c:884: internal-error: switch_to_thread:
>> Assertion `inf != NULL' failed.
>> A problem internal to GDB has been detected,
>> further debugging may prove unreliable.
>> Quit this debugging session? (y or n)
>> That is because:
>>  objdump -h ./vmcore
>>
>> ./vmcore:     file format elf64-x86-64
>>
>> Sections:
>> Idx Name          Size      VMA               LMA               File off  Algn
>>   0 note0         00000a48  0000000000000000  0000000000000000  00000238  2**0
>>                   CONTENTS, READONLY
>>   1 .reg/0        000000d8  0000000000000000  0000000000000000  000002bc  2**2
>>                   CONTENTS
>>   2 .reg          000000d8  0000000000000000  0000000000000000  000002bc  2**2
>>                   CONTENTS
>>   3 .reg/2719     000000d8  0000000000000000  0000000000000000  00000420  2**2
>>                   CONTENTS
>>   4 .reg/0        000000d8  0000000000000000  0000000000000000  00000584  2**2
>>                   CONTENTS
>>   5 .reg/0        000000d8  0000000000000000  0000000000000000  000006e8  2**2
>>                   CONTENTS
>> Each of reg/n is a cpu core note.  It will be a GDB thread.  n is the
>> prstatus.pr_pid that will be the thread lwpid.  Because the 3 threads
>> pid is same, so GDB get error.
>>
>> current->pid is 0 because this cpu is in idle.  So I add a check, set
>> prstatus.pr_pid to cpu id when current->pid is 0.  Then GDB work OK
>> with the core.
>
> That is a gdb limitation.  It looks to me like applying this patch will
> loose information, and give you no guarantee that prstatus.pr_pid will
> not equal 0.
>
> If you want to change something please do it in a post processing tool.
>
> Eric

Equal 0 is not a bug, the trouble is a lot of core's pid is same.

This is what gdb say:
/* Found an old thread with the same id.  It has to be dead,
       otherwise we wouldn't be adding a new thread with the same id.
       The OS is reusing this id --- delete it, and recreate a new
       one.  */

Hui

>
>
>> Thanks,
>> Hui
>>
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>> ---
>>  kernel/kexec.c |    5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> --- a/kernel/kexec.c
>> +++ b/kernel/kexec.c
>> @@ -1191,7 +1191,10 @@ void crash_save_cpu(struct pt_regs *regs
>>       if (!buf)
>>               return;
>>       memset(&prstatus, 0, sizeof(prstatus));
>> -     prstatus.pr_pid = current->pid;
>> +     if (current->pid)
>> +             prstatus.pr_pid = current->pid;
>> +     else
>> +             prstatus.pr_pid = cpu;
>>       elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
>>       buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
>>                             &prstatus, sizeof(prstatus));
>
