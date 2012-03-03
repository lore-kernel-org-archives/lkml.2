Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab2CCRhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 12:37:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35492 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab2CCRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 12:37:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 3 Mar 2012 18:37:22 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [PATCH v2 08/11] firewire-sbp-target: Add sbp_login.{c,h}
Message-ID: <20120303183722.04cdbfee@stein>
In-Reply-To: <4F3CE6A1.9050602@bootc.net>
References: <1328989452-20921-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-1-git-send-email-bootc@bootc.net>
	<1329317248-94128-9-git-send-email-bootc@bootc.net>
	<20120215220052.040e680a@stein>
	<4F3CE6A1.9050602@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16 Chris Boot wrote:
> The session is only really inspected/maniuplated in the context of work 
> items, so it's possible I could use mutexes - although in the target 
> agent address handler I do check the node_id against the one in the 
> session (and I should really check the generation too). Would memory 
> barriers be enough for those or would locking be required?

A node ID itself is an incomplete datum.  Only a card--generation--node_ID
tuple is complete.

If generation and node ID are written and read concurrently, you have a
couple of choices to do this consistently:  You could atomically write and
read an integer which contains 8 bits of generation and 16 bits of node
ID.  Or you could serialize write and read accesses by a lock or mutex.
Or you could force the write side to write node ID before generation
(with an smp_wmb between to enforce order), and the read side to read
generation before node ID (with an smp_rmb to enforce order).

The latter method leaves a brief window in which a reader could pick up a
current node ID together with an outdated generation.  This is harmless
because the OHCI hardware and respective precautions in firewire-ohci
prevents transaction subactions with outdated generation to go out to the
wire.

It is generally recommended to implement such accesses in drivers with
locks (spinlocks or mutexes).  Among the various means to deal with
concurrency issues, locks seem to be best understood by us simple folk who
hack on drivers. :-)

[...]
> I guess I need to protect access to 
> the entire session really. Possibly even rwlocks due to only the 
> management processes ever changing anything, but lots of reads during 
> command handling.

The use case for rwlocks is not really the case where infrequent write
access meets frequent read access.  Rather, the use case is when it is
important to reduce or prevent contention between readers.

Rwlocks come with their own downsides though.  I guess the somewhat
costlier lock implementation could counter the benefit of allowing
concurrent readers.  Or maybe latency spikes around a write access could be
an issue.

I believe I have read somewhere that one should rather use a simple
spinlock unless exhaustive tests prove that an rwlock really performs
better.  Furthermore, in many if not all use cases of rwlocks, RCU is
available as another alternative.  RCU comes with its own set of downsides
though, for example not being as well and widely understood by programmers
compared to locking, being less easy to debug (may have improved
recently), and posing some challenges to RT-PREEMPT kernels.

AFAIU the above considerations cannot be applied 100 % to able-to-sleep
reader-writer locks, i.e. the kernel's rwsem.  Still, the use case of an
rwsem (in contrast to a mutex) is not particularly where a datum is rarely
written and often read, but where it is desirable to let multiple readers
not block each other.

[Somebody correct me where I'm wrong.]

PS, I cloned your git tree not long ago, but again various distractions
kept me from having a broader look at your code...
-- 
Stefan Richter
-=====-===-- --== ---==
http://arcgraph.de/sr/
