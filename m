Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1LSLoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:44:07 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51207 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab1LSLnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:43:51 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <20111219112326.GA15090@elte.hu>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 19 Dec 2011 17:15:05 +0530
Message-ID: <87k45sbxa6.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121911-9574-0000-0000-000000955938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 12:23:26 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com> wrote:
> 
> >     The following patches implements gang scheduling. These 
> >     patches are *highly* experimental in nature and are not 
> >     proposed for inclusion at this time.
> > 
> >     Gang scheduling is an approach where we make an effort to 
> >     run related tasks (the gang) at the same time on a number 
> >     of CPUs.
> 
> The thing is, the (non-)scalability consequences are awful, gang 
> scheduling is a true scalability nightmare. Things like this in 
> gang_sched():
> 
> +               for_each_domain(cpu_of(rq), sd) {
> +      	                count = 0;
> +                       for_each_cpu(i, sched_domain_span(sd))
> +                               count++;
> 
> makes me shudder.
>
One point to note here is this happens only once for electing the
gang_leader, which can be done on bootup as well. And later when
offlining-onlining the cpu.
 
> So could we please approach this from the benchmarked workload 
> angle first? The highest improvement is in ebizzy:
>
<snip> 
> >     ebizzy 2vm (improved 15 times, i.e. 1520%)
> >     +------------+--------------------+--------------------+----------+
> >     |                               Ebizzy                            |
> >     +------------+--------------------+--------------------+----------+
> >     | Parameter  |        Basline     |         gang:V2    | % imprv  |
> >     +------------+--------------------+--------------------+----------+
> >     | EbzyRecords|            1709.50 |           27701.00 |     1520 |
> >     |    EbzyUser|              20.48 |             376.64 | 1739 |
> 
It is getting more usertime.

> >     |     EbzySys|            1384.65 |            1071.40 |       22 |
> >     |    EbzyReal|             300.00 |             300.00 |        0 |
> >     |     BwUsage|   2456114173416.00 |   2483447784640.00 |        1 |
> >     |    HostIdle|              34.00 |              35.00 |       -2 |
> >     |     UsrTime|               6.00 |              14.00 | 133 |
>
Even the guest numbers says so, got using iostat in guest.

> 
> What's behind this huge speedup? Does ebizzy use user-space 
> spinlocks perhaps? Could we do something on the user-space side 
> to get a similar speedup?
> 
Some more oprofile data here for the above ebizzy-2VM run:

ebizzy: gang top callers(2 VMs)
             2147208                     total                    0
              357627       ____pagevec_lru_add                 1064
              297518   native_flush_tlb_others                 1328
              245478    get_page_from_freelist                  174
              219277 default_send_IPI_mask_logical                  978
              168287           __do_page_fault                  159
              156154             release_pages                  336
               73961          handle_pte_fault                   20
               68923         down_read_trylock                 2153
               60094    __alloc_pages_nodemask                   29
ebizzy: nogang top callers(2 VMs)
             2771869                     total                    0
             2653732   native_flush_tlb_others                11847
               16004    get_page_from_freelist                   11
               15977       ____pagevec_lru_add                   47
               13125 default_send_IPI_mask_logical                   58
               10739           __do_page_fault                   10
                9379             release_pages                   20
                5330          handle_pte_fault                    1
                4727         down_read_trylock                  147
                3770    __alloc_pages_nodemask                    1

Regards,
Nikunj

