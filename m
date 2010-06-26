Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0FZLU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:20:57 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:54548 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab0FZLU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:20:56 -0400
Date: Sat, 26 Jun 2010 13:20:55 +0200
From: Jens Axboe <jaxboe@fusionio.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, czoccolo@gmail.com
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100626112054.GA30661@kernel.dk>
References: <4C1F3916.4070608@kernel.dk> <20100621110436.GA4056@lst.de> <4C1FB5F7.3070908@kernel.dk> <20100621191410.GA24213@lst.de> <20100621213618.GC6474@redhat.com> <20100623100138.GA9575@lst.de> <20100624014420.GB3297@redhat.com> <20100625110319.GA12855@lst.de> <20100626033509.GA2435@redhat.com> <20100626100526.GA27159@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100626100526.GA27159@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26 2010, Christoph Hellwig wrote:
> > - Stop idling on all the WRITE_SYNC IO. There is no reasonable way to 
> >   tell whether there will be more IO or not from applicatoin. This will
> >   impact direct writes, O_SYNC writes and fsync().
> > 
> >   If direct IO application is submitting writes with a delay in between
> >   it can be starved out in presnce of competing workloads.
> 
> So what application does this?

It isn't about apps having a small delay between submissions,
not sure where Vivek gets that from. Even if you submit back
to back, there's still very small time where the io scheduler
will switch to something else if there's other io pending. This
happens instantly when the sync request finishes - if we don't
idle for any given request, then we of course go to service
someone else with pending io.

The whole idling/anticipation is all about knowing when to
stall the queue very briefly for sync io, allowing that single
sync stream to make good progress for a while before switching
to something else. This switching back and forth potentially
destroyes throughput for the O_DIRECT writer, especially for
disks with write through caching.

Christoph, you seem not to agree on the concept of idling. As
Nick writes in another reply, the difference in performance
when you get it right is staggering. We don't idle the disk
for kicks and laughs. I wont rule out bugs, both in the
handling and the signalling of idling. But as a concept, it
is definitely sound and proven.

-- 
Jens Axboe

