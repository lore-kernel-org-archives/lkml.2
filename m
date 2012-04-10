Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab2DJPNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 11:13:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab2DJPN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 11:13:29 -0400
Date: Tue, 10 Apr 2012 17:13:26 +0200
From: Jan Kara <jack@suse.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
Message-ID: <20120410151326.GA4936@quack.suse.cz>
References: <4F75E46E.2000503@msgid.tls.msk.ru>
 <20120405232913.GA6640@quack.suse.cz>
 <4F7E74F4.90604@msgid.tls.msk.ru>
 <20120410022628.GN18323@dastard>
 <4F83CC86.2010805@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F83CC86.2010805@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-04-12 10:00:38, Michael Tokarev wrote:
> On 10.04.2012 06:26, Dave Chinner wrote:
> 
> > Barriers. Turn them off, and see if that fixes your problem.
> 
> Thank you Dave for a hint.  And nope, that's not it, not at all... ;)
> While turning off barriers helps a tiny bit, to gain a few %% from
> the huge slowdown, it does not cure the issue.
> 
> Meanwhile, I observed the following:
> 
> 1) the issue persists on more recent kernels too, I tried 3.3
>    and it is also as slow as 3.0.
> 
> 2) at least 2.6.38 kernel works fine, as fast as 2.6.32, I'll
>    try 2.6.39 next.
> 
>    I updated $subject accordingly.
> 
> 3) the most important thing I think: this is general I/O speed
>    issue.  Here's why:
> 
>   2.6.38:
>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>   100+0 records in
>   100+0 records out
>   104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s
> 
>   3.0:
>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>   100+0 records in
>   100+0 records out
>   104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s
> 
> That's about 20 times difference on direct read from the
> same - idle - device!!
  Huh, that's a huge difference for such a trivial load. So we can rule out
filesystems, writeback, mm. I also wouldn't think it's IO scheduler but
you can always check by comparing dd numbers after
  echo none >/sys/block/sdb/queue/scheduler
Anyway, the most likely cause seems to be some driver issue (which would
also explain why you can see it only on one machine). I'd also compare very
closely config files of the two kernels if there isn't some unexpected
difference...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
