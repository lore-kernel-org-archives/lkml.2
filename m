Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031299Ab2CVWMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:12:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33708 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab2CVWMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <m1vclw1fx8.fsf@fess.ebiederm.org>
References: <20120313005855.GA24639@redhat.com> <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
 <20120318192755.GB6589@ZenIV.linux.org.uk> <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
 <m1vclw1fx8.fsf@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Thu, 22 Mar 2012 19:12:26 -0300
Message-ID: <CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 6:31 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
>> On Sun, Mar 18, 2012 at 4:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Sun, Mar 18, 2012 at 12:02:04PM -0700, Linus Torvalds wrote:
>>>> and that load is from
>>>>
>>>>     poll_wait(filp, &table->poll->wait, wait);
>>>>
>>>> where the testing of %rsi and %rcx are the "if (p && wait_address)"
>>>> check in poll_wait(), and %rsi is "table->poll" if I read it all
>>>> correctly.
>>>>
>>>> And the 6b6b6b6b6b6b6b6b pattern is obviously POISON_FREE, so
>>>> apparently 'table' has already been freed.
>>>>
>>>> I suspect the whole sysctl 'poll' code is seriously broken, since it
>>>> seems to depend on those ctl_table pointers being stable over the
>>>> whole open/close sequence, but if somebody unregisters the sysctl,
>>>> it's all gone. The ctl_table doesn't have any refcounting etc, and I
>>>> suspect that your hibernate sequence ends up unregistering some sysctl
>>>> (perhaps as part of a module unload?)
>>
>> How could that happen if the only files that support poll  right now
>> on sysctl are kernel/hostname and kernel/domainname?
>>
>>>
>>> Ewww...  The way it was supposed to work (prio to ->poll() madness) was
>>> that actual IO gets wrapped into grab_header()/sysctl_head_finish()
>>> pair.  proc_sys_poll() doesn't do it, so yes, that post-mortem is
>>> very likely to be correct.
>>
>> Yes, it  seems like I forgot to call grab_header() there, sorry for
>> that. I'll prepare a patch and send you later today. I just wonder
>> what is happening to reach that code... :-/
>
> It looks like it was a combination of the fuzzer doing silly things
> and a removed ctl_table entry being poisoned and having .poll set
> to 6b6b6b6b6b6b6b6b so the guard against calling poll when it is
> nonsense did not trigger.  So your patch should be sufficient
> for now.

What I understood afterwards was:

1. fuzzer calling poll() on files that did support poll
2. modules that created that sysctl entries were removed
3. 'table' was entirely removed (not ->poll).

>
> Long term we still need a version of poll that is safe to use
> with modules.

I think the way it's now (with my patch taken by Andrew) is safe for
having poll() with modules.


Lucas De Marchi
