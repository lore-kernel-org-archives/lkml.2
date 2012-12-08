Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2LHBUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 20:20:34 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:43463 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab2LHBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 20:20:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloNAM2UwlB5LHa//2dsb2JhbAA9B4VMsnmFeRdzgh4BAQQBOhwjBQsIAxguFCUDDQETE4gLBcEoFIwrIQGEIQOWBJBJgweBUAEfAw
Date: Sat, 8 Dec 2012 12:20:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Alun <alun.linux@ty-penguin.org.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121208012029.GR27172@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
 <20121207004255.GC27172@dastard>
 <20121207085952.57ee1f22@pcebbj.staff.aber.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207085952.57ee1f22@pcebbj.staff.aber.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 08:59:52AM +0000, Alun wrote:
> Dave Chinner <david@fromorbit.com> said, in message
> 20121207004255.GC27172@dastard:
> > 
> > The problem wth doing this is that the sync can delay the freeze
> > process by quite some time under the exact conditions you describe.
> > If you want freeze to take effect immediately (i.e instantly stop
> > new modifications), then adding a sync will break this semantic.
> > THere are existing users of freeze that require this behaviour...
> 
> Ahh, that would be the subtlety I was worried might exist! Thanks.
> 
> The specific issue that brought me here was that, on a fairly heavily
> loaded file server (>1000 connected Windows clients), taking an LVM
> snapshot caused enough of an interruption to service that many of the
> Windows clients disconnected and reconnected, so causing a huge process
> load on the server - enough that we'd completely lose service and have
> to reboot. Chasing this down, I noticed that FIFREEZE does a filesystem
> sync, and it seemed to me that adding another one prior to blocking
> writes was an easy hit. 

Yup, that's typical.

> I'm not trying to argue my case here - you've convinced me that this
> change in semantics is risky and removes flexibility.
> 
> I'll try and chase this up by submitting patches to lvcreate and
> fsfreeze (in the former case, I think there's no reason not to run
> syncfs; in the latter perhaps it should be a command line option).

Is that even necesary? users can issue the sync themselves if
necessary....

> > That, to me, is irrelevant, because something is normally done while
> > the filesystem is frozen. It's not uncommon for freeze periods to
> > extend to minutes while work is done by whatever required the
> > freeze. Hence the few seconds it takes to acheive the frozen state is
> > mostly irrelevant.
> 
> You've referred twice to existing systems that would break in the
> presence of this change.  I'm really having trouble thinking of a
> situation where it's critical to have writes suspended *NOW* and where
> it's valid to keep them suspended for minutes.

Say you get your filesystem reporting a read error in a directory.
There are people out there that will immediately freeze the
filesystem (to prevent potential damage from being propagated) while
they investigate the problem and determine their next action. This
may even involve running non-modifying fsck on the underlying block
device while the filesystem is frozen...

Then there is systems like HA servers that share a filesystem in a
primary/secondary setup - freezes are often used in failover
situations. This ensures all cached dirty data is written to disk
in preparation for the other node to mount it. Freezing the
filesystem ensures that spurious errors are not returned to
applications/clients while the failover takes place. Hence the
filesystem can remain frozen for some time while everything on the
new primary node is started up and fences/STONITHs the frozen
node....

Then there's co-ordinating management operations on filesystems that
span multiple storage arrays (e.g. for hardware based snapshots,
cloning, etc), VM guest migration between two physical hosts, and so
on. Freeze is use for a lot more things than LVM snapshots...

> I'd have thought that,
> in the vast majority of cases, the critical thing was to minimise the
> time for which writes were suspended.

In the obvious use cases, yes. Once you look outside snapshots to
consider applications that need a stable, unchanging filesystem in
an application transparent manner, you'll find lots of interesting
uses for FIFREEZE....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
