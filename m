Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab2KVTfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:35:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757139Ab2KVTe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:34:57 -0500
Date: Thu, 22 Nov 2012 16:24:41 +0100
From: Michal Hocko <mhocko@suse.cz>
To: azurIt <azurit@pobox.sk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: memory-cgroup bug
Message-ID: <20121122152441.GA9609@dhcp22.suse.cz>
References: <20121121200207.01068046@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment
In-Reply-To: <20121121200207.01068046@pobox.sk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 21-11-12 20:02:07, azurIt wrote:
> Hi,
> 
> i'm using memory cgroup for limiting our users and having a really
> strange problem when a cgroup gets out of its memory limit. It's very
> strange because it happens only sometimes (about once per week on
> random user), out of memory is usually handled ok.

What is your memcg configuration? Do you use deeper hierarchies, is
use_hierarchy enabled? Is the memcg oom (aka memory.oom_control)
enabled? Do you use soft limit for those groups? Is memcg swap
accounting enabled and memsw limits in place?
Is the machine under global memory pressure as well?
Could you post sysrq+t or sysrq+w?

> This happens when problem occures:
>  - no new processes can be started for this cgroup
>  - current processes are freezed and taking 100% of CPU
>  - when i try to 'strace' any of current processes, the whole strace
>    freezes until process is killed (strace cannot be terminated by
>    CTRL-c)
>  - problem can be resolved by raising memory limit for cgroup or
>    killing of few processes inside cgroup so some memory is freed
> 
> I also garbbed the content of /proc/<pid>/stack of freezed process:
> [<ffffffff8110a9c1>] mem_cgroup_handle_oom+0x241/0x3b0
> [<ffffffff8110b5ab>] T.1146+0x5ab/0x5c0

Hmm what is this?

> [<ffffffff8110ba56>] mem_cgroup_charge_common+0x56/0xa0
> [<ffffffff8110bae5>] mem_cgroup_newpage_charge+0x45/0x50
> [<ffffffff810ec54e>] do_wp_page+0x14e/0x800
> [<ffffffff810eda34>] handle_pte_fault+0x264/0x940
> [<ffffffff810ee248>] handle_mm_fault+0x138/0x260
> [<ffffffff810270ed>] do_page_fault+0x13d/0x460
> [<ffffffff815b53ff>] page_fault+0x1f/0x30
> [<ffffffffffffffff>] 0xffffffffffffffff
>

How many tasks are hung in mem_cgroup_handle_oom? If there were many
of them then it'd smell like an issue fixed by 79dfdaccd1d5 (memcg:
make oom_lock 0 and 1 based rather than counter) and its follow up fix
23751be00940 (memcg: fix hierarchical oom locking) but you are saying
that you can reproduce with 3.2 and those went in for 3.1. 2.6.32 would
make more sense.

> I'm currently using kernel 3.2.34 but i'm having this problem since 2.6.32.

I guess this is a clean vanilla (stable) kernel, right? Are you able to
reproduce with the latest Linus tree?

-- 
Michal Hocko
SUSE Labs
