Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2IDSzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:55:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44149 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab2IDSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:55:39 -0400
Date: Tue, 4 Sep 2012 11:55:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904185540.GC3638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904034100.GA21602@moria.home.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikulas, Kent.

On Mon, Sep 03, 2012 at 08:41:00PM -0700, Kent Overstreet wrote:
> On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> > ... or another possibility - start a timer when something is put to 
> > current->bio_list and use that timer to pop entries off current->bio_list 
> > and submit them to a workqueue. The timer can be cpu-local so only 
> > interrupt masking is required to synchronize against the timer.
> > 
> > This would normally run just like the current kernel and in case of 
> > deadlock, the timer would kick in and resolve the deadlock.
> 
> Ugh. That's a _terrible_ idea.

That's exactly how workqueue rescuers work - rescuers kick in if new
worker creation doesn't succeed in given amount of time.  The
suggested mechanism already makes use of workqueue, so it's already
doing it.  If you can think of a better way to detect the generic
stall condition, please be my guest.

> Remember the old plugging code? You ever have to debug performance
> issues caused by it?

That is not equivalent.  Plugging was kicking in all the time and it
wasn't entirely well-defined what the plugging / unplugging conditions
were.  This type of rescuing for forward-progress guarantee only kicks
in under severe memory pressure and people expect finite latency and
throughput hits under such conditions.  The usual bio / request /
scsi_cmd allocations could be failing under these circumstances and
things could be progressing only thanks to the finite preallocated
pools.  I don't think involving rescue timer would be noticeably
deterimental.

Actually, if the timer approach can reduce the frequency of rescuer
involvement, I think it could actually be better.

Thanks.

-- 
tejun
