Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0FBVql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:46:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53418 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab0FBVqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:46:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=tnEupD3jxl9v/QdB2YnKOA97PL0L5WYcbumM/MNK/eZcZcpziqZd59UFPUsHjWcgS
	9KBnBF66aBnNFXpCjUifQ==
Date: Wed, 2 Jun 2010 14:46:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/5] oom: select_bad_process: check PF_KTHREAD instead
 of !mm to skip kthreads
In-Reply-To: <20100602213331.GA31949@redhat.com>
Message-ID: <alpine.DEB.2.00.1006021437010.4765@chino.kir.corp.google.com>
References: <20100601212023.GA24917@redhat.com> <alpine.DEB.2.00.1006011424200.16725@chino.kir.corp.google.com> <20100602223612.F52D.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006021405280.32666@chino.kir.corp.google.com>
 <20100602213331.GA31949@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010, Oleg Nesterov wrote:

> > This isn't a bugfix, it simply prevents a recall to the oom killer after
> > the kthread has called unuse_mm().  Please show where any side effects of
> > oom killing a kthread, which cannot exit, as a result of use_mm() causes a
> > problem _anywhere_.
> 
> I already showed you the side effects, but you removed this part in your
> reply.
> 
> From http://marc.info/?l=linux-kernel&m=127542732121077
> 
> 	It can't die but force_sig() does bad things which shouldn't be done
> 	with workqueue thread. Note that it removes SIG_IGN, sets
> 	SIGNAL_GROUP_EXIT, makes signal_pending/fatal_signal_pedning true, etc.
> 
> A workqueue thread must not run with SIGNAL_GROUP_EXIT set, SIGKILL
> must be ignored, signal_pending() must not be true.
> 
> This is bug. It is minor, agreed, currently use_mm() is only used by aio.
> 

It's a problem that would probably never happen in practice because you're 
talking about a race between select_bad_process() and __oom_kill_task() 
which is wide since it iterates the entire tasklist, which workqueue 
threads will be near the beginning of, and there is an extremely small 
chance that the badness score for the mm that it assumed would be 
considered the ideal task to kill.  If you think this is rc material, then 
push it to Andrew and say that.
