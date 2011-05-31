Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab1EaHSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:18:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:37300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab1EaHSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:18:00 -0400
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
In-Reply-To: <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
	 <1306578144.1200.1150.camel@twins>
	 <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
	 <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 09:17:47 +0200
Message-ID: <1306826267.2530.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 21:33 -0400, Vince Weaver wrote:
> On Sun, 29 May 2011, Vince Weaver wrote:
> 
> > On Sat, 28 May 2011, Peter Zijlstra wrote:
> > 
> > > On Fri, 2011-05-27 at 23:38 -0400, Vince Weaver wrote:
> > > > on that note (and while trying to document exactly what the ioctls do) it 
> > > > seems that a PERF_EVENT_IOC_REFRESH with an argument of anything higher 
> > > > than one does not work on kernels 2.6.36 and newer.  The behavior acts
> > > > as if 1 was passed, even if you pass in, say, 3.
> > > 
> > > Urgh, no that should definitely work. Thanks for the test-case, I'll
> > > work on that (probably not until Monday though, but who knows).
> > > 
> > 
> > after a painfully long bisection, it turns out that this problem was in
> > theory introduced by the following commit:
> > 
> >   d57e34fdd60be7ffd0b1d86bfa1a553df86b7172
> > 
> >   perf: Simplify the ring-buffer logic: make perf_buffer_alloc() do everything needed
> > 
> > I'll see if I can come up with a patch, but it's a bit non-obvious why
> > this commit is affecting the REFRESH value at all.
> 
> the problem was the mentioned commit tried to optimize the use of 
> watermark and wakeup_watermark without taking into account that 
> wakeup_watermark is a union with wakeup_events.
> 
> The patch below *should* fix it,

Awesome thanks!

>  but something unrelated has broken 
> overflow support between 2.6.39 and 3.0-rc1 which I haven't had time to 
> investigate.  The overflow count is suddenly about 10x what it should be 
> though.  So the below is semi-untested and I possibly need to do another 
> bisect.  *sigh*

Yeah, I noticed, I was hunting that as well..
