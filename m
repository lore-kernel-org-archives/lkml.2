Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991Ab1IHNty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:49:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932789Ab1IHNtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:49:53 -0400
Date: Thu, 8 Sep 2011 09:49:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        axboe@kernel.dk, takuya.yoshikawa@gmail.com
Subject: Re: CFQ I/O starvation problem triggered by RHEL6.0 KVM guests
Message-ID: <20110908134945.GA7024@redhat.com>
References: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908181353.8b3eb66d.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 06:13:53PM +0900, Takuya Yoshikawa wrote:
> This is a report of strange cfq behaviour which seems to be triggered by
> QEMU posix aio threads.
> 
> Host environment:
>   OS: RHEL6.0 KVM/qemu-kvm (with no patch applied)
>   IO scheduler: cfq (with the default parameters)

So you are using both RHEL 6.0 in both host and guest kernel? Can you
reproduce the same issue with upstream kernels? How easily/frequently
you can reproduce this with RHEL6.0 host.

> 
> On the host, we were running 3 linux guests to see if I/O from these guests
> would be handled fairly by host; each guest did dd write with oflag=direct.
> 
> Guest virtual disk:
>   We used a host local disk which had 3 partitions, and each guest was
>   allocated one of these as dd write target.
> 
> So our test was for checking if cfq could keep fairness for the 3 guests
> who shared the same disk.
> 
> The result (strage starvation):
>   Sometimes, one guest dominated cfq for more than 10sec and requests from
>   other guests were not handled at all during that time.
> 
> Below is the blktrace log which shows that a request to (8,27) in cfq2068S (*1)
> is not handled at all during cfq2095S and cfq2067S which hold requests to
> (8,26) are being handled alternately.
> 
> *1) WS 104920578 + 64
> 
> Question:
>   I guess that cfq_close_cooperator() was being called in an unusual manner.
>   If so, do you think that cfq is responsible for keeping fairness for this
>   kind of unusual write requests?

- If two guests are doing IO to separate partitions, they should really
  not be very close (until and unless partitions are really small).

- Even if there are close cooperators, these queues are merged and they
  are treated as single queue from slice point of view. So cooperating
  queues should be merged and get a single slice instead of starving
  other queues in the system.

Can you upload the blktrace logs somewhere which shows what happened 
during that 10 seconds.

> 
> Note:
>   With RHEL6.1, this problem could not triggered. But I guess that was due to
>   QEMU's block layer updates.

You can try reproducing this with fio.

Thanks
Vivek
