Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab1JLTgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab1JLTgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:36:02 -0400
Date: Wed, 12 Oct 2011 15:35:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "krzf83@gmail.com " <krzf83@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cgroup blkio bug/feedback
Message-ID: <20111012193551.GH12845@redhat.com>
References: <CAJ1PRSnQgaCr4s+JwmB3r_J9de5MHJKVwrxGnderYGqyVVMG3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ1PRSnQgaCr4s+JwmB3r_J9de5MHJKVwrxGnderYGqyVVMG3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 08:39:23PM +0200, krzf83@gmail.com  wrote:
> I've been testing cgroup blkio controller in production eviroment for
> many days now especialy blkio.throttle.write_iops_device and
> blkio.throttle.read_iops_device. I'm using software raid so I have to
> limit on devices like /dev/md2 which is 9:2 in my system. Limiting
> works fine but every some time whole system overloads and only thing
> to do is hard reboot. For two times this happened with cgroup that was
> used to limit rsync-ing about 30GB of data.

So in this case rsync is reading from local disk and sending it over
network somewhere and you are limiting the read iops of rsync process?

Or rsync is doing some local buffered writes also and you are trying
to limit those buffered writes?

Currently throttling works primarily in throttling reads or direct IO.
Buffered writes are not supported. In current writeback code, some IO
shows up at the device in the context of writing application so that
IO will still be throttled. Any IO showing in the context of flusher
thread will be attributed to root group and will not be throttled. Anyway,
once IO less throttling patches from Wu Fengguang are merged, then
all the writeback will be done using flusher threads and none in
writer's context.

So my first question is what is rsync doing and what kind of limits
have you put.(read/write and what are absolute numbers).

> Somewhere in the middle
> loadavg starts to rise quicly, shell hangs at every kill command and
> soft reboot does not work.

Can you do alt-sysrq-t to get a dump on console regarding what various
tasks are doing.

> When I do echo "9:2 0" >
> blkio.throttle.read_iops_device and echo "9:2 0" >
> blkio.throttle.write_iops_device problem was immeadetly gone.

I suspect that it is some kind of file system serialization behind
some throttled IO on the device. For example, if your throttlingl
limits are low, then it might happen that rsync writer got throttled
at device and filesystem is waiting for that IO to finish (to release
some lock or something else) and is not allowing any other IO to
proceed. 

Which filesystem are you using? If your limits are not very low,
and system does not recover, then other possibility is that there
is a bug in throttle code and we kind stop dispatching IO from
a cgroup. While load average is going up, can you monitor the
cgroup file "blkio.throttle.io_serviced" and see if IO dispatch
numbers are increasing or not with time.

You can also take a blktrace of your md device (9:2). Remember to
save traces on a separate disk and separate file system as if your
existing filesystem is kind of stuck, then blktrace will not write
anything to disk.

You can try one more thing and that is try changing the limit. So if
you have iops limit as X then try setting it to X+1 and if everything
works fine, then it might be the case that throttling logic got stuck
and changing limits gave it an extra kick and it started working again.

Also, what do you mean by that disk access is still working. How did
you verify that?

Thanks
Vivek
