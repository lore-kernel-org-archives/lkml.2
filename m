Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0KOUzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:55:46 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758372Ab0KOUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ndW59qojIi8WwZNJxYN93ID0nbWhIcd416+Cqc19dXIgfdovUZ/XWoeGuBES30ngY9
         V64tfH/0iBRalCbeS82Q==
Date: Mon, 15 Nov 2010 12:54:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <20101115105735.0f9c1a22@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1011151243460.8167@chino.kir.corp.google.com>
References: <1289402093.10699.25.camel@localhost.localdomain> <1289402666.10699.28.camel@localhost.localdomain> <20101114141913.E019.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011141330120.22262@chino.kir.corp.google.com> <4CE0A87E.1030304@leadcoretech.com>
 <alpine.DEB.2.00.1011150204060.2986@chino.kir.corp.google.com> <20101115105735.0f9c1a22@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, Alan Cox wrote:

> > The goal was to make the oom killer heuristic as predictable as possible 
> > and to kill the most memory-hogging task to avoid having to recall it and 
> > needlessly kill several tasks.
> 
> Meta question - why is that a good thing. In a desktop environment it's
> frequently wrong, in a server environment it is often wrong. We had this
> before where people spend months fiddling with the vm and make it work
> slightly differently and it suits their workload, then other workloads go
> downhill. Then the cycle repeats.
> 

Most of the arbitrary heuristics were removed from oom_badness(), things 
like nice level, runtime, CAP_SYS_RESOURCE, etc., so that we only consider 
the rss and swap usage of each application in comparison to each other 
when deciding which task to kill.  We give root tasks a 3% bonus since 
they tend to be more important to the productivity or uptime of the 
machine, which did exist -- albeit with a more dramatic impact -- in the 
old heursitic.

You'll find that the new heuristic always kills the task consuming the 
most amount of rss unless influenced by userspace via the tunables (or 
within 3% of root tasks).

We always want to kill the most memory-hogging task because it avoids 
needlessly killing additional tasks when we must immediately recall the 
oom killer because we continue to allocate memory.  If that task happens 
to be of vital importance to userspace, then the user has full control 
over tuning the oom killer priorities in such circumstances.

> > You have full control over disabling a task from being considered with 
> > oom_score_adj just like you did with oom_adj.  Since oom_adj is 
> > deprecated for two years, you can even use the old interface until then.
> 
> Which changeset added it to the Documentation directory as deprecated ?
> 

51b1bd2a was the actual change that deprecated it, which was a direct 
follow-up to a63d83f4 which actually obsoleted it.
