Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162Ab2DLIEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 04:04:49 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:54723 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2DLIEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 04:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <201204112147.55348.remi@remlab.net>
References: <1333648371-24812-1-git-send-email-remi@remlab.net>
	<4F85B908.4070404@redhat.com>
	<201204112147.55348.remi@remlab.net>
Date: Thu, 12 Apr 2012 09:04:42 +0100
Message-ID: <CAAMvbhHviuwC0ik2ZY91ZgN4hZyqUbuk=qVcAOH0VYMhva4LeA@mail.gmail.com>
Subject: Re: [RFC] [PATCH] v4l2: use unsigned rather than enums in ioctl() structs
From: James Courtier-Dutton <james.dutton@gmail.com>
To: =?UTF-8?Q?R=C3=A9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/11 Rémi Denis-Courmont <remi@remlab.net>:
>        Hello,
>
> Le mercredi 11 avril 2012 20:02:00 Mauro Carvalho Chehab, vous avez écrit :
>> Using unsigned instead of enum is not a good idea, from API POV, as
>> unsigned has different sizes on 32 bits and 64 bits.
>
> Fair enough. But then we can do that instead:
> typedef XXX __enum_t;
> where XXX is the unsigned integer with the right number of bits. Since Linux
> does not use short enums, this ought to work fine.
>
>> Yet, using enum was really a very bad idea, and, on all new stuff,
>> we're not accepting any new enum field.
>
> That is unfortunately not true. You do follow that rule for new fields to
> existing V4L2 structure. But you have been royally ignoring that rule when it
> comes to extending existing enumerations:
>
> linux-media does regularly add new enum values to existing enums. That is new
> stuff too, and every single time you do that, you do BREAK THE USERSPACE ABI.
> This is entirely unacceptable and against established kernel development
> policies.
>
> For instance, in Linux 3.1, V4L2_CTRL_TYPE_BITMASK was added. This broke
> userspace. And there are some pending patches adding more of the same thing...
> And V4L2_MEMORY_DMABUF will similarly break the user-to-kernel interface,
> which is yet worse.
>

I agree that breaking user-to-kernel interface is not advised.
We came across a similar problem some years ago with the ALSA sound
kernel drivers.
The solution we used was:
1) If a change is likely to change the user-to-kernel API, add a new
IOCTL for it.
Then old userland software can use the old IOCTL, and new userland
software can use the new IOCTL.
2) Add an version IOCTL that returns the current API level, so that
the app can be written to support more than one API interface,
depending on which kernel it is running on. The version IOCTL simply
returns an u32 value. This is a consistent part of the user-kernel API
that will never change.
3) Add "depreciated" compiler warnings to all the old API IOCTL calls,
so app developers know they should be working to update their apps.
4) After a few years, remove the old IOCTLs.
5) Use "uint32_t" and "uint64_t" types for all IOCTL calls, and not
"unsigned int" or "unsigned long int".
I.e. All structures passed in IOCTLs use fixed bit sized parameters
for everything except of course pointers. Pointers depend on
architecture.
6) Add a #if #endif around the old API, so a user compiling their own
kernel can decide if the old API exists or not. User might want to do
this for security reasons.

Kind Regards

James
