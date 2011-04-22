Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab1DVXTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 19:19:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22680 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1DVXTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 19:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=XaFbcCm440LfubYApjdRvIrADsSTo59Gx9YTM7N9VAzH8bKS7wr6AtEOlWnElkAHwh
         XzeH9U1+XWgRtUfc65LQ==
Date: Fri, 22 Apr 2011 16:19:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: J Freyensee <james_p_freyensee@linux.intel.com>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH] export kernel call get_task_comm().
In-Reply-To: <1303513182.13457.134.camel@localhost>
Message-ID: <alpine.DEB.2.00.1104221612140.4927@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303511744-815-2-git-send-email-james_p_freyensee@linux.intel.com> <20110422224308.GA301@suse.de> <1303513182.13457.134.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, J Freyensee wrote:

> I'll do whatever is best and easiest for you and will bring a close to
> my submission attempts.  I can also just go into the Kconfig where the
> pti driver is configured and just make the selection bool, yes or no,
> and not make it an option to compile this modularly.  Then I'll drop
> this patch all together.  This is the whole reason why I'm making this
> change.  I don't have to have the pti driver as a module, just more
> convenient.  And within the fs/exec.c it states reads to 'current->comm'
> without a lock is safe.
> 

It's safe to read current->comm without holding task_lock(current), but it 
may be corrupted by a concurrent write via /proc/pid-of-current/comm, 
which could result in garbage where you'd expect the name of the thread.  
That doesn't sound very clean to me and adds more incentive to implement 
some finer-grained protection like a seqlock specifically for tsk->comm.

If /proc/pid/comm is really that important and we can't get away with the 
long-standing prctl(PR_SET_NAME), then you need to protect the string 
somehow and I'm quite surprised this wasn't required before writing other 
threads' comm was allowed.

If you can get away with task_lock(current) in your driver, then great, 
export the symbol and use it, but we have hundreds of racy reads to a 
thread's comm all over the kernel.
