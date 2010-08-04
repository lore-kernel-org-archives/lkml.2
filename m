Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab0HDDoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:44:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab0HDDoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:44:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=gcqKu/OllXHDEPKIXehuVmFzqnzMgOBUEv2VzmjTumE1UMGQ8kWc/7QTSmnbI4ZWB
	6KxxEOPRS1T1ajswz+a8w==
MIME-Version: 1.0
In-Reply-To: <20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
Date: Tue, 3 Aug 2010 20:44:01 -0700
Message-ID: <AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking per 
	threadgroup
From: Paul Menage <menage@google.com>
To: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Fri, Jul 30, 2010 at 4:57 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> +	 * The threadgroup_fork_lock prevents threads from forking with
> +	 * CLONE_THREAD while held for writing. Use this for fork-sensitive
> +	 * threadgroup-wide operations. It's taken for reading in fork.c in
> +	 * copy_process().
> +	 * Currently only needed write-side by cgroups.
> +	 */
> +	struct rw_semaphore threadgroup_fork_lock;
> +#endif

I'm not sure how best to word this comment, but I'd prefer something like:

"The threadgroup_fork_lock is taken in read mode during a CLONE_THREAD
fork operation; taking it in write mode prevents the owning
threadgroup from adding any new threads and thus allows you to
synchronize against the addition of unseen threads when performing
threadgroup-wide operations. New-process forks (without CLONE_THREAD)
are not affected."

As far as the #ifdef mess goes, it's true that some people don't have
CONFIG_CGROUPS defined. I'd imagine that these are likely to be
embedded systems with a fairly small number of processes and threads
per process. Are there really any such platforms where the cost of a
single extra rwsem per process is going to make a difference either in
terms of memory or lock contention? I think you should consider making
these additions unconditional.

Paul
