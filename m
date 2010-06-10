Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab0FJQ3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:29:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39634 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0FJQ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rt70L+z7ykHaKUxs5TXpuS4bLgm78Fh3G/zbiZMSb0TQVFTkqroaRoNxIdpTkog7KP
         OgMQU3tIT1C44oWGBD//pB9j6CIsLKu67oP0dbvnbTZTYvAHxyFQ6BjyvaeYEaQpYzjG
         7qW9tRDDCD7BqcK1d9K0U4u6fHP/EETCr2vvw=
Date: Thu, 10 Jun 2010 18:29:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
	events
Message-ID: <20100610162858.GD5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com> <1276141760-11590-2-git-send-regression-fweisbec@gmail.com> <1276166813.2077.96.camel@twins> <1276168242.2077.134.camel@twins> <20100610161234.GA5255@nowhere> <1276186576.2077.554.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276186576.2077.554.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 06:16:16PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-10 at 18:12 +0200, Frederic Weisbecker wrote:
> > On Thu, Jun 10, 2010 at 01:10:42PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2010-06-10 at 12:46 +0200, Peter Zijlstra wrote:
> > > > 
> > > > Something like the below would work, the only 'problem' is that it grows
> > > > hw_perf_event.
> > > 
> > > If we do the whole PAUSEd thing right, we'd not need this I think.
> > 
> > 
> > It's not needed, and moreover software_pmu:stop/start() can be the same
> > than software:pmu:disable/enable() without the need to add another check
> > in the fast path.
> > 
> > But we need perf_event_stop/start() to work on software events. And in fact
> > now that we use the hlist_del_init, it's safe, but a bit wasteful in
> > the period reset path. That's another problem that is not critical, but
> > if you want to solve this by ripping the differences between software and
> > hardware (which I agree with), we need a ->reset_period callback.
>
>
> Why? ->start() should reprogram the hardware, so a
> ->stop()/poke-at-state/->start() cycle is much more flexible.


Imagine you have several software and hardware events running on the
same cpu. Each time you reset this period for a software event, you do
a hw_pmu_disable() / hw_pmu_enable(), which writes/read the hardware
register for each hardware events, amongst other wasteful things.

