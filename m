Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0HHTbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:31:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48321 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0HHTbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MUL69ZpxDHJ6iaFLsng2OU6BLQlsoVAhVDkrApLKNHvAXMZseynlyaVi1hnaioAM30
         LVmDulgk8eGnkkfUmLTtmzTlflk76RAzV8e8ZFPYcXoM4GA7/u3IhmABXkuT6JvKnaaL
         vaBBLHmBLYL7J3q4MEp02hQbm6XfWVYLK0Fao=
MIME-Version: 1.0
In-Reply-To: <1281261789.2384.11.camel@localhost>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	<1281261789.2384.11.camel@localhost>
Date: Sun, 8 Aug 2010 12:31:40 -0700
Message-ID: <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
Subject: Re: [PATCH 0/6] improve list_sort test
From: Don Mullis <don.mullis@gmail.com>
To: dedekind1@gmail.com
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <dedekind1@gmail.com> writes:
> Actually, your 'list_sort()' version does have a problem. I found out
> that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
> cases 'a' and 'b' can point to something which is not a valid element of
> the original list. Probably a senitel or something like that.
>
> It is easy to work around this by adding:
>
> if (a == b)
>        return 0;
>
> in the 'cmp()' function, but this is nevertheless a bug (not too bad,
> though) and should be fixed.

Yes, invalid 'a' or 'b' pointers would be a bug.  If providing a test
case is hard, can you say what segment is pointed to?  Into the stack?
Into address ranges normal for elements, but not now on the list?  Is
there a pattern to the values returned?  Is it perhaps always the
first or last callback from a particular call to list_sort()?

That sometimes a==b is, on the other hand, by design:

	/*
	 * In worst cases this loop may run many iterations.
	 * Continue callbacks to the client even though no
	 * element comparison is needed, so the client's cmp()
	 * routine can invoke cond_resched() periodically.
	 */
	(*cmp)(priv, tail, tail);

Adding a sentence to the function header comment reminding callers
that they need to be able to handle a==b seems like a good idea.
