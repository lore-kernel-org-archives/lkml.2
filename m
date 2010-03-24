Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0CXPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:01:40 -0400
Received: from 8bytes.org ([88.198.83.132]:49873 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab0CXPBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:01:38 -0400
Date: Wed, 24 Mar 2010 16:01:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100324150137.GE14800@8bytes.org>
References: <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA1A53.20207@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:57:39PM +0200, Avi Kivity wrote:
> On 03/24/2010 03:46 PM, Joerg Roedel wrote:

>> Someone who uses libvirt and virt-manager by default is probably not
>> interested in this feature at the same level a kvm developer is. And
>> developers tend not to use libvirt for low-level kvm development.  A
>> number of developers have stated in this thread already that they would
>> appreciate a solution for guest enumeration that would not involve
>> libvirt.
>
> So would I.

Great.

> But when I weigh the benefit of truly transparent  system-wide perf
> integration for users who don't use libvirt but do use  perf, versus
> the cost of transforming kvm from a single-process API to a
> system-wide API with all the complications that I've listed, it comes
> out in favour of not adding the API.

Its not a transformation, its an extension. The current per-process
/dev/kvm stays mostly untouched. Its all about having something like
this:

$ cd /sys/kvm/guest0
$ ls -l
-r-------- 1 root root 0 2009-08-17 12:05 name
dr-x------ 1 root root 0 2009-08-17 12:05 fs
$ cat name
guest0
$ # ...

The fs/ directory is used as the mount point for the guest root fs.

>> The samples will be tagged with the guest-name (and some additional
>> information perf needs). Perf userspace can access the symbols then
>> through /sys/kvm/guest0/fs/...
>
> I take that as a yes?  So we need a virtio-serial client in the kernel  
> (which might be exploitable by a malicious guest if buggy) and a  
> fs-over-virtio-serial client in the kernel (also exploitable).

What I meant was: perf-kernel puts the guest-name into every sample and
perf-userspace accesses /sys/kvm/guest_name/fs/ later to resolve the
symbols. I leave the question of how the guest-fs is exposed to the host
out of this discussion. We should discuss this seperatly.


>> An approach like: "The files are owned and only readable by the same
>> user that started the vm." might be a good start. So a user can measure
>> its own guests and root can measure all of them.
>
> That's not how sVirt works.  sVirt isolates a user's VMs from each  
> other, so if a guest breaks into qemu it can't break into other guests  
> owned by the same user.

If a vm breaks into qemu it can access the host file system which is the
bigger problem. In this case there is no isolation anymore. From that
context it can even kill other VMs of the same user independent of a
hypothetical /sys/kvm/.

>> Yeah that would be interesting information. But it is more related to
>> tracing than to pmu measurements.  The information which you
>> mentioned above are probably better captured by an extension of
>> trace-events to userspace.
>
> It's all related.  You start with perf, see a problem with mmio, call up  
> a histogram of mmio or interrupts or whatever, then zoom in on the  
> misbehaving device.

Yes, but its different from the implementation point-of-view. For the
user it surely all plays together.

	Joerg

