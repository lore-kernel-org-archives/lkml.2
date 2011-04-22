Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab1DVW5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:57:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47189 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1DVW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jU8yJdOuMkeh6QXg0RIi4VzjL77zU36cx7KSV2qJ0k+GsYPcTmuwnB0oo3YI5i8SzS
         VxKBt9FS3sUuVC2FiQUdM2JNJDXl2Zl/FJ8vINNzwnCkNViFs2KPfkKs90pq4WFW310x
         xM1Pn6WKT+qXdiFOSQ+VfriL165fnq/ZiujQA=
Date: Sat, 23 Apr 2011 00:57:04 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [RFC]block: add flush request at head
Message-ID: <20110422225704.GA1576@mtj.dyndns.org>
References: <1303112174.3981.187.camel@sli10-conroe>
 <4DABF194.4010603@fusionio.com>
 <1303115157.3981.198.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303115157.3981.198.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 18, 2011 at 04:25:57PM +0800, Shaohua Li wrote:
> then why requeue adds request at head? we could have the similar issue.

SCSI doesn't seem to do it anymore but it used to cache scmd at
rq->special over requeues so that it doesn't have to re-initialize
requests across requeues, which means that unprepped request getting
ahead of requeued ones may lead to deadlock due to resource
starvation, so that's why requeue uses front queueing.

The code changed over time and the above requirement might not be
necessary at this point.  I don't know.  However, block layer doesn't
have any method to enforce that requests can't hold any extra resource
on requeue and having such difficult to trigger deadlock condition
dormant is scary.

What kind of benchmarking are we talking about on which kernel?
blk-flush support has been revamped twice recently.  2.6.38 stripped
out the block layer barrier thing and then it got re-reimplemented for
2.6.39 to support advanced flush merging.  If the regression (for
which benchmark btw?) was visible on the older reimplementation, I'd
really like to know how it behaves on 2.6.39-rcX.

If the problem is localized to 2.6.38, oh well, too bad, but I don't
think we care too much.  If some distro is basing their kernel on
2.6.38 and the flush regression is hurting them, backporting the new
implementation from 2.6.39 shouldn't be too difficult after all.  The
reimplementation was almost self-contained.

If the regression affects 2.6.39 implementation too, eh well, we need
to think of something, but I'd really like to know what kind of
workload we're talking about.

> I'll look at this. Optimizing this one should fix the regression too. On
> the other hand, adding flush request at head if it just follows a flush
> still has its advantage, because drive cache is already flushed out.

New implementation wouldn't issue two flushes back to back like that,
it doesn't make any sense to begin with.  Again, what have you been
testing and how?

Thanks.

-- 
tejun
