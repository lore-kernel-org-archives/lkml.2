Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0IQCnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 22:43:10 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47262 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0IQCnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 22:43:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AwImH+DM/BsBINRSH2oSG+b426KZMnGJjZumzSb4em5pSsH7ZR+Fom6jiTblb7VndD
         UoUHKHpjBIs7VifV2pUCA0blcf8NpMhfpYHD0nAztTGfiBl6kkZR5aKPDayQmI4NJYID
         yroIL3c6msOdHVd9NZIQoWazaGDXd5j73NC+I=
MIME-Version: 1.0
In-Reply-To: <201009162339.05158.s.L-H@gmx.de>
References: <12845915543097@site>
	<201009162339.05158.s.L-H@gmx.de>
Date: Fri, 17 Sep 2010 10:43:07 +0800
Message-ID: <AANLkTikhf-qz5bHT=V1P-Osyxhhgx+2OJgjqVWzEsOGn@mail.gmail.com>
Subject: Re: Patch "percpu: fix a memory leak in pcpu_extend_area_map()" has
 been added to the 2.6.35-stable tree
From: Huang Shijie <shijie8@gmail.com>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, tj@kernel.org,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi :

    I think this maybe caused by the kfree/vfree.
    I do not have any AMD machine. Could you add some log to debug it
?  such as in pcpu_extend_area_map():

        ================================
        printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);
	pcpu_mem_free(old, old_size);
        printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);
        pcpu_mem_free(new, new_size);
        printk(KERN_INFO "[ %s ] line : %d\n", __func__, __LINE__);

        ================================
  The system will print the log before it hung.

Best Regards.
Huang Shijie


2010/9/17 Stefan Lippers-Hollmann <s.L-H@gmx.de>:
> Hi
>
> On Thursday 16 September 2010, gregkh@suse.de wrote:
>> This is a note to let you know that I've just added the patch titled
>>     percpu: fix a memory leak in pcpu_extend_area_map()
>> to the 2.6.35-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> [...]
>> From a002d148426f40bc2b7dc066982eb177cdebeaaa Mon Sep 17 00:00:00 2001
>> From: Huang Shijie <shijie8@gmail.com>
>> Date: Sun, 8 Aug 2010 14:39:07 +0200
>> Subject: percpu: fix a memory leak in pcpu_extend_area_map()
>>
>> From: Huang Shijie <shijie8@gmail.com>
>>
>> commit a002d148426f40bc2b7dc066982eb177cdebeaaa upstream.
>>
>> The original code did not free the old map.  This patch fixes it.
>>
>> tj: use @old as memcpy source instead of @chunk->map, and indentation
>>     and description update
>
> This patch, as part of the current -stable queue-2.6.35, breaks booting for
> me on nforce4/ AMD64 X2. Unfortunately it fails even before the serial
> console is initialized and the only messages shown on screen are:
>
> Decompressing Linux... Parsing ELF... done.
> Booting kernel.
>
> [...]
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -390,7 +390,9 @@ static int pcpu_extend_area_map(struct p
>>               goto out_unlock;
>>
>>       old_size = chunk->map_alloc * sizeof(chunk->map[0]);
>> -     memcpy(new, chunk->map, old_size);
>> +     old = chunk->map;
>> +
>> +     memcpy(new, old, old_size);
>>
>>       /*
>>        * map_alloc < PCPU_DFL_MAP_ALLOC indicates that the chunk is
>
> Reverting just this patch from the current queue-2.6.35 fixes the issue for
> me; gzipped kernel config (amd64) attached.
>
> Regards
>        Stefan Lippers-Hollmann
>
