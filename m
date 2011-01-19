Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1ASUpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:45:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50453 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1ASUpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bbv92iClnxRKjVNPkqgASHI8TXIUDgPI5bNeaYfydWcRQjBLfuOb+xv48ayNhUhXH6
         0gfnFqvY1ctFtwvis88dBXvzyXIZs8DNcTMVdBTQzx0qWFbPhKxfuE/e+eta8p5jfkds
         C7gRDJqx8/CjDR9aJMD6rQ4TDaeo782GBoTS0=
MIME-Version: 1.0
In-Reply-To: <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<20110118235236.GA14087@quack.suse.cz>
	<AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
	<20110119132123.GC4246@quack.suse.cz>
	<x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
	<x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
	<AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
	<x491v48d47d.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 20 Jan 2011 07:45:42 +1100
Message-ID: <AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 7:32 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> On Thu, Jan 20, 2011 at 6:46 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Jeff Moyer <jmoyer@redhat.com> writes:
>>>
>>>> Jan Kara <jack@suse.cz> writes:
>>>>
>>>>>  But there's the second race I describe making it possible
>>>>> for new IO to be created after io_destroy() has waited for all IO to
>>>>> finish...
>>>>
>>>> Can't that be solved by introducing memory barriers around the accesses
>>>> to ->dead?
>>>
>>> Upon further consideration, I don't think so.
>>>
>>> Given the options, I think adding the synchronize rcu to the io_destroy
>>> path is the best way forward.  You're already waiting for a bunch of
>>> queued I/O to finish, so there is no guarantee that you're going to
>>> finish that call quickly.
>>
>> I think synchronize_rcu() is not something to sprinkle around outside
>> very slow paths. It can be done without synchronize_rcu.
>
> I'm not sure I understand what you're saying.  Do you mean to imply that
> io_destroy is not a very slow path?  Because it is.  I prefer a solution
> that doesn't re-architecht things in order to solve a theoretical issue
> that's never been observed.

Even something that happens once per process lifetime, like in fork/exit
is not necessarily suitable for RCU. I don't know exactly how all programs
use io_destroy -- of the small number that do, probably an even smaller
number would care here. But I don't think it simplifies things enough to
use synchronize_rcu for it.
