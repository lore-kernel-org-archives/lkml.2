Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1AXIcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 03:32:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:14168 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1AXIct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 03:32:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fDee8ws1B37EiJzJDSd8GKY8c3d4nL3UT3g7x8/UocAoD+4Oq1AGBoVZR9f0FG9oa4
         Bt+KYFw3gDymhSy7yYpQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimCMnjBM5naA1Wzb_FiW7bsVcb1DRyffTizDp_Z@mail.gmail.com>
References: <AANLkTimCMnjBM5naA1Wzb_FiW7bsVcb1DRyffTizDp_Z@mail.gmail.com>
From: Nauman Rafique <nauman@google.com>
Date: Mon, 24 Jan 2011 17:32:22 +0900
Message-ID: <AANLkTimQhy9X_dEx6D_trNRcxtz3BGjjRqzFEf1iCDPR@mail.gmail.com>
Subject: Re: How does CFQ handle the fairness of process write
To: Yuehai Xu <yuehaixu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yuehai,
You have got it right. CFQ is not able to attribute writes to the
threads which actually submit the writes, unless the writes are done
in a synchronous mode (the ones coming through fsync, etc) or in
O_DIRECT mode where the writes are submitted in the context of the
thread itself.

Some attempts have been made in the past to help with this problem. In
the patch series at http://lkml.org/lkml/2010/7/8/478, Munehiro Ikeda
added support for tracking the cgroup (not thread) of the writer
threads, but the patches were not merged. You can read the discussion
there to find out the objections to getting the patches merged (which
I don't necessarily agree with).Tracking the actual thread (instead of
cgroup) of the writer would be the next logical step after those
patches are merged.

In summary, it is a known problem, and hopefully would get fixed one day.

On Sun, Jan 23, 2011 at 9:49 AM, Yuehai Xu <yuehaixu@gmail.com> wrote:
> Hi all,
>
> Suppose there are two processes writing lots of data to disk, these
> data are written to cache at first, and then, kernel threads might
> flush them to disk later. However, from the point of block device, the
> kernel thread is just another process that issues write requests. So,
> how does CFQ handle the fairness between the two processes? It is
> impossible for CFQ to keep the fairness of the two queues for each
> process since many write requests are dispatched by kernel thread,
> which has another queue in CFQ. And both the requests from two
> processes are mixed together in this kernel thread queue.
>
> Is this description correct? In that case, how does CFQ keep the
> fairness for two processes since CFQ seems unable to know the exact
> process the request belongs to.
>
> I appreciate your help.
>
> Thanks,
> Yuehai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
