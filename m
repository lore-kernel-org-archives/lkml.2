Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1EQW1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:27:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:55445 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab1EQW1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:27:20 -0400
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect
 task->comm access
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20110517212734.GB28054@elte.hu>
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>
	 <1305665263-20933-2-git-send-email-john.stultz@linaro.org>
	 <20110517212734.GB28054@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 15:27:05 -0700
Message-ID: <1305671225.2915.133.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 23:27 +0200, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> 
> > The implicit rules for current->comm access being safe without locking are no 
> > longer true. Accessing current->comm without holding the task lock may result 
> > in null or incomplete strings (however, access won't run off the end of the 
> > string).
> 
> This is rather unfortunate - task->comm is used in a number of performance 
> critical codepaths such as tracing.
> 
> Why does this matter so much? A NULL string is not a big deal.

I'll defer to KOSAKI Motohiro and David on this bit. :)

> Note, since task->comm is 16 bytes there's the CMPXCHG16B instruction on x86 
> which could be used to update it atomically, should atomicity really be 
> desired.

Could we use this where cmpxchg16b is available and fall back to locking
if not? Or does that put too much of a penalty on arches that don't have
cmpxchg16b support?

Alternatively, we can have locked accessors that are safe in the
majority of slow-path warning printks, and provide unlocked accessors
for cases where the performance is critical and the code can properly
handle possibly incomplete comms.

thanks
-john



