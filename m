Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab2HWQAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:00:07 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42941 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934130Ab2HWQAD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:00:03 -0400
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2012 12:00:02 EDT
From: "Banerjee, Debabrata" <dbanerje@akamai.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Hunt, Joshua" <johunt@akamai.com>,
        "dbavatar@gmail.com" <dbavatar@gmail.com>,
        "Lubashev, Igor" <ilubashe@akamai.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Aug 2012 11:51:41 -0400
Subject: Re: IPv6 deadlock with CONFIG_IPV6_ROUTER_PREF
Thread-Topic: IPv6 deadlock with CONFIG_IPV6_ROUTER_PREF
Thread-Index: Ac2BRzEv9xaZyHhNQMusGx+mNMzIIA==
Message-ID: <19507780-1BF1-48B1-A2FE-6B44B6110D76@akamai.com>
References: <CC52AD11.7CC2%dbanerje@akamai.com>
 <CAF1ivSZN8PyPhAkyaFL-GsTbnr4uwP=zzzjZbgqOKts_wgngYA@mail.gmail.com>
In-Reply-To: <CAF1ivSZN8PyPhAkyaFL-GsTbnr4uwP=zzzjZbgqOKts_wgngYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 23, 2012, at 11:11 AM, "Lin Ming" <mlin@ss.pku.edu.cn> wrote:

> On Fri, Aug 17, 2012 at 1:58 AM, Banerjee, Debabrata
> <dbanerje@akamai.com> wrote:
>> This code tries to send a neighbor discovery ICMPv6 packet for router
>> reachability while read_lock(tb6_lock) is held. The send may want to cause
>> a fib6_clean_all() garbage collection, which will try to take
>> write_lock(tb6_lock), resulting in deadlock. Garbage collection becomes
>> more likely under high load of cloned routes, so this is exploitable as a
>> DDOS attack, given enough attack hosts in relation max_size of the route
>> table (default of 4k). I checked from 3.6-rc1 back to 2.6.32, it is
>> present everywhere.
> 
> How about moving the garbage collection to a kernel thread?
> Then the write_lock(tb6_lock) in this kernel thread won't cause such
> kind of dead lock with other threads.
> 
> Lin Ming

It already runs in a thread, this is a forced gc because we are over the gc threshold, and this thread deadlocks with itself. I thing Cong Wang is on the right track with his patch. The implementation of this RFC must be fixed.

-Debabrata
