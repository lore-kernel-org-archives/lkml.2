Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab2JYGVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:21:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55368 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab2JYGVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:21:23 -0400
MIME-Version: 1.0
In-Reply-To: <20121025041620.GH2616@ZenIV.linux.org.uk>
References: <20121024232032.GA31129@www.outflux.net>
	<20121025041620.GH2616@ZenIV.linux.org.uk>
Date: Wed, 24 Oct 2012 23:21:21 -0700
X-Google-Sender-Auth: dI87K6PX_avE8B6UAUwgOlDXBUU
Message-ID: <CAGXu5jLwvcpyMp8RcF8aFySKkkj+17ovNOvC_r88+D0fQW7CsQ@mail.gmail.com>
Subject: Re: [PATCH] exec: do not leave bprm->interp on stack
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-fsdevel@vger.kernel.org, halfdog <me@halfdog.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 9:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Oct 24, 2012 at 04:20:32PM -0700, Kees Cook wrote:
>> If a series of scripts are executed, each triggering module loading via
>> unprintable bytes in the script header, kernel stack contents can leak
>> into the command line.
>>
>> Normally execution of binfmt_script and binfmt_misc happens
>> recursively. However, when modules are enabled, and unprintable bytes
>> exist in the bprm->buf, execution will restart after attempting to load
>> matching binfmt modules. Unfortunately, the logic in binfmt_script and
>> binfmt_misc does not expect to get restarted. They leave bprm->interp
>> pointing to their local stack. This means on restart bprm->interp is
>> left pointing into unused stack memory which can then be copied into
>> the userspace argv areas.
>>
>> This changes the logic to require allocation for any changes to the
>> bprm->interp. To avoid adding a new kmalloc to every exec, the default
>> value is left as-is. Only when passing through binfmt_script or
>> binfmt_misc does an allocation take place.
>
> I really don't like that.  It papers over the problem, but doesn't really
> solve the underlying stupidity.  We have no good reason to retry a binfmt
> we'd already attempted on this level of recursion.  And your patch doesn't
> deal with that at all.

What should the code here _actually_ be doing? The _script and _misc
handlers expect to rewrite the bprm contents and recurse, but the
module loader want to try again. It's not clear to me what the binfmt
module handler is even there for; I don't see any binfmt-XXXX aliases
in the tree. If nothing uses it, should we just rip it out? That would
solve it too.

-Kees

-- 
Kees Cook
Chrome OS Security
