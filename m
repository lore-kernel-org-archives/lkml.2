Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1HaRIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:08:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:26790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab1HaRIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,308,1312182000"; 
   d="scan'208";a="46877148"
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Ehrenberg <dehrenberg@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Approaches to making io_submit not block
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<20110830053231.GA1627@infradead.org>
	<CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
	<20110831052627.GA5338@infradead.org>
Date: Wed, 31 Aug 2011 10:08:50 -0700
In-Reply-To: <20110831052627.GA5338@infradead.org> (Christoph Hellwig's
	message of "Wed, 31 Aug 2011 01:26:27 -0400")
Message-ID: <m2pqjlo6e5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
>
> I'll get it polished up and send it out for RFC once Dave sends out
> the updated allocation workqueue patch.  With this he moves all
> allocator calls in XFS into a workqueue.  My direct I/O patch uses that
> fact to use that workqueue for the allocator call

Is that really a good direction? The problem when you push operations
from multiple threads all into a single resource (per cpu workqueue)
is that the CPU scheduler loses control over that because they
are all mixed up.

So if one guy submits a lot and another very little the "a lot" guy
can overwhelm the queue for the very little guy.

We also have similar problems with the IO schedulers, which also
rely on process context to make fairness decisions. If you remove
the process context they do badly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
