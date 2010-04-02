Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab0DBICb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 04:02:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51176 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab0DBICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 04:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oVWCC3mgr03UKnEJQRDUYUhyxr1fruUm4D3cIM+rrCP8BQdn+WLDxpWtlWjwh1P4qf
         Hd0WmB9qFs/Dg8g6Dz7J+bDff5nX8tK5KMPqrG24Rs+6e3qBOWDncIYm55KuEMpxh3DE
         KdF3WWwppLwFDVuFlz4OOsQxMhRXKz6O+oW0M=
MIME-Version: 1.0
In-Reply-To: <m2v100eff551003311324tdc2e567atd2a48e35520e8601@mail.gmail.com>
References: <m2v100eff551003311324tdc2e567atd2a48e35520e8601@mail.gmail.com>
Date: Fri, 2 Apr 2010 10:02:16 +0200
Message-ID: <x2h4e5e476b1004020102gaf301a69oc4e0ffda85c2ce39@mail.gmail.com>
Subject: Re: Questions about RAID and I/O scheduler
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yhxu@wayne.edu,
       neilb@suse.de, jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 10:24 PM, Yuehai Xu <yuehaixu@gmail.com> wrote:
> Hi,
>
> I noticed that some one said NOOP is usually the default I/O scheduler
> for hardware RAID. Why not CFQ? Suppose there are just several
> sequential read processes, as I know CFQ will keep all the disk heads
> of hard raid to serve a process for a while(a time slice), in that
> case, CFQ should be the best of all I/O schedulers. Am I right?
> Generally, hard raid should have its own I/O scheduler in their
> firmware, in that case, the I/O scheduler of OS should do nothing
> except dispatch the requests as soon as possible, it is the hard raid
> itself to decide how to schedule these requests. From this point of
> view, NOOP should be the default one. I am really confused here.
Even single ncq disks have an I/O scheduler nowadays.
To clear the confusion, we should make a distinction between
work-conserving and non-work-conserving I/O schedulers.
    * A work-conserving scheduler (e.g. deadline, noop) is idle only
when there is no request pending
    * A non-work-conserving scheduler (e.g. CFQ, AS) may be idle at
any time, in an effort to improve request pattern locality or to
provide fairness.
A non-work-conserving scheduler in the host computer will generally
perform bad if the RAID also has a non-work-conserving scheduler,
because the decision to idle taken by the two schedulers could
conflict, causing disk utilization to drop needlessly. In that case,
NOOP or even better, deadline, could perform much better.

If the raid controller has a work-conserving I/O scheduler, instead
(single NCQ disks and cheap RAID cards typically have this kind of
schedulers), CFQ can effectively control the access pattern (by
queuing only the requests pertinent to the pattern and delaying the
others), and will take advantage when possible of the better
understanding of disk geometry by the lower level scheduler for some
kind of patterns (the ones for which we can submit multiple requests
in parallel, namely random access patterns).
In this case, we suggest to try CFQ and report if you see regressions
w.r.t. NOOP or deadline on some workloads, so we can tune it better.
>
> The next question is about the maximal number of disks in disk array,
> the fault tolerance should be one limitation because the more the
> number of disks, the higher chance of failure. However, may throughput
> also be one limitation? Do you know anyone use disk array which
> contains large number of disks to handle small requests? Such as 256
> disks to handle 4K requests?
You can use multiple disks to handle many parallel random requests.
You should check, though, the queue depth of your raid card, that
limits the actual number of requests issued in parallel.
If it is lower than the number of disks (e.g. it is 31 on SATA), then
the additional disks are wasted for random access patterns.

Thanks,
Corrado
>
> Thanks!
>
> Yuehai
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
