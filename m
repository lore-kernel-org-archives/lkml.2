Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1FCMf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:35:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab1FCMf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:35:57 -0400
Message-ID: <4DE8D50F.1090406@redhat.com>
Date: Fri, 03 Jun 2011 14:35:27 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
CC: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>	<20110601123913.GC4266@tiehlicka.suse.cz>	<4DE6399C.8070802@redhat.com>	<20110601134149.GD4266@tiehlicka.suse.cz>	<4DE64F0C.3050203@redhat.com>	<20110601152039.GG4266@tiehlicka.suse.cz>	<4DE66BEB.7040502@redhat.com> <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
In-Reply-To: <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 01:10 AM, Hiroyuki Kamezawa wrote:
>> pc = list_entry(list->prev, struct page_cgroup, lru);
> Hmm, I disagree your patch is a fix for mainline. At least, a cgroup
> before completion of
> create() is not populated to userland and you never be able to rmdir()
> it because you can't
> find it.
>
>
>   >26:   e8 7d 12 30 00          call   0x3012a8
>   >2b:*  8b 73 08                mov    0x8(%ebx),%esi<-- trapping
> instruction
>   >2e:   8b 7c 24 24             mov    0x24(%esp),%edi
>   >32:   8b 07                   mov    (%edi),%eax
>
> Hm, what is the call 0x3012a8 ?
>
                 pc = list_entry(list->prev, struct page_cgroup, lru);
                 if (busy == pc) {
                         list_move(&pc->lru, list);
                         busy = 0;
                         spin_unlock_irqrestore(&zone->lru_lock, flags);
                         continue;
                 }
                 spin_unlock_irqrestore(&zone->lru_lock, flags); <---- 
is  call 0x3012a8
                 ret = mem_cgroup_move_parent(pc, mem, GFP_KERNEL);

and  mov 0x8(%ebx),%esi
is dereferencing of 'pc' in inlined mem_cgroup_move_parent

I've looked at vmcore once more and indeed there isn't any parallel task
that touches cgroups code path.
Will investigate if it is xen to blame for incorrect data in place.

Thanks very much for your opinion.
> Thanks,
> -Kame

