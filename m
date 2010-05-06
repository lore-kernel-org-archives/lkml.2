Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0EFX06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:26:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0EFX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:26:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc:
	subject:references:in-reply-to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=eRT32WBCMjUxzGRqUH34wuqXuylPlboCwON+TmYPMh1Epmzcq6B6oB0fix83p53mw
	YkK0QJHwCT6xbyheaSkSg==
Message-ID: <4BE3503A.2000309@google.com>
Date: Thu, 06 May 2010 16:26:50 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Michel Lespinasse <walken@google.com>
CC: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, Ying Han <yinghan@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
References: <20100505032033.GA19232@google.com> <22933.1273053820@redhat.com> <20100505103646.GA32643@google.com>
In-Reply-To: <20100505103646.GA32643@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> On Wed, May 05, 2010 at 11:03:40AM +0100, David Howells wrote:
>> If the system is as heavily loaded as you say, how do you prevent
>> writer starvation?  Or do things just grind along until sufficient
>> threads are queued waiting for a write lock?
> 
> Reader/Writer fairness is not disabled in the general case - it only is
> for a few specific readers such as /proc/<pid>/maps. In particular, the
> do_page_fault path, which holds a read lock on mmap_sem for potentially long
> (~disk latency) periods of times, still uses a fair down_read() call.
> In comparison, the /proc/<pid>/maps path which we made unfair does not
> normally hold the mmap_sem for very long (it does not end up hitting disk);
> so it's been working out well for us in practice.
> 

FWIW, these sorts of block-ups are usually really pronounce on machines 
with harddrives that take _forever_ to respond to SMART commands (which 
are done via PIO, and which can serialize many drives when they are 
hidden behind a port multiplier).  We've seen cases where hard faults 
can take unusually long on an otherwise non-busy machines (~10 seconds?).

The other case we have problems with mmap_sem from a cluster monitoring 
perspective occurs when we get blocked up behind a task that is having 
problems dying from oom.  We have a variety of hacks used internally to 
cover these cases, though I think we (David and I?) figured that it'd 
make more sense to fix the dependencies on down_read(&current->mmap_sem) 
in the do_exit() path.  For instance, it really makes no sense to 
coredump when we are being oom killed (and thus we should be able to 
skip the mmap_sem dependency there..).

Mike Waychison
