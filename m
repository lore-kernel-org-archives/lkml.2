Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab0DPPcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 11:32:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53012 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab0DPPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 11:32:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LuKI07+EgQ6a1gt98lIpat4F5SbKfgG3diJkPWoGlMizIx4U9+p1bwJ4jHjn4rIluI
         PFjWB0B/HzukgaNZsx6Vb6KcJ/vgOo9GGqm2jnPiAqkAGW9VPXWJYaw4vHL+d6qB5Q4J
         a0BHGqQjayCnDDWkhPXiRT0zyGGqOyAFNFFS8=
Date: Fri, 16 Apr 2010 17:32:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100416153210.GG5162@nowhere>
References: <1271366710-17468-1-git-send-email-dzickus@redhat.com> <20100416014712.GC15570@nowhere> <20100416141213.GC15159@redhat.com> <20100416144302.GB5162@nowhere> <20100416150407.GH15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100416150407.GH15159@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 11:04:07AM -0400, Don Zickus wrote:
> > This is really just a corner case, I guess you don't need to
> > bother with that. It is actually racy against other cpus and adding
> > a spinlock here (in the everything is fine path) would be an overkill.
> > 
> > In fact, having two per cpu vars named hardlockup_warned and
> > softlockup_warned would be better than cpumasks. I'm sorry I
> > suggested you the cpumask, but such per cpu vars will avoid
> > you dealing with these synchonization issues. And one of the primary
> > rules is usually to never take a lock from NMIs if we can :)
> 
> Yeah, I guess per cpu is better.  I agree that locks in NMI are frowned
> upon but I wasn't sure of it was dealt with.


They work in fact. They are just not checked by lockdep.
And mostly they are very dangerous: if something else can
take it (from interrupt, from context) then this is a deadlock.
And even though we ensure this is only taken from NMI, we tend
to avoid that.


 
> I'll try to implement this.  Any objections if I combined hardlockup and
> softlockup with per cpu watchdog_warn and have bit masks for HARDLOCKUP
> and SOFTLOCKUP?  I hate to just waste per cpu space for this.



Hmm, a hardlockup can come in after a softlockup.
Don't worry too much about memory: usually the more you have cpu,
the more you have memory :)
Plus this is debugging code, not something supposed to be enabled
in production.

