Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab0CUSmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 14:42:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab0CUSmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 14:42:10 -0400
Date: Sun, 21 Mar 2010 11:38:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
In-Reply-To: <20100321060607.GA4062@x200>
Message-ID: <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Mar 2010, Alexey Dobriyan wrote:
> 
> It's a perfect opportunity to introduce getrlimit64(2), setrlimit64(2)
> _without_ involving /proc, without all bugs in setrlimit(2), without
> compat code, with all resources equal across arches, and, optionally,
> with infinity setting clearly separate from value (useful for C/R).

Yeah, the infinity setting should be cleaned up. I also wonder if we 
should clean up the odd file limit rules, and make them all be about 
bytes. Correct me if I'm wrong, but don't we do that whole file size thing 
in kilobytes right now?

I do also agree that maybe we could/should skip the whole "writable /proc" 
thing.

So introducing it as just two system calls:

	int getprlimit64(pid, limit, struct rlimit64 *);
	int setprlimit64(pid, limit, const struct rlimit64 *);

and having perhaps something like 'pid=0 means current' would look a lot 
prettier to me.

Or even just _one_ system call that takes two pointers, and can do an 
atomic replace-and-return-the-old-value, like 'sigaction()' does, ie 
something like

	int prlimit64(pid, limit, const struct rlimit64 *new, struct rlimit64 *old);

wouldn't that be a nice generic interface?

(Somebody should really check me on the whole "limit in kilobytes" thing - 
I may be _totally_ off there. I am too lazy to check the actual source 
code)

			Linus
