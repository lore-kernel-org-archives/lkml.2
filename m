Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab0CYI7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:59:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:34338 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753296Ab0CYI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="607457161"
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       zhiteng.huang@intel.com, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <4BAA57DA.5030707@redhat.com>
References: <20100324125043.GC14800@8bytes.org>
	 <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org>
	 <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org>
	 <4BAA2BF7.4060407@redhat.com> <20100324154605.GG14800@8bytes.org>
	 <4BAA3496.2010901@redhat.com> <20100324155927.GI14800@8bytes.org>
	 <4BAA393A.9000105@redhat.com> <20100324174703.GD3625@ghostprotocols.net>
	 <4BAA57DA.5030707@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 25 Mar 2010 17:00:31 +0800
Message-Id: <1269507631.2078.88.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 20:20 +0200, Avi Kivity wrote:
> On 03/24/2010 07:47 PM, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Mar 24, 2010 at 06:09:30PM +0200, Avi Kivity escreveu:
> >    
> >> Doesn't perf already has a dependency on naming conventions for finding
> >> debug information?
> >>      
> > It looks at several places, from most symbol rich (/usr/lib/debug/, aka
> > -debuginfo packages, where we have full symtabs) to poorest (the
> > packaged binary, where we may just have a .dynsym).
> >
> > In an ideal world, it would just get the build-id (a SHA1 cookie that is
> > in an ELF session inserted in every binary (aka DSOs), kernel module,
> > kallsyms or vmlinux file) and use that to look first in a local cache
> > (implemented in perf for a long time already) or in some symbol server.
> >
> > For instance, for a random perf.data file I collected here in my machine
> > I have:
> >
> > [acme@doppio linux-2.6-tip]$ perf buildid-list | grep libpthread
> > 5c68f7afeb33309c78037e374b0deee84dd441f6 /lib64/libpthread-2.10.2.so
> > [acme@doppio linux-2.6-tip]$
> >
> > So I don't have to access /lib64/libpthread-2.10.2.so directly, nor some
> > convention to get a debuginfo in a local file like:
> >
> > /usr/lib/debug/lib64/libpthread-2.10.2.so.debug
> >
> > Instead the tools look at:
> >
> > [acme@doppio linux-2.6-tip]$ l ~/.debug/.build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6
> > lrwxrwxrwx 1 acme acme 73 2010-01-06 18:53 /home/acme/.debug/.build-id/5c/68f7afeb33309c78037e374b0deee84dd441f6 ->  ../../lib64/libpthread-2.10.2.so/5c68f7afeb33309c78037e374b0deee84dd441f6*
> >
> > To find the file for that specific build-id, not the one installed in my
> > machine (or on the different machine, of a different architecture) that
> > may be completely unrelated, a new one, or one for a different arch.
> >    
> 
> Thanks.  I believe qemu could easily act as a symbol server for this use 
> case.


I spent a couple of days to investigate why sshfs/fuse doesn't work well with
procfs and sysfs. Just after my patch against fuse is ready almost, I found
fuse already supports such access by direct I/O. With parameter -o direct_io,
it could work well.

Here is an example to mount / from a guest os.
#sshfs -p 5551 -o direct_io localhost:/ guestmount

We can read files and write files if permission is ok.

I will go ahead to support multiple guest os instance statistics parsing.

Yanmin


