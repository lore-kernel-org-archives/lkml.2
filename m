Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2BANyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab2BANyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:54:22 -0500
Date: Wed, 1 Feb 2012 11:43:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
        Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
Message-ID: <20120201134347.GA18998@amt.cnet>
References: <1328016724.2446.229.camel@twins>
 <4F27F0E6.1040309@redhat.com>
 <1328017807.2446.230.camel@twins>
 <20120131222447.GH2391@linux.vnet.ibm.com>
 <1328091749.2760.34.camel@laptop>
 <4F29178A.1090306@redhat.com>
 <4F2918D5.4050104@redhat.com>
 <4F291B56.30600@oss.ntt.co.jp>
 <4F291B92.8070402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F291B92.8070402@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:01:38PM +0200, Avi Kivity wrote:
> On 02/01/2012 01:00 PM, Takuya Yoshikawa wrote:
> >
> >> rcu_assign_pointer), and use atomic operations to copy and clear:
> >>
> >>    word = bitmap[i]
> >>    put_user(word)
> >>    atomic_and(&bitmap[i], ~word)
> >>
> >>
> >
> > This kind of this was really slow IIRC.
> >
> >
> > How about just doing:
> >
> > take a spin_lock
> > copy the entire (or some portions of) bitmap locally
> > clear the bitmap
> > unlock
> >
> 
> That means that vcpus dirtying memory also have to take that lock, and
> spin while the bitmap is being copied.  So kvm_vm_ioctl_get_dirty_log()
> will become faster, at the expense of vcpus, which I think is a bad
> tradeoff.
> 
> > write protect the dirty pages based on the copied dirty data
> >
> > copy_to_user
> >
> >
> >
> > I can show you some performance numbers, this weekend, if you like.
> 
> That'll be great, numbers are better than speculation.

  get dirty log:    5634134 ns for     262144 dirty pages

5ms (for the entire operation).

