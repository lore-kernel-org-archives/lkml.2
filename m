Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2LGJAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 04:00:06 -0500
Received: from hosting.adsl24.co.uk ([84.234.17.171]:52985 "EHLO
	hosting.adsl24.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab2LGJAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 04:00:05 -0500
Date: Fri, 7 Dec 2012 08:59:52 +0000
From: Alun <alun.linux@ty-penguin.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121207085952.57ee1f22@pcebbj.staff.aber.ac.uk>
In-Reply-To: <20121207004255.GC27172@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
	<20121207004255.GC27172@dastard>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.adsl24.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ty-penguin.org.uk
X-Get-Message-Sender-Via: hosting.adsl24.co.uk: authenticated_id: mail@typenguin.adsl24.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> said, in message
20121207004255.GC27172@dastard:
> 
> The problem wth doing this is that the sync can delay the freeze
> process by quite some time under the exact conditions you describe.
> If you want freeze to take effect immediately (i.e instantly stop
> new modifications), then adding a sync will break this semantic.
> THere are existing users of freeze that require this behaviour...

Ahh, that would be the subtlety I was worried might exist! Thanks.

The specific issue that brought me here was that, on a fairly heavily
loaded file server (>1000 connected Windows clients), taking an LVM
snapshot caused enough of an interruption to service that many of the
Windows clients disconnected and reconnected, so causing a huge process
load on the server - enough that we'd completely lose service and have
to reboot. Chasing this down, I noticed that FIFREEZE does a filesystem
sync, and it seemed to me that adding another one prior to blocking
writes was an easy hit. 

I'm not trying to argue my case here - you've convinced me that this
change in semantics is risky and removes flexibility.

I'll try and chase this up by submitting patches to lvcreate and
fsfreeze (in the former case, I think there's no reason not to run
syncfs; in the latter perhaps it should be a command line option).

> That, to me, is irrelevant, because something is normally done while
> the filesystem is frozen. It's not uncommon for freeze periods to
> extend to minutes while work is done by whatever required the
> freeze. Hence the few seconds it takes to acheive the frozen state is
> mostly irrelevant.

You've referred twice to existing systems that would break in the
presence of this change.  I'm really having trouble thinking of a
situation where it's critical to have writes suspended *NOW* and where
it's valid to keep them suspended for minutes. I'd have thought that,
in the vast majority of cases, the critical thing was to minimise the
time for which writes were suspended. Would you mind describing the use
case you're thinking of?

Cheers,
Alun.
