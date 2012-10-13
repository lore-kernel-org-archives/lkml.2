Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab2JMRXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 13:23:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44464 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2JMRXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 13:23:20 -0400
MIME-Version: 1.0
In-Reply-To: <5079012A.90407@halfdog.net>
References: <20121012023240.GA24232@www.outflux.net>
	<20121012185037.GJ24964@outflux.net>
	<5079012A.90407@halfdog.net>
Date: Sat, 13 Oct 2012 10:23:18 -0700
X-Google-Sender-Auth: SobuTqcuC2R-GzVkkfLn7m3_m-A
Message-ID: <CAGXu5j+4rb=LZcxYDzHGdV4BmA8g1FMEYx7KDnysBmQpE_iAjA@mail.gmail.com>
Subject: Re: [PATCH] binfmt_script: do not leave interp on stack
From: Kees Cook <keescook@chromium.org>
To: halfdog <me@halfdog.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 10:50 PM, halfdog <me@halfdog.net> wrote:
> Kees Cook wrote:
>> More importantly, I also wonder if interp handling to just be
>> changed to be an allocation that needs to be cleaned up, as done with
>> argv?
>
> You mean like an allocation on the stack of the new process' growing
> stack? This would be cleaned automatically if something goes wrong
> during exec.

Either in userspace like argv, or just a straight kmalloc.

Looking at the code, the problem is that binfmt_script and binfmt_misc
are "rewrite" hacks (they change the bprm instead of actually starting
a process), and the module loading is a hack in that it retries all
the loaders a second time. These two hacks together aren't very
compatible if the error path of the rewrite hacks expects to see the
bprm go away instead of getting retried.

I'm concerned that the proposed patch is really just a band-aid on top
of a broken design.

To make this safe, either the bprm needs to be explicitly copied for
each recursion attempt (so the post-module-load retry starts with a
clean bprm), or everything about the bprm needs to stay off the stack
(to allow rewrite modifications to be stable).

I think the latter approach is best since it means we don't have to
execute the rewrite logic twice. It just means we must take a closer
look at the lifetime of that structure and make sure we're cleaning it
up correctly.

-Kees

-- 
Kees Cook
Chrome OS Security
