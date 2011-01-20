Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1ATScg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:32:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab1ATScd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tr/tI7p/v0Wh7XVx+AkpyusWLuOHiBIIw34bdsgzlj2uVXFRUwsn+iAUQ/fcXhOn9i
         ygRDyGDn/7jLVsClQw8xtsNWtWrENdHV1TVEUYx+s0MOGDfLu7ZpyCwOFhJM9fRO+9s+
         NyJFCrwLeiAU/1xJQZlnd+3KzQ25D/ikDkhVA=
MIME-Version: 1.0
In-Reply-To: <20110120040308.GD8476@linux.vnet.ibm.com>
References: <20110118235236.GA14087@quack.suse.cz>
	<AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
	<20110119132123.GC4246@quack.suse.cz>
	<x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
	<x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
	<AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
	<x491v48d47d.fsf@segfault.boston.devel.redhat.com>
	<AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
	<x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
	<20110120040308.GD8476@linux.vnet.ibm.com>
Date: Fri, 21 Jan 2011 05:31:53 +1100
Message-ID: <AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 3:03 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Jan 20, 2011 at 08:20:00AM +1100, Nick Piggin wrote:
>> On Thu, Jan 20, 2011 at 8:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> >> I don't know exactly how all programs use io_destroy -- of the small
>> >> number that do, probably an even smaller number would care here. But I
>> >> don't think it simplifies things enough to use synchronize_rcu for it.
>> >
>> > Above it sounded like you didn't think AIO should be using RCU at all.
>>
>> synchronize_rcu of course, not RCU (typo).
>
> I think that Nick is suggesting that call_rcu() be used instead.
> Perhaps also very sparing use of synchronize_rcu_expedited(), which
> is faster than synchronize_rcu(), but which which uses more CPU time.

call_rcu() is the obvious alternative, yes.

Basically, once we give in to synchronize_rcu() we're basically giving
up. That's certainly a very good tradeoff for something like filesystem
unregistration or module unload, it buys big simplifications in real
fastpaths. But I just don't think it should be taken lightly.
