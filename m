Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1FVW5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:57:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FVW5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HwJqCHDKz37NrKyov3/DRXN0OxXvuHxTr86mWbNRisLS9q0C4ohvzr+eb80AfA63Ly
         Ru11y6cvXNSegy/U+y5w==
Date: Wed, 22 Jun 2011 15:57:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, caiqian@redhat.com,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/6] oom: use euid instead of CAP_SYS_ADMIN for protection
 root process
In-Reply-To: <4E01C809.9020508@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1106221552310.11759@chino.kir.corp.google.com>
References: <4E01C7D5.3060603@jp.fujitsu.com> <4E01C809.9020508@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, KOSAKI Motohiro wrote:

> Recently, many userland daemon prefer to use libcap-ng and drop
> all privilege just after startup. Because of (1) Almost privilege
> are necessary only when special file open, and aren't necessary
> read and write. (2) In general, privilege dropping brings better
> protection from exploit when bugs are found in the daemon.
> 

You could also say that dropping the capability drops the bonus it is 
given in the oom killer.  We've never promised any benefit in the oom 
killer badness scoring without the capability.

> But, it makes suboptimal oom-killer behavior. CAI Qian reported
> oom killer killed some important daemon at first on his fedora
> like distro. Because they've lost CAP_SYS_ADMIN.
> 

I disagree that we should be identifying "important daemons" by tying it 
the effective uid of the process and thus making some sort of inference 
because a thread was forked by root.  I think it is more clear to tie that 
to an actual capability that is present, such as CAP_SYS_ADMIN, or suggest 
that the user give the "important daemon" it's own bonus by tuning 
/proc/pid/oom_score_adj.

We already know that the kernel will not be able to identify critical 
processes perfectly, that's an assumption that we can live with.  We must 
rely on userspace to influence that decision by using the tunable.

If this patch were merged, I could easily imagine an argument in the 
reverse that would just simply revert it: it would be very easy to say 
that CAP_SYS_ADMIN has always given this bonus in recent memory so 
changing it would be a regression over the previous behavior and/or that 
giving the capability to a thread as it runs implies that it should have 
the bonus when the euid may not be 0.
