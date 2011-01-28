Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1A1JO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 04:14:57 -0500
Received: from mx0.aculab.com ([213.249.233.131]:59879 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755132Ab1A1JOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 04:14:55 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 04:14:54 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
Date: Fri, 28 Jan 2011 09:05:59 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AC2D@saturn3.aculab.com>
In-Reply-To: <4D41B213.4070606@caviumnetworks.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/7] PowerPC: add unlikely() to BUG_ON()
Thread-Index: Acu+S3YEACgfkvu+QDeJYRikb06MDAAfBwJQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "David Daney" <ddaney@caviumnetworks.com>,
        "Coly Li" <bosong.ly@taobao.com>
Cc: "Wang Cong" <xiyou.wangcong@gmail.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        "Yong Zhang" <yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > +#define __BUG_ON(x) do {					\
> >   	if (__builtin_constant_p(x)) {				\
> >   		if (x)						\
> >   			BUG();					\
> > @@ -85,6 +86,8 @@
> >   	}							\
> >   } while (0)
> >
> > +#define BUG_ON(x) __BUG_ON(unlikely(x))
> > +

>From my experiments, adding an 'unlikely' at that point isn't
enough for non-trivial conditions - so its presence will
give a false sense the the optimisation is present!
In particular 'if (unlikely(x && y))' needs to be
'if (unlikely(x) && unlikely(y))' in order to avoid
mispredicted branches when 'x' is false.

Also, as (I think) in some of the generated code quoted,
use of __builtin_expect() with a boolean expression can
force some versions of gcc to generate the integer
value of the expression - rather than just selecting the
branch instructions that statically predict the
normal code path.

Sometimes I've also also had to add an asm() statement
that generates no code in order to actually force a
forwards branch (so it has something to place at the
target).

(I've been counting clocks ....)

	David


