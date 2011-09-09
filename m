Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab1III4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:56:10 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:44565 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1III4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:56:08 -0400
Date: Fri, 9 Sep 2011 18:00:28 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        axboe@kernel.dk, takuya.yoshikawa@gmail.com
Subject: Re: CFQ I/O starvation problem triggered by RHEL6.0 KVM guests
Message-Id: <20110909180028.d1aba6c0.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110908134945.GA7024@redhat.com>
References: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
	<20110908134945.GA7024@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> wrote:

> So you are using both RHEL 6.0 in both host and guest kernel? Can you
> reproduce the same issue with upstream kernels? How easily/frequently
> you can reproduce this with RHEL6.0 host.

Guests were CentOS6.0.

I have only RHEL6.0 and RHEL6.1 test results now.
I want to try similar tests with upstream kernels if I can get some time.

With RHEL6.0 kernel, I heard that this issue was reproduced every time, 100%.

> > On the host, we were running 3 linux guests to see if I/O from these guests
> > would be handled fairly by host; each guest did dd write with oflag=direct.
> > 
> > Guest virtual disk:
> >   We used a host local disk which had 3 partitions, and each guest was
> >   allocated one of these as dd write target.
> > 
> > So our test was for checking if cfq could keep fairness for the 3 guests
> > who shared the same disk.
> > 
> > The result (strage starvation):
> >   Sometimes, one guest dominated cfq for more than 10sec and requests from
> >   other guests were not handled at all during that time.
> > 
> > Below is the blktrace log which shows that a request to (8,27) in cfq2068S (*1)
> > is not handled at all during cfq2095S and cfq2067S which hold requests to
> > (8,26) are being handled alternately.
> > 
> > *1) WS 104920578 + 64
> > 
> > Question:
> >   I guess that cfq_close_cooperator() was being called in an unusual manner.
> >   If so, do you think that cfq is responsible for keeping fairness for this
> >   kind of unusual write requests?
> 
> - If two guests are doing IO to separate partitions, they should really
>   not be very close (until and unless partitions are really small).

Sorry for my lack of explanation.

The IO was issued from QEMU and the cooperative threads were both for the same
guest. In other words, QEMU was using two threads for one IO stream from the guest.

As my blktrace log snippet showed, cfq2095S and cfq2067S treated one sequential
IO; cfq2095S did 64KB, then cfq2067S did next 64KB, and so on.

  These should be from the same guest because the target partition was same,
  which was allocated to that guest.

During the 10sec, this repetition continued without allowing others to interrupt.

I know it is unnatural but sometimes QEMU uses two aio threads for issuing one
IO stream.

> 
> - Even if there are close cooperators, these queues are merged and they
>   are treated as single queue from slice point of view. So cooperating
>   queues should be merged and get a single slice instead of starving
>   other queues in the system.

I understand that close cooperators' queues should be merged, but in our test
case, when the 64KB request was issued from one aio thread, the other thread's
queue was empty; because these queues are for the same stream, next request
could not come until current request got finished.

  But this is complicated because it depends on the qemu block layer aio.

I am not sure if cfq would try to merge the queues in such cases.

> Can you upload the blktrace logs somewhere which shows what happened 
> during that 10 seconds.

I have some restrictions here, so maybe, but I need to check later.

> > Note:
> >   With RHEL6.1, this problem could not triggered. But I guess that was due to
> >   QEMU's block layer updates.
> 
> You can try reproducing this with fio.

Thank you, I want to do some tests by myself; the original report was not from
my team.


My feeling is that, it may be possible to dominate IO if we create two threads
and issue cooperative IO as our QEMU did; QEMU is just a process from the host
view, and one QEMU process dominated IO preventing other QEMU's IO.

Thanks,
	Takuya
