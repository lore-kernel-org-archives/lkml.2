Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1L0N6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 08:58:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab1L0N57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 08:57:59 -0500
Date: Tue, 27 Dec 2011 14:57:52 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] Makefiles: Disable unused-variable warning (was: Re: [PATCH
 1/6] memcg: fix unused variable warning)
Message-ID: <20111227135752.GK5344@tiehlicka.suse.cz>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 24-12-11 05:00:14, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> mm/memcontrol.c: In function ‘memcg_check_events’:
> mm/memcontrol.c:784:22: warning: unused variable ‘do_numainfo’ [-Wunused-variable]
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d643bd6..a5e92bd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -781,14 +781,15 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
>  	/* threshold event is triggered in finer grain than soft limit */
>  	if (unlikely(mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_THRESH))) {
> -		bool do_softlimit, do_numainfo;
> +		bool do_softlimit;
>  
> -		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> -						MEM_CGROUP_TARGET_SOFTLIMIT);
>  #if MAX_NUMNODES > 1
> +		bool do_numainfo;
>  		do_numainfo = mem_cgroup_event_ratelimit(memcg,
>  						MEM_CGROUP_TARGET_NUMAINFO);
>  #endif
> +		do_softlimit = mem_cgroup_event_ratelimit(memcg,
> +						MEM_CGROUP_TARGET_SOFTLIMIT);

I don't like this very much. Maybe we should get rid of both do_* and
do it with flags? But maybe it is not worth the additional code at
all...

Anyway, I am wondering why unused-but-set-variable is disabled while
unused-variable is enabled. Shouldn't we just disable it as well rather
than workaround this in the code? The warning is just pure noise in this
case.
What about something like:
---
>From e1136891fe86eacf9212b2144f80ff6b75b10194 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 27 Dec 2011 14:53:06 +0100
Subject: [PATCH] Makefiles: Disable unused-variable warning

We are already disabling unused-but-set-variable and Wunused-variable
produces some noise as well.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index ea51081..25c76f3 100644
--- a/Makefile
+++ b/Makefile
@@ -578,6 +578,7 @@ endif
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
 KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
-- 
1.7.7.3



-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
