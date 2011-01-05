Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1AEWR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:17:59 -0500
Received: from kroah.org ([198.145.64.141]:45585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab1AEWRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:17:55 -0500
Date: Wed, 5 Jan 2011 14:16:23 -0800
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
Message-ID: <20110105221623.GA17437@kroah.com>
References: <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <4D2342E1.8010405@redhat.com>
 <20110104210011.GB4180@kroah.com>
 <4D247867.9040502@fusionio.com>
 <20110105155816.GD2072@kroah.com>
 <4D24BC88.4090804@fusionio.com>
 <20110105200825.GA11372@kroah.com>
 <4D24E4C7.30906@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D24E4C7.30906@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:38:15PM +0100, Jens Axboe wrote:
> On 2011-01-05 21:08, Greg KH wrote:
> > On Wed, Jan 05, 2011 at 07:46:32PM +0100, Jens Axboe wrote:
> >> On 2011-01-05 16:58, Greg KH wrote:
> >>> On Wed, Jan 05, 2011 at 02:55:51PM +0100, Jens Axboe wrote:
> >>>> On 2011-01-04 22:00, Greg KH wrote:
> >>>>> On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
> >>>>>> Also add a refcount to struct hd_struct to keep the partition in
> >>>>>> memory as long as users exist. We use kref_test_and_get() to ensure
> >>>>>> we don't add a reference to a partition which is going away.
> >>>>>
> >>>>> No, don't do this, use a kref correctly and no such function should be
> >>>>> needed.
> >>>>>
> >>>>>> +	} else {
> >>>>>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> >>>>>
> >>>>> That is the function that should properly increment the reference count
> >>>>> on the object.  If the object is "being removed", then it will return
> >>>>> NULL and you need to check that.  Do that and you do not need to add:
> >>>>
> >>>> It doesn't matter if you do it in there of after the fact, since the
> >>>> "lock" (RCU) is being held across the call. See my original suggestion
> >>>> here:
> >>>>
> >>>> https://lkml.org/lkml/2010/12/17/275
> >>>
> >>> Ok, that's fine, just do it without adding that kref function and I have
> >>> no objection :)
> >>
> >> Why? The code is perfectly fine. I originally objected to making an API
> >> like this for simple reference counting - seems I was right. Please
> >> actually look at the code and use. Alexey asked whether this was a toy
> >> API or a real one, I'd like to know that as well. If this is meant just
> >> for very basic get/put references, fine, then document that. But then
> >> what's the point of having this API in the first place?
> > 
> > The point is that you shouldn't have to roll your own reference count
> > code all over the place, 99% of the time, you should just use the
> > debugged, and documented, interface that the kernel provides with the
> > kref interface.
> > 
> > As for it being a "toy", it properly handles a very large majority of
> > the kernel reference counting logic today, in a race-free manner, so I
> > would not call that a "toy" at all.
> 
> Dunno, then perhaps pointless. It's not like the API is saving lots of
> typing or easier to use than just atomics, imho.

Remember what Andrew said when you complained about this last time?
I'll paraphrase:
	When we see someone use an atomic value for a reference count,
	we then need to go audit the code to make sure they got the
	flushing right, and all the other little stuff you need to do in
	order to ensure the code works properly.

	If you use a kref, then we know that all is correct, and we can
	then focus on how the kref is used (very easy to audit) and
	worry about the rest of the code.  It saves us time as
	reviewers and maintainers also.

> > Just use it properly.  As this patch series points out, adding this type
> 
> By adding pointless locks?

No.

> Your suggestion of doing the referencing
> inside the function being called is moot, since RCU is held off over the
> call. The point of the addition to the API is to _not_ grab a reference
> if someone has done the final put. We know that the RCU grace period has
> not ended, so the kref is valid. But if it is going away _in the future_
> after we drop the part lock, then we don't want a reference to it.
> 
> So to "use it properly", I would have to slow down a fast path. No
> thanks.

Then don't use it.  a kref is NOT for a fast path, use RCU for that.
Heck, an atomic value is also not good for a fast path also, as it
causes major stalls, so you might want to reconsider not even using that
if you are thinking you should roll your own.

> > of function to the api is not a good idea, as it will be incorrect when
> > used.
> 
> The code is fine, the use is fine. I think the only thing we have
> established here is that Jerome made the mistake of using the kref API
> for this. I'll rewrite that part to handle its own references.

Yes, that is true.  If you are already using RCU, then by all means,
don't use a kref.  There are lots of reference counts in the kernel that
don't use a kref, nor should they.

thanks,

greg k-h
