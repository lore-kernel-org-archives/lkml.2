Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0CXMuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:50:52 -0400
Received: from 8bytes.org ([88.198.83.132]:57841 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab0CXMuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:50:44 -0400
Date: Wed, 24 Mar 2010 13:50:43 +0100
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
Message-ID: <20100324125043.GC14800@8bytes.org>
References: <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA00B1.20407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 02:08:17PM +0200, Avi Kivity wrote:
> On 03/24/2010 01:59 PM, Joerg Roedel wrote:

> You can always provide the kernel and module paths as command line  
> parameters.  It just won't be transparently usable, but if you're using  
> qemu from the command line, presumably you can live with that.

I don't want the tool for myself only. A typical perf user expects that
it works transparent.

>> Could be easily done using notifier chains already in the kernel.
>> Probably implemented with much less than 100 lines of additional code.
>
> And a userspace interface for that.

Not necessarily. The perf event is configured to measure systemwide kvm
by userspace. The kernel side of perf takes care that it stays
system-wide even with added vm instances. So in this case the consumer
for the notifier would be the perf kernel part. No userspace interface
required.

> If we make an API, I'd like it to be generally useful.

Thats hard to do at this point since we don't know what people will use
it for. We should keep it simple in the beginning and add new features
as they are requested and make sense in this context.

> It's a total headache.  For example, we'd need security module hooks to  
> determine access permissions.  So far we managed to avoid that since kvm  
> doesn't allow you to access any information beyond what you provided it  
> directly.

Depends on how it is designed. A filesystem approach was already
mentioned. We could create /sys/kvm/ for example to expose information
about virtual machines to userspace. This would not require any new
security hooks.

> Copying the objects is a one time cost.  If you run perf for more than a  
> second or two, it would fetch and cache all of the data.  It's really  
> the same problem with non-guest profiling, only magnified a bit.

I don't think we can cache filesystem data of a running guest on the
host. It is too hard to keep such a cache coherent.

>>> Other userspaces can also provide this functionality, like they have to
>>> provide disk, network, and display emulation.  The kernel is not a huge
>>> library.

If two userspaces run in parallel what is the single instance where perf
can get a list of guests from?

> kvm.ko has only a small subset of the information that is used to define  
> a guest.

The subset is not small. It contains all guest vcpus, the complete
interrupt routing hardware emulation and manages event the guests
memory.

	Joerg

