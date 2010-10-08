Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab0JHQzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:55:17 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:60811 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab0JHQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:55:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19631.19630.584400.854655@quad.stoffel.home>
Date: Fri, 8 Oct 2010 12:54:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: John Stoffel <john@stoffel.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "agruen@suse.de" <agruen@suse.de>
Subject: Re: Linux 2.6.36-rc7
In-Reply-To: <201010081717.25940.tvrtko.ursulin@sophos.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<1286486674.2571.16.camel@localhost.localdomain>
	<19631.15310.568446.991954@quad.stoffel.home>
	<201010081717.25940.tvrtko.ursulin@sophos.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tvrtko" == Tvrtko Ursulin <tvrtko.ursulin@sophos.com> writes:

Tvrtko> On Friday 08 Oct 2010 16:42:06 John Stoffel wrote:
>> >>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:
Eric> I will tell you that the way I envision it working (and being
Eric> backwards compatible) is that priority 0 is the last thing to be
Eric> serviced.  If 2 things register at the same priority the order
Eric> between them getting events is unpredictable.  So when an HSM
Eric> uses the interface it would use the highest priority.  An AV
Eric> vendor might use (highest priority / 2) while normal inotify
Eric> like listeners would all be happy using priority 0.
>> 
>> Ugh, I'd prefer that priority 0 is first (highest), but I can see how
>> that would make ABI problems, assuming we don't punt on releasing the
>> ABI now.
>> 
>> So if the order is undefined now, that's not good.  Well... maybe it's
>> acceptable, but I can see all kinds of problems cropping up.
>> Hopefully they're processed in order of notifier creation instead.  So
>> if I insert a notifier, anyone who inserts a notifier after me gets
>> serviced after my notifier gets run.  That would seem to be the
>> logical and sane semantics to use here.
>> 
>> Again, I'm really approaching this as a SysAdmin who'd love to use
>> this in an HSM environment, so ordering is a *key* requirement.

Tvrtko> Ordering by time of registration? I thought of that but it
Tvrtko> falls flat once any service needs to restart or be restarted.

Yup, it can fail, esp if you have indexing before the HSM
retrieval... :]  That could lead to all kinds of silliness.

But then again, how *serious* is it when it does fail?  For example,
we use CommVault at work on Netapps to do HSM for some data.  CV
leaves a little stub file holding the key to the content to be
restored, and a note for the end user saying "Don't mess with this
file, it's a pointer to your data.  Call your SysAdmin if you see
this..."

So that's one way of approaching the error handling case.

Tvrtko> Priority is also not that great concept. I may have proposed
Tvrtko> classes or something similar at some point, don't remember any
Tvrtko> more. It would be equivalent to having allocated priority
Tvrtko> ranges, like:

Tvrtko> 1000 - pre-content
Tvrtko> =100 - access-control
Tvrtko> <100 - content

Umm, why is there only one value for the access-control part?  Are you
saying there should only be one program to decide on access control?
Shouldnt' there be more?   So I think you're classes are just passed
in by the notifier setup call:

   flags = FANOTIFY_PRE_CONTENT & FANOTIFY_EXCLUSIVE;
   add_notifier(filesystem,flags,&hook);

   flags = ACCESS & SUFFICIENT;
   add_notififier(filesystem,flags,&hook);

And you'd have flags like:

    PRE_ACCESS 	     1
    ACCESS	     2
    POST_ACCESS	     4
    EXCLUSIVE	     8
    SUFFICIENT	     16	/* Passing this means all ACCESS is allowed */
    		        /* even with other ACCESS notifiers in the
			chain */

so say where in the process you need to be.  The EXCLUSIVE flag means
we want to be the only one doing this and to bail if someone else is
already registered.  

Tvrtko> Doesn't really solve ordering inside groups so maybe we do not
Tvrtko> need priorities at all just these three classes?

Ordering is a key thing.  In most cases, you don't care, but for some
cases you really do care.  

Maybe we should take some of the ideas used by PAM for ordering to
used as a basis?  

John
