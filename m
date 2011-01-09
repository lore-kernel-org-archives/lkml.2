Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1AIOmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 09:42:00 -0500
Received: from mail-vw0-f66.google.com ([209.85.212.66]:38756 "EHLO
	mail-vw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1AIOl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 09:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=npiZr10pZXjotYUeIeBYJJz/W0xFFyJ4KCS59K8c/sBUdYG/Gp6ORSqXcWZb1KHtfO
         cz8s3jv2O5JOdtHx+lD2xyLeWcSXt+LDhk2f+mUEUMI5cxBy+009npgPSdDxPEa85cv3
         y6S0ezNYXlZNooli5X0JX7B8HerWCMu69a8Oo=
Date: Sun, 9 Jan 2011 09:41:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Screwing with the concurrency limit
Message-ID: <20110109144154.GA22453@mtj.dyndns.org>
References: <4D287AED.9090304@gmail.com>
 <20110108161840.GC13269@mtj.dyndns.org>
 <20110108163733.GD13269@mtj.dyndns.org>
 <iga94g$hkf$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iga94g$hkf$1@dough.gmane.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 08, 2011 at 10:06:04AM -0800, Kent Overstreet wrote:
> Well, that doesn't quite do it, I'd need workqueue_inc_max_active()
> and workqueue_dec_max_active()... set_max_active() would be racy.

You'll of course need to grab an outer mutex around max_active
updates.

> But also there's no point in adjusting max_active on every cpu's
> workqueue, adjusting just the one on the local cpu would do exactly
> what I want and be more efficient too... Can you see any issues in
> doing it that way?

Can you please explain the use case a bit more?  Is something per-cpu?
ie. Are your write locks per-cpu?  How frequent do you expect the
write locking to be?  I think adjusting max_active per-cpu should be
doable but I'd rather stay away from that.

> What I was really hoping for was something like... maybe
> move_work_to_workqueue() - if you could do that on the work item
> you're executing, move it from the workqueue that has max_active = 1
> to a different one - it's stateless from the caller's perspective.

I don't think that's gonna be a good idea.  It's too specialized
soultion which is likely to bite our asses down the road.

> But I suspect that'd be more complicated than your way of doing it,
> and inc()/dec() is probably just as good...

So, I think it would be better to make max_active manipulation work
somehow but again I want to stay way from being too specialized.

Thank you.

-- 
tejun
