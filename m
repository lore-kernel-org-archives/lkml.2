Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab2GKQzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:55:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33084 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932081Ab2GKQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:55:44 -0400
Message-ID: <1342025743.13724.102.camel@joe2Laptop>
Subject: Re: pr_cat() + CATSTR(name, size)?
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 09:55:43 -0700
In-Reply-To: <CAPXgP13ff+eFH_jJ+0FDX0-GkuZj3RSv7VCp3ftcsGzA412FVQ@mail.gmail.com>
References: <1342002808.810.12.camel@mop>
	 <1342018897.13724.61.camel@joe2Laptop>
	 <CAPXgP11XnrFayb-g5HFu3wPtw8=xLfSY7HNCCbiSoehj8KsGcw@mail.gmail.com>
	 <1342020647.13724.71.camel@joe2Laptop>
	 <CAPXgP13ff+eFH_jJ+0FDX0-GkuZj3RSv7VCp3ftcsGzA412FVQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:48 +0200, Kay Sievers wrote:
> On Wed, Jul 11, 2012 at 5:30 PM, Joe Perches <joe@perches.com> wrote:
> > Well, I think the malloc costs are pretty low
> > and could devolve pretty easily when OOM.
> 
> We need to avoid allocating memory in situations where we want to
> printk(), it's just not possible.

"it's just not possible???"  Kay, them's fightin' words. :)

> That's why all the kmsg/printk can
> not really do any plain malloc. All printk memory needs to be static,
> on the stack or somehow pre-allocated.

Maybe, I was planning to play with it after
refactoring printk in the next couple releases.

> > Anyway, interesting idea, keep at it, see what
> > comes out of it.
> 
> Just depends on us, I guess. :)

Yup.

If your solution is just for the dev_<level> messages
(ie: with vprintk_emit descriptors), then it's not
too ugly.

Did you look at the remaining dev_<level> and printk
continuations grep pattern?  There really aren't too
many to fix up.

Maybe in 3.6.  None of them appear particularly urgent.

One trivial style note:

Maybe CATSTR could use a struct and a DECLARE_ macro?

struct printk_continuation_buffer {
	size_t length;
	size_t pos;
	char buf[];
}

It's a pity gcc doesn't allow non-static declarations like:

#define DECLARE_PRINTK_BUF(name, size)		\
struct printk_continuation_buffer name = {	\
	.length = size;				\
	.pos = 0;				\
	.buf[size] = {0};			\
}

So maybe a DECLARE/DESTROY thing could work
with the appropriate malloc/free.

cheers, Joe

