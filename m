Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0DNBdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:33:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1465 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab0DNBdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:33:23 -0400
Subject: Re: [REGRESSION PATCH] vsprintf: increase sizeof precision in
 printf_spec
From: Joe Perches <joe@perches.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 18:33:21 -0700
Message-ID: <1271208801.1555.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 21:13 -0400, Eric Paris wrote:
> Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
> from and int to an s8.  Problem is that we have code which uses a much larger
> precision in the kernel.  An example would in the audit code where we have:
> 
> vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> 
> which causes precision to be too large and end up truncating to nothing.
> Raising the size of the precision fixes the audit system issue.  It also does
> not affect the alignment of the struct according to pahole and is still
> approprietely packed.

I don't see how it could be appropriately packed.

This is the structure now:

struct printf_spec {
	u16	type;
	s16	field_width;	/* width of output field */
	u8	flags;		/* flags to number() */
	u8	base;
	s8	precision;	/* # of digits/chars */
	u8	qualifier;
};

Adding another char should make the structure larger than 64 bits.

type isn't currently required to be u16.
It could be u8.

Perhaps this is better.

struct printf_spec {
	u8 type;
	u8 flags;		/* flags to number() */
	u8 base;
	u8 qualifier;
	s16 field_width;	/* width of output field */
	s16 precision;		/* # of digits/chars */
} __attribute__((packed));

