Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934799Ab0EZXMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934489Ab0EZXMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:12:06 -0400
Date: Wed, 26 May 2010 16:07:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Regression] Crash in load_module() while freeing args
In-Reply-To: <201005270056.25748.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005261559020.3689@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005261730.59058.rusty@rustcorp.com.au> <201005262127.26235.rusty@rustcorp.com.au> <201005270056.25748.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Rafael J. Wysocki wrote:
> 
> Since the commit has been reverted, do you still want me to test this patch?
> Quite frankly I'd prefer to test a complete replacement for that commit on top
> of current -git.

I'm not re-applying it with the pointless semantic changes that are 
visible to modules. It doesn't matter if they were informed, if it means 
that they'll then just have some odd version dependency and add crazy 
"#if LINUX_VERSION" tests that aren't even exact.

I also wonder exactly what that module_mutex() actually ends up 
protecting. 99% of load_module() seems to be stuff that is purely about 
local issues. Maybe we could tighten the actual lock section to just the
parts that actually expose the vmalloc'ed area to others?

It's generally pointless releasing a lock in the middle - that just makes 
the lock even less valid. If it's valid to just release the lock (without 
some retry logic starting everything from the beginning), it likely the 
lock shouldn't have been held there in the first place.

		Linus
