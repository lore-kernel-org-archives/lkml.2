Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1BJCDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:03:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60053 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab1BJCDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:03:47 -0500
Message-ID: <4D5347C9.2030909@cn.fujitsu.com>
Date: Thu, 10 Feb 2011 10:04:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Menage <menage@google.com>, balbir@linux.vnet.ibm.com,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Subject: Re: [RFC][PATCH] cgroup: Fix cgroup_subsys::exit callback
References: <4d384700.2308e30a.70bc.ffffd532@mx.google.com>	 <1295534345.28776.175.camel@laptop> <1296646160.26581.315.camel@laptop>	 <20110202115012.GA16409@balbir.in.ibm.com>	 <1296650792.26581.319.camel@laptop>	 <20110202190251.GB16409@balbir.in.ibm.com>	 <1297095033.13327.46.camel@laptop>	 <AANLkTimF+8XAZxF4psrXSKx1CHFxin6AW=tu5OLGUgNi@mail.gmail.com>	 <1297108959.13327.54.camel@laptop>	 <AANLkTikWS86TPjp+J=iiwCQJ56pqYTQo8Z9_V20GEcEz@mail.gmail.com> <1297160655.13327.92.camel@laptop>
In-Reply-To: <1297160655.13327.92.camel@laptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 10:02:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-10 10:02:49,
	Serialize complete at 2011-02-10 10:02:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(just came back from vacation)

>> How about if the exit callback was moved before the preceding
>> task_unlock()? Since I think the scheduler is still the only user of
>> the exit callback, redefining the locking semantics should be fine.
> 
> Like the below? Both the perf and sched exit callback are fine with
> being called under task_lock afaict, but I haven't actually ran with
> lockdep enabled to see if I missed something.
> 

This change should be fine.

...

> +
> +	if (run_callbacks && need_forkexit_callback) {
> +		/*
> +		 * modular subsystems can't use callbacks, so no need to lock
> +		 * the subsys array
> +		 */
> +		for (i = 0; i < CGROUP_BUILTIN_SUBSYS_COUNT; i++) {
> +			struct cgroup_subsys *ss = subsys[i];
> +			if (ss->exit) {
> +				struct cgroup *old_cgrp =
> +					rcu_dereference_raw(cg->subsys[i])->cgroup;
> +				struct cgroup *cgrp = task_cgroup(tsk, i);
> +				ss->exit(ss, cgrp, old_cgrp, tsk);

Since both sched and perf won't use the 2 args @cgrp and @old_cgrp,
don't bother to change the ->exit interface?

> +			}
> +		}
> +	}
>  	task_unlock(tsk);
> +
>  	if (cg)
>  		put_css_set_taskexit(cg);
>  }
