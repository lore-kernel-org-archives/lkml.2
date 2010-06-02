Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab0FBVCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:02:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:36716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab0FBVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:02:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=MdtCVmSza3onJhZL4mji72uxem1patpOQ96kt/5KKTu0eWeN+BVDnNlYmSkCk9AHj
	NYx2mXdCA48qFp+Fy4prg==
Date: Wed, 2 Jun 2010 14:02:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: remove PF_EXITING check completely
In-Reply-To: <20100602155455.GB9622@redhat.com>
Message-ID: <alpine.DEB.2.00.1006021359430.32666@chino.kir.corp.google.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com> <20100602200732.F518.A69D9226@jp.fujitsu.com> <20100602155455.GB9622@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010, Oleg Nesterov wrote:

> > Today, I've thought to make some bandaid patches for this issue. but
> > yes, I've reached the same conclusion.
> >
> > If we think multithread and core dump situation, all fixes are just
> > bandaid. We can't remove deadlock chance completely.
> >
> > The deadlock is certenaly worst result, then, minor PF_EXITING optimization
> > doesn't have so much worth.
> 
> Agreed! I was always wondering if it really helps in practice.
> 

Nack, this certainly does help in practice, it prevents needlessly killing 
additional tasks when one is exiting and may free memory.  It's much 
better to defer killing something temporarily if an eligible task (i.e. 
one that has a high probability of memory allocations on current's nodes 
or contributing to its memcg) is exiting.

We depend on this check specifically for our use of cpusets, so please 
don't remove it.
