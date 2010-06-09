Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab0FIVWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:22:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab0FIVWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:22:07 -0400
Date: Wed, 9 Jun 2010 14:21:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Salman <sqazi@google.com>
cc: peterz@infradead.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>
Message-ID: <alpine.LFD.2.00.1006091408430.4506@i5.linux-foundation.org>
References: <20100609210014.7464.92234.stgit@bumblebee1.mtv.corp.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Salman wrote:
> +/*
> + * If we started walking pids at 'base', is 'a' seen before 'b'?
> + *
> + */
> +static int pid_before(int base, int a, int b)
> +{
> +	int a_lt_b = (a < b);
> +	int min_a_b = min(a, b);
> +	int max_a_b = max(a, b);
> +
> +	if ((base <= min_a_b) || (base >= max_a_b))
> +		return a_lt_b;
> +
> +	return !a_lt_b;
> +}

Ok, so that's a very confusing expression. I'm sure it gets the right 
value, but it's not exactly straightforward, is it?

Wouldn't it be nicer to write it out in a more straightforward way? 
Something like

	/* a and b in order? base must not be between them */
	if (a <= b)
		return (base <= a || base >= b);
	/* b < a? We reach 'a' first iff base is between them */
	return base >= b && base <= a;

would seem to be equivalent and easier to explain, no?

And when you write it that way, it looks like the compiler should be able 
to trivially CSE the five comparisons down to just three (notice how the 
"base <= a" and "base >= b" comparisons are repeated. Which I'm sure some 
super-optimizing compiler can do from your version too, but mine seems 
more straightforward.

But maybe I did that thing wrong, and I just confused myself. I have _not_ 
checked the logic deeply, somebody else should definitely double-check me.

		Linus
