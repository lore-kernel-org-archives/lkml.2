Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1JMOwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 10:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1JMOwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 10:52:38 -0400
Date: Thu, 13 Oct 2011 10:52:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "krzf83@gmail.com " <krzf83@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cgroup blkio bug/feedback
Message-ID: <20111013145231.GB25588@redhat.com>
References: <CAJ1PRSnQgaCr4s+JwmB3r_J9de5MHJKVwrxGnderYGqyVVMG3Q@mail.gmail.com>
 <20111012193551.GH12845@redhat.com>
 <CAJ1PRS=jPU07GjGMecyS=iMhWpfUYe-WO4ntBd=qZ0V0qnK-ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ1PRS=jPU07GjGMecyS=iMhWpfUYe-WO4ntBd=qZ0V0qnK-ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 06:37:52AM +0200, krzf83@gmail.com  wrote:
> I was using rsync to copy between two hard drives on same machine. I
> tried limiting blkio.throttle.read_iops_device and
> blkio.throttle.write_iops_device to about 15 on the destination drive.
> I also tried values like 5, 10.

Ok. So no network involved. Reads and Writes happening on local system
on different block devices.

So md raid (9:2) is your source device and destination of rsync is
some other local block device with a different file system? And you
have put limits only on destination drive and not on source device?

Is md raid (9:2) your root disk too?

> 
> I've even if total overload, previously described, did not occur, I
> now see (since I've stoped using limiting) that those limits caused
> also "minor" spikes in loadavg and resposivness of whole system.

Can you give more details how do you define responsiveness of whole
syste. 

> Whole
> idea of iops limiting is to avoid spikes.

I think if you do some testing and debugging with me, then lets first
solve the total deadlock case and then look into the responsiveness
issue.

> Anyway tests that are made was on 2.6.38.8 kernel which is bit old
> now. I don't know if there were improvments in cgroup blkio since
> then.

I can't think of any very significant changes going in that area since
2.6.38.

Thanks
Vivek

> 
> 
> 2011/10/12 Vivek Goyal <vgoyal@redhat.com>:
> > On Mon, Oct 03, 2011 at 08:39:23PM +0200, krzf83@gmail.com  wrote:
> >> I've been testing cgroup blkio controller in production eviroment for
> >> many days now especialy blkio.throttle.write_iops_device and
> >> blkio.throttle.read_iops_device. I'm using software raid so I have to
> >> limit on devices like /dev/md2 which is 9:2 in my system. Limiting
> >> works fine but every some time whole system overloads and only thing
> >> to do is hard reboot. For two times this happened with cgroup that was
> >> used to limit rsync-ing about 30GB of data.
> >
> > So in this case rsync is reading from local disk and sending it over
> > network somewhere and you are limiting the read iops of rsync process?
> >
> > Or rsync is doing some local buffered writes also and you are trying
> > to limit those buffered writes?
> >
> > Currently throttling works primarily in throttling reads or direct IO.
> > Buffered writes are not supported. In current writeback code, some IO
> > shows up at the device in the context of writing application so that
> > IO will still be throttled. Any IO showing in the context of flusher
> > thread will be attributed to root group and will not be throttled. Anyway,
> > once IO less throttling patches from Wu Fengguang are merged, then
> > all the writeback will be done using flusher threads and none in
> > writer's context.
> >
> > So my first question is what is rsync doing and what kind of limits
> > have you put.(read/write and what are absolute numbers).
> >
> >> Somewhere in the middle
> >> loadavg starts to rise quicly, shell hangs at every kill command and
> >> soft reboot does not work.
> >
> > Can you do alt-sysrq-t to get a dump on console regarding what various
> > tasks are doing.
> >
> >> When I do echo "9:2 0" >
> >> blkio.throttle.read_iops_device and echo "9:2 0" >
> >> blkio.throttle.write_iops_device problem was immeadetly gone.
> >
> > I suspect that it is some kind of file system serialization behind
> > some throttled IO on the device. For example, if your throttlingl
> > limits are low, then it might happen that rsync writer got throttled
> > at device and filesystem is waiting for that IO to finish (to release
> > some lock or something else) and is not allowing any other IO to
> > proceed.
> >
> > Which filesystem are you using? If your limits are not very low,
> > and system does not recover, then other possibility is that there
> > is a bug in throttle code and we kind stop dispatching IO from
> > a cgroup. While load average is going up, can you monitor the
> > cgroup file "blkio.throttle.io_serviced" and see if IO dispatch
> > numbers are increasing or not with time.
> >
> > You can also take a blktrace of your md device (9:2). Remember to
> > save traces on a separate disk and separate file system as if your
> > existing filesystem is kind of stuck, then blktrace will not write
> > anything to disk.
> >
> > You can try one more thing and that is try changing the limit. So if
> > you have iops limit as X then try setting it to X+1 and if everything
> > works fine, then it might be the case that throttling logic got stuck
> > and changing limits gave it an extra kick and it started working again.
> >
> > Also, what do you mean by that disk access is still working. How did
> > you verify that?
> >
> > Thanks
> > Vivek
> >
