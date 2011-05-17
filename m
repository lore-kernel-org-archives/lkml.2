Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab1EQW4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:56:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51609 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511Ab1EQW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=F7enrZ40KrgeeHfB/+V8UwEwrmLPzecEIXmn9FlZd1pr4uk9VvVoPfuGIavyE3SFyX
         EKpIaUye/HJKgK457mMw==
Date: Tue, 17 May 2011 15:56:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect
 task->comm access
In-Reply-To: <1305669256.2466.6286.camel@twins>
Message-ID: <alpine.DEB.2.00.1105171551450.10386@chino.kir.corp.google.com>
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org> <1305665263-20933-2-git-send-email-john.stultz@linaro.org> <20110517212734.GB28054@elte.hu> <1305669256.2466.6286.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Peter Zijlstra wrote:

> The changelog also fails to mention _WHY_ this is no longer true. Nor
> does it treat why making it true again isn't an option.
> 

It's been true since:

	4614a696bd1c3a9af3a08f0e5874830a85b889d4
	Author: john stultz <johnstul@us.ibm.com>
	Date:   Mon Dec 14 18:00:05 2009 -0800

	    procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm

Although at the time it appears that nobody was concerned about races so 
proper syncronization was never implemented.  We always had the 
prctl(PR_SET_NAME) so the majority of comm reads, those to current, 
required no locking, but this commit changed that.  The remainder of comm 
dereferences always required task_lock() and the helper get_task_comm() to 
read the string into a (usually stack-allocated) buffer.

> Who is changing another task's comm? That's just silly.
> 

I agree, and I suggested taking write privileges away from /proc/pid/comm, 
but others find that it is useful to be able to differentiate between 
threads in the same thread group without using the prctl() for debugging?
