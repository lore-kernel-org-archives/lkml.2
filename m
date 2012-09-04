Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab2IDDlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 23:41:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46199 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2IDDle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 23:41:34 -0400
Date: Mon, 3 Sep 2012 20:41:00 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904034100.GA21602@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> ... or another possibility - start a timer when something is put to 
> current->bio_list and use that timer to pop entries off current->bio_list 
> and submit them to a workqueue. The timer can be cpu-local so only 
> interrupt masking is required to synchronize against the timer.
> 
> This would normally run just like the current kernel and in case of 
> deadlock, the timer would kick in and resolve the deadlock.

Ugh. That's a _terrible_ idea.

Remember the old plugging code? You ever have to debug performance
issues caused by it?

> 
> > I could be convinced, but right now I prefer my solution.
> 
> It fixes bio allocation problem, but not other similar mempool problems in 
> dm and md.

I looked a bit more, and actually I think the rest of the problem is
pretty limited in scope - most of those mempool allocations are per
request, not per split.

I'm willing to put some time into converting dm/md over to bioset's
front_pad. I'm having to learn the code for the immutable biovec work,
anyways.
