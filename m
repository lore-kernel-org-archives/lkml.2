Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab1IIMpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:45:02 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:37729 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab1IIMpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:45:01 -0400
Message-ID: <2d14558326f860dea54093d31d1ba12f.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109090824.37366.vda.linux@googlemail.com>
References: <201109090822.30063.vda.linux@googlemail.com>
    <201109090824.37366.vda.linux@googlemail.com>
Date: Fri, 9 Sep 2011 14:44:57 +0200
Subject: Re: [PATCH 1/2] ptrace: don't modify flags on PTRACE_SETOPTIONS
 failure
From: "Indan Zupancic" <indan@nul.nu>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org, dvlasenk@redhat.com,
        "Linus Torvalds" <torvalds@linux-foundation.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 12f61b0c8dc8dcc8c992b8e1fde77987
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, September 9, 2011 08:24, Denys Vlasenko wrote:
> It's very unlikely that there is userspace code in the wild which
> will be affected by this change: it should have the form
>
>     ptrace(PTRACE_SETOPTIONS, pid, 0, PTRACE_O_BOGUSOPT)
>
> where PTRACE_O_BOGUSOPT is a constant unknown to the kernel.
> But kernel headers, naturally, don't contain any
> PTRACE_O_BOGUSOPTs, thus the only way userspace can use one
> if it defines one itself. I can't see why anyone would do such
> a thing deliberately.

The only realistic case is when a program compiled on a newer
kernel is run on an older kernel, when it does things like

#ifndef PTRACE_O_TRACEFORK
	opts |= PTRACE_O_TRACEFORK;
#endif

and happened to work on older kernels because it didn't check
the return value.

With the current options the program has to change its behaviour
depending whether the options are available or not, so no problems
should happen in practice, because if a program counts on any
options that didn't exist before, it won't work anyway.

Code that cares about backward compatibility will check at runtime
if the PTRACE_SETOPTIONS fails, and do a new one without the unknown
options.

So it's best to fix this behaviour before introducing new options
that are harmless if the setting of them fails.

Greetings,

Indan


