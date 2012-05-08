Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2EHNJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab2EHNJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:09:05 -0400
Date: Tue, 8 May 2012 14:07:40 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120508130740.GG18762@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
 <20120504204627.GB18177@linux.vnet.ibm.com>
 <1336164981.6509.72.camel@twins>
 <20120504213010.GD3054@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120504213010.GD3054@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 02:30:11PM -0700, Nishanth Aravamudan wrote:
> On 04.05.2012 [22:56:21 +0200], Peter Zijlstra wrote:
> > On Fri, 2012-05-04 at 13:46 -0700, Nishanth Aravamudan wrote:
> > > What about other users of cpusets (what are they?)? 
> > 
> > cpusets came from SGI, its traditionally used to partition _large_
> > machines. Things like the batch/job-schedulers that go with that type of
> > setup use it.
> 
> Yeah, I recall that usage (or some description similar). Do we have any
> other known users of cpusets (beyond libvirt)?

IIRC, the lxc.sf.net project also uses cpusets (no connection to the libvirt
LXC driver mentioned below which is an alternative impl of the same concept).

> > I've no clue why libvirt uses it (or why one would use libvirt for that
> > matter).
> 
> Well, it is the case that libvirt does use it, and libvirt is used
> pretty widely (or so it seems to me). I don't use it (cpusets or libvirt
> :) either, but it seems like we should either tell libvirt directly that
> cpusets are inappropriate for their use-case (once we figure out what
> exactly that is, and why they chose cpusets) or work with them to
> support their use-case?

Libvirt uses the cpuset cgroups functionality in two of its
virtualization drivers:

 - LXC.  Container based virt. The cpuset controller is used to
   constrain all processes running inside the container to a
   specific collection of CPUs. While we could use the traditional
   sched_setaffinity() syscall at initial startup of the container,
   this is not so practical when we want to dynamically change the
   affinity of an existing container. It would require that we
   iterate over all tasks changing their affinity, and to avoid
   fork() race conditions we'd need to suspend the container while
   doing this. Thus we've long used the cpuset cgroups controller
   for LXC.

 - KVM.  Full machine virt. By default we use sched_setaffinity
   to apply constraints on what host CPUs a VM executes on. Fairly
   recently we added the ability to optionally use the cpuset
   controller instead (only if the sysadmin has already mounted
   it). The advantage of this, is that if we update the cpuset
   of an existing VM, then IIUC, the kernel will migrate its
   allocated memory to be local to the new CPU set mask.

The pain point we're hitting, is that upon suspend/restore the cgroups
cpuset masks are not preserved. This is not a problem for server virt
usage scenarios, but it is for desktop users with virt on laptaops.

I don't see a viable alternative to the cpuset controller for our LXC
container driver. For KVM we could do without the cpuset controller
if there is alternative way to tell the kernel to migrate the KVM
process memory to be local to the new CPU affinity set using the
sched_setaffinity() call.

We are open to suggestions of alternative approaches, particularly since
we have had no end of trouble with pretty much all of the kernel's
cgroups controllers :-(

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
