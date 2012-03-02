Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030475Ab2CBUFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:05:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:22584 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab2CBUFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:05:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124305540"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZTmLGAgACV04CAAB/YAIAABAsAgAANCYCAAAjigIAA1e4AgACboYD//+qe4IABJ7SAgACA1gA=
Date: Fri, 2 Mar 2012 20:05:13 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F04117B@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab>
 <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab>
 <4F4EDD9A.4050900@jp.fujitsu.com> <20120301114023.GB32410@aftab>
 <3908561D78D1C84285E8C5FCA982C28F040ACC@ORSMSX104.amr.corp.intel.com>
 <4F504645.5040708@jp.fujitsu.com>
In-Reply-To: <4F504645.5040708@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    - It would be better to have a well organized table rather than
      having a raw copy of config space etc.

I think it would be challenging to come up with a table format that
can handle all the address mapping options that SNB memory controller
can set up.

E.g. I have a very simple setup with all DIMM slots populated with the
same size/speed DIMMS.  If I pick a page at random and lookup which DIMM
slot each cache line translates to, I'll see a simple pattern:

	A1 B1 C1 D1 A1 B1 C1 D1 ...

as lines are sequentially placed across all four channels.  Looking at
other pages I'll sometimes see that pattern, and sometimes see that the
other set of DIMM slots was chosen

	A2 B2 C2 D2 A2 B2 C2 D2 ...

The decision to use slot1 vs. slot2 DIMMs on the channel may depend on
the XOR of a couple of bit fields from the full physical address.

But life might not be that simple. I can fill DIMM slots with different
size/speed DIMMs - which will affect the interleave options. About the
only restriction on placement is that you cannot fill a "2" slot on a
channel unless you have a DIMM present in the "1" slot.

Then there are a handful of BIOS options that may change things - e.g.
you could turn off NUMA mode - then you'll find that pages are striped
across DIMMs from all nodes.

Ultimately your table generation code would have to take into account
all of the mapping possibilities in the h/w ... at which point it would
be far simpler to just write a routine that performs the same translation
that the h/w does (based on the values from those memory controller
config registers).

-Tony
