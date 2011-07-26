Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1GZAlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:41:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48394 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:41:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:references:date:
	in-reply-to:message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=D17puO/IojH5HxgHzoSxVR39JGB7enrGv9Dn153iu8mRo6rlXcW9e7mcb9PzuHyiL
	rFQhnUr+c8ElCLfZ7EiEg==
From: Ian Lance Taylor <iant@google.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, gcc-help@gcc.gnu.org,
        stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	<CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
Date: Mon, 25 Jul 2011 17:41:02 -0700
In-Reply-To: <CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	(Arnaud Lacombe's message of "Mon, 25 Jul 2011 19:50:26 -0400")
Message-ID: <mcrfwltoov5.fsf@coign.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Lacombe <lacombar@gmail.com> writes:

> gcc will only emits the warning at -Os. It seems to me that the
> resulting code clearly ends-up testing an uninitialized value, ie.
> assuming the following test-case:
>
> extern void *e(void);
> extern void *f(void);
> extern void g(void);
>
> void fn(void)
> {
>         void *b, *a;
>
>         a = e();
>         if (a != 0)
>                 b = f();
>         if (a != 0 && b != 0)
>                 g();
> }
>
> ...
>
> It seems gcc transforms the conditional from:
>
> if (a != NULL && b != NULL) ...
>
> to
>
> if (b != NULL && a != NULL) ...
>
> In which case the warning is fully valid. I'm not sure what's the C
> standard guarantee in term of conditional test order. gcc 4.7.0 has
> the same behavior.

Not quite.  C guarantees that && is executed in order.  In this case gcc
is generating

  a = e();
  if (a != NULL)
    b = f();
  if (a != NULL & b != NULL)
    g();

Note the change from && to & in the last conditional.  This
transformation is safe, in that it does not change the meaning of the
program.  However, it does cause a read of an uninitialized memory
location, and this is causing a later gcc pass to generate a false
positive warning.

Please consider filing a bug report about this false positive.  Thanks.

Ian
