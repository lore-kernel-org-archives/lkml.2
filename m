Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1L0AWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 19:22:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54269 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1L0AWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 19:22:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Dec 2011 09:20:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: "Nikolay S." <nowhere@hakkenden.ath.cx>,
        Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-Id: <20111227092052.f2b02637.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBAyw2rapPPhYFYKxyjEQ-EAG2j_UCP-4A6Uk5GSP5LE6A@mail.gmail.com>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	<20111221095249.GA28474@tiehlicka.suse.cz>
	<20111221225512.GG23662@dastard>
	<1324630880.562.6.camel@rybalov.eng.ttk.net>
	<20111223102027.GB12731@dastard>
	<1324638242.562.15.camel@rybalov.eng.ttk.net>
	<20111223204503.GC12731@dastard>
	<CAJd=RBDa4LT1gbh6zPx+bzoOtSUeX=puJe6DVC-WyKoF4nw-dg@mail.gmail.com>
	<1324808519.29243.8.camel@hakkenden.homenet>
	<CAJd=RBAyw2rapPPhYFYKxyjEQ-EAG2j_UCP-4A6Uk5GSP5LE6A@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Dec 2011 20:35:46 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Sun, Dec 25, 2011 at 6:21 PM, Nikolay S. <nowhere@hakkenden.ath.cx> wrote:
> >
> > Uhm.., is this patch against 3.2-rc4? I can not apply it. There's no
> > mem_cgroup_lru_del_list(), but void mem_cgroup_del_lru_list(). Should I
> > place changes there?
> >
> > And also, -rc7 is here. May the problem be addressed as part of some
> > ongoing work? Is there any reason to try -rc7 (the problem requires
> > several days of uptime to become obvious)?
> >
> 
> Sorry, Nikolay, it is not based on the -next, nor on the -rc5(I assumed it was).
> The following is based on -next, and if you want to test -rc5, please
> grep MEM_CGROUP_ZSTAT mm/memcontrol.c and change it.
> 
> Best regard
> 

Hmm ? memcg is used ? Why do you consider this will be a help ?

Thanks,
-Kame

> Hillf
> ---
> 
> --- a/mm/memcontrol.c	Mon Dec 26 20:34:38 2011
> +++ b/mm/memcontrol.c	Mon Dec 26 20:37:54 2011
> @@ -1076,7 +1076,11 @@ void mem_cgroup_lru_del_list(struct page
>  	VM_BUG_ON(!memcg);
>  	mz = page_cgroup_zoneinfo(memcg, page);
>  	/* huge page split is done under lru_lock. so, we have no races. */
> -	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
> +	if (WARN_ON_ONCE(MEM_CGROUP_ZSTAT(mz, lru) <
> +				(1 << compound_order(page))))
> +		MEM_CGROUP_ZSTAT(mz, lru) = 0;
> +	else
> +		MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);
>  }
> 
>  void mem_cgroup_lru_del(struct page *page)
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

