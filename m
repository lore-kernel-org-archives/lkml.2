Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0CWDOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:14:07 -0400
Received: from mga10.intel.com ([192.55.52.92]:20272 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752137Ab0CWDOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,292,1267430400"; 
   d="scan'208";a="551269205"
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100322164437.GB4066@ghostprotocols.net>
References: <1268717232.2813.36.camel@localhost>
	 <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	 <1269242687.2078.25.camel@ymzhang.sh.intel.com>
	 <20100322164437.GB4066@ghostprotocols.net>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 23 Mar 2010 11:14:41 +0800
Message-Id: <1269314081.2078.63.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 13:44 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Mar 22, 2010 at 03:24:47PM +0800, Zhang, Yanmin escreveu:
> > On Fri, 2010-03-19 at 09:21 +0100, Ingo Molnar wrote:
> > > So some sort of --guestmount option would be the natural solution, which 
> > > points to the guest system's root: and a Qemu enumeration of guest mounts 
> > > (which would be off by default and configurable) from which perf can pick up 
> > > the target guest all automatically. (obviously only under allowed permissions 
> > > so that such access is secure)
> > If sshfs could access /proc/ and /sys correctly, here is a design:
> > --guestmount points to a directory which consists of a list of sub-directories.
> > Every sub-directory's name is just the qemu process id of guest os. Admin/developer
> > mounts every guest os instance's root directory to corresponding sub-directory.
> > 
> > Then, perf could access all files. It's possible because guest os instance
> > happens to be multi-threading in a process. One of the defects is the accessing to
> > guest os becomes slow or impossible when guest os is very busy.
> 
> If the MMAP events on the guest included a cookie that could later be
> used to query for the symtab of that DSO, we wouldn't need to access the
> guest FS at all, right?
It depends on specific sub commands. As for 'perf kvm top', developers want to see
the profiling immediately. Even with 'perf kvm record', developers also want to
see results quickly. At least I'm eager for the results when investigating
a performance issue.

> 
> With build-ids and debuginfo-install like tools the symbol resolution
> could be performed by using the cookies (build-ids) as keys to get to
> the *-debuginfo packages with matching symtabs (and DWARF for source
> annotation, etc).
We can't make sure guest os uses the same os images, or don't know where we
could find the original DVD images being used to install guest os.

Current perf does save build id, including both kernls's and other application
lib/executables.

> 
> We have that for the kernel as:
> 
> [acme@doppio linux-2.6-tip]$ l /sys/kernel/notes 
> -r--r--r-- 1 root root 36 2010-03-22 13:14 /sys/kernel/notes
> [acme@doppio linux-2.6-tip]$ l /sys/module/ipv6/sections/.note.gnu.build-id 
> -r--r--r-- 1 root root 4096 2010-03-22 13:38 /sys/module/ipv6/sections/.note.gnu.build-id
> [acme@doppio linux-2.6-tip]$
> 
> That way we would cover DSOs being reinstalled in long running 'perf
> record' sessions too.
That's one of objectives of perf to support long running.

> 
> This was discussed some time ago but would require help from the bits
> that load DSOs.
> 
> build-ids then would be first class citizens.
> 
> - Arnaldo


