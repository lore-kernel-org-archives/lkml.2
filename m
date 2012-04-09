Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab2DIXII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 19:08:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2DIXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 19:08:06 -0400
Date: Mon, 9 Apr 2012 16:08:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
Message-Id: <20120409160803.27bc1376.akpm@linux-foundation.org>
In-Reply-To: <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
References: <1333415903.860.0.camel@mop>
	<1333420612.26079.6.camel@joe2Laptop>
	<CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 05:00:10 +0200
Kay Sievers <kay@vrfy.org> wrote:

> > Maybe it'd be better to aggregate content rather like
> > printk does. __Aggregate until you get a newline or a
> > new KERN_<LEVEL>
> 
> The continuation printk() can can always go wrong when multiple
> threads do that in parallel. We can try to make it better with a
> per-cpu buffer, but I guess there will always be a situation where
> this can happen.

Maybe we can be a bit smarter.  For example, if `current' is unchanged
and __builtin_return_address(0) is unchanged, keep on buffering.

It's all a bit hacky, but weeding out all those thousands of printks
which never get printed anyway doesn't sound much fun either.

> -	printk(")");
> +	printk(KERN_CONT ")");

And I do think we should avoid doing it that way, if only because it
consumes 10 display columns and makes a mess.  Maybe use pr_cont()? 
But that implies that the affected code is using the pr_foo()
facilities, and a lot of it doesn't.  So maybe a new macro.

All a bit of a pain.
