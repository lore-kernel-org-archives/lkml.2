Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1K1M2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:28:49 -0500
Received: from bender.cm4all.net ([87.106.27.49]:44323 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1K1M2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:28:47 -0500
Date: Mon, 28 Nov 2011 13:30:57 +0100
From: Max Kellermann <mk@cm4all.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/namei: waiting for mutex during name lookups is
 "killable"
Message-ID: <20111128123056.GA19907@rabbit.intern.cm-ag>
References: <20111128113918.23050.25938.stgit@rabbit.intern.cm-ag>
 <20111128121936.GR4387@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128121936.GR4387@parisc-linux.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011/11/28 13:19, Matthew Wilcox <matthew@wil.cx> wrote:
> On Mon, Nov 28, 2011 at 12:39:18PM +0100, Max Kellermann wrote:
> > Use mutex_lock_killable() instead of mutex_lock() during name lookups,
> > to allow killing the process while it's waiting.
> 
> This is cool.  Could you describe what situations this mutex gets held
> for a user-noticable length of time, and how you tested this patch?

I experienced lots of blocked unkillable processes in an environment
that uses NFS mounts extensively.

There seems to be a lot wrong with Linux's NFS client; it waits for
RPC responses synchronously while the VFS layer holds mutexes, a
behaviour that should be avoided.  My patch does not try to address
this core issue.  Instead, it attempts to mitigate a nasty side
effect.

Most blocked processes were hanging inside stat(), in the code
locations that my patch changes.  After this patch, I could verify
that the affected processes could be killed, instead of hanging in the
task list until the one process holding the mutex would give up the
RPC request.

The patch has been in production on a few heavily loaded servers for
nearly a week, and I did not observe any negative side effects.

Max
