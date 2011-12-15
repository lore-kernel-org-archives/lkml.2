Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1LOWoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:44:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab1LOWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:44:13 -0500
Date: Thu, 15 Dec 2011 14:44:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
Message-Id: <20111215144411.930dd860.akpm@linux-foundation.org>
In-Reply-To: <CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
References: <1323917052-480-1-git-send-email-walken@google.com>
	<20111215141945.add405d5.akpm@linux-foundation.org>
	<CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011 14:38:58 -0800
Michel Lespinasse <walken@google.com> wrote:

> On Thu, Dec 15, 2011 at 2:19 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > I think the patch is correct but the description is misleading?
> >
> > I see no memory leak here. __Calling __putname() directly simply
> > bypasses some audit-related stuff.
> 
> Hmmm, maybe I wasn't explicit enough about it. We are definitely
> seeing a memory leak without the patch.
> 
> When auditing is enabled, putname() calls audit_putname *instead* (not
> in addition) to __putname(). Then, if a syscall is in progress,
> audit_putname does not release the name - instead, it expects the name
> to get released when the syscall completes, but that will happen only
> if audit_getname() was called previously, i.e. if the name was
> allocated with getname() rather than the naked __getname(). So,
> __getname() followed by putname() ends up leaking memory.
> 

OK.  Please resend with a new changelog?

The bug surprises me - it seems that it makes it trivial for userspace
to cause leaking of mad amounts of kernel memory, which would cause the
bug to be found and fixed quickly.

Is it a recent regression, or does the bug trigger only in weird
circumstances, or what?


