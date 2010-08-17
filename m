Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0HQC5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:57:55 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0HQC5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:57:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=Wc9MPh8KM6bHQWYK/snx/r2i1LL+6GvyHmfa74uPiyMXQZ3tv1633b+6hmCl+tleW
	RA3uZnFlMB/WxVd+ToFXw==
Date: Mon, 16 Aug 2010 19:57:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Chris Mason <chris.mason@oracle.com>,
        Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
        Jan Kara <jack@suse.cz>, Anton Altaparmakov <aia21@cantab.net>,
        Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: [patch 0/6] remove dependency on __GFP_NOFAIL
Message-ID: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes __GFP_NOFAIL from various allocations when those
callers don't have __GFP_FS set, meaning they cannot invoke the oom
killer to free memory.

This is the second phase of four for the total removal of __GFP_NOFAIL:
the remaining phases will introduce __GFP_KILLABLE to invoke the oom
killer to free memory for all remaining callers since they allow
__GFP_FS, and then __GFP_NOFAIL will be removed from the page allocator.

/* FIXME */ comments were added where potentially infinite loops were
added to the callers.  These always had the potential to infinitely loop
in the page allocator, but those loops will now occur in the caller
instead and some documentation of this behavior was necessary (grep for
__GFP_NOFAIL will no longer work when this effort is completed).

There's a benefit for the removal of __GFP_NOFAIL: we save several
branches in the page allocator if we can move this logic to the caller
instead.
