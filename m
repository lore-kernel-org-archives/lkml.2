Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab2H1Tns (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 15:43:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53733 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2H1Tnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 15:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120828170908.GA14655@kroah.com>
References: <20120827203215.GA16637@www.outflux.net>
	<20120828144110.GA23035@thunk.org>
	<20120828170908.GA14655@kroah.com>
Date: Tue, 28 Aug 2012 12:43:45 -0700
X-Google-Sender-Auth: DUmec1CQIFT8JiCVwL_L8ny70v4
Message-ID: <CAGXu5jKvhxHO3JDoBb0GD_nSi3n0pMc5y=_CpL7RsCD1XPKFkQ@mail.gmail.com>
Subject: Re: Hardening debugfs (Was Re: [PATCH] debugfs: more tightly restrict
 default mount mode)
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, Rob Landley <rob@landley.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ludwig Nussel <ludwig.nussel@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:09 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 28, 2012 at 10:41:10AM -0400, Theodore Ts'o wrote:
>> On Mon, Aug 27, 2012 at 01:32:15PM -0700, Kees Cook wrote:
>> > Since the debugfs is mostly only used by root, make the default mount
>> > mode 0700. Most system owners do not need a more permissive value,
>> > but they can choose to weaken the restrictions via their fstab.
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> I agree with this patch, but it would also be good if we could try to
>> harden debugfs in general.  Some ideas that might be worth discussing,
>> for example?
>>
>> 1) Adding a per-module flag, so things in debugfs only show up if they
>> are explicitly requested (you know, for debugging purposes).  If most
>> people are using debugfs for access to ftrace and powertap (my use
>> case), there's no point making directories for other device drivers
>> and file systems visible.
>
> The module code is "explicitly requesting" a debugfs file when it makes
> the call to create it.  If you want to depend on a flag for the
> individual modules to do this or not, sure, go ahead, but that's a
> module/driver issue, nothing I can do in the debugfs core itself.
>
>> 2) Can we find a pattern of common security #fail's with debugfs
>> files, and try to sweep through and fix them?
>
> The only one I know of is the "unload the module with an open file
> handle" issue.  I'm pretty sure this could be fixed up somehow in
> debugfs, much like it was resolved in sysfs, but it would take a lot of
> work, for a very limited benefit (in other words, if someone sends me
> patches for this, great, but it's so low on my TODO list that I'll
> probably never get to it myself.)

Staying after world-writable files is probably the biggest deal
(though this has been checked for in the past after problems
surfaced). I think the main reason I've wanted to push for 0700 was
just because the scope of the problems is so large. It could be as
simple as leaking kernel (or userspace) address locations (allowing
ASLR bypass, or heap location predictability) or other side-effects
from world-readable files, all the way to weird ioctl flaws in
world-writable files. In general, since debugfs is specifically
designed to have unstructured contents, it's not particularly trivial
to be able to reason about how those contents can be best protected.
As such, I just wanted to isolated it.

-Kees

-- 
Kees Cook
Chrome OS Security
