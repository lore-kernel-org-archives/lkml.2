Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030397Ab2CGT4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab2CGT4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:56:44 -0500
Date: Wed, 7 Mar 2012 14:56:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Josh Hunt <joshhunt00@gmail.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120307195638.GI13430@redhat.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
 <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
 <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F57AF4A.6080703@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 07:56:10PM +0100, Jens Axboe wrote:
[..]

> > 
> > blktrace of cfq look odd. I see that some IO (async writes) are being
> > submitted but CFQ did not dispatch it for a long time.  Even some unplugs
> > came in still nothing happened. Also no completions are happening during
> > that window. Not sure why CFQ refuses to dispatch queued writes.
> > 
> > Request added by flusher.
> > 
> >   8,0    1    36926  5028.546000122  2846  A   W 20147012 + 8 <- (8,3)
> > 3375152
> >   8,0    1    36927  5028.546001798  2846  Q   W 20147012 + 8 [flush-8:0]
> >   8,0    1    36928  5028.546009900  2846  G   W 20147012 + 8 [flush-8:0]
> >   8,0    1    36929  5028.546014649  2846  I   W 20147012 + 8 (    4749)
> > [flush-8:0]
> > 
> > And this request is dispatched after 22 seconds.
> > 
> >   8,0    1    37056  5050.117337221   162  D   W 20147012 + 16 (21571322572) [sync_supers]
> > 
> > 
> > And it completes fairly fast.
> > 
> >  8,0    0    36522  5050.117686149  9657  C   W 20147012 + 16 (  348928)
> > [0]
> > 
> > So not sure why CFQ will hold that request for so long when other IO is
> > not happening.
> > 
> > Please try latest kernels and see if deadline has the same issue. If not,
> > then we know somehow CFQ is related. If it still happens on latest
> > kernels, can you try capturing blktrace again when you are experiencing
> > the delays.
> 
> I'm seeing something very similar here. While testing the gtk fio
> client, I ran a job that issued a lot of random reads to my primary
> disk. 64 ios in flight, direct, libaio, 512b random reads. Firefox
> essentially froze, windows starting freezing up around me.
> 
> I'll try and reproduce, but a quick guess would be that things starting
> piling up in fsync() or stalling on writes in general, since we are
> heavily starving those.

Quite possible. Other people also had reported write starvation issues. I 
have got reports of "hung task timeout of 120 seconds" reports in presence
of sync IO happening on same disk/partition.

We probably need to do something about write starvation. I had posted one
patch to make sure we dispatch atleast one WRITE after we were waiting for
pending sync requests to finish.

https://lkml.org/lkml/2011/6/10/326

This might help a bit but might not prevent servere delays in dispatching
async writes as things are so heavily loaded in favor or sync IO.

BTW, in this case, I did not see any sync IO completions happening while
async was not being dispatched. That's little odd.

Thanks
Vivek
