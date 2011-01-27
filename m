Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1A0QB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:01:27 -0500
Received: from smtp-out.google.com ([74.125.121.67]:7279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab1A0QBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:01:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=eOQxkku5yNJWUmu25/pqQBFPld9C6feyfSihSXbMytWPIj/7QkOTqezhcR1+BMZJvY
         KsULLercYIj7DNomlXFw==
Date: Thu, 27 Jan 2011 07:57:54 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, olofj@chromium.org
Subject: Re: [PATCH] printk: allow setting DEFAULT_MESSAGE_LEVEL via Kconfig
Message-ID: <20110127155754.GB8520@google.com>
References: <20110125235700.GR8008@google.com>
 <20110126144910.ce0646ec.akpm@linux-foundation.org>
 <20110126145703.a0f5add5.rdunlap@xenotime.net>
 <20110126151017.ed9e627c.akpm@linux-foundation.org>
 <20110127082718.GA4748@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127082718.GA4748@p183.telecom.by>
X-Operating-System: Linux/2.6.32-gg298-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Wed, Jan 26, 2011 at 03:10:17PM -0800, Andrew Morton wrote:
> > On Wed, 26 Jan 2011 14:57:03 -0800
> > Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > > I'm a bit surprised that this wasn't already tunable at boot-time
> > > > and/or at runtime.
> > > 
> > > 
> > > As WANG Cong replied:
> > > 
> > > Why? We already have "loglevel=" kernel parameter.
> > 
> > That's different.
> > 
> > Mandeep's patch addresses printks which didn't have a facility level. 
> 
> For those, we have ignore_loglevel kernel parameter.

That's a little different. ignore_loglevel will print ALL kernel messages
to the console. What we would like to do is look at all messages that
are KERN_WARNING (and higher in priority) very closely. Bugs lie there;)
Problem is that DEFAULT_MESSAGE_LEVEL is KERN_WARNING so there is too
much noise at KERN_WARNING. So we'd like to be able to set
DEFAULT_MESSAGE_LEVEL (default_message_loglevel) to something lower in,
priority, at boot or earlier. You can set it via /proc/sys/kernel/printk
(takes an int_vec) but that's too late. A ton of stuff has already been
logged by the time we're able to change a sysctl.

Our plan is to whitelist any KERN_WARNING messages we know are OK and
flag any new KERN_WARNING messages. We're hoping this will help us cut
down on regressions. We've been burned in the past where we caused a
regression which tooks weeks to locate and triage only to later learn
that there was a new KERN_WARNING that if we hadn't ignored would have
caught the bug much much earlier.
