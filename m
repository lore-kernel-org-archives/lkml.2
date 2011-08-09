Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1HIPE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:04:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37793 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1HIPEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:04:55 -0400
MIME-Version: 1.0
Message-ID: <77feea14-0eff-433d-a3af-b1eb973efce8@default>
Date: Tue, 9 Aug 2011 08:03:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: hannes@cmpxchg.org, jackdachef@gmail.com, hughd@google.com,
        jeremy@goop.org, npiggin@kernel.dk, linux-mm@kvack.org,
        akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        Chris Mason <chris.mason@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, riel@redhat.com,
        ngupta@vflare.org, linux-kernel@vger.kernel.org, matthew@wil.cx
Subject: RE: Subject: [PATCH V6 2/4] mm: frontswap: core code
References: <20110808204615.GA15864@ca-server1.us.oracle.com
 4E41439D0200007800050581@nat28.tlf.novell.com>
In-Reply-To: <4E41439D0200007800050581@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E414C68.0013,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#ifndef CONFIG_FRONTSWAP
> > +/* all inline routines become no-ops and all externs are ignored */
> > +#define frontswap_enabled (0)
> > +#endif
> > +
> > +static inline int frontswap_test(struct swap_info_struct *sis, pgoff_t
> > offset)
> > +{
> > +	int ret = 0;
> > +
> > +	if (frontswap_enabled && sis->frontswap_map)
> > +		ret = test_bit(offset % BITS_PER_LONG,
> > +			&sis->frontswap_map[offset/BITS_PER_LONG]);
> 
> 	if (sis->frontswap_map)
> 		ret = test_bit(offset, sis->frontswap_map);
> 
> (since sis->frontswap_map can't be non-NULL without
> frontswap_enabled being true, and since test_bit() itself already
> does what you open-coded here.

Hi Jan --

Thanks for the review!

> since test_bit() itself already does what you open-coded here

Good catch.  Will change.  Either is correct and I suspect the
compiler may end up generating the same code, but your code
is much more succinct.

> (since sis->frontswap_map can't be non-NULL without
> frontswap_enabled being true

As noted in the comment immediately preceding, the frontswap_enabled
check serves a second purpose:  When CONFIG_FRONTSWAP is
disabled, this entire inline function devolves to a compile-time
constant (0), which avoids a handful of ifdef's in the
core swap subsystem.  (This approach was originally suggested
for cleancache by Jeremy Fitzhardinge.)

Also, though this patch never unsets frontswap_enabled, it is
a global and some future tmem backend might unset it, so
it's probably best to leave the extra test anyway.
