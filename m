Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1DYJNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 05:13:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45974 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab1DYJNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 05:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WtT4eUz0fiCAR4ezRhWYsBWVa07hoBo3+alnosUi3pjQyj8dSwAFlZeG6Tv5XsSVij
         3tKgRLgZxGDQ39ncT20ViwbQQLz8eJgNh4buVIgvz4pPOkSP2m2k5qYSYwWev2mmppwz
         gDudAHt7LcyjpcDPQzIUalDPz3y2hB2YTzKO8=
Date: Mon, 25 Apr 2011 11:13:11 +0200
From: Tejun Heo <htejun@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2]block: optimize non-queueable flush request drive
Message-ID: <20110425091311.GC17734@mtj.dyndns.org>
References: <1303202686.3981.216.camel@sli10-conroe>
 <20110422233204.GB1576@mtj.dyndns.org>
 <20110425013328.GA17315@sli10-conroe.sh.intel.com>
 <20110425085827.GB17734@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425085827.GB17734@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Apr 25, 2011 at 10:58:27AM +0200, Tejun Heo wrote:
> Eh, wasn't your optimization only applicable if flush is not
> queueable?  IIUC, what your optimization achieves is merging
> back-to-back flushes and you're achieving that in a _very_ non-obvious
> round-about way.  Do it in straight-forward way even if that costs
> more lines of code.

To add a bit more, here, flush exclusivity gives you an extra ordering
contraint that while flush is in progress no other request can proceed
and thus if there's another flush queued, it can be completed
together, right?  If so, teach block layer the whole thing - let block
layer hold further requests while flush is in progress and complete
back-to-back flushes together on completion and then resume normal
queue processing.

Also, another interesting thing to investigate is why the two flushes
didn't get merged in the first place.  The two flushes apparently
didn't have any ordering requirement between them.  Why didn't they
get merged in the first place?  If the first flush were slightly
delayed, the second would have been issued together from the beginning
and we wouldn't have to think about merging them afterwards.  Maybe
what we really need is better algorithm than C1/2/3 described in the
comment?

What did sysbench do in the workload which showed the regression?  A
lot of parallel fsyncs combined with writes?

Thanks.

-- 
tejun
