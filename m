Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2ENUqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:46:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17680 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab2ENUqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:46:08 -0400
MIME-Version: 1.0
Message-ID: <0966a902-a35e-4c06-ab04-7d088bf25696@default>
Date: Mon, 14 May 2012 13:45:36 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com
Subject: RE: [PATCH] ramster: switch over to zsmalloc and crypto interface
References: <1336676781-8571-1-git-send-email-dan.magenheimer@oracle.com>
 <20120514200659.GA15604@kroah.com>
In-Reply-To: <20120514200659.GA15604@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH] ramster: switch over to zsmalloc and crypto interface
> 
> On Thu, May 10, 2012 at 12:06:21PM -0700, Dan Magenheimer wrote:
> > RAMster does many zcache-like things.  In order to avoid major
> > merge conflicts at 3.4, ramster used lzo1x directly for compression
> > and retained a local copy of xvmalloc, while zcache moved to the
> > new zsmalloc allocator and the crypto API.
> >
> > This patch moves ramster forward to use zsmalloc and crypto.
> >
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 

Hi Greg --

> I finally enabled building this one (didn't realize it required ZCACHE
> to be disabled, I can only build one or the other)

Yes, correct.  This overlap is explained in drivers/staging/ramster/TODO
(which IIRC you were the one that asked me to create that file).
In short the TODO says: ramster is a superset of zcache that also
"remotifies" zcache-compressed pages to another machine, and the overlap
with zcache will need to be rectified before either is promoted
from staging.

> and I noticed after
> this patch the following warnings in my build:
> 
> drivers/staging/ramster/zcache-main.c:950:13: warning: ‘zcache_do_remotify_ops’ defined but not used
> [-Wunused-function]
> drivers/staging/ramster/zcache-main.c:1039:13: warning: ‘ramster_remotify_init’ defined but not used
> [-Wunused-function]

These are because CONFIG_FRONTSWAP isn't yet in your tree.  It is
in linux-next and will hopefully finally be in Linus' tree at
the next window.  Ramster (and zcache) has low value without
frontswap, so the correct fix, after frontswap is merged, is
to remove all the "ifdef CONFIG_FRONTSWAP" and force the
dependency in Kconfig... but I can't do that until frontswap
is merged. :-(

> drivers/staging/ramster/zcache-main.c: In function ‘zcache_put’:
> drivers/staging/ramster/zcache-main.c:1594:4: warning: ‘page’ may be used uninitialized in this
> function [-Wuninitialized]
> drivers/staging/ramster/zcache-main.c:1536:8: note: ‘page’ was declared here

Hmmm... this looks like an overzealous compiler.  The code
is correct and was unchanged by this patch.  My compiler
(gcc 4.4.4) doesn't even report it.  I think I could fix it
by assigning a superfluous NULL at the declaration and will
do that if you want but I can't test the fix with my compiler
since it doesn't report it.

> Care to please fix them up?

It looks like you've taken the patch... if my whining
above falls on deaf ears and you still want me to "fix"
one or both, let me know and I will submit a fixup patch.
(And then... what gcc are you using?)

Dan
