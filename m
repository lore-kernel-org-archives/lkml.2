Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1AQXY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:24:27 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40712 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1AQXY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WEcLrue0XNfZjhclCe3fLRILqdoq87ihuai53qVv7n7huC0rKvNPMXrZswO3QMAO/E
         mF56Z7P/4iNDodmoAct/nj9xGXu/FjAeFF+ulNouT14hQ1iMlpm5ZmJ1ixEtaraweyMJ
         T7O/0Nrdh19znQuCvb5F5gIL+KvfzAon9XClU=
MIME-Version: 1.0
In-Reply-To: <x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 18 Jan 2011 10:24:24 +1100
Message-ID: <AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> On Sat, Jan 15, 2011 at 1:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Nick Piggin <npiggin@gmail.com> writes:
>>>
>>>> Hi,
>>>>
>>>> While hunting down a bug in NFS's AIO, I believe I found this
>>>> buggy code...
>>>>
>>>> fs: aio fix rcu ioctx lookup
>>>>
>>>> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
>>>>
>>>> lookup_ioctx doesn't implement the rcu lookup pattern properly.
>>>> rcu_read_lock does not prevent refcount going to zero, so we
>>>> might take a refcount on a zero count ioctx.
>>>
>>> So, does this patch fix the problem?  You didn't actually say....
>>
>> No, it seemd to be an NFS AIO problem, although it was a
>> slightly older kernel so I'll re test after -rc1 if I haven't heard
>> back about it.
>
> OK.
>
>> Do you agree with the theoretical problem? I didn't try to
>> write a racer to break it yet. Inserting a delay before the
>> get_ioctx might do the trick.
>
> I'm not convinced, no.  The last reference to the kioctx is always the
> process, released in the exit_aio path, or via sys_io_destroy.  In both
> cases, we cancel all aios, then wait for them all to complete before
> dropping the final reference to the context.

That wouldn't appear to prevent a concurrent thread from doing an
io operation that requires ioctx lookup, and taking the last reference
after the io_cancel thread drops the ref.


> So, while I agree that what you wrote is better, I remain unconvinced of
> it solving a real-world problem.  Feel free to push it in as a cleanup,
> though.

Well I think it has to be technically correct first. If there is indeed a
guaranteed ref somehow, it just needs a comment.
