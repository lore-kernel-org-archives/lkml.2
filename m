Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab0EYXvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:51:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755315Ab0EYXvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:51:03 -0400
Date: Tue, 25 May 2010 16:47:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>
Subject: Re: [Regression] Crash in load_module() while freeing args
In-Reply-To: <201005260054.52122.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1005251639420.3689@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005260054.52122.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 May 2010, Rafael J. Wysocki wrote:
>
> I'm not able to reproduce the issue with the following commit reverted:
> 
> commit 480b02df3aa9f07d1c7df0cd8be7a5ca73893455
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed May 19 17:33:39 2010 -0600
> 
>     module: drop the lock while waiting for module to complete initialization.

Hmm. That does seem to be buggy. We can't just drop and re-take the lock: 
that may make sense _internally_ as far as resolve_symbol() itself is 
concerned, but the caller will its own local variables, and some of those 
will no longer be valid if the lock was dropped. 

That commit also changes the return value semantics of "use_module()", 
which is an exported interface where the only users seem to be 
out-of-kernel (the only in-kernel use is in kernel/module.c itself). That 
seems like a really really bad idea too.

So I think reverting it is definitely the right thing to do. The commit 
seems fundamentally broken. And having modules do request_module() in 
their init functions has always been invalid anyway, so that excuse 
doesn't really seem to be a reason to do anything crazy like this either.

Rewriting the logic to
 - not drop the lock
 - not change the return semantics of an exported interface
 - just make 'resolve_symbol()' fail if the module isn't fully loaded
would seem to be a more reasonable approach, no?

			Linus
