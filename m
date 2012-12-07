Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2LGAnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:43:02 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59458 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721Ab2LGAnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:43:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4NAIo6wVB5LHa//2dsb2JhbABEuECFehdzgh4BAQQBOhwjBQsIAxguFCUDIROICgXCehSMJYNiYQOWApBIgwc
Date: Fri, 7 Dec 2012 11:42:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alun <alun.linux@ty-penguin.org.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121207004255.GC27172@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 09:17:07PM +0000, Alun wrote:
> 
> This patch is against kernel version 3.7-rc7.
> 
> The FIFREEZE ioctl blocks userland writes, then calls sync_filesystem.
> If there is a large amount of dirty data, this sync can take a
> substantial time to complete, with corresponding loss of responsiveness
> to any userland processes wishing to write.
> 
> This patch simply adds an extra call to sync_filesystem prior to
> blocking writes, so that (hopefully) the majority of outstanding dirty
> data has been flushed before we impact on userland.

The problem wth doing this is that the sync can delay the freeze
process by quite some time under the exact conditions you describe.
If you want freeze to take effect immediately (i.e instantly stop
new modifications), then adding a sync will break this semantic.
THere are existing users of freeze that require this behaviour...

> I'm a complete kernel newbie and have only done some pretty minimal
> testing on my own machine, but with the patch in place the impact of
> running "fsfreeze -f" immediately followed by "fsfreeze -u" on a
> moderately loaded filesystem (as measured by time taken for a write()
> to complete) was reduced from 2.5 to 0.2 seconds.

That, to me, is irrelevant, because something is normally done while
the filesystem is frozen. It's not uncommon for freeze periods to
extend to minutes while work is done by whatever required the
freeze. Hence the few seconds it takes to acheive the frozen state is
mostly irrelevant.

If you are really concerned by minimising the amount of time it
takes to freeze, then "syncfs; fsfreeze -f; fsfreeze -u" will get
you exactly the same result as your patch, without having any bad
side effects for other users....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
