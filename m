Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab1FPHZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:25:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60130 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab1FPHZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:25:13 -0400
Date: Thu, 16 Jun 2011 09:24:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Alexander Graf <agraf@suse.de>, Anthony Liguori <anthony@codemonkey.ws>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616072452.GA15366@elte.hu>
References: <1308153214.7566.6.camel@jaguar>
 <4DF8DE26.1070301@redhat.com>
 <BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
 <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
 <4DF92C80.3030106@codemonkey.ws>
 <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
 <BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@kernel.org> wrote:

> On Thu, Jun 16, 2011 at 1:07 AM, Alexander Graf <agraf@suse.de> wrote:
> >> qemu-system-x86_64 -drive file=/dev/shm/test.qcow2,cache=writeback,if=virtio
> >
> > Wouldn't this still be using threaded AIO mode? I thought KVM tools used native AIO?
> 
> We don't use AIO at all. It's just normal read()/write() with a 
> thread pool. I actually looked at AIO but didn't really see why 
> we'd want to use it.

We could certainly try kernel AIO, it would allow us to do all the 
virtio-blk logic from the vcpu thread, without single threading it - 
turning the QCOW2 logic into an AIO driven state machine in essence.

Advantages:

 - we wouldnt do context-switching between the vcpu thread and the 
   helper threads

 - it would potentially provide tighter caching and potentially would 
   allow higher scalability.

Disadvantages:

 - the kaio codepaths are actually *more* complex than the regular 
   read()/write() IO codepaths - they keep track of an 'IO context', 
   so part of the efficiency advantages are spent on AIO tracking.

 - executing AIO in the vcpu thread eats up precious vcpu execution 
   time: combined QCOW2 throughput would be limited by a single 
   core's performance, and any time spent on QCOW2 processing would 
   not be spent running the guest CPU. (In such a model we certainly 
   couldnt do more intelligent, CPU-intense storage solutions like on 
   the fly compress/decompress of QCOW2 data.)

 - state machines are also fragile in the sense that any 
   unintentional blocking of the vcpu context will kill the 
   performance and latencies of *all* processing in certain 
   circumstances. So we generally strive to keep the vcpu demux path 
   obvious, simple and atomic.

 - more advanced security models go out the window as well: we 
   couldnt isolate drivers from each other if all of them execute in 
   the same vcpu context ...

 - state machines are also notoriously difficult to develop,
   debug and maintain.

So careful performance, scalability, IO delay and maintainability 
measurements have to accompany such a model switch, because the 
disadvantages are numerous.

I'd only consider KAIO it if it provides some *real* measurable 
performance advantage of at least 10% in some important usecase.
A few percent probably wouldnt be worth it.

Thanks,

	Ingo
