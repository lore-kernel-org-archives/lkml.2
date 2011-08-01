Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab1HALVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 07:21:18 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:40600 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1HALVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 07:21:15 -0400
Date: Mon, 1 Aug 2011 15:21:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: v3.0: Weird kernel log message when resuming avout NMI received
Message-ID: <20110801112102.GQ2209@sun>
References: <CAC9WiBgbhLomH_CtLGKyxm2xD9=h1nJAy=-b24GOaUV+hg7bNg@mail.gmail.com>
 <20110731110641.GG2209@sun>
 <CAC9WiBgg+To8ggUvTqxOCy2hgb=XQCRH6D_0HFy4sEEoF8R0rw@mail.gmail.com>
 <20110731153225.GJ2209@sun>
 <1312196702.2617.445.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312196702.2617.445.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 01:05:02PM +0200, Peter Zijlstra wrote:
> On Sun, 2011-07-31 at 19:32 +0400, Cyrill Gorcunov wrote:
> 
> > > >> I'm seeing those kernel message when resuming:
> > > >>
> > > >> [  524.973283] Uhhuh. NMI received for unknown reason 3d on CPU 0.
> > > >> [  524.973288] Do you have a strange power saving mode enabled?
> > > >> [  524.973289] Dazed and confused, but trying to continue
> > > >>
> > > >> I don't know if it's important or not because the system seems to work
> > > >> after but maybe it worths to report
> 
> So I guess the problem is the NMI watchdog and suspend stuff not
> shutting things down properly.. 
> 
> Argh, the PM notifier muck runs before the hotplug notifiers and it
> doesn't avoid hotplug races on its own.. what crap.
> 
> something like the below perhaps, compile tested only.. does it work?
> 

Thanks a huge, Peter! (I'm CC'ing Jiri as well, he has same issue)

...
> @@ -6809,7 +6810,7 @@ static void __cpuinit perf_event_init_cp
>  	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
>  
>  	mutex_lock(&swhash->hlist_mutex);
> -	if (swhash->hlist_refcount > 0) {
> +	if (swhash->hlist_refcount > 0 && !swhash->swevent_hlist) {

Should not there be rcu_dereference(swhash->swevent_hlist)?

>  		struct swevent_hlist *hlist;
>  
>  		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
...

	Cyrill
