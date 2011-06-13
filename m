Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1FMO27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:28:59 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60469 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1FMO24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dYplKSjoRpXThOPaAIydMur9awp8LrRoVPDCl2YK56TbL/G169DLKcZ0kmHpMgHhSs
         vTiXf2x+VmCN0rusbgd8/JMoKlUIKfM5ZXoVgv0zMpQqG6glFhECEke2r6oWk4U6KQ8Z
         FcBrU1FPoQGjLaFHoMp2m/zfltc78FBXtLu5g=
MIME-Version: 1.0
In-Reply-To: <m14o3vukqg.fsf@fess.ebiederm.org>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
 <BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com> <m18vtkq57c.fsf@fess.ebiederm.org>
 <BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com> <20110602134338.0c56160e@lxorguk.ukuu.org.uk>
 <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com> <m1hb88e3qs.fsf@fess.ebiederm.org>
 <BANLkTin5P8P_HR78qo0oyzeu9hpWazZqTw@mail.gmail.com> <m14o3vukqg.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 13 Jun 2011 16:28:41 +0200
Message-ID: <BANLkTimFiR0x9LQg3wQOX7wUULSg8tsaUA@mail.gmail.com>
Subject: Re: [PATCH] sysctl: add support for poll()
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 17:34, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>> On Thu, Jun 2, 2011 at 15:56, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>>
>>>> With this patch in, if anyone wants to manage a file under /proc/sys
>>>> there's really a small amount of code to write. He only has to define
>>>> the new poll struct for that file.
>>>
>>> The support currently appears cumbersome to add, and it adds what appear
>>> to be unnecessary wake ups (say when the hostname in another uts
>>> namespace changes).
>>
>> Yeah, *possibly* waking up once a day compared to *unconditionally*
>> waking up every second in every namespace and check if something has
>> changed. If that *possibly* should be optimized, which I think isn't
>> necessary at all, I guess the logic could be moved down to the
>> namespaced data.
>
> Unless you happen to be on a system, where someone has decided that it
> has a daemon that likes creating a new set of namespaces per connection
> to reduce the effect of code bugs.  At which point you could be talking
> much more than a wake up per second.

What do you mean? We talk about changing the hostname, right? How
often do we expect that to happen?

You mean every network connection mounts a proc filesystem and runs a
service that polls hostname files there?

>>> There is no explanation at all of why you care about the nis domainname.
>>
>> Just the same reason as the hostname, we need to know when the
>> kernel's internal state changes. regardless who did it and why, system
>> services need to follow it.
>
> So the problem is that you have a system where userspace can't get it's
> act together?

There will never be a layer between the kernel and userspace that is
centrally managed. The kernel keeps the authoritative data, so we need
to know when _this_ data changes, not when some imaginary middle man
might manage it.

It will just never happen in reality, we stopped long ago being so
naive. And 'getting the act together' today is 'watching what people
did' to the kernel data, not tell them how to do it, or not to do it.

We can change some parts sometimes, and recommend some sanity, but
surely nobody will patch all the 15 dhcp clients to work with some
strange higher-level hostname interface here. People use the syscall
to set it, and there is nothing wrong with it, we just need to know
it.

>>> Since there does not appear to be a specific problem that this problem
>>> is being aimed at, since the code just looks like extra maintenance and
>>> since the code needed to support this appears to be unnecessarily
>>> cumbersome I am going to nack the patch for now.
>>>
>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> Please provide solid technical reasons, why we can't to the same we do
>> everywhere else since years, or provide working alternatives. Until
>> then:
>>
>> Acked-By: Kay Sievers <kay.sievers@vrfy.org>
>
> Looking a little closer the patch is broken.
>
> It changes the return of poll for every file under /proc/sys reporting
> no file under /proc/sys is writable unless it implements the new poll
> method.

Poll is undefined for regular files, or proc/sys files which don't
implement it. What do you mean with writable? How does not providing
poll() affect write()?

> Also with having the wait_queue owned by the calling code either I am
> mistake or this breaks hotplug type situations.  How do you get things
> off of your wait queue when you remove a file from /proc/sys.
>
> This
> infrastructure as written looks like a setup for use after free
> problems.

The wait queue is in static non-allocated code. What do you mean?

>> I think poll() is the natural interface if you care about the data in
>> a file. It's the same an single fd you care, and not some iniotify
>> watch, fd, pathname to register, and filter for whatever comes out
>> there.
>
> Sort of.  poll is really designed for socket and pipe data.
>
> The problem with poll is there is no POLLUPDATED.

Right, hence we use POLLERR|POLLPRI, to indicate something has
changed. The case is kind of special because poll does not tell 'there
is more to read' but 'something happend, re-read it again'.

>> We already use exactly the same semantics for quite some years for
>> /proc/mounts, /proc/swaps, /proc/mdstat, ... and all over /sys. The
>> patch just provides the missing pieces that /proc provides, but
>> /proc/sys is missing.
>
> Good point.
>
> There is still the problem that the infrastructure code for the proc
> sysctl files are in much worse shape than the sysfs files.
>
>> I don't disagree, it might be nice to have generic inotify support on
>> /proc for this or other problems. But unless you want to work on it
>> now, and it would solve these problems, I don't see how we can get the
>> functionality we need, and that seems to solved with this patch.
>> Besides the fact that I think poll() is the simple and better
>> solution.
>
> Which is a question that has never been answered.

Sure, any other easy-to-use and easy-to-get-working interface you have
in mind? We can certainly use something else if it can provide us with
the updates we are looking for.

> What functionality
> do you need?  To me this all looks like a bad science experiment.

We need a simple interface to detect changes to the hostname data in
the kernel. It does not matter if the proc file is written or
sethostname() or hostname(1) is used. Any source of such change needs
to be propagated to running system services, to adapt to the new
hostname.

Kay
