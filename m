Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab2IZRPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:15:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab2IZRPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:15:21 -0400
Date: Wed, 26 Sep 2012 19:15:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120926171541.GB5339@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mel Gorman <mgorman@suse.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
	linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic>
 <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <1348624845.7100.147.camel@marge.simpson.net>
 <CA+55aFw8F=M7O6KfpotnhWoyJ6MiFF1U5S4RDboxyzPjW4hs6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFw8F=M7O6KfpotnhWoyJ6MiFF1U5S4RDboxyzPjW4hs6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 07:22:22PM -0700, Linus Torvalds wrote:
> So I'm sure there are architecture differences (where HT in particular
> probably changes optimal scheduling strategy, although I'd expect
> the bulldozer approach to not be *that*different - but I don't know
> if BD shows up as "HT siblings" or not, so dissimilar topology
> interpretation may make it *look* very different).

Right, those cores sharing an L2 are thread siblings on BD:

$ grep . /sys/devices/system/cpu/cpu0/topology/*
/sys/devices/system/cpu/cpu0/topology/core_id:0
/sys/devices/system/cpu/cpu0/topology/core_siblings:ff
/sys/devices/system/cpu/cpu0/topology/core_siblings_list:0-7
/sys/devices/system/cpu/cpu0/topology/physical_package_id:0
/sys/devices/system/cpu/cpu0/topology/thread_siblings:03
/sys/devices/system/cpu/cpu0/topology/thread_siblings_list:0-1

much like HT siblings on this single-socket Sandybridge: 

$ grep . /sys/devices/system/cpu/cpu0/topology/*
/sys/devices/system/cpu/cpu0/topology/core_id:0
/sys/devices/system/cpu/cpu0/topology/core_siblings:ff
/sys/devices/system/cpu/cpu0/topology/core_siblings_list:0-7
/sys/devices/system/cpu/cpu0/topology/physical_package_id:0
/sys/devices/system/cpu/cpu0/topology/thread_siblings:11
/sys/devices/system/cpu/cpu0/topology/thread_siblings_list:0,4

Although I don't know whether those thread siblings on this SB box are
actual HT siblings, sharing almost all resources, judging by the core
ids.

-- 
Regards/Gruss,
Boris.
