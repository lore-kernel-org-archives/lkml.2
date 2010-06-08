Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab0FHS1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:27:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:52973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0FHS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:26:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=THlRToxcxuMvTDzwiTzRF3tENCSvMOPdO2iCJReAahafnUS0a59e4wuW6/Yr4m+/x
	QTiYPF+EAe5le0NiHCMbA==
Date: Tue, 8 Jun 2010 11:26:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 12/12] oom: give current access to memory reserves if it
 has been killed
In-Reply-To: <20100607083650.8736.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006081125340.18848@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152653.726B.A69D9226@jp.fujitsu.com> <20100607083650.8736.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, KOSAKI Motohiro wrote:

> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 67b5fa5..ad85e1b 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -638,6 +638,16 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> >  	}
> >  
> >  	/*
> > +	 * If current has a pending SIGKILL, then automatically select it.  The
> > +	 * goal is to allow it to allocate so that it may quickly exit and free
> > +	 * its memory.
> > +	 */
> > +	if (fatal_signal_pending(current)) {
> > +		set_tsk_thread_flag(current, TIF_MEMDIE);
> > +		return;
> > +	}
> 
> Self NAK this.
> We have no gurantee that current is oom killable. Oh, here is
> out_of_memory(), sigh.
> 

We're not killing it, it's already dying.  We're simply giving it access 
to memory reserves so it may allocate and quickly exit to free its memory.  
Being OOM_DISABLE does not imply the task cannot exit or use memory 
reserves in the exit path.
