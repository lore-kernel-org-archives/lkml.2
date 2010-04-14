Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab0DNPFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:05:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64982 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab0DNPFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m9OOzbEZzkv/C4HSYPELIxlmuiujQrLXojAf/OHtwPig4T1I8ctKQhKXnoyKvg2KVl
         mOMadIHHroZltz2tZR+QZ0pjuHxxXIXLpcsgrWpQWebmrjm3XfaSK6VKs41Po3c1ltU2
         sI0GD4H16bey196N+kJCXTiZyRnRgqfwVZET4=
Date: Wed, 14 Apr 2010 17:00:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION PATCH] vsprintf: increase sizeof precision in
	printf_spec
Message-ID: <20100414150007.GD5142@nowhere>
References: <20100414011336.16139.68030.stgit@paris.rdu.redhat.com> <1271208801.1555.12.camel@Joe-Laptop.home> <1271213041.3008.35.camel@dhcp235-240.rdu.redhat.com> <1271214102.1555.27.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271214102.1555.27.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 08:01:42PM -0700, Joe Perches wrote:
> On Tue, 2010-04-13 at 22:44 -0400, Eric Paris wrote:
> > On Tue, 2010-04-13 at 18:33 -0700, Joe Perches wrote:
> > > On Tue, 2010-04-13 at 21:13 -0400, Eric Paris wrote:
> > > > Patch ef0658f3de484bf9b173639cd47544584e01efa5 changed the precision field
> > > > from and int to an s8.  Problem is that we have code which uses a much larger
> > > > precision in the kernel.  An example would in the audit code where we have:
> > > > 
> > > > vsnprintf(...,..., " msg='%.1024s'", (char *)data);
> > > > 
> > > > which causes precision to be too large and end up truncating to nothing.
> > > > Raising the size of the precision fixes the audit system issue.  It also does
> > > > not affect the alignment of the struct according to pahole and is still
> > > > approprietely packed.
> > > 
> > > I don't see how it could be appropriately packed.
> > 
> > I was just saying there was no padding inside the struct, although you
> > are right about it now being longer than 64.
> 
> Which is bad.
> 
> > But what does __attribute__((packed)) buy us?
> 
> It could force the size to be 64 bits on more platforms.
> 
> > I'll gladly resend with u8 type and s16 precision if that's the best
> > solution.
> 
> Reordering struct members to keep width and precision
> together seems appropriate.  The attribute may not be.
> 
> struct printf_spec {
> 	u8 type;
> 	u8 flags;		/* flags to number() */
> 	u8 base;
> 	u8 qualifier;
> 	s16 field_width;	/* width of output field */
> 	s16 precision;		/* # of digits/chars */
> };


Yeah, we should avoid the attribute. Packing struct should be
done for pretty special cases, not to fix padding holes, because
the hole problem would be turned into an alignment access unefficiency.

