Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1FCNAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:00:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62238 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1FCNAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=syJes1cDxCePcstvyv3pOFLemF3nqoZYcPalHtcemb0++p3AsnZWuuyA2XN3UaKScK
         rtCa9iGKL25O0uSuZ9K3xDo+oLWXimAka97aPsCM4VMtk5wRh6znG1Zk8C+PgRzCWJay
         5iaRmLrjuB6vcU3R0BU+wVrSAp5vTwYYyrxBc=
MIME-Version: 1.0
In-Reply-To: <4DE8D50F.1090406@redhat.com>
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
	<20110601123913.GC4266@tiehlicka.suse.cz>
	<4DE6399C.8070802@redhat.com>
	<20110601134149.GD4266@tiehlicka.suse.cz>
	<4DE64F0C.3050203@redhat.com>
	<20110601152039.GG4266@tiehlicka.suse.cz>
	<4DE66BEB.7040502@redhat.com>
	<BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
	<4DE8D50F.1090406@redhat.com>
Date: Fri, 3 Jun 2011 22:00:47 +0900
Message-ID: <BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node to world
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/3 Igor Mammedov <imammedo@redhat.com>:
> On 06/02/2011 01:10 AM, Hiroyuki Kamezawa wrote:
>>>
>>> pc = list_entry(list->prev, struct page_cgroup, lru);
>>
>> Hmm, I disagree your patch is a fix for mainline. At least, a cgroup
>> before completion of
>> create() is not populated to userland and you never be able to rmdir()
>> it because you can't
>> find it.
>>
>>
>>  >26:   e8 7d 12 30 00          call   0x3012a8
>>  >2b:*  8b 73 08                mov    0x8(%ebx),%esi<-- trapping
>> instruction
>>  >2e:   8b 7c 24 24             mov    0x24(%esp),%edi
>>  >32:   8b 07                   mov    (%edi),%eax
>>
>> Hm, what is the call 0x3012a8 ?
>>
>                pc = list_entry(list->prev, struct page_cgroup, lru);
>                if (busy == pc) {
>                        list_move(&pc->lru, list);
>                        busy = 0;
>                        spin_unlock_irqrestore(&zone->lru_lock, flags);
>                        continue;
>                }
>                spin_unlock_irqrestore(&zone->lru_lock, flags); <---- is
>  call 0x3012a8
>                ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);
>
> and  mov 0x8(%ebx),%esi
> is dereferencing of 'pc' in inlined mem_cgroup_move_parent
>
Ah, thank you for input..then panicd at accessing pc->page and "pc"
was 0xfffffff4.
it means list->prev was NULL.

> I've looked at vmcore once more and indeed there isn't any parallel task
> that touches cgroups code path.
> Will investigate if it is xen to blame for incorrect data in place.
>
> Thanks very much for your opinion.

What curious to me is that the fact "list->prev" is NULL.
I can see why you doubt the initialization code ....the list pointer never
contains NULL once it's used....
it smells like memory corruption or some to me. If you have vmcore,
what the problematic mem_cgroup_per_zone(node) contains ?

Thanks,
-Kame
