Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab1IXIiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 04:38:11 -0400
Received: from home.kolivas.org ([59.167.196.135]:46632 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231Ab1IXIiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:38:09 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: BFS cpu scheduler and skip list implementation
Date: Sat, 24 Sep 2011 18:38:06 +1000
User-Agent: KMail/1.13.6 (Linux/3.0.0-ck1; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201109240945.58879.kernel@kolivas.org> <201109241214.21458.kernel@kolivas.org> <20110924073522.GV7761@one.firstfloor.org>
In-Reply-To: <20110924073522.GV7761@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109241838.06941.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Sep 2011 17:35:22 Andi Kleen wrote:
> On Sat, Sep 24, 2011 at 12:14:21PM +1000, Con Kolivas wrote:
> > On Sat, 24 Sep 2011 11:21:06 Andi Kleen wrote:
> > > Con Kolivas <kernel@kolivas.org> writes:
> > > > +struct nodeStructure {
> > > > +	int level;	/* Levels in this structure */
> > > > +	keyType key;
> > > > +	valueType value;
> > > > +	skiplist_node *next[16];
> > > > +	skiplist_node *prev[16];
> > > > +};
> > > 
> > > That's 128 byte / 2 cache lines, not too bad, but it limits
> > > the maximum number of tasks that can be efficiently handled
> > > (my guess to around 64k with maxlevel == 16, but someone may
> > > correct me on that)
> > 
> > Thanks very much for your informed comments. Do you mean once 64k of
> > tasks are queued concurrently, or after 64k of entries have gone in +/-
> > been removed?
> 
> queued concurrently I believe.

That's great then. I'm sure we'd explode in other weird and wonderful ways 
before the CPU load ever got to 64k. Plus all that would happen is that it 
would start degenerating from O(log n) insertion to O(n) as the number way 
surpassed 64k. The number 16 for levels was simply chosen as the one 
originally used by William Pugh in his sample code, but seems to be ample for 
this application.


Being very unimaginative with my benchmarking, a quick benchmark showed a 
significant improvement in the make -j (allnoconfig kbuild) case on my quad core 
from the previous BFS code (all with performance governor). 


3.0.0:
Elapsed Time 28.7

3.0.0-bfs406:
Elapsed Time 28.5

3.0.0-bfs406-sl:
Elapsed Time 27.0


For convenience of those interested in testing:

Here's the original 3.0 -bfs 406 patch:
http://ck.kolivas.org/patches/bfs/3.0.0/3.0-sched-bfs-406.patch

And here's a combined bfs406 + skiplists patch:
http://ck.kolivas.org/patches/bfs/test/3.0-sched-bfs-406-skiplists.patch


-- 
-ck
