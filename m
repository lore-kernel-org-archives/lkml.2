Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0ELRdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:33:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab0ELRdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:33:17 -0400
Message-ID: <4BEAE6A7.8070809@colorfullife.com>
Date: Wed, 12 May 2010 19:34:31 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>,
       Zach Brown <zach.brown@oracle.com>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] ipc/sem.c: move wake_up_process out of the spinlock
 section
References: <1272481588-1941-1-git-send-email-manfred@colorfullife.com> <1272481588-1941-2-git-send-email-manfred@colorfullife.com> <1272481588-1941-3-git-send-email-manfred@colorfullife.com> <20100511142149.83bb3538.akpm@linux-foundation.org>
In-Reply-To: <20100511142149.83bb3538.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 11:21 PM, Andrew Morton wrote:
> On Wed, 28 Apr 2010 21:06:27 +0200
> Manfred Spraul<manfred@colorfullife.com>  wrote:
>
>    
>> The wake-up part of semtimedop() consists out of two steps:
>> - the right tasks must be identified.
>> - they must be woken up.
>>
>> Right now, both steps run while the array spinlock is held.
>> This patch reorders the code and moves the actual wake_up_process()
>> behind the point where the spinlock is dropped.
>>
>> The code also moves setting sem->sem_otime to one place: It does not
>> make sense to set the last modify time multiple times.
>>      
> ipc/sem.c: In function 'update_queue':
> ipc/sem.c:545: warning: 'retval' may be used uninitialized in this function
>
> which indeed was a bug.
>
>    
Duh - hiding in shame.

The effect would be that e.g. a semctl(SETALL) operation might change 
sem_otime.
semctl(SETALL) must only change sem_ctime (and sem_otime only if it 
causes a wakeup
and the woken up thread modifies the array)


> +++ a/ipc/sem.c
> @@ -542,7 +542,7 @@ static int update_queue(struct sem_array
>   	struct list_head *walk;
>   	struct list_head *pending_list;
>   	int offset;
> -	int retval;
> +	int retval = 0;
>
>   	/* if there are complex operations around, then knowing the semaphore
>   	 * that was modified doesn't help us. Assume that multiple semaphores
> _
>
> But I worry that the patch which you sent might not have been the one
> which you tested.
>    

I think I tested the patch that I sent out.

Thus I'll retest everything (including sem_ctime/sem_otime and SETALL)

The odd thing: My gcc somehow doesn't report the missing initialization :-(

 >>>
[manfred@cores linux-2.6]$ grep 'int update_queue' -A 10 ipc/sem.c
static int update_queue(struct sem_array *sma, int semnum, struct 
list_head *pt)
{
         struct sem_queue *q;
         struct list_head *walk;
         struct list_head *pending_list;
         int offset;
         int retval;

         /* if there are complex operations around, then knowing the 
semaphore
          * that was modified doesn't help us. Assume that multiple 
semaphores
          * were modified.
[manfred@cores linux-2.6]$ touch ipc/sem.o
[manfred@cores linux-2.6]$ make ipc
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    scripts/checksyscalls.sh
   LD      ipc/built-in.o
[manfred@cores linux-2.6]$ gcc --version
gcc (GCC) 4.4.3 20100127 (Red Hat 4.4.3-4)
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[manfred@cores linux-2.6]$ cat ipc/.sem.o.cmd
cmd_ipc/sem.o := gcc -Wp,-MD,ipc/.sem.o.d  -nostdinc -isystem 
/usr/lib/gcc/x86_64-redhat-linux/4.4.3/include 
-I/home/manfred/git/linux-2.6/arch/x86/include -Iinclude  -include 
include/generated/autoconf.h -D__KERNEL__ -Wall -Wundef 
-Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common 
-Werror-implicit-function-declaration -Wno-format-security 
-fno-delete-null-pointer-checks -Os -m64 -mtune=generic -mno-red-zone 
-mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args 
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -pipe -Wno-sign-compare 
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow 
-Wframe-larger-than=1024 -fno-stack-protector -fno-omit-frame-pointer 
-fno-optimize-sibling-calls -g -Wdeclaration-after-statement 
-Wno-pointer-sign -fno-strict-overflow -fno-dwarf2-cfi-asm 
-fconserve-stack   -D"KBUILD_STR(s)=\#s" 
-D"KBUILD_BASENAME=KBUILD_STR(sem)"  -D"KBUILD_MODNAME=KBUILD_STR(sem)"  
-c -o ipc/sem.o ipc/sem.c

<<<

--
     Manfred
