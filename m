Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab2FUUc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab2FUUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:32:24 -0400
Date: Thu, 21 Jun 2012 16:32:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120621203217.GC14095@redhat.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
 <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
 <20120307162851.GC13430@redhat.com>
 <4F57AF4A.6080703@kernel.dk>
 <CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
 <CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
 <20120308234016.GA925@redhat.com>
 <CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
 <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 02:26:13PM -0500, Josh Hunt wrote:
> On Thu, Mar 8, 2012 at 6:16 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> > On Thu, Mar 8, 2012 at 5:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Thu, Mar 08, 2012 at 04:22:31PM -0600, Josh Hunt wrote:
> >>
> >> [..]
> >>> A crude bisection seems to show that if I revert "blkio: Set
> >>> must_dispatch only if we decided to not dispatch the request"
> >>> (bf7919371025412978268efca4b09dd847acb395) I no longer see the stalls
> >>> in 2.6.35. However this does not seem to solve the problem if I revert
> >>> it in 2.6.38.
> >>
> >> Strange. If this was the problem it should have fixed it in 2.6.38 also.
> >> BTW, the blktrace you sent was from 2.6.38 or 2.6.35 kernels.
> >>
> >
> > The blktrace is from 2.6.35. I just attached a portion of it earlier
> > b/c I thought it would be too much to send the whole thing. I've gone
> > ahead and attached the full output (bzip'd), along with the same
> > workload with slice_idle set to 0 for comparison.
> >
> >>>
> >>> By setting slice_idle to 0, does this basically disable plugging?
> >>
> >> It disables idling and not plugging.
> >
> > OK that's what I thought. I'm just confused about the differences in
> > the blktrace outputs wrt plugging with slice_idle set to 0.
> >
> >>
> >>> Based on the blktrace info it seems that something is going wrong with
> >>> plugging with my testcase. I'm just wondering why setting slice_idle
> >>> to 0 seems to resolve my issue? Also, since we see unplugs in the
> >>> blktrace how could the requests still not be getting sent to the disk?
> >>
> >> Unplug will just try to kick the queue. That does not mean that request
> >> will be dispatched. And that's the question that why are we not
> >> dispatching requests.
> >>
> >> I had another look at traces and I think it is not just async write, but
> >> there is was sync write request queued and we have not dispatched that
> >> too for a long time.
> >>
> >> Added request here.
> >>
> >>  8,0    1    36921  5028.492019664   162  A  WS 63 + 8 <- (8,1) 0
> >>  8,0    1    36922  5028.492021620   162  Q  WS 63 + 8 [sync_supers]
> >>  8,0    1    36923  5028.492029721   162  G  WS 63 + 8 [sync_supers]
> >>  8,0    1    36924  5028.492040617   162  I   W 63 + 8 (   10896)
> >> [sync_supers]
> >>  8,0    1        0  5028.492044807     0  m   N cfq162 insert_request
> >>  8,0    1        0  5028.492046763     0  m   N cfq162 add_to_rr
> >>
> >> And after a long time we dispatched the request.
> >>
> >>  8,0    0        0  5050.116841906     0  m   N cfq162 set_active wl_prio:0 wl_type:1
> >>  8,0    0        0  5050.116844979     0  m   N cfq162 fifo=ffff8800e8787aa0
> >>  8,0    0        0  5050.116846655     0  m   N cfq162 dispatch_insert
> >>  8,0    0        0  5050.116849728     0  m   N cfq162 dispatched a
> >> request
> >>  8,0    0        0  5050.116851683     0  m   N cfq162 activate rq, drv=1
> >>  8,0    0    36518  5050.116853360   166  D   W 63 + 8 (21624812743)
> >> [kblockd/0]
> >>  8,0    0    36519  5050.117236650  9671  C   W 63 + 8 (  383290) [0]
> >>
> >> So it is not async requestss being starved by sync request issue, most
> >> likely.
> >>
> >
> > I wanted to point out again that this is a very small io load. On the
> > avg of a few KB/s.
> >
> >> Are you using any of the blk cgroup stuff?
> >
> > No, none of that is enabled in the kernel.
> >
> >>
> >> Can you put some more trace messages to figure out what's happening.
> >> I think you can try putting some trace messages in following functions.
> >>
> >> __blk_run_queue()
> >> cfq_select_queue()
> >>
> >> and try to narrow down why CFQ refuses to dispatch the request when
> >> this happens.
> >
> > Sure. I'll add some more traces here and see if it sheds any light on the issue.
> >
> > Thanks again for your help.
> >
> >>
> >> Thanks
> >> Vivek
> >
> > --
> > Josh
> 
> It looks like I am hitting this issue again. I upgraded our system to
> the 3.0.13 kernel and it appeared to resolve the issues I was seeing.
> Unfortunately it is still occurring now just less frequently.
> 
> I've gone ahead and instrumented cfq_select_queue and have some more
> information. To quickly recap my issue - using CFQ we are seeing an
> application's async writes stall for 5-15s. This is using a sata_svw
> controller and a rotating drive which does not have NCQ enabled. If I
> change slice_idle to 0 the stalls appear to go away. I've also tried
> using the deadline scheduler and do not see the issue with that. I dug
> through CFQ and identified the line which with slice_idle set to 0
> gets bypassed and allows my workload to run without stalling (I added
> in the blktrace logging for my debugging):
> 
>         if (cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
>                 service_tree = cfqq->service_tree;
>                 cfq_log_cfqq(cfqd, cfqq, "keep_queue st->count:%d, dispatch:%u",
>                         service_tree->count, cfqq->dispatched);
>                 cfqq = NULL;
>                 goto keep_queue;
>         }
> 
> When I have slice_idle set to 0, this gets bypassed and my workload
> runs fine. I've verified this by removing this code and running the
> workload with that kernel. I'm not saying it should be removed, just
> that bypassing this code helps my workload for whatever reason.
> 
> Here are some snippets from my blktrace log (attached):
> 
> Insert:
>   8,0    1        0  4466.115833485     0  m   N cfq5864 insert_request
>   8,0    1        0  4466.115835161     0  m   N cfq20720 Idling.
> st->count:2, hw_tag:0
>   8,0    1  1499412  4466.115836278  6023  I   W 7078615 + 256 (
> 311495) [flush-8:0]
>   8,0    1        0  4466.115837675     0  m   N cfq5864 insert_request
>   8,0    1        0  4466.115840190     0  m   N cfq20720 Idling.
> st->count:2, hw_tag:0
>   8,0    1  1499413  4466.115841307  6023  U   N [flush-8:0] 8
>   8,0    1        0  4466.115842983     0  m   N cfq20720 Idling.
> st->count:2, hw_tag:0
>   8,0    1        0  4466.115844660     0  m   N cfq20720 keep_queue
> st->count:2, dispatch:1
> 
> Dispatch:
>   8,0    0        0  4478.127274376     0  m   N cfq5864 complete rqnoidle 0
>   8,0    0        0  4478.127318796     0  m   N cfq5864 Not idling. st->count:1
>   8,0    0        0  4478.127320472     0  m   N cfq5864 dispatch_insert
>   8,0    0        0  4478.127322148     0  m   N cfq5864 dispatched a request
>   8,0    0        0  4478.127324104     0  m   N cfq5864 activate rq, drv=2
>   8,0    0  2876000  4478.127325221  7232  D   W 7078615 + 256
> (12011488943) [testd]
>   8,0    0  2876001  4478.128414478  7232  C   W 7078135 + 264 ( 1250173) [0]
>   8,0    0        0  4478.128445767     0  m   N cfq5864 complete rqnoidle 0
> 
> Also in the blktrace I see gaps of 3-4s where nothing happens:
>  8,0    0        0  4466.893959719     0  m   N cfq20723 del_from_rr
>   8,0    0        0  4466.893961395     0  m   N cfq schedule dispatch
>   8,0    1  1499539  4470.000135552   174  A  WS 63 + 8 <- (8,1) 0
>   8,0    1  1499540  4470.000138066   174  Q  WS 63 + 8 [sync_supers]
> 
> Meanwhile the requests issued earlier are just sitting on the queue
> waiting to be dispatched.
> 
> To accelerate the issue I'm constantly dropping the cache - while :;
> do echo 1 > /proc/sys/vm/drop_caches; done. The issue occurs without
> it, but this helps reproduce it in about an hour. I also wanted to
> point out that I see a decent amount of syslogd activity in the trace
> and know that it does do fsync(). I'm not sure if that's helping the
> stalling, but wanted to mention that.

This is strange. I can see in logs that for some reason writes are not
being dispatched and queue is doing nothing.

  8,0    0        0  4466.132851211     0  m   N cfq schedule dispatch
  8,0    0        0  4466.132854564     0  m   N cfq20720 keep_queue
timer_pending st->count:2, dispatch:0
  8,0    0        0  4466.139951919     0  m   N cfq idle timer fired
  8,0    0        0  4466.139954713     0  m   N cfq20720 slice expired
t=0
  8,0    0        0  4466.139958066     0  m   N cfq20720 sl_used=17
disp=21 charge=17 iops=0 sect=176
  8,0    0        0  4466.139959742     0  m   N cfq20720 del_from_rr
  8,0    0        0  4466.139963653     0  m   N cfq schedule dispatch
  8,0    1  1499521  4466.791207736  7570  A   R 7258191 + 8 <- (8,1)
7258128
  8,0    1  1499522  4466.791209692  7570  Q   R 7258191 + 8 [httpdmon]
  8,0    1  1499523  4466.791217514  7570  G   R 7258191 + 8 [httpdmon]
  8,0    1  1499524  4466.791221705  7570  I   R 7258191 + 8 (    4191)
[httpdmon]
  8,0    1        0  4466.791227572     0  m   N cfq7570 insert_request
  8,0    1        0  4466.791229248     0  m   N cfq7570 add_to_rr
  8,0    1        0  4466.791235953     0  m   N cfq20719 set_active
wl_prio:0 wl_type:2

Here we deleted queue 20720 and did nothing for .6 seconds and from
previous logs it is visible that writes are pending and queued.

For some reason cfq_schedule_dispatch() did not lead to kicking queue
or queue was kicked but somehow write queue was not selected for
dispatch (A case of corrupt data structures?).

Are you able to reproduce this issue on latest kernels (3.5-rc2?). I would
say put some logs in select_queue() and see where did it bail out. That
will confirm that select queue was called and can also give some details 
why we did not select async queue for dispatch. (Note: select_queue is called
multiple times so putting trace point there makes logs very verbose).

Thanks
Vivek
