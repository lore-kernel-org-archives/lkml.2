Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172Ab2FVNqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:46:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:33764 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762129Ab2FVNqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:46:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="161254570"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "Raj, Ashok" <ashok.raj@intel.com>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Li, Susie" <susie.li@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keir Fraser <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
Thread-Topic: [vMCE design RFC] Xen vMCE design
Thread-Index: AQHNUGvJexbUH0BVTLGVMLMLWAtaJ5cGOLAg
Date: Fri, 22 Jun 2012 13:46:17 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
In-Reply-To: <4FE475BE020000780008B624@nat28.tlf.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> On 22.06.12 at 12:40, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>> Jan Beulich wrote:
>>>>>> On 20.06.12 at 18:13, "Liu, Jinsong" <jinsong.liu@intel.com>
>>>>>> wrote: 
>>>> Recently we design xen vMCE as attached.
>>>> Please kindly help me to review it, any comments/suggestions are
>>>> appreciated.
>>> 
>>> The concept looks quite okay, provided no OS has a problem with
>>> the limitations imposed (most notably the restriction to a single
>>> reporting bank, particularly in the context of e.g. Linux partly
>>> ignoring the first bank under some conditions iirc).
>> 
>> 'bank0 skipping' quirks is only for older model cpus, I think we
>> have 2 options: 1). still use 1 bank and simply ignore this issue. I
>> mean, even if guest runs at bank0 quirks platform, when hypervisor
>> inject vMCE# to guest, guest skip bank0, then guest MCE logic would
>> think it detect a spurious mce, then kill itself. Considering bank0
>> quirks is only for old cpus, this is acceptable; 2). use 32 banks
>> 
>> In fact, a third option is, use 1 bank, but hypervisor kill guest
>> when it detect bank0 quirks. This would be same effect as option 1,
>> so I prefer let guest kill itself.
> 
> Out of these, I'd actually favor using 32 banks. Using 2 banks
> instead of 1 might be another option.

Yes, 2 or 32 are both OK. Let's use 32.
(or, 2 is better for some other reasons, let me confirm inside Intel first).

> 
>>> As to not needing any migration specific adjustments - what if
>>> a migration is in progress when an event needs to be delivered?
>> 
>> If a migration is in progress while an event delivered, we abort the
>> migration.
> 
> Is there a way the hypervisor can tell the tools to abort a
> migration? Or are you meaning to say such functionality would
> need to be added?

I didn't check migration code, but I think it could be done by
1). set a flag indecating the case 'migration is in progress while event delivered'.
2). at the last shakehand stage of migration (i.e. A to B), checking the flag and if yes, abort migration.
So guest will continue run at A, and quit at B after timeout.

> 
> One other concern that occurred to me after long having sent
> the original response: Your proposal aims at a fixed,
> unmodifiable vMCE interface. How is that going to be forward
> compatible? I.e. consider you had made that proposal before
> the SRAO/SRAR changes went in - would the same interface (with
> the same set of capability bits set/clear) still be suitable?

Yes, since it's pure s/w emulated interface. At the case when SRAO or SRAR not supported by h/w platform, it's still OK, since under such case hypervisor don't need deliver SRAO or SRAR to guest at all. The emulated vMCE interface just tell the guest that it runs at a virtual platform with those well-defined capabilities.

> 
> I think that we minimally need to retain the MCG_CAP register
> as being of potentially variable content (and hence needing
> saving/restoring on migration). To support this in a forward
> compatible manner, we may have to have a way to tell the
> hypervisor e.g. via command line option which extra MSRs
> have to be treated read-as-zero/writes-ignored upon guest
> accesses.
> 
> Jan

Seems unnecessary, reason as above.

Thanks,
Jinsong


