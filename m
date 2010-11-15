Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0KOKOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 05:14:33 -0500
Received: from smtp-out.google.com ([74.125.121.35]:7480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab0KOKOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 05:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fOlj2LeKajFzt/ZpdR/pZd/hkkmcKgeoHKxmj3mLB/kW9GJhPLM7DxrGIFwAdw/32R
         qVMaNofU59dips0ZkwdQ==
Date: Mon, 15 Nov 2010 02:14:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <4CE0A87E.1030304@leadcoretech.com>
Message-ID: <alpine.DEB.2.00.1011150204060.2986@chino.kir.corp.google.com>
References: <1289402093.10699.25.camel@localhost.localdomain> <1289402666.10699.28.camel@localhost.localdomain> <20101114141913.E019.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141330120.22262@chino.kir.corp.google.com>
 <4CE0A87E.1030304@leadcoretech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Figo.zhang wrote:

> i am doubt that a new rewrite but the athor canot provide some evidence and
> experiment result, why did you do that? what is the prominent change for your
> new algorithm?
> 
> as KOSAKI Motohiro said, "you removed CAP_SYS_RESOURCE condition with ZERO
> explanation".
> 
> David just said that pls use userspace tunable for protection by
> oom_score_adj. but may i ask question:
> 
> 1. what is your innovation for your new algorithm, the old one have the same
> way for user tunable oom_adj.
> 

The goal was to make the oom killer heuristic as predictable as possible 
and to kill the most memory-hogging task to avoid having to recall it and 
needlessly kill several tasks.

The goal behind oom_score_adj vs. oom_adj was for several reasons, as 
pointed out before:

 - give it a unit (proportion of available memory), oom_adj had no unit,

 - allow it to work on a linear scale for more control over 
   prioritization, oom_adj had an exponential scale,

 - give it a much higher resolution so it can be fine-tuned, it works with 
   a granularity of 0.1% of memory (~128M on a 128G machine), and

 - allow it to describe the oom killing priority of a task regardless of 
   its cpuset attachment, mempolicy, or memcg, or when their respective
   limits change.

> 2. if server like db-server/financial-server have huge import processes (such
> as root/hardware access processes)want to be protection, you let the
> administrator to find out which processes should be protection. you
> will let the  financial-server administrator huge crazy!! and lose so many
> money!! ^~^
> 

You have full control over disabling a task from being considered with 
oom_score_adj just like you did with oom_adj.  Since oom_adj is 
deprecated for two years, you can even use the old interface until then.

> 3. i see your email in LKML, you just said
> "I have repeatedly said that the oom killer no longer kills KDE when run on my
> desktop in the presence of a memory hogging task that was written specifically
> to oom the machine."
> http://thread.gmane.org/gmane.linux.kernel.mm/48998
> 
> so you just test your new oom_killer algorithm on your desktop with KDE, so
> have you provide the detail how you do the test? is it do the
> experiment again for anyone and got the same result as your comment ?
> 

Xorg tends to be killed less because of the change to the heuristic's 
baseline, which is now based on rss and swap instead of total_vm.  This is 
seperate from the issues you list above, but is a benefit to the oom 
killer that desktop users especially will notice.  I, personally, am 
interested more in the server market and that's why I looked for a more 
robust userspace tunable that would still be applicable when things like 
cpusets have a node added or removed.
