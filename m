Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab0HEPFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:05:16 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51738 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab0HEPFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:05:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q8FO63FaW151aZPgwseDSfq6Am3i+UocP9d7UrIlncGbVVraLvbZMoxCrz2IUzVu2D
         zhaZiCHSTKlT4EilITkFvDuHTRJnJWmdMOAQDidjzXu3gQdrlEqVrhoOefThc1QR43zW
         c3SXsDKkwhIe9yhxO9aFvlLGbIP/JVqvkEVp4=
Date: Thu, 5 Aug 2010 22:59:40 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: lockdep and oops_in_progress
Message-ID: <20100805145940.GA8685@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <AANLkTi=gnsPUPomCUXRLgV0PhNxtBaXiCheDU=yRV0Kx@mail.gmail.com>
 <1280995849.1923.1515.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1280995849.1923.1515.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 10:10:49AM +0200, Peter Zijlstra wrote:
> On Thu, 2010-08-05 at 16:21 +1000, Dave Airlie wrote:
> > Hi guys,
> > 
> > I was debugging a wierd issue with suspend/resume and fbcon/X with
> > some recent work Jesse and myself did to try and make sure a pinned
> > fbcon always gets the text on it with a panic or oops occurs.
> > 
> > It does this by testing the oops_in_progress flag, however once any
> > lockdep issue occurs it looks to me that we leave this flag set
> > forever, in most places I can see in oops code etc they call
> > bust_spinlocks(1) then bust_spinlocks(0) to balance the
> > oops_in_progress value, but lockdep never seems to reset it.
> > 
> > I'm wondering if there is an inherent reason for this or if I whip up
> > a patch to reset once the lockdep is printed if this would cause any
> > issues?
> 
> That's debug_locks_off(), right? I don't think there's a particular
> reason we keep it set, cleaning that up might take a bit of work but
> shouldn't be too hard.

commit e0fdace10e75dac67d906213b780ff1b1a4cc360
Author: David Miller <davem@davemloft.net>
Date:   Fri Aug 1 01:11:22 2008 -0700

    debug_locks: set oops_in_progress if we will log messages.
    
    Otherwise lock debugging messages on runqueue locks can deadlock the
    system due to the wakeups performed by printk().
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Seems we can revert that commit now because of 'robustify printk'.

Dave, what do you think about it?

Thanks,
Yong

> 
> Ingo, do you remember anything about that?, I think that bit comes from
> before my time.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
