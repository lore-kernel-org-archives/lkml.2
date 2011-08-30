Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1H3W2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:28:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1H3W14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:27:56 -0400
Date: Tue, 30 Aug 2011 15:22:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
Message-Id: <20110830152216.dffd3cc3.akpm@linux-foundation.org>
In-Reply-To: <4E5D5EE6.3070708@linux.intel.com>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
	<1314661157-22173-2-git-send-email-andi@firstfloor.org>
	<20110830144407.acdae071.akpm@linux-foundation.org>
	<4E5D5EE6.3070708@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 15:06:30 -0700
Andi Kleen <ak@linux.intel.com> wrote:

> 
> > Sorry, it should be an rlimit from day one, IMO.
> >
> 
> Ok.
> 
> > Partly because rlimits are a better implementation.
> 
> The reason I went with a sysctl is that rlimits are more intrusive for 
> user space,
> requires special tools or patching bash.

Yes, deployment for new rlimits is a big PITA.  It would be sensible to
modify the shells to take some anonymous numeric argument, so you could
do

	ulimit 42 1000

to set rlimit number 42 if your shell version doesn't understand the
symbolic representation of more recent additions.  Who do I call?

There was code floating about which would permit rlimits to be modified
from other processes, perhaps by making /proc/pid/limits writable.  I
don't think it got merged.  I have a vague feeling that this might be
my fault.

> > Partly because once rlimits are added, the /proc knob no longer has any
> > sane behaviour.  Does it only modify /sbin/init?  Does it do a global
> > process walk, modifying all threads?
> 
> There's no way to modify: you would need to kill the process or randomly
> take timers away. The limit only applies to new timers.

Sure, it applies to new timers.  My concern is: what does a write to
the old /proc knob _do_?  Modify all the system's task_struct.rlim[],
overwriting whatever was there?  Something else?  It would need to at
least roughly emulate the old behaviour.

