Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab2DFTF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:05:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab2DFTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:05:23 -0400
Date: Fri, 6 Apr 2012 12:05:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liu Yu" <liuyums@bwstor.com.cn>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Wrong use of MAX_JIFFY_OFFSET?
Message-Id: <20120406120521.1a6dcd1b.akpm@linux-foundation.org>
In-Reply-To: <006001cd0cb2$20f547b0$62dfd710$@com.cn>
References: <006001cd0cb2$20f547b0$62dfd710$@com.cn>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 15:12:24 +0800
"Liu Yu" <liuyums@bwstor.com.cn> wrote:

> Hi guys,
> 
> I saw a couple of places in current kernel have this kind of code:
> 
> > static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> > {
> >         unsigned long end = jiffies;
> >
> >         if (end >= start)
> >                return jiffies_to_msecs(end - start);
> >
> >         return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> > }
> 
> As you know, jiffies has a type of unsigned long, so if we know which is the
> end and
> which is the start, then (end - start) can simply figure out how much
> jiffies flies,
> without worry about the overflow.
> 
> Look at the code above, assume that there is just an overflow happening on
> jiffies: end=0 and start=~0UL.
> Since end < start, then the return value of the function is
> jiffies_to_msecs(MAX_JIFFY_OFFSET+2).
> But shouldn't the correct value be jiffies_to_msecs(1)?
> 
> could someone tell me that am I missing anything?
> 

Seems right.  The code should be

static inline unsigned long elapsed_jiffies_msecs(unsigned long start)
{
	return jiffies_to_msecs(jiffies - start);
}

Note the return type.  jiffies_to_msecs() currently returns unsigned
int.  I think it should return unsigned long.  Even then, it can still
overflow with valid inputs on HZ=100 32-bit machines.

