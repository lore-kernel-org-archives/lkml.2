Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1BWJj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:39:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60749 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1BWJjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:39:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E26jRtBKhbPDWOKb53d09YoSVtxpJvercoW7B3iTt+j/ecRK9A2N/8JLICgQL+0YnD
         B1SdrGsU4wyhPXAfirn5lw6WSCF1g0ZnVpaVTVp6r6rZH1rjwBYIb/px6YxbsIO29fx9
         MIGm0Xpgypdc/rTgwZnHIHCjEEAbR8T+Rr6+g=
Date: Wed, 23 Feb 2011 10:38:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "pantherchen@versanet.de" <pantherchen@versanet.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110223093854.GB26065@htj.dyndns.org>
References: <20110222085223.GC11681@core.coreip.homeip.net>
 <20110222090255.GR31267@htj.dyndns.org>
 <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
 <4D63D062.3040404@versanet.de>
 <20110222172254.GA13114@core.coreip.homeip.net>
 <20110222175955.GA27991@core.coreip.homeip.net>
 <4D640F67.3040109@versanet.de>
 <20110222195257.GA13256@core.coreip.homeip.net>
 <4D641936.90404@versanet.de>
 <20110223052042.GA19269@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223052042.GA19269@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 22, 2011 at 09:20:42PM -0800, Dmitry Torokhov wrote:
> On Tue, Feb 22, 2011 at 09:14:46PM +0100, pantherchen@versanet.de wrote:
> > On 02/22/2011 08:52 PM, Dmitry Torokhov wrote:
> > >Ewww... tty/ldisc...
> > >
> > >Does it help if you change drivers/input/serio/serio.c::serio_queue_event()
> > >from calling
> > >
> > >	schedule_work(&serio_event_work);
> > >
> > >to call
> > >
> > >	queue_work(system_long_wq,&serio_event_work);
> > >
> > >?
> > 
> > Yes, that works: http://img.xrmb2.net/images/499337.png
> > 
> 
> Great!
> 
> OK, so below is properly formatted patch. I am going to send it upstream
> unless somebody objects.

Ah, okay, thanks a lot for tracking this down, Dmitry.  Didn't expect
flush_scheduled_work() to bite back this way.  :-)

> Input: serio/gameport - use 'long' system workqueue
> 
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Commit 8ee294cd9def0004887da7f44b80563493b0a097 converted serio
> subsystem event handling from using a dedicated thread to using
> common workqueue. Unfortunately, this regressed our boot times,
> due to the fact that serio jobs take long time to execute. While
> the new concurrency managed workqueue code manages long-playing
> works just fine and schedules additional workers as needed, such
> works wreck havoc among remaining users of flush_scheduled_work().
> 
> To solve this problem let's move serio/gameport works from system_wq
> to system_long_wq which nobody tries to flush.
> 
> Reported-and-tested-by: Hernando Torque <pantherchen@versanet.de>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Acked-by: Tejun Heo <tj@kernel.org>

Most flush_scheduled_work() users are already gone and once all of
them are gone, system_long_wq can be removed without causing any
difference.

Thank you.

-- 
tejun
