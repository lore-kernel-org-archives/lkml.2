Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1BUVhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:37:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58595 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1BUVhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:37:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fjXWY0sqMgf7R67daHsZQBaNAPwRWlPfytZloB+3lsWir36lMA4BeLnaJum7yKQ3PW
         t38PyMxppA+zBN/dSnpPQCqEZ12JKCjbGcMGxB6IXe1cz9GDZxHhLh3s0NFWF9WfnGGs
         rJdfHInRckf9+2sIXtGV5NKnxzHq6iGSE0XzU=
Date: Mon, 21 Feb 2011 22:37:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
Message-ID: <20110221213740.GC3583@nowhere>
References: <1298322150-15505-1-git-send-email-daahern@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298322150-15505-1-git-send-email-daahern@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 02:02:26PM -0700, David Ahern wrote:
> v1 -> v2:
> - removed change to WARN_ON_ONCE in perf_event.c
> - fixed init of realtime_clock event (needed call to perf_swevent_init_hrtimer)
> - changed userspace event name to clock-realtime with the alias clkr as the 
>   raw events code sucks up all options that start with 'r' followed by a hex
>   character
> - remove RAW sample hack for pushing realtime clock event data to userspace
> - plumbed PERF_SAMPLE_READ to enable retrieving event data during sample
>   generation
> - add patch to perf-stat to recognize realtime-clock as a nsec counter
> - implementation of tiemhist in perf-record was revamped significantly
>   -- to use event data,
>   -- to better handle fallback to synthesized event,
>   -- added feature to force a sample to be generated at startup (to output
>      wall-clock times we need a sample immediately; after that realtime-clock
>      samples are generated periodically)
>   -- change counter creation to be done only on first cpu; we do not need a
>      counter for each cpu 
> 
> A request was made to modify perf-trace and perf-script. From what I can see
> perf-trace does not exist yet and perf-script requires raw data which means
> it does not work for the primary use case that motivated this feature
> (perf record -e cs -1 -ag).

The goal is actually to extend perf script to handle more than just raw data.
So that it can handle the rest of what we can find in an event: time, ip, stacktraces...

You've added 200 lines in perf report to add the dump support. It wouldn't
require more to extend perf script to do that. And the result is going to be
much more powerful.

Look at struct scripting_ops::process_event().

What you need is too pass in the whole event instead of only the raw data,
cpu and so on...

You don't even need to add the support in the scripts themselves, they can
just cope with the new parameter layout. You only need to handle the rest of
the event in the print_event() function (the default scripting_ops::process_event())
to print ip, time and stacktraces.

This probably needs some option in perf script to avoid showing ip and other
new things. Although we probably want to print stacktraces by default
if there are present.
