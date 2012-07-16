Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2GPOfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab2GPOfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:35:40 -0400
Message-ID: <500426B6.2010200@redhat.com>
Date: Mon, 16 Jul 2012 17:35:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, "mst@redhat.com" <mst@redhat.com>,
        "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home>    <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com>    <4FFD5A2B.2040605@redhat.com> <4FFD6221.1060304@siemens.com>    <4FFD68C3.7000504@redhat.com> <1342036673.2229.17.camel@bling.home>   <4FFE9A6F.3080607@redhat.com> <1342109982.10815.20.camel@ul30vt>  <50028073.8000804@redhat.com> <1342447433.3880.9.camel@ul30vt>
In-Reply-To: <1342447433.3880.9.camel@ul30vt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2012 05:03 PM, Alex Williamson wrote:
>> 
>> This is what I meant, except I forgot that we already do direct path for
>> MSI.
> 
> Ok, vfio now does it for the unmask irqfd-line interface too.  Except
> when we re-inject from eoifd we have to do the eventfd_signal from a
> work queue as we can't have nested eventfd_signals.  We probably need to
> do some benchmarks to see if that re-injection path saves us anything vs
> letting hardware fire again.

If you do that you might as well proxy it in userspace.  Yes the big
qemu lock will get in the way but we shouldn't code the kernel with the
expectation that userspace will be forever broken.

> 
>> > For an MSI that seems to already provide direct
>> > injection.  
>> 
>> Ugh, even for a broadcast MSI into 254 vcpu guests.  That's going to be
>> one slow interrupt.
>> 
>> > For level we'll schedule_work, so that explains the overhead
>> > in that path, but it's not too dissimilar to a a threaded irq.  vfio
>> > does something very similar, so there's a schedule_work both on inject
>> > and on eoi.  I'll have to check whether anything prevents the unmask
>> > from the wait_queue function in vfio, that could be a significant chunk
>> > of the gap.  Where's the custom poll function come into play?  Thanks,
>> 
>> So I don't understand where the gap comes from.  The number of context
>> switches for kvm and vfio is the same, as long as both use MSI (and
>> either both use threaded irq or both don't).
> 
> Right, we're not exactly apples to apples yet.  Using threaded
> interrupts and work queue injection, vfio is a little slower.  There's
> an extra work queue in that path vs kvm though.  Using non-threaded
> interrupts and direct injection, vfio is faster.  Once kvm moves to
> non-threaded interrupt handling, I expect we'll be pretty similar.  My
> benchmarks are just rough estimates at this point as I'm both trying to
> work out lockdep and get some ballpark performance comparison.  Thanks,

Okay.  I'm not really interested in how the code compares today, but
whether there is something in vfio that prevents it achieving kvm
performance once it's completely optimized.  Given the above, I don't
think there is.


-- 
error compiling committee.c: too many arguments to function


