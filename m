Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2DIXhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:37:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45649 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753491Ab2DIXhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:37:47 -0400
Message-ID: <1334014666.3228.33.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Mon, 09 Apr 2012 16:37:46 -0700
In-Reply-To: <20120409160803.27bc1376.akpm@linux-foundation.org>
References: <1333415903.860.0.camel@mop>
	 <1333420612.26079.6.camel@joe2Laptop>
	 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
	 <20120409160803.27bc1376.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 16:08 -0700, Andrew Morton wrote:
> On Tue, 3 Apr 2012 05:00:10 +0200
> Kay Sievers <kay@vrfy.org> wrote:
> 
> > > Maybe it'd be better to aggregate content rather like
> > > printk does. __Aggregate until you get a newline or a
> > > new KERN_<LEVEL>
> > 
> > The continuation printk() can can always go wrong when multiple
> > threads do that in parallel. We can try to make it better with a
> > per-cpu buffer, but I guess there will always be a situation where
> > this can happen.
> 
> Maybe we can be a bit smarter.  For example, if `current' is unchanged
> and __builtin_return_address(0) is unchanged, keep on buffering.

There are dozens to hundreds of existing sequences
like:

void some_func(...)
{
	printk("some additional data");
}

...

void some_device_init(...)
{
	...
	printk([KERN_LEVEL or not] "some initiator")
	some_func();
	printk("\n");
}

> It's all a bit hacky, but weeding out all those thousands of printks
> which never get printed anyway doesn't sound much fun either.

Nope.  That isn't any fun.

So given the example above, maybe check if the
initial printk's __builtin_return_address(0) exists
in some level of the stack say up to 3 deep for each
subsequent printk.

I don't remember any threads spun off to emit printk
continuation lines so maybe that'd work reasonably
well.

> All a bit of a pain.

Too true.


