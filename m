Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2HaRYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:24:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2HaRYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:24:04 -0400
MIME-Version: 1.0
Message-ID: <89702248-0c3f-465c-bc1f-2115a21c8c89@default>
Date: Fri, 31 Aug 2012 10:23:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: RE: [PATCH] frontswap: support exclusive gets if tmem backend is
 capable
References: <5557ec97-daa1-41a6-b3db-671f116ddc50@default>
 <20120831170814.GF18929@localhost.localdomain>
In-Reply-To: <20120831170814.GF18929@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk

Hi Konrad --

Thanks for the fast feedback!

> > +#define FRONTSWAP_HAS_EXCLUSIVE_GETS
> > +extern void frontswap_tmem_exclusive_gets(bool);
> 
> I don't think you need the #define here..

The #define is used by an ifdef in the backend to ensure
that it is using a version of frontswap that has this feature,
so avoids the need for the frontend (frontswap) and
the backend (e.g. zcache2) to merge in lockstep.

> > +EXPORT_SYMBOL(frontswap_tmem_exclusive_gets);
> 
> We got two of these now - the writethrough and this one. Merging
> them in one function and one flag might be better. So something like:
> static int frontswap_mode = 0;
>
> void frontswap_set_mode(int set_mode)
> {
> 	if (mode & (FRONTSWAP_WRITETH | FRONTSWAP_EXCLUS..)
> 		mode |= set_mode;
> }

IMHO, it's too soon to try to optimize this.  One or
both of these may go away.   Or the mode may become
more fine-grained in the future (e.g. to allow individual
gets to be exclusive).

So unless you object strongly, let's just leave this
as is for now and revisit in the future if more "modes"
are needed.
 
> ... and
> > +
> > +/*
> >   * Called when a swap device is swapon'd.
> >   */
> >  void __frontswap_init(unsigned type)
> > @@ -174,8 +190,13 @@ int __frontswap_load(struct page *page)
> >  	BUG_ON(sis == NULL);
> >  	if (frontswap_test(sis, offset))
> >  		ret = (*frontswap_ops.load)(type, offset, page);
> > -	if (ret == 0)
> > +	if (ret == 0) {
> >  		inc_frontswap_loads();
> > +		if (frontswap_tmem_exclusive_gets_enabled) {
> 
> For these perhaps use asm goto for optimization? Is this showing up in
> perf as a hotspot? The asm goto might be a bit too much.

This is definitely not a performance hotspot.  Frontswap code
only is ever executed in situations where a swap-to-disk would
otherwise have occurred.  And in this case, this code only
gets executed after the frontswap_test has confirmed that
tmem does already contain the page of data, in which case
there is thousands of cycles spent copying and/or decompressing.

Dan
