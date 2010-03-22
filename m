Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab0CVG4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 02:56:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:24912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab0CVG4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 02:56:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,285,1267430400"; 
   d="scan'208";a="502460540"
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100321212009.GE30194@elte.hu>
References: <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws>
	 <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com>
	 <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com>
	 <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com>
	 <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com>
	 <20100321212009.GE30194@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 22 Mar 2010 14:59:24 +0800
Message-Id: <1269241164.2078.4.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-03-21 at 22:20 +0100, Ingo Molnar wrote:
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > > Well, for what it's worth, I rarely ever use anything else. My virtual 
> > > disks are raw so I can loop mount them easily, and I can also switch my 
> > > guest kernels from outside... without ever needing to mount those disks.
> > 
> > Curious, what do you use them for?
> > 
> > btw, if you build your kernel outside the guest, then you already have 
> > access to all its symbols, without needing anything further.
> 
> There's two errors with your argument:
> 
> 1) you are assuming that it's only about kernel symbols
> 
> Look at this 'perf report' output:
> 
> # Samples: 7127509216
> #
> # Overhead     Command                  Shared Object  Symbol
> # ........  ..........  .............................  ......
> #
>     19.14%         git  git                            [.] lookup_object
>     15.16%        perf  git                            [.] lookup_object
>      4.74%        perf  libz.so.1.2.3                  [.] inflate
>      4.52%         git  libz.so.1.2.3                  [.] inflate
>      4.21%        perf  libz.so.1.2.3                  [.] inflate_table
>      3.94%         git  libz.so.1.2.3                  [.] inflate_table
>      3.29%         git  git                            [.] find_pack_entry_one
>      3.24%         git  libz.so.1.2.3                  [.] inflate_fast
>      2.96%        perf  libz.so.1.2.3                  [.] inflate_fast
>      2.96%         git  git                            [.] decode_tree_entry
>      2.80%        perf  libc-2.11.90.so                [.] __strlen_sse42
>      2.56%         git  libc-2.11.90.so                [.] __strlen_sse42
>      1.98%        perf  libc-2.11.90.so                [.] __GI_memcpy
>      1.71%        perf  git                            [.] decode_tree_entry
>      1.53%         git  libc-2.11.90.so                [.] __GI_memcpy
>      1.48%         git  git                            [.] lookup_blob
>      1.30%         git  git                            [.] process_tree
>      1.30%        perf  git                            [.] process_tree
>      0.90%        perf  git                            [.] tree_entry
>      0.82%        perf  git                            [.] lookup_blob
>      0.78%         git  [kernel.kallsyms]              [k] kstat_irqs_cpu
> 
> kernel symbols are only a small portion of the symbols. (a single line in this 
> case)
Above example shows perf could summarize both kernel and application hot functions.
If we collect guest os statistics from host side, we can't summarize detailed guest os
application info because we couldn't get guest os's application process id from host
side. So we could only get detailed kernel info and the total utilization percent of
guest application processes.


> 
> To get to those other symbols we have to read the ELF symbols of those 
> binaries in the guest filesystem, in the post-processing/reporting phase. This 
> is both complex to do and relatively slow so we dont want to (and cannot) do 
> this at sample time from IRQ context or NMI context ...
> 
> Also, many aspects of reporting are interactive so it's done lazily or 
> on-demand. So we need ready access to the guest filesystem - for those guests 
> which decide to integrate with the host for this.


