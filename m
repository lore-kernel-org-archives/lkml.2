Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1EFGxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:53:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38429 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1EFGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B0QV++JFckEFqwGMj44I33U5QdOQcSSEfmqMjPGxxJd64eNG13g+2DWnq8HBtGp6Wx
         NhZ07f/caWKisBwoGZt2DsvUrdd0FEApEOXpyT4jlX0hMlSJY8tokh7qNBsjamv3uhXo
         XrjmVlXcUkRD1uXqu7PYuJKE67WRmK+ikqjnY=
Date: Fri, 6 May 2011 08:53:47 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "jgarzik@pobox.com" <jgarzik@pobox.com>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ricwheeler@gmail.com" <ricwheeler@gmail.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for
 non-queueable flush drive
Message-ID: <20110506065347.GA8824@htj.dyndns.org>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com>
 <20110505020417.817084678@sli10-conroe.sh.intel.com>
 <20110505083853.GC30950@htj.dyndns.org>
 <1304656325.3828.22.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304656325.3828.22.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 06, 2011 at 12:32:05PM +0800, Shaohua Li wrote:
> > - This is much more minor but if block layer already knows flushes are
> >   non-queueable, it might be a good idea to hold dispatching of
> >   flushes if other requests are already in progress.  It will only
> >   save dispatch/requeue overhead which might not matter at all, so
> >   this has pretty good chance of not being worth of the added
> >   complexity tho.
>
> I did some experiment to hold flush too, but no obvious performance
> difference. It doesn't make more flush requests merge. Avoiding
> unnecessary requeue is a gain for fast devices, but my test doesn't
> show.

I see.  Thanks for testing.

> Subject: block: hold queue if flush is running for non-queueable flush drive
> 
> Commit 53d63e6b0dfb9(block: make the flush insertion use the tail of
> the dispatch list) causes about 20% regression running a sysbench fileio
> workload. Let's consider the following scenario:
> - flush1 is dispatched with write1 in the elevator.
> - Driver dispatches write1 and requeues it.
> - flush2 is issued and appended to dispatch queue after the requeued write1. 
>   As write1 has been requeued flush2 can't be put in front of it.
> - When flush1 finishes, the driver has to process write1 before flush2 even
>   though there's no fundamental reason flush2 can't be processed first and,
>   when two flushes are issued back-to-back without intervening writes, the
>   second one essentially becomes noop.
> Without the commit, flush2 is inserted before write1, so the issue is hiden.
> But the commit itself makes sense, because flush request isn't a preempt
> request, there is no reason to add it to queue head.
> 
> The regression is exposed in a SATA device. In SATA, flush requests are
> non-queueable. When flush request is running, normal read/write requests
> can't run. If block layer dispatches such request, driver can't handle it
> and requeue it. Tejun suggested we can hold the queue when flush is running.
> This can avoid unnecessary requeue.
> 
> And also this can improve performance and solve the regression. In above
> scenario, when flush1 is running, queue is hold, so write1 isn't dispatched.
> flush2 will be the only request in the queue. After flush1 is finished, flush2
> will be dispatched soon. Since there is no write between flush1 and flush2,
> flush2 essentially becomes noop.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Acked-by: Tejun Heo <tj@kernel.org>

Jens, can you please queue this for the next merge window?

Thanks.

-- 
tejun
