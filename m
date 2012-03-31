Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2CaV3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:29:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52107 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2CaV25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120330223606.GK28934@google.com>
References: <20120330223423.GJ28934@google.com>
	<20120330223606.GK28934@google.com>
Date: Sun, 1 Apr 2012 06:28:56 +0900
Message-ID: <CABEgKgpxidNfK4_A_TNPZvM8Dbm35QxGEGYbRH+roTU2zM7vNw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal optional
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com,
        Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012年3月31日7:36 Tejun Heo <tj@kernel.org>:
> Currently, cgroup removal tries to drain all css references.  If there
> are active css references, the removal logic waits and retries
> ->pre_detroy() until either all refs drop to zero or removal is
> cancelled.
>
> This semantics is unusual and adds non-trivial complexity to cgroup
> core and IMHO is fundamentally misguided in that it couples internal
> implementation details (references to internal data structure) with
> externally visible operation (rmdir).  To userland, this is a behavior
> peculiarity which is unnecessary and difficult to expect (css refs is
> otherwise invisible from userland), and, to policy implementations,
> this is an unnecessary restriction (e.g. blkcg wants to hold css refs
> for caching purposes but can't as that becomes visible as rmdir hang).
>
> Unfortunately, memcg currently depends on ->pre_destroy() retrials and
> cgroup removal vetoing and can't be immmediately switched to the new
> behavior.  This patch introduces the new behavior of not waiting for
> css refs to drain and maintains the old behavior for subsystems which
> have __DEPRECATED_clear_css_refs set.
>
> Once, memcg is updated, we can drop the code paths for the old
> behavior as proposed in the following patch.  Note that the following
> patch is incorrect in that dput work item is in cgroup and may lose
> some of dputs when multiples css's are released back-to-back, and
> __css_put() triggers check_for_release() when refcnt reaches 0 instead
> of 1; however, it shows what part can be removed.
>
>  http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251
>
> Note that, in not-too-distant future, cgroup core will start emitting
> warning messages for subsys which require the old behavior, so please
> get moving.
>
Ok, I'll update memcg ASAP (after LSF/MM).
I'm now thinking to move all resources to root if use_hierarchy=0.

Thanks,
-Kame
