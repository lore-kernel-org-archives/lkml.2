Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1FGP60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:58:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58141 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab1FGP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t9/wrb7OY8kb6w/F3DfkUa8MtntsPTwjHF3OUoL8jhi5wxFwGBKJwQPVTwOSNIjScN
         8mEfvy0eYFhxNmrqgWBkgfxcZsihqaNt7Y9bLs+g5iiw3sy4G5prThZ3QBNqF8bfGvIu
         wl7YReblu7gaIQ8rw5+ZTZx4JMH0/aAPh9aYo=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4DEE3944.5020005@mit.edu>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
	 <1307383898.3098.90.camel@edumazet-laptop> <4DED976C.90009@linux.intel.com>
	 <4DEE3944.5020005@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 17:58:20 +0200
Message-ID: <1307462300.3091.39.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 juin 2011 à 10:44 -0400, Andy Lutomirski a écrit :
> On 06/06/2011 11:13 PM, Darren Hart wrote:
> >
> >
> > On 06/06/2011 11:11 AM, Eric Dumazet wrote:
> >> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
> >>>
> >>
> >>> If I understand the problem correctly, RO private mapping really doesn't
> >>> make any sense and we should probably explicitly not support it, while
> >>> special casing the RO shared mapping in support of David's scenario.
> >>>
> >>
> >> We supported them in 2.6.18 kernels, apparently. This might sounds
> >> stupid but who knows ?
> >
> >
> > I guess this is actually the key point we need to agree on to provide a
> > solution. This particular case "worked" in 2.6.18 kernels, but that
> > doesn't necessarily mean it was supported, or even intentional.
> >
> > It sounds to me that we agree that we should support RO shared mappings.
> > The question remains about whether we should introduce deliberate
> > support of RO private mappings, and if so, if the forced COW approach is
> > appropriate or not.
> >
> 
> I disagree.
> 
> FUTEX_WAIT has side-effects.  Specifically, it eats one wakeup sent by 
> FUTEX_WAKE.  So if something uses futexes on a file mapping, then a 
> process with only read access could (if the semantics were changed) DoS 
> the other processes by spawning a bunch of threads and FUTEX_WAITing 
> from each of them.
> 
> If there were a FUTEX_WAIT_NOCONSUME that did not consume a wakeup and 
> worked on RO mappings, I would drop my objection.

If a group of cooperating processes uses a memory segment to exchange
critical information, do you really think this memory segment will be
readable by other unrelated processes on the machine ?

How is this related to futex code ? 

Same problem for legacy IPC (shm, msg, sem) : Appropriate protections
are needed, obviously.

BTW, kernel/futex.c uses a global hash table (futex_queues[256]) and a
very predictable hash_futex(), so its easy to slow down futex users...



