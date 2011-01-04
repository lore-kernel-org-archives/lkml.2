Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1ADIgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:36:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35287 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1ADIgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kIrhE3ejQDNdNbLi+2gXqw0PEA30U4ginmGpRrXgbR70LvELFVHZHNziVrREI39Twq
         9CrOwtD/T6fZvkAgc+ScuFpPRCdNStaPQXbv78jQxo3XdN1M8wHgiE9seB8K1I35i2Ah
         MDUrGa+xED48WWHjiPBCsupmeOA9fOv5QTnO4=
Date: Tue, 4 Jan 2011 09:36:37 +0100
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 11/32] v4l/cx18: update workqueue usage
Message-ID: <20110104083637.GB8066@mtj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-12-git-send-email-tj@kernel.org>
 <1294102496.10094.152.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294102496.10094.152.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 03, 2011 at 07:54:56PM -0500, Andy Walls wrote:
> 2. To prevent work items being handled by keventd/n from being delayed
> too long, as the deferred work in question can involve a bit of sleeping
> due to contention, the workload of the CX23418's MPEG encoding engine,
> and the number of CX23418 devices in the system.
> 
> Will all the sleeping that can happen, is the move to a system wq, under
> cmwq, going to have adverse affects on processing other work items in
> the system?
> 
> I get the feeling it won't be a problem with cmwq, but I haven't paid
> enough attention to be sure. 

It won't be a problem.  Now the system_wq supports parallel execution
of multiple works and manages concurrency automatically.  Work items
can sleep as necessary without worrying about other work items.

...
> It is not unusual for scheduled TV recording software to start nearly
> simultaneous DTV TS, MPEG, and VBI or MPEG Index streams on multiple
> cards.  So 3 CX23418 cards with 3 streams each.   Let's nominally
> estimate the timing of the CX18_CPU_DE_SET_MDL commands per stream at
> the PAL frame rate of 25 Hz; or 1 CX18_CPU_DE_SET_MDL mailbox command
> per stream per 40 milliseconds.

IIUC, if they spend any significant amount of time executing, they'll
be doing so by waiting for events (mutex, IRQ...), right?  If so,
there's nothing to worry about.  If it's gonna burn a lot of CPU
cycles, we'll need to use a workqueue marked CPU_INTENSIVE but I don't
think that's the case here.

Thank you.

-- 
tejun
