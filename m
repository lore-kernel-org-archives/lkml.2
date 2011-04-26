Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1DZKkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:40:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60873 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab1DZKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:40:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=quihkq4M8+0sMtID0AUatfWsw5781JPRyekWkPFmLj6yUrcgeI2zqZLozjjWEBtp4h
         3a6zr/vfp2LiiVxer6pm8AuWhRQeYngnKoiOu0YgK4VAlqadSv8BX278axnUuXotYXUS
         LuHuLrOX9gnRRyy3L+YfGuiKoL8XCFEpsOnZk=
Date: Tue, 26 Apr 2011 12:40:14 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110426104014.GA878@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
 <20110422233204.GB1576@mtj.dyndns.org>
 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
 <20110425085827.GB17734@mtj.dyndns.org>
 <1303778559.3981.279.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303778559.3981.279.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Apr 26, 2011 at 08:42:39AM +0800, Shaohua Li wrote:
> > What I was saying is that request completion is decoupled from driver
> > fetching requests from block layer and that the order of completion
> > doesn't necessarily follow the order of execution.  IOW, nothing
> > guarantees that FLUSH completion code would run before the low level
> > driver fetches the next command and _completes_ it, in which case your
> > code would happily mark flush complete after write without actually
> > doing it.
>
> What I described is in the background of non-queueable flush request.
> For queueable flush, this definitely isn't correct.

We're definitely having communication issues.  The above doesn't have
anything to do with queueability of flushes.  It's about the
asynchronous nature of block request completion and issue paths, so it
can happen whether flush is queueable or not, or am I still
misunderstanding you?

> > Eh, wasn't your optimization only applicable if flush is not
> > queueable?  IIUC, what your optimization achieves is merging
> > back-to-back flushes and you're achieving that in a _very_ non-obvious
> > round-about way.  Do it in straight-forward way even if that costs
> > more lines of code.
>
> This isn't a problem of more code or less code. I thought my patch is
> already quite simple.

Well, then, we'll have to agree to disagree there as it looks really
hackish to me and I don't think it's even correct as written above.

> The method your described only works for non-queueable flush too. And it
> has limitation that the requests between two back-to-back flushes must
> not be write. my patch works for non-queueable flush but has no such
> limitation.

No, I'm saying you can achieve about the same effect in cleaner and
safer way if you teach the issue and completion paths properly about
these back-to-back flushes at the cost of more code changes.  Your
patch doesn't work reliably whether flush is queueable or not.

> > Darrick, do you see flush performance regression between rc1 and rc2?
> > You're testing on higher end, so maybe it's still okay for you?
>
> please ignore the regression. the patch isn't related to the regression,
> but that problem motivates me to do the patch.
> Actually I still need the RFC patch in another thread to recover the
> regression. I hope you and Jens can seriously look at that issue too.

Ah, okay, it's a separately issue.  Sorry about confusing the two.
I'll continue on another reply.

Thanks.

-- 
tejun
