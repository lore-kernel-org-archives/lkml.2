Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab0KLPxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:53:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513Ab0KLPxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:53:02 -0500
Date: Fri, 12 Nov 2010 10:52:50 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, lmcilroy@redhat.com
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-ID: <20101112105250.75f01670@tlielax.poochiereds.net>
In-Reply-To: <4CDCC457.9030400@redhat.com>
References: <20101109114422.3918e7f6@annuminas.surriel.com>
	<20101109142109.224267d0@corrin.poochiereds.net>
	<4CD9A209.6070807@redhat.com>
	<20101109210715.GJ3099@thunk.org>
	<4CD9BA08.2000002@redhat.com>
	<20101109134139.c6f9f6dc.akpm@linux-foundation.org>
	<4CDCC457.9030400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 23:36:39 -0500
Rik van Riel <riel@redhat.com> wrote:

> On 11/09/2010 04:41 PM, Andrew Morton wrote:
> 
> > yup.  It's a userspace bug, really.  Although that bug might be
> > expressed as "userspace didn't know about linux-specific EIO
> > behaviour".
> 
> Looking at this some more, I am not convinced this is a userspace
> bug.
> 
> First, let me describe the problem scenario:
> 1) process A calls write
> 2) process B calls write
> 3) process A calls fsync, runs into an IO error, returns -EIO
> 4) process B calls fsync, returns success
>         (even though data could have been lost!)
> 
> Common sense, as well as these snippets from the fsync man
> page, suggest that this behaviour is incorrect:
> 
> DESCRIPTION
>         fsync()  transfers ("flushes") all modified in-core data of (i.e.,
>         modified buffer cache pages for) the file referred to by the  file
>         descriptor  fd  to  the  disk  device
> ...
> RETURN VALUE
>         On  success,  these  system  calls  return  zero.  On error, -1 is
>         returned, and errno is set appropriately.
> 

I'll agree that that situation sucks for userspace but I'm not sure
that problem scenario is technically wrong. The error got reported to
userspace after all, just not to both processes that had done writes.

The root cause here is that we don't track the file descriptor that was
used to dirty specific pages. The reason is simple, IMO -- it would be
an unmanageable rabbit-hole.

Here's another related "problem" scenario (for purposes of argument):

Suppose between steps 2 and 3, the VM decides to flush out the pages
dirtied by process A, but not the ones from process B. That succeeds,
but just afterward the disk goes toes-up.

Now, process A issues an fsync. He gets an error but his data was
flushed to disk just fine. Is that also incorrect behavior?

-- 
Jeff Layton <jlayton@redhat.com>
