Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0DNCoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 22:44:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0DNCoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 22:44:07 -0400
Subject: Re: [REGRESSION PATCH] vsprintf: increase sizeof precision in
 printf_spec
From: Eric Paris <eparis@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <1271208801.1555.12.camel@Joe-Laptop.home>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
	 <1271208801.1555.12.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 22:44:01 -0400
Message-ID: <1271213041.3008.35.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 18:33 -0700, Joe Perches wrote:
> On Tue, 2010-04-13 at 21:13 -0400, Eric Paris wrote:
> > Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
> > from and int to an s8.  Problem is that we have code which uses a much larger
> > precision in the kernel.  An example would in the audit code where we have:
> > 
> > vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> > 
> > which causes precision to be too large and end up truncating to nothing.
> > Raising the size of the precision fixes the audit system issue.  It also does
> > not affect the alignment of the struct according to pahole and is still
> > approprietely packed.
> 
> I don't see how it could be appropriately packed.

I was just saying there was no padding inside the struct, although you
are right about it now being longer than 64.

> type isn't currently required to be u16.
> It could be u8.
> 
> Perhaps this is better.
> 
> struct printf_spec {
> 	u8 type;
> 	u8 flags;		/* flags to number() */
> 	u8 base;
> 	u8 qualifier;
> 	s16 field_width;	/* width of output field */
> 	s16 precision;		/* # of digits/chars */
> } __attribute__((packed));

If we don't need the size in type I'm happy with this.

But what does __attribute__((packed)) buy us?  I always thought that was
frowned upon because it could put us in a position where if it does
affect the layout it destroys performance on systems where unaligned
access matters.  I don't think it is going to affect the alignment of
this struct, so I don't understand why we should add it.  But maybe I'm
misinformed....

I'll gladly resend with u8 type and s16 precision if that's the best
solution.

-Eric

