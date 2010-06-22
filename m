Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0FVNS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:18:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0FVNS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:18:56 -0400
Date: Tue, 22 Jun 2010 09:18:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cfq: allow dispatching of both sync and async I/O
 together
Message-ID: <20100622131853.GB13153@redhat.com>
References: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
 <1277149789-4493-3-git-send-email-jmoyer@redhat.com>
 <4C1FC4B4.3060700@kernel.dk>
 <20100621232208.GA10175@redhat.com>
 <20100622040700.GA12502@redhat.com>
 <x49sk4ffd6l.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49sk4ffd6l.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 08:45:54AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, Jun 21, 2010 at 07:22:08PM -0400, Vivek Goyal wrote:
> >> On Mon, Jun 21, 2010 at 09:59:48PM +0200, Jens Axboe wrote:
> >> > On 21/06/10 21.49, Jeff Moyer wrote:
> >> > > Hi,
> >> > > 
> >> > > In testing a workload that has a single fsync-ing process and another
> >> > > process that does a sequential buffered read, I was unable to tune CFQ
> >> > > to reach the throughput of deadline.  This patch, along with the previous
> >> > > one, brought CFQ in line with deadline when setting slice_idle to 0.
> >> > > 
> >> > > I'm not sure what the original reason for not allowing sync and async
> >> > > I/O to be dispatched together was.  If there is a workload I should be
> >> > > testing that shows the inherent problems of this, please point me at it
> >> > > and I will resume testing.  Until and unless that workload is identified,
> >> > > please consider applying this patch.
> >> > 
> >> > The problematic case is/was a normal SATA drive with a buffered
> >> > writer and an occasional reader. I'll have to double check my
> >> > mail tomorrow, but iirc the issue was that the occasional reader
> >> > would suffer great latencies since service times for that single
> >> > IO would be delayed at the drive side. It could perhaps just be
> >> > a bug in how we handle the slice idling on the read side when the
> >> > IO gets delayed initially.
> >> > 
> >> > So if my memory is correct, google for the fsync madness and
> >> > interactiveness thread that we had some months ago and which
> >> > caused a lot of tweaking. The commit adding this is
> >> > 5ad531db6e0f3c3c985666e83d3c1c4d53acccf9 and was added back
> >> > in July last year. So it was around that time that the mails went
> >> > around.
> >> 
> >> Hi Jens,
> >> 
> >> I suspect we might have introduced this patch because mike galbraith
> >> had issues which application interactiveness (reading data back from swap)
> >> in the prence of heavy writeout on SATA disk.
> >> 
> >> After this patch we did two enhancements.
> >> 
> >> - You introduced the logic of building write queue depth gradually.
> >> - Corrado introduced the logic of idling on the random reader service
> >>   tree.
> >> 
> >> In the past random reader were not protected from WRITES as there was no
> >> idling on random readers. But with corrado's changes of idling on
> >> sync-noidle service tree, I think this problem might have been solved to
> >> a great extent.
> >> 
> >> Getting rid of this exclusivity of either SYNC/ASYNC requests in request
> >> queue might help us with throughput on storage arrys without loosing
> >> protection for random reader on SATA. 
> >> 
> >> I will do some testing with and without patch and see if above is true
> >> or not.
> >
> > Some primilinary testing results with and without patch. I started a
> > buffered writer and started firefox and monitored how much time firefox
> > took.
> >
> > dd if=/dev/zero of=zerofile bs=4K count=1024M
> >
> > 2.6.35-rc3 vanilla
> > ==================
> > real    0m22.546s
> > user    0m0.566s
> > sys     0m0.107s
> >
> >
> > real    0m21.410s
> > user    0m0.527s
> > sys     0m0.095s
> >
> >
> > real    0m27.594s
> > user    0m1.256s
> > sys     0m0.483s
> >
> > 2.6.35-rc3 + jeff's patches
> > ===========================
> > real    0m20.372s
> > user    0m0.635s
> > sys     0m0.128s
> >
> > real    0m22.281s
> > user    0m0.509s
> > sys     0m0.093s
> >
> > real    0m23.211s
> > user    0m0.674s
> > sys     0m0.140s
> >
> > So looks like firefox launching times have not changed much in the presence
> > of heavy buffered writting going on root disk. I will do more testing tomorrow.
> 
> Was the buffered writer actually hitting disk?  How much memory is on
> your system?

I have 4G of memory in the system. I used to wait for 10-15 seconds after
writer has started and then launch firefox to make sure writes are actually
hitting the disk.

Are you seeing different results in your testing?

Thanks
Vivek
