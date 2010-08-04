Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab0HDFn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 01:43:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40078 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0HDFn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 01:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <1280894427.11045.293.camel@mulgrave.site>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
	<1280851338.2774.30.camel@mulgrave.site>
	<AANLkTinJ2jy18bAS-=abtDLaQWVmQdK1Oq105FcNDNyJ@mail.gmail.com>
	<1280894427.11045.293.camel@mulgrave.site>
Date: Tue, 3 Aug 2010 22:43:19 -0700
Message-ID: <AANLkTikn4NhRW8v7CFfo7Yb6+-pmun+DiArGJdkq_vYr@mail.gmail.com>
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/3 James Bottomley <James.Bottomley@suse.de>:
> On Tue, 2010-08-03 at 15:08 -0700, Arve Hjønnevåg wrote:
>> 2010/8/3 James Bottomley <James.Bottomley@suse.de>:
>> > On Mon, 2010-08-02 at 21:18 -0700, Arve Hjønnevåg wrote:
>> >> > o       A power-aware application must be able to efficiently communicate
>> >> >        its needs to the system, so that such communication can be
>> >> >        performed on hot code paths.  Communication via open() and
>> >> >        close() is considered too slow, but communication via ioctl()
>> >> >        is acceptable.
>> >> >
>> >>
>> >> The problem with using open and close to prevent an allow suspend is
>> >> not that it is too slow but that it interferes with collecting stats.
>> >
>> > Please elaborate on this.  I expect the pm-qos stats interface will
>> > collect stats across user open/close because that's how it currently
>> > works.  What's the problem?
>> >
>>
>> The pm-qos interface creates the request object in open and destroys
>> it in release just like the suspend blocker interface. We need stats
>> for each client which is lost if you free the object every time you
>> unblock suspend.
>
> ? right at the moment it doesn't do stats.  I don't see why adding a per
> pid or per name stat count on the long lived object won't work here.
>
>> Or are you talking about user space opening and closing the stats
>> interface (which does not cause any problems)?
>
> There is no stat interface yet; it's for us to define.
>

Then I don't know what you are asking. This specific requirement was
about the userspace interface to block and unblock suspend. The
existing pm-qos interface to update pm-qos requests is similar to the
user space suspend blocker interface (it has the same object
lifetime).

>> >> The wakelock code has a sysfs interface that allow you to use a
>> >> open/write/close sequence to block or unblock suspend. There is no
>> >> limit to the amount of kernel memory that a process can consume with
>> >> this interface, so the suspend blocker patchset uses a /dev interface
>> >> with ioctls to block or unblock suspend and it destroys the kernel
>> >> object when the file descriptor is closed.
>> >
>> > This is an implementation detail only.
>>
>> There is no way fix it without changing the user space visible
>> behavior of the API. The kernel does not know when it is safe to free
>> the objects.
>
> They're freed on destruction of the long lived kernel object or on user
> space clear request.  Surely that's definitive enough?
>

What is a user-space clear request? Clearing all stats. Deleting a
suspend blocker? Unblocking suspend?

The android wakelock interface to userspace creates new wakelocks
every time it sees a new name. This was rejected on this list because
it does not put any limit on the amount of kernel memory used as a
result of calls from user space.

>> > The pm-qos objects are long
>> > lived, so their stats would be too.  I would guess that explicit stat
>> > clearing might be a useful option.
>> >
>>
>> Which pm-qos objects are you referring to? The struct pm_qos_object
>> that backs each pm-qos class is long lived (I don't know why this is
>> named pm_qos_object), but we need stats in struct pm_qos_request_list.
>
> Actually, why not two separate lists?  one for the request and one for
> the stats?
>
Why do you want to do another lookup? Is there a reason you don't want
stats in pm_qos_request_list?

> OK, so I'm tired and I've had a long flight to get to where I am, so I
> may be a bit jaded, but this isn't fucking rocket science the question
> is how do we implement what you want on what we have ... there looks to
> be multiple useful solutions ... we just have to pick one and agree on
> it (that's standard open source).
>

I don't think adding stats to pm-qos is hard. It is not as easy as the
wakelock/suspend blocker interface since the number of possible
request values is unknown, but we could for instance have stats on
default vs non-default request values. However, it is not at all clear
that switching our code to the pm-qos interface would make it
acceptable for mainline inclusion. The main objections to the last
suspend blocker patchset seemed to be that we should not use suspend
at all. There are also some new api in linux-next that try to solve
the same problem in an non android compatible way. Are drivers
supposed to use both this interface and pm-qos to prevent suspend?

-- 
Arve Hjønnevåg
