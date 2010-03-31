Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab0CaDUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:20:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:45448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699Ab0CaDUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:20:50 -0400
Message-ID: <4BB2BF8A.6080501@suse.de>
Date: Wed, 31 Mar 2010 12:20:42 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
References: <20100324031829.2136.66489.stgit@notabene.brown>	<4BAC3CE0.2010408@suse.de>	<20100326170214.517a17cc@notabene.brown>	<4BAC5513.8060608@suse.de> <20100329161054.2dfcdfa8@notabene.brown>
In-Reply-To: <20100329161054.2dfcdfa8@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On 03/29/2010 02:10 PM, Neil Brown wrote:
>> I don't know.  After spending some time with k* and device model, I
>> grew a pretty strong dislike for abstractions without clear functional
>> necessities.  kref being much simpler than kobject, the abuse is much
>> less severe but there have been kref misuses (in kobject and SCSI
>> midlayer) which could have been avoided or at least easily located if
>> they simply had used atomic_t instead of dreaming up some mystical
>> properties of kref.
> 
> this strikes me as really valuable experience that it would be great
> to share.  While I generally like kref and see value in at least
> some of kobject I don't for a moment suppose they are perfect.
> Fixing them requires a good understanding of the problems they
> cause.  If you have that knowledge, it would be a great resource for
> anyone wanting to 'fix' kobject.  Are you interested in writing
> anything (more) up at all???

I'm not sure I have enough to say to write something up about. :-) One
thing I've been hoping to do is to hide the k* abstraction behind
device model abstraction so that device model API users only have to
deal with device model abstractions - devices and drivers.  They are
what the driver writers need and have pretty good tangible concrete
concept about.  I think my opinions can be compressed into

* Add abstractions which serve concrete functional necessities as
  doing so makes communication among peer programmers much easier by
  reducing confusion.

* Don't get too attached to software engineering theories.  They're
  not bad in themselves but often end up labeling only certain small
  subset of all the things which need to be considered, with the
  adverse side effect of emphasizing those named ones out of
  proportion harming overall trade-off balance.

> This would argue that having a return value from kobject_get violates Rusty's
> law that interfaces should be hard to misuse.
> We could probably change that - it is only used 19 times in the current
> kernel.
> It probably doesn't help that Documentation/kobject.txt includes the text:
> 
>     A successful call to kobject_get() will increment the kobject's reference
>     counter and return the pointer to the kobject.
> 
> which seems to suggest that an unsuccessful call is possible.

Yeap, the return value is only for convenience and I think it's more
harmful overall, but then again I suppose most people got used to it
now, which is another important factor to consider.  Given that there
are not many users of the return value, I agree that removing it would
be better.

>> This is *way* worse than atomic_t not better and the confusion is
>> caused exactly by superflous abstraction which leads the users of the
>> API to imagine some non-existing function of the abstraction and
>> hinders the flow of review.
> 
> I'm not immediately convinced by this, though maybe I haven't seen enough
> examples yet.
> 
> The deadlocks that I have come across would not have been any more obvious in
> either of the above - they were caused because sysfs_remove deadlocks when
> called from inside a sysfs attribute action...
>
> Also, while this re-write is possible for kref uses it isn't really possible
> in kobject as the 'final_put' function must be included in the ktype (though
> maybe you don't like that either).

Ah, right, I probably was mixing kobject and kref release functions
when talking about the problems I've seen.  I still don't like the
kref API and have chosen atomic_t over it in several cases.  To me,
the separate ->release seems way too heavy compared to the
functionality the abstraction actually provides and hinders writing
and reviewing more than it clarifies things.

> What would be really helpful here is a survey of what sorts of things are
> actually done in final_put functions so would could create some guidelines
> about how to write the release functions.

For kobject, I'm not sure what should be done other than hiding it as
much as possible behind device model abstractions.  For kref, I think
it would be great if it can be made simpler and dumber so that it only
clarifies the intention of the usage instead of forcing separate
->release.  If fancier reference helper is needed, capability to defer
release to a separate context and handle module symbol dereference
problem automatically would be nice provided they can be done in clean
manner, but these are just something I've been vaguely hoping for so
they may be absurd to actually implement.  :-)

Thanks.

-- 
tejun
