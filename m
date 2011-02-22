Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab1BVOLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1BVOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:11:37 -0500
Message-ID: <4D63C413.4020602@redhat.com>
Date: Tue, 22 Feb 2011 16:11:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 0/6] KVM support for TSC scaling
References: <4D57F677.3090004@redhat.com> <20110221172807.GD16508@amd.com> <4D638BDE.70602@redhat.com> <20110222103513.GF16508@amd.com> <4D6392F1.1030601@redhat.com> <20110222111111.GG16508@amd.com>
In-Reply-To: <20110222111111.GG16508@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 01:11 PM, Roedel, Joerg wrote:
> >
> >  Ok, so your scenario is
> >
> >  - boot on host H1
> >  - no intervening migrations
> >  - migrate to host Hnew
> >  - all succeeding migrations are only to new hosts or back to H1
> >
> >  This is somewhat artificial, and not very different from an all-new cluster.
>
> This is at least the scenario where the new hardware feature will make
> sense. Its clear that if you migrate a guest between hosts without
> tsc-scaling will make the tsc appear unstable for the guest. This is
> basically the same situation as we have today.
> In fact, for older hosts the feature can be emulated in software by
> trapping tsc accesses from the guest. Isn't this what Zachary has been
> working on?

Yes.  It's of dubious value though, you get a stable tsc but it's 
incredibly slow.

>   During my implementation I understood tsc-scaling as a
> hardware supported way to do this. And thats the reason I implemented it
> the way it is.

Right.  The only question is what the added guest switch cost.  If it's 
expensive (say, >= 100 cycles) then we need a mode where we can drop 
this cost by applying the same multiplier to all guests and the host 
(can be done as an add-on optimization patch).  If however we end up 
always recommending that all hosts use the same virtual tsc rate, why 
should we support individual rates for guests?

It does make sense from a generality point of view, we provide 
mechanism, not policy, just make sure that the policies we like are 
optimized as far as they can go.

> >  [the whole thing is kind of sad; we went through a huge effort to make
> >  clocks work on virtual machines in spite of the tsc issues; then we have
> >  a hardware solution, but can't use it because of old hardware.  Same
> >  thing happens with the effort put into shadow in the pre-npt days]
>
> The shadow code has a revivial as it is required for emulating
> nested-npt and nested-ept, so the effort still has value :)

Yes.  Some of it though is unused (unsync pages).  And it's hard for me 
to see nested svm itself used in production due to the huge performance 
hit for I/O.  Maybe an emulated iommu (so we can do virtio device 
assignment, or even real device assignment all the way from the host) 
will help, or even more hardware support a la s390.

-- 
error compiling committee.c: too many arguments to function

