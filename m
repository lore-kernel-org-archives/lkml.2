Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1BVJDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 04:03:16 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32959 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1BVJDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 04:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ujQEHGSEzUXEtV+cBjd7/2ICbAedR+jhZUmkybLRr2/ynwfqO4WY5LYCOpLV6UFqII
         5sPM21YVyWYf76NiiAV8zpygNzO3rSVqL67xhCskL84LBtbjDzMXikdoG17Owo09HP/P
         KPsOrSpdmmRrQrZRdJ+71Bu3PVPMHtqFwlHMs=
Date: Tue, 22 Feb 2011 10:02:55 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "pantherchen@versanet.de" <pantherchen@versanet.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110222090255.GR31267@htj.dyndns.org>
References: <4D62CE9C.7090806@versanet.de>
 <20110222081752.GP31267@htj.dyndns.org>
 <20110222085223.GC11681@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222085223.GC11681@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:52:23AM -0800, Dmitry Torokhov wrote:
> > 1. kworker/0:1's uninterruptible sleeps start later than kserio's.
> > 
> >    It could be that cpu 0 was busy running other stuff and thus cmwq
> >    delayed executing serio_event_work; however, if we look at the CPU
> >    usage, that doesn't seem likely.  The CPU is not busy at all and if
> >    the CPU isn't busy, cmwq wouldn't introduce any noticeable delay in
> >    work item execution.
> > 
> >    Another possibility is the rescuer concurrency depletion bug is
> >    delaying execution of queued work items early during boot.  This
> >    was fixed recently.  Can you please give a shot at 2.6.38-rc6 and
> >    see whether anything is different?
> > 
> > 2. Most of the delay is caused by xorg starting up much later.  xorg
> >    seems to start up in parallel with the kseriod sleeps in 2.6.37 but
> >    on 2.6.38 it seems to wait for the serio_event_work to finish.
> > 
> >    I have no idea what xorg is waiting for.  Dmitry, any clue?
> > 
> 
> It looks like it is not X is waiting but plymouth not being told to
> quit... I will have to look at waht triggers plymouth->X/GDM transition.
> 
> Also, serio jobs (mouse probe) is quite lengthtly. Should it be using
> unbound workqueue instead?

How long it works doesn't matter at all.  If you look at the boot
chart, as soon as those uninterruptible sleeps start, kworker/0:2 is
created to serve other work items, so it doesn't really affect anyone
else.  Unbound ones are mostly helpful for cases where the work items
involved may consume large amount of cpu cycles (not true here) over
long period of time.  That said, something definitely seems wrong
here.  Eh well, let's find out. :-)

Thanks.

-- 
tejun
