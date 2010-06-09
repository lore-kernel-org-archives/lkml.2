Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab0FIJTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:19:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41579 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab0FIJTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=o8+BLE+svvJL+oji3aVaKyVPPW8lK2os8H9d4pNb4E7bdG3Atw0OwGVrwuvg2s5OuF
         IPYEQlmFTlY7hTmD8e1lu9RYEnBgHJ0AE6Mk+h0u4xlQDvrmBLMHRi8lXK18Txpl+wxZ
         zxsM1b72SmA0DZvWdaTtwNtCW+5CjZajarO8w=
MIME-Version: 1.0
In-Reply-To: <AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
References: <AANLkTin1OS3LohKBvWyS81BoAk15Y-riCiEdcevSA7ye@mail.gmail.com>
	<1275929000.3021.56.camel@e102109-lin.cambridge.arm.com>
	<AANLkTilsCkBiGtfEKkNXYclsRKhfuq4yI_1mrxMa8yJG@mail.gmail.com>
Date: Wed, 9 Jun 2010 17:19:02 +0800
Message-ID: <AANLkTik-cwrabXH_bQRPFtTo3C9r30B83jMf4IwJKCms@mail.gmail.com>
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
From: Dave Young <hidave.darkstar@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, riel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 10:37 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Tue, Jun 8, 2010 at 12:43 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
>> On Mon, 2010-06-07 at 11:00 +0100, Dave Young wrote:
>>> On Mon, Jun 7, 2010 at 5:19 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>>> > On Mon, 2010-06-07 at 06:20 +0100, Dave Young wrote:
>>> >> On Fri, Jun 4, 2010 at 9:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>> >> > On Fri, Jun 4, 2010 at 6:50 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
>>> >> >> Dave Young <hidave.darkstar@gmail.com> wrote:
>>> >> >>> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks
>>> >> >>
>>> >> >> Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
>>> >> >> hasn't been reviewed yet (I'll probably need to repost, so if it fixes
>>> >> >> the problem for you a Tested-by would be nice):
>>> >> >>
>>> >> >> http://lkml.org/lkml/2010/5/4/175
>>> >> >
>>> >> >
>>> >> > I'd like to test, but I can not access the test pc during weekend. So
>>> >> > I will test it next monday.
>>> >>
>>> >> Bad news, the patch does not fix this issue.
>>> >
>>> > Thanks for trying. Could you please just disable CONFIG_NO_BOOTMEM and
>>> > post the kmemleak reported leaks again?
>>>
>>> Still too many suspected leaks, results similar with
>>> (CONFIG_NO_BOOTMEM = y && apply your patch), looks like a little
>>> different from original ones? I just copy some of them here:
>>>
>>> unreferenced object 0xde3c7420 (size 44):
>>>   comm "bash", pid 1631, jiffies 4294897023 (age 223.573s)
>>>   hex dump (first 32 bytes):
>>>     05 05 00 00 ad 4e ad de ff ff ff ff ff ff ff ff  .....N..........
>>>     98 42 d9 c1 00 00 00 00 50 fe 63 c1 10 32 8f dd  .B......P.c..2..
>>>   backtrace:
>>>     [<c1498ad2>] kmemleak_alloc+0x4a/0x83
>>>     [<c10c1ace>] kmem_cache_alloc+0xde/0x12a
>>>     [<c10b421b>] anon_vma_fork+0x31/0x88
>>>     [<c102c71d>] dup_mm+0x1d3/0x38f
>>>     [<c102d20d>] copy_process+0x8ce/0xf39
>>>     [<c102d990>] do_fork+0x118/0x295
>>>     [<c1007fe0>] sys_clone+0x1f/0x24
>>>     [<c10029b1>] ptregs_clone+0x15/0x24
>>>     [<ffffffff>] 0xffffffff
>>
>> I'll try to test the mmotm kernel as well. I don't get any kmemleak
>> reports with the 2.6.35-rc1 kernel.
>
> Manually bisected mm patches, the memleak caused by following patch:
>
> mm-extend-ksm-refcounts-to-the-anon_vma-root.patch

Add following debug code:

 void drop_anon_vma(struct anon_vma *anon_vma)
 {
+       int a, b;
+       a =  anonvma_external_refcount(anon_vma);
+       b =  anonvma_external_refcount(anon_vma->root);
+       if (!a || !b) {
+               printk("drop_anon_vma: ref %d ", a);
+               printk("root ref %d\n", b);
+       }

result in below debug output:

[   52.948614] drop_anon_vma: ref 0 root ref 0
[   52.949770] Pid: 1403, comm: ps Not tainted 2.6.35-rc1-mm1 #29
[   52.951386] Call Trace:
[   52.952062]  [<c14b1128>] ? printk+0x20/0x24
[   52.953210]  [<c10b409c>] drop_anon_vma+0x37/0xb3
[   52.954503]  [<c10b418c>] unlink_anon_vmas+0x74/0xc4
[   52.955854]  [<c10aeaa0>] free_pgtables+0x45/0x95
[   52.957142]  [<c10b00fd>] exit_mmap+0xab/0xfe
[   52.958325]  [<c102fafa>] ? exit_mm+0xdd/0xec
[   52.959497]  [<c102c25d>] mmput+0x49/0xcf
[   52.960605]  [<c102fb01>] exit_mm+0xe4/0xec
[   52.961750]  [<c103137c>] do_exit+0x1b4/0x64b
[   52.962921]  [<c1031875>] do_group_exit+0x62/0x85
[   52.964212]  [<c10318ab>] sys_exit_group+0x13/0x17
[   52.965523]  [<c14b344d>] syscall_call+0x7/0xb

So I guess the refcount break, either drop-without-get or over-drop

>
> cc Rik van Riel
>
>>
>> Can you send me your .config file? Do you have CONFIG_HUGETLBFS enabled?
>>
>> Thanks.
>>
>> --
>> Catalin
>>
>>
>
>
>
> --
> Regards
> dave
>



-- 
Regards
dave
