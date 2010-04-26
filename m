Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0DZNvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab0DZNvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:51:03 -0400
Date: Mon, 26 Apr 2010 09:50:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: CFQ read performance regression
Message-ID: <20100426135051.GB1559@redhat.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu> <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com> <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu> <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com> <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu> <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu> <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com> <20100422203123.GF3228@redhat.com> <1272020222.24780.460.camel@tucsk.pomaz.szeredi.hu> <s2q4e5e476b1004241336lbd071624ke489350093ca6e1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s2q4e5e476b1004241336lbd071624ke489350093ca6e1a@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 10:36:48PM +0200, Corrado Zoccolo wrote:

[..]
> >
> >> Anyway, if that's the case, then we probably need to allow IO from
> >> multiple sequential readers and keep a watch on throughput. If throughput
> >> drops then reduce the number of parallel sequential readers. Not sure how
> >> much of code that is but with multiple cfqq going in parallel, ioprio
> >> logic will more or less stop working in CFQ (on multi-spindle hardware).
> Hi Vivek,
> I tried to implement exactly what you are proposing, see the attached patches.
> I leverage the queue merging features to let multiple cfqqs share the
> disk in the same timeslice.
> I changed the queue split code to trigger on throughput drop instead
> of on seeky pattern, so diverging queues can remain merged if they
> have good throughput. Moreover, I measure the max bandwidth reached by
> single queues and merged queues (you can see the values in the
> bandwidth sysfs file).
> If merged queues can outperform non-merged ones, the queue merging
> code will try to opportunistically merge together queues that cannot
> submit enough requests to fill half of the NCQ slots. I'd like to know
> if you can see any improvements out of this on your hardware. There
> are some magic numbers in the code, you may want to try tuning them.
> Note that, since the opportunistic queue merging will start happening
> only after merged queues have shown to reach higher bandwidth than
> non-merged queues, you should use the disk for a while before trying
> the test (and you can check sysfs), or the merging will not happen.

Thanks corrado. Using split queue sounds like the right place to do it.
I will test it and report back my results.

> 
> >
> > Have you tested on older kernels?  Around 2.6.16 it seemed to allow more
> > parallel reads, but that might have been just accidental (due to I/O
> > being submitted in a different pattern).
> Is the BW for 1 single reader also better on 2.6.16, or the
> improvement is only seen with more concurrent readers?

I will also test 2.6.16. I am anyway curious, how come 2.6.16 performed
better and we were dispatching requests from multiple cfqq and driving
deeper queue depths. To me this is fundamental cfq design that at one
time one queue gets to use the disk (at least for sync-idle tree). So
something must have been different in 2.6.16.

Thanks
Vivek
