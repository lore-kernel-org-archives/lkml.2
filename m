Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1DZKsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:48:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37449 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1DZKss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=STEHpfSsVMK9OIA8ShErc/F86+wGc1NZDOAKhQn46sIRPhSfoUIF9VeMAVw/IhviE2
         N+HpoX1eReKoR9/ioV4BIgPb88o9zvB/Z/C7QzyzI+37wEvTBZnHrVDm8RGpHEjEdsEf
         S2tFgTDnGwlON6voCBtmPw6wR+DqSin97q7iY=
Date: Tue, 26 Apr 2011 12:48:43 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110426104843.GB878@htj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
 <20110422233204.GB1576@mtj.dyndns.org>
 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
 <20110425085827.GB17734@mtj.dyndns.org>
 <20110425091311.GC17734@mtj.dyndns.org>
 <1303778790.3981.283.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303778790.3981.283.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Apr 26, 2011 at 08:46:30AM +0800, Shaohua Li wrote:
> the blk-flush is part of block layer. If what you mean is the libata
> part, block layer doesn't know if flush is queueable without knowledge
> from driver.

It seems my communication skill towards you sucks badly.  I was
talking about making both the issue and completion paths cooperate on
flush sequence handling instead of depending on queuability of flush
to make assumptions on completion order, which I still think is
incorrect.

> > Also, another interesting thing to investigate is why the two flushes
> > didn't get merged in the first place.  The two flushes apparently
> > didn't have any ordering requirement between them.  Why didn't they
> > get merged in the first place?  If the first flush were slightly
> > delayed, the second would have been issued together from the beginning
> > and we wouldn't have to think about merging them afterwards.  Maybe
> > what we really need is better algorithm than C1/2/3 described in the
> > comment?
>
> the sysbench fileio does a 16 threads write-fsync, so it's quite normal
> a flush is running and another flush is added into pending list.

I think you're optimizing in the wrong place.  These back-to-back
flushes better be merged on the issue side instead of completion.  The
current merging rules (basically how long to delay pending flushes)
are minimal and mechanical (timeout is the only huristic parameter).

For the initial implementation, my goal was matching the numbers of
Darrick's original implementation at higher level and keeping things
simple, but the code is intentionally structured to allow easy tuning
of merging criteria, so I suggest looking there instead of mucking
with completion path.

Thank you.

-- 
tejun
