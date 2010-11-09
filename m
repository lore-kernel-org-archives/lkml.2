Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0KIVb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:31:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:6475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0KIVbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:31:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=O9RnJOfiEw+mHYA6mYoFaoBbdv/Qw1P5NkWYGnyoLba5WXG4iHghAmnEKR3uBdGvaQ
         pDaMjvUTBbQ6CtfmBHAQ==
Date: Tue, 9 Nov 2010 13:31:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Thelen <gthelen@google.com>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] memcg: fix unit mismatch in memcg oom limit
 calculation
In-Reply-To: <xr93iq068dyd.fsf@ninji.mtv.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011091327420.7730@chino.kir.corp.google.com>
References: <20101109110521.GS23393@cmpxchg.org> <xr93iq068dyd.fsf@ninji.mtv.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010, Greg Thelen wrote:

> Johannes Weiner <hannes@cmpxchg.org> writes:
> 
> > Adding the number of swap pages to the byte limit of a memory control
> > group makes no sense.  Convert the pages to bytes before adding them.
> >
> > The only user of this code is the OOM killer, and the way it is used
> > means that the error results in a higher OOM badness value.  Since the
> > cgroup limit is the same for all tasks in the cgroup, the error should
> > have no practical impact at the moment.
> >
> > But let's not wait for future or changing users to trip over it.
> 
> Thanks for the fix.
> 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Greg Thelen <gthelen@google.com>
> 

Nice catch, but it's done in the opposite way: the oom killer doesn't use 
byte limits but page limits.  So this needs to be

	(res_counter_read_u64(&memcg->res, RES_LIMIT) >> PAGE_SHIFT) +
			total_swap_pages;
