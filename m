Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab2ARR21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:28:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:22116 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab2ARR20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:28:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113656763"
From: "Luck, Tony" <tony.luck@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: RE: [PATCH] mce: fix warning messages about static struct mce_device
Thread-Topic: [PATCH] mce: fix warning messages about static struct
 mce_device
Thread-Index: AQHM1J/gZZi9VvM99kKJ1R/CbZ8vIpYQw7OAgAB45YCAASg4AIAAVvMAgAATRoD//5B5gA==
Date: Wed, 18 Jan 2012 17:28:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
References: <20120118144250.GA16288@suse.de>
 <Pine.LNX.4.44L0.1201181047060.1343-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1201181047060.1343-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg said:
> It was already fixed that way, but the problem is that you can not have
> statically allocated 'struct device' objects in the system.

and then Alan said:
> There's an additional requirement: Device structures may not be reused.  
> Not even if the caller clears all the fields to 0 in between.  That was
> the real bug in the original code -- and adding a dummy release routine
> wouldn't fix it.

There seems to be some curious logic happening here which I don't understand
at all. How can the code that deals with 'struct device' tell whether it was
statically declared or dynamically allocated? Why would it care?

What happens if we play by the rules using a dynamic structure and do

 device_register() + device_create_file(dev)
   ...
 device_remove_file(dev) + device_unregister()

then later come back to re-add this and by pure random fluke kzalloc()
gives us back the exact same block of memory that we used for dev before?

By Alan's logic we are screwed - we are re-using the same device structure
(unless kfree() + kzalloc() does some magic pixie dust thing so that this
same block of memory is now not the same device structure we had before, even
though it has the same address).

In summary - I can totally buy the argument that you must start with a zeroed
struct device (and that it is just fine that device_unregister() doesn't waste
cpu cycles cleaning up the structure just in case someone will re-use it, because
that isn't going to be the common case).

I just don't understand the magical difference between a static structure that
has been memset() to all zero, and a dynamic block returned from kzalloc().

-Tony
