Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0DNDBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:01:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1468 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab0DNDBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:01:44 -0400
Subject: Re: [REGRESSION PATCH] vsprintf: increase sizeof precision in
 printf_spec
From: Joe Perches <joe@perches.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1271213041.3008.35.camel@dhcp235-240.rdu.redhat.com>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
	 <1271208801.1555.12.camel@Joe-Laptop.home>
	 <1271213041.3008.35.camel@dhcp235-240.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 20:01:42 -0700
Message-ID: <1271214102.1555.27.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 22:44 -0400, Eric Paris wrote:
> On Tue, 2010-04-13 at 18:33 -0700, Joe Perches wrote:
> > On Tue, 2010-04-13 at 21:13 -0400, Eric Paris wrote:
> > > Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
> > > from and int to an s8.  Problem is that we have code which uses a much larger
> > > precision in the kernel.  An example would in the audit code where we have:
> > > 
> > > vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> > > 
> > > which causes precision to be too large and end up truncating to nothing.
> > > Raising the size of the precision fixes the audit system issue.  It also does
> > > not affect the alignment of the struct according to pahole and is still
> > > approprietely packed.
> > 
> > I don't see how it could be appropriately packed.
> 
> I was just saying there was no padding inside the struct, although you
> are right about it now being longer than 64.

Which is bad.

> But what does __attribute__((packed)) buy us?

It could force the size to be 64 bits on more platforms.

> I'll gladly resend with u8 type and s16 precision if that's the best
> solution.

Reordering struct members to keep width and precision
together seems appropriate.  The attribute may not be.

struct printf_spec {
	u8 type;
	u8 flags;		/* flags to number() */
	u8 base;
	u8 qualifier;
	s16 field_width;	/* width of output field */
	s16 precision;		/* # of digits/chars */
};


