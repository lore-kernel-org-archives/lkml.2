Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013Ab1DNTVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1DNTVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:21:49 -0400
Date: Thu, 14 Apr 2011 21:20:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 5/5] signals: Don't hold shared siglock across
	signal delivery
Message-ID: <20110414192059.GB23517@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-6-git-send-email-matt@console-pimps.org> <20110413201219.GB15330@redhat.com> <20110414115750.1a6703b6@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414115750.1a6703b6@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14, Matt Fleming wrote:
>
> On Wed, 13 Apr 2011 22:12:19 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > This adds new races. And this time I do not even understand the intent.
> > I mean, it is not clear to me why this change can really help to speed
> > up get_signal_to_deliver().
>
> Again, it's not necessarily speeding up get_signal_to_deliver(), but
> rather it's reducing the contention on the shared siglock.

Yes, sorry for confusion. I used the "speed up" term wrongly throughout.
I understand what are you trying to do.

But yes, in this case I probably missed the intent,

> For example, without this patch, if you've got someone sending a signal
> to a task group, you can't run get_signal_to_deliver() in parallel

I missed the simple fact, get_signal_to_deliver() could avoid ->siglock
completely if it dequeues the private signal.

Btw, I forgot to mention another problem. We should not dequeue from
signal->shared_pending before task->pending. There are various reasons
why we shouldn't, but in particular please look at a27341cd
"Prioritize synchronous signals over 'normal' signals".

Oleg.

