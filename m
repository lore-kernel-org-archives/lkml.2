Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2APNaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:30:11 -0500
Received: from mx0.aculab.com ([213.249.233.131]:44880 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754549Ab2APNaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:30:09 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet multipoint GRE over IP
Date: Mon, 16 Jan 2012 13:30:07 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AF46@saturn3.aculab.com>
In-Reply-To: <1326719999.2255.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet multipoint GRE over IP
Thread-Index: AczUUZfH7tHyZA08RjmMyYlpPp7nIAAADyDA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@gmail.com>
Cc: "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        "James Morris" <jmorris@namei.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "Patrick McHardy" <kaber@trash.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2012 13:30:07.0828 (UTC) FILETIME=[F6B3B140:01CCD452]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	for (i = 0; i < GRETAP_BR_HASH_SIZE; i++) {
> > +		struct ipgre_tap_bridge_entry *entry;
> > +		struct hlist_node *h, *n;
> > +		hlist_for_each_entry_safe(entry, h, n,
> > +			&tunnel->hash[i], hlist)
> > +		{
> > +			unsigned long this_timer;
> > +			this_timer = entry->ageing_timer + delay;
> > +			if (time_before_eq(this_timer, jiffies))
> > +				ipgre_tap_bridge_delete(entry);
> > +			else if (time_before(this_timer, next_timer))
> > +				next_timer = this_timer;
> > +		}
> > +	}
> > +	spin_unlock_bh(&tunnel->hash_lock);
> > +	mod_timer(&tunnel->gc_timer, round_jiffies(next_timer + HZ/4));
> 
> wow... why setup a 250 ms timer, if entries are valid 300 seconds ?

Isn't that code trying to wakeup 250ms after the first expiry of any
of its items?

Do you even need a timer at all?

It may be enough to just put a timestamp into each entry
and tidy up when scanning one of the hash chains in (say)
the 'add item' path - when you need write access anyway.

A hash table might not be the best structure either!
The hash lookup is still o(n) for n >> table_size.
It also may be likely that you'll do repeated lookups for a small
number of items - in which case using a hash to cache recent lookups
might be useful (maybe with some type of balanced tree structure)

	David


