Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab2BRKAs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 05:00:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab2BRKAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 05:00:47 -0500
Message-ID: <4F3F76BE.8020308@redhat.com>
Date: Sat, 18 Feb 2012 12:00:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Anthony Liguori <anthony@codemonkey.ws>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-ppc <kvm-ppc@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <4F2B41D6.8020603@codemonkey.ws> <51470503-DEE0-478D-8D01-020834AF6E8C@suse.de> <4F3117E5.6000105@redhat.com> <EF2405C8-CBF4-4CED-B7DC-D048EA002E48@suse.de> <4F31241C.70404@redhat.com> <BE675ED2-9384-4B91-9A30-098C2915A227@suse.de> <4F313354.4080401@redhat.com> <4B03190C-1B6B-48EC-92C7-C27F6982018A@suse.de> <4F3B9497.4020700@redhat.com> <C2015C96-C4B7-4768-8C01-E41F4D8ED9FB@suse.de> <4F3BB33C.1000908@redhat.com> <1FE08D00-49E8-4371-9F23-C5D2EE568FA8@suse.de> <4F3BB9DC.6040102@redhat.com> <3DC824A5-5D5A-4BCC-A0FB-1B459B7E362D@suse.de> <4F3D57E3.7020503@redhat.com> <810F6879-64A9-4FCF-9C22-00BCC945D6B0@suse.de> <4F3D5B35.4000606@redhat.com> <8A20A1D8-9CB7-4256-A9BD-03D972C5292A@suse.de>
In-Reply-To: <8A20A1D8-9CB7-4256-A9BD-03D972C5292A@suse.de>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 02:19 AM, Alexander Graf wrote:
> > 
> > Or we try to be less clever unless we have a really compelling reason. 
> > qemu monitor and gdb support aren't compelling reasons to optimize.
>
> The goal here was simplicity with a grain of performance concerns.
>

Shared memory is simple in one way, but in other ways it is more
complicated since it takes away the kernel's freedom in how it manages
the data, how it's laid out, and whether it can lazify things or not.

> So what would you be envisioning? Should we make all of the MMU walker code in target-ppc KVM aware so it fetches that single way it actually cares about on demand from the kernel? That is pretty intrusive and goes against the general nicely fitting in principle of how KVM integrates today.

First, it's trivial, when you access a set you call
cpu_synchronize_tlb(set), just like how you access the registers when
you want them.

Second, and more important, how a random version of qemu works is
totally immaterial to the kvm userspace interface.  qemu could change in
15 different ways and so could the kernel, and other users exist. 
Fitting into qemu's current model is not a goal (if qemu happens to have
a good model, use it by all means; and clashing with qemu is likely an
indication the something is wrong -- but the two projects need to be
decoupled).

> Also, we need to store the guest TLB somewhere. With this model, we can just store it in user space memory, so we keep only a single copy around, reducing memory footprint. If we had to copy it, we would need more than a single copy.

That's the whole point.  You could store it on the cpu hardware, if the
cpu allows it.  Forcing it into always-synchronized shared memory takes
that ability away from you.

>  
> > 
> > At least on x86, we synchronize only rarely.
>
> Yeah, on s390 we only know which registers actually contain the information we need for traps / hypercalls when in user space, since that's where the decoding happens. So we better have all GPRs available to read from and write to.
>

Ok.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

