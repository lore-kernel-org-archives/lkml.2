Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1EDOZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:25:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1EDOZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:25:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WF7zyYc4YQqYZ/bnjqdXn5Zu0kAk3M9t1HWRAX1rmgxRtB71PvdR5BEhUdTWo2ATo8
         HnD9aTAPyMqWMEUKozdKXpKkmvA6ytXGouiXd8gX5rwpI8pl8mAGHgRZYoeBcWRWBeBb
         aE7sjRiaptNt+VORi13MnXpq4wcAXqAc+We3Q=
Date: Wed, 4 May 2011 16:25:32 +0200
From: Tejun Heo <tj@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504142532.GC17294@htj.dyndns.org>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
 <20110504083559.GB25724@elte.hu>
 <alpine.LFD.2.02.1105041124080.3005@ionos>
 <20110504101932.GA3392@elte.hu>
 <alpine.LFD.2.02.1105041233280.3005@ionos>
 <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com>
 <20110504112746.GE8007@htj.dyndns.org>
 <alpine.LFD.2.02.1105041417330.3005@ionos>
 <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105041539050.3005@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 04, 2011 at 04:10:29PM +0200, Thomas Gleixner wrote:
> > cases where the generic implementation is used.  Has anyone measured
> > the difference against before the whole this_cpu conversion?
> 
> Yes, that really wants to be done. The whole CMPXCHG_LOCAL ifdeffery
> should have been avoided in the first place. this_cpu_cmpxchg can
> really be implemented with preempt_enable/disable and the irqsafe
> variant in any case.

Yeah, slub code looks pretty scary with the #ifdefs.  IIUC, the
problem was that cmpxchg_double is an optimization for fast path which
was already very light weight and an extra locked op or irq on/off
would have made considerable difference.

The cmpxchg_double optimization made the fast path go quite faster
when CPU supports it but it may as well slow things down considerably
if CPU doesn't, due to extra irq on/off's.  Anyways, here's hoping
that the slow down is acceptable compared to the base code without
cmpxchg_double and the ugliness can be removed.

Thanks.

-- 
tejun
