Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab1GFIpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:45:44 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39077 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1GFIpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:45:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110629130038.GA7909@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	<20110629130038.GA7909@in.ibm.com>
Date: Wed, 6 Jul 2011 11:45:41 +0300
X-Google-Sender-Auth: Dd3f7oLsZeE_DdRwQMGX12rxVoM
Message-ID: <CAOJsxLHQP=-srK_uYYBsPb7+rUBnPZG7bzwtCd-rRaQa4ikUFg@mail.gmail.com>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory Power Management
From: Pekka Enberg <penberg@kernel.org>
To: Ankita Garg <ankita@in.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ankita,

[ I don't really know anything about memory power management but
  here's my two cents since you asked for it. ]

On Wed, Jun 29, 2011 at 4:00 PM, Ankita Garg <ankita@in.ibm.com> wrote:
> I) Dynamic Power Transition
>
> The goal here is to ensure that as much as possible, on an idle system,
> the memory references do not get spread across the entire RAM, a problem
> similar to memory fragmentation. The proposed approach is as below:
>
> 1) One of the first things is to ensure that the memory allocations do
> not spill over to more number of regions. Thus the allocator needs to
> be aware of the address boundary of the different regions.

Why does the allocator need to know about address boundaries? Why
isn't it enough to make the page allocator and reclaim policies favor using
memory from lower addresses as aggressively as possible? That'd mean
we'd favor the first memory banks and could keep the remaining ones
powered off as much as possible.

IOW, why do we need to support scenarios such as this:

   bank 0     bank 1   bank 2    bank3
 | online  | offline | online  | offline |

instead of using memory compaction and possibly something like the
SLUB defragmentation patches to turn the memory map into this:

   bank 0     bank 1   bank 2   bank3
 | online  | online  | offline | offline |

> 2) At the time of allocation, before spilling over allocations to the
> next logical region, the allocator needs to make a best attempt to
> reclaim some memory from within the existing region itself first. The
> reclaim here needs to be in LRU order within the region.  However, if
> it is ascertained that the reclaim would take a lot of time, like there
> are quite a fe write-backs needed, then we can spill over to the next
> memory region (just like our NUMA node allocation policy now).

I think a much more important question is what happens _after_ we've
allocated and free'd tons of memory few times. AFAICT, memory
regions don't help with that kind of fragmentation that will eventually
happen anyway.

					Pekka
