Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab1ELRbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:31:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46866 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab1ELRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dwIhAIP4K0/PfbqYjlEsCwABSKITW/ZeJwT25pRvDcO4BIsvwOkH07Mik9VyMlwP9C
         cLgEJYdt1sgbsX8hSrIw==
MIME-Version: 1.0
In-Reply-To: <1305191300.2914.263.camel@laptop>
References: <1304299157-25769-1-git-send-email-ncrao@google.com>
 <20110502061411.GA16682@elte.hu> <BANLkTiktch2mHDLXZCdCED3XoqmkVRfghA@mail.gmail.com>
 <20110504111355.GC5914@elte.hu> <BANLkTi=rnOZb-E35SC5B9Xb3SXMwFZi=Fg@mail.gmail.com>
 <1305191300.2914.263.camel@laptop>
From: Nikhil Rao <ncrao@google.com>
Date: Thu, 12 May 2011 10:30:56 -0700
Message-ID: <BANLkTimsvvWqcGanJs688hytLx1_jb0itw@mail.gmail.com>
Subject: Re: [PATCH v1 00/19] Increase resolution of load weights
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 2:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-05-05 at 18:29 -0700, Nikhil Rao wrote:
>> > It's a cost/benefit analysis and for 32-bit systems the benefits seem to be
>> > rather small, right?
>> >
>>
>> Yes, that's right. The benefits for 32-bit systems do seem to be limited.
>
> deep(er) hierarchies on 32 bits still require this, it would be good to
> verify that the cgroup mess created by the insanity called libvirt will
> indeed work as expected.
>

I went through the libvirt docs and from what I understand, it creates
a hierarchy which is about 3 levels deep and has as many leaf nodes as
guest VMs.

Taking this graphic from
http://berrange.com/posts/2009/12/03/using-cgroups-with-libvirt-and-lxckvm-guests-in-fedora-12/

$ROOT
 |
 +-  libvirt    (all virtual machines/containers run by libvirtd)
       |
       +- lxc   (all LXC containers run by libvirtd)
       |   |
       |   +-  guest1    (LXC container called 'guest1')
       |   +-  guest2    (LXC container called 'guest2')
       |   +-  guest3    (LXC container called 'guest3')
       |   +-  ...       (LXC container called ...)
       |
       +- qemu  (all QEMU/KVM containers run by libvirtd)
           |
           +-  guest1    (QENU machine called 'guest1')
           +-  guest2    (QEMU machine called 'guest2')
           +-  guest3    (QEMU machine called 'guest3')
           +-  ...       (QEMU machine called ...)

Assuming the tg shares given to libvirt, lxc and qemu containers are
the defaults, the load balancer should be able to deal with the
current resolution on 32-bit. Back of the envelope calculations using
that approach I mentioned earlier (i.e. log_b(1024/NR_CPU)) says you
need > 64 VMs before you run out of resolution. I think that might be
too much to expect from a 8-cpu 32-bit machine ;-)

-Thanks,
Nikhil
