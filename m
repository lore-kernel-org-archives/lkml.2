Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2INWOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 18:14:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39958 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284Ab2INWOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 18:14:44 -0400
Date: Sat, 15 Sep 2012 00:14:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120914221440.GB6468@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nikolay Ulyanitsky <lystor@gmail.com>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <1347658843.7172.90.camel@twins>
 <CA+55aFz6SxLEr0MNubz7rcwcqki7EM33Vp-q3KFEvuLG6a61ZQ@mail.gmail.com>
 <1347659777.7172.97.camel@twins>
 <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwKEjsPKYNFkkNfrr9V=vyEO6M9o_48be4y9w6=h-06UQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 03:01:44PM -0700, Linus Torvalds wrote:
> On Fri, Sep 14, 2012 at 2:56 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > Both things change semantics, not looking at the entire package is new
> > too.
> 
> Well, the "idle_buddy" thing on its own could be considered to be
> purely a caching thing.
> 
> Sure, it doesn't take tsk_cpus_allowed() into account while setting up
> the cache (since it's not dynamic enough), but *assuming* the common
> case is that people let threads be on any of the cores of a package,
> it should be possible to make the cache 100% equivalent with no
> semantic change. No?
> 
> The code doesn't even try to do that kind of "don't change semantics",
> though, and makes the idle-buddy thing entirely different.

Could it be that this machine has a non-power of two cores (6) and maybe
the idle buddy selection doesn't work as expected?

 (Although it shouldn't since the commit message speaks also of non-power of
  two cores (40) and it works fine there).

Anyway, here's the topology of the box:

$ for i in $(ls cpu?/topology/*); do echo -n $i": "; cat $i; done
cpu0/topology/core_id: 0
cpu0/topology/core_siblings: 3f
cpu0/topology/core_siblings_list: 0-5
cpu0/topology/physical_package_id: 0
cpu0/topology/thread_siblings: 01
cpu0/topology/thread_siblings_list: 0
cpu1/topology/core_id: 1
cpu1/topology/core_siblings: 3f
cpu1/topology/core_siblings_list: 0-5
cpu1/topology/physical_package_id: 0
cpu1/topology/thread_siblings: 02
cpu1/topology/thread_siblings_list: 1
cpu2/topology/core_id: 2
cpu2/topology/core_siblings: 3f
cpu2/topology/core_siblings_list: 0-5
cpu2/topology/physical_package_id: 0
cpu2/topology/thread_siblings: 04
cpu2/topology/thread_siblings_list: 2
cpu3/topology/core_id: 3
cpu3/topology/core_siblings: 3f
cpu3/topology/core_siblings_list: 0-5
cpu3/topology/physical_package_id: 0
cpu3/topology/thread_siblings: 08
cpu3/topology/thread_siblings_list: 3
cpu4/topology/core_id: 4
cpu4/topology/core_siblings: 3f
cpu4/topology/core_siblings_list: 0-5
cpu4/topology/physical_package_id: 0
cpu4/topology/thread_siblings: 10
cpu4/topology/thread_siblings_list: 4
cpu5/topology/core_id: 5
cpu5/topology/core_siblings: 3f
cpu5/topology/core_siblings_list: 0-5
cpu5/topology/physical_package_id: 0
cpu5/topology/thread_siblings: 20
cpu5/topology/thread_siblings_list: 5

-- 
Regards/Gruss,
    Boris.
