Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab0CVQpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:45:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CVQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:45:15 -0400
Date: Mon, 22 Mar 2010 13:44:37 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100322164437.GB4066@ghostprotocols.net>
References: <1268717232.2813.36.camel@localhost> <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu> <1269242687.2078.25.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269242687.2078.25.camel@ymzhang.sh.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 22, 2010 at 03:24:47PM +0800, Zhang, Yanmin escreveu:
> On Fri, 2010-03-19 at 09:21 +0100, Ingo Molnar wrote:
> > So some sort of --guestmount option would be the natural solution, which 
> > points to the guest system's root: and a Qemu enumeration of guest mounts 
> > (which would be off by default and configurable) from which perf can pick up 
> > the target guest all automatically. (obviously only under allowed permissions 
> > so that such access is secure)
> If sshfs could access /proc/ and /sys correctly, here is a design:
> --guestmount points to a directory which consists of a list of sub-directories.
> Every sub-directory's name is just the qemu process id of guest os. Admin/developer
> mounts every guest os instance's root directory to corresponding sub-directory.
> 
> Then, perf could access all files. It's possible because guest os instance
> happens to be multi-threading in a process. One of the defects is the accessing to
> guest os becomes slow or impossible when guest os is very busy.

If the MMAP events on the guest included a cookie that could later be
used to query for the symtab of that DSO, we wouldn't need to access the
guest FS at all, right?

With build-ids and debuginfo-install like tools the symbol resolution
could be performed by using the cookies (build-ids) as keys to get to
the *-debuginfo packages with matching symtabs (and DWARF for source
annotation, etc).

We have that for the kernel as:

[acme@doppio linux-2.6-tip]$ l /sys/kernel/notes 
-r--r--r-- 1 root root 36 2010-03-22 13:14 /sys/kernel/notes
[acme@doppio linux-2.6-tip]$ l /sys/module/ipv6/sections/.note.gnu.build-id 
-r--r--r-- 1 root root 4096 2010-03-22 13:38 /sys/module/ipv6/sections/.note.gnu.build-id
[acme@doppio linux-2.6-tip]$

That way we would cover DSOs being reinstalled in long running 'perf
record' sessions too.

This was discussed some time ago but would require help from the bits
that load DSOs.

build-ids then would be first class citizens.

- Arnaldo
