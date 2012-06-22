Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337Ab2FVPV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:21:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:65145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762234Ab2FVPVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:21:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="157158359"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
Thread-Topic: [vMCE design RFC] Xen vMCE design
Thread-Index: Ac1O/6XAexbUH0BVTLGVMLMLWAtaJwBAufgAACbfvoAAAhphAAAEZvmAAALR9gAADp/WcA==
Date: Fri, 22 Jun 2012 15:21:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19323340@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
 <4FE4A636020000780008B756@nat28.tlf.novell.com>
In-Reply-To: <4FE4A636020000780008B756@nat28.tlf.novell.com>
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

>>> I think that we minimally need to retain the MCG_CAP register
>>> as being of potentially variable content (and hence needing
>>> saving/restoring on migration). To support this in a forward
>>> compatible manner, we may have to have a way to tell the
>>> hypervisor e.g. via command line option which extra MSRs
>>> have to be treated read-as-zero/writes-ignored upon guest
>>> accesses.
>> 
>> Seems unnecessary, reason as above.
>
> So going forward you see no possibility of additions to the
> interface that might warrant allowing more bits to be set in
> MCG_CAP than you define to be set here? That really looks
> unrealistic to me.

More bits can be added to MCG_CAP - but this becomes a hard
problem for migration because most OS guests only look at
MCG_CAP at boot time (linux certainly does) ... so if you migrate
and change MCG_CAP to match the new host, the guest will have
no idea that things changed.

MCG_SER_P bit is easy to deal with:
1) You already know about it
2) You can safely set it when the guest is running on a host that
does not support software error recover ... the guest will just
think that SRAO and SRAR events are possible, but they will never
actually occur. Setting it does make sure that the guest will be
ready should you migrate to a system that really does support it.

Future bits would have to be dealt with on a case by case basis.
The same general model would apply ... set the bit everywhere ...
but you might need some Xen changes to virtualize any new resources
and capabilities that were described by the new bit. Side question:
when a guest is migrated from one machine to another, does the version
of Xen running on source and target have to be the same? This tactic
will not work if you migrate a guest running on Xen version 99 that
does have the code to virtualize some new capability to a machine
running Xen version 98 that doesn't.

-Tony
