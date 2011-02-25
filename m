Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab1BYMWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 07:22:04 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56356 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1BYMWD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 07:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dUAslIip/xEc1iSQB7n6o2/DjnZi8jiMLfVtCVFk+XtYc8dYLQg7iF5U45Lqq5spSV
         /hTKtXQ8GWeIQ59lEaug==
MIME-Version: 1.0
In-Reply-To: <201102251140.46893.arnd@arndb.de>
References: <1298506377-16796-1-git-send-email-mikew@google.com>
 <201102241519.44336.arnd@arndb.de> <AANLkTim3Zcgi8joipid=tGtLF70=pqa5ViRtbsiWru38@mail.gmail.com>
 <201102251140.46893.arnd@arndb.de>
From: Mike Waychison <mikew@google.com>
Date: Fri, 25 Feb 2011 04:21:37 -0800
Message-ID: <AANLkTi=8S4=vEUNHR6zD8d1or6BS_o9k4nPg4he+Kik2@mail.gmail.com>
Subject: Re: [klibc] [PATCH] build: Define __EXPORTED_HEADER__
To: Arnd Bergmann <arnd@arndb.de>
Cc: klibc@zytor.com, maximilian attems <max@stro.at>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 2:40 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 25 February 2011, Mike Waychison wrote:
>> On Thu, Feb 24, 2011 at 6:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 24 February 2011, Mike Waychison wrote:
>> >> The kernel header guard to ensure that headers aren't included from
>> >> userland moved in commit 69c8f52b.  This causes the following message to
>> >> be emitted when building klibc (which is designed to use kernel headers
>> >> explicitly):
>> >>
>> >> /usr/local/src/git/linux-2.6//include/linux/types.h:13:2: warning: #warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
>> >>
>> >> In order to silence this warning, make sure we define
>> >> __EXPORTED_HEADERS__ when building klibc userland.
>> >>
>> >> Signed-off-by: Mike Waychison <mikew@google.com>
>> >
>> > Well, klibc uses the kernel headers, but I don't think it's a good idea
>> > to use them directly without make headers_install. Since klibc also
>> > doesn't set -D__KERNEL__, the result should be the same, except that
>> > it makes sure not to use any headers that are meant to be internal.
>>
>> I'm not sure I follow.  The warning happens when __KERNEL__ isn't set.
>>
>> Also, the build for klibc explicitly supports using kernel headers
>> without installing them first via setting KLIBCKERNELSRC.
>
> My point was that klibc should perhaps no longer support this. When klibc
> was initially written, we did not have a way to install kernel headers and
> distros shipped a set of hand-crafter modified kernel headers. This is no
> longer the case since the kernel headers now work for all other libc
> implementations after installing.
>
> Is there still any benefit in allowing klibc to be built without
> installing the headers?

Well, it's useful for users (like us) that have environments where we
build a single vmlinux image given upstream kernel.org linux and klibc
trees.

> For instance, it should be easy to change the klibc build process from
> requiring to link to the kernel source to automatically installing the
> kernel headers into the klibc object directory.

I'm not against this idea, but is this something that works (and that
people can actually do given the state of the klibc tree at this
point)?

Maybe I don't understand what benefit is had by having a separate
install_headers step that does not much more than copy headers from
the kernel source tree into the klibc object tree as part of the
vmlinux build.

I believe the original motivation of klibc was to maintain a minimal
libc implementation that would mature to the point where we are
capable of building userland binaries in the kernel source tree (so
that some hairy legacy functionality currently implemented in
kernel-space could be cleaned up and moved into early-userspace
targets). I don't know why this effort has subsided, though I can
imagine that lack of will and time were large factors.

What you are proposing seems to me like a step towards giving up on
this noble goal :(

*sigh* At the other end of the spectrum is the fact that we now build
userland targets out of the kernel source tree, but that seems to be
more of a convenience-in-versioning issue than anything else. The
build environment has become pretty reliant on there being a whole GNU
based LSB environment setup for userland, which on a per-unit basis
isn't the de-facto standard anymore.  It'd be nice to hit some middle
ground here.
