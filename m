Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2EWPxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:53:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2EWPxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:53:01 -0400
Subject: Re: [PATCH 1/2] sched: add virt sched domain for the guest
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Liu ping fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <4FBD00DA.5080308@linux.vnet.ibm.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
	 <1337754751-9018-2-git-send-email-kernelfans@gmail.com>
	 <1337759644.9698.49.camel@twins>
	 <CAFgQCTvhVs8-onz3huovYe=StOYJe2pJO-nka_7KogSju6AttQ@mail.gmail.com>
	 <1337761402.9698.62.camel@twins>
	 <CAFgQCTt+cmUWUB6GvE=Ki5ikC1P7YA_sGrvgUKKJ6c3VuqCsAg@mail.gmail.com>
	 <1337762914.9698.65.camel@twins>  <4FBD00DA.5080308@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 17:52:47 +0200
Message-ID: <1337788367.9783.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 08:23 -0700, Dave Hansen wrote:
> On 05/23/2012 01:48 AM, Peter Zijlstra wrote:
> > On Wed, 2012-05-23 at 16:34 +0800, Liu ping fan wrote:
> >> > so we need to migrate some of vcpus from node-B to node-A, or to
> >> > node-C.
> > This is absolutely broken, you cannot do that.
> > 
> > A guest task might want to be node affine, it looks at the topology sets
> > a cpu affinity mask and expects to stay on that node.
> > 
> > But then you come along, and flip one of those cpus to another node. The
> > guest task will now run on another node and get remote memory accesses.
> 
> Insane, sure.  But, if the node has physically gone away, what do we do?
>  I think we've got to either kill the guest, or let it run somewhere
> suboptimal.  Sounds like you're advocating killing it. ;)

You all seem terribly confused. If you want a guest that 100% mirrors
the host topology you need hard-binding of all vcpu threads and clearly
you're in trouble if you unplug a host cpu while there's still a vcpu
expecting to run there.

That's an administrator error and you get to keep the pieces, I don't
care.

In case you want simple virt-numa where a number of vcpus constitute a
vnode and have their memory all on the same node the vcpus are ran on,
what does it matter if you unplug something in the host? Just migrate
everything -- including memory.

But what Liu was proposing is completely insane and broken. You cannot
simply remap cpu:node relations. Wanting to do that shows a profound
lack of understanding.

Our kernel assumes that a cpu remains on the same node. All userspace
that does anything with NUMA assumes the same. You cannot change this.

