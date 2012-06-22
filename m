Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342Ab2FVPsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:48:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56898 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2FVPsC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 11:48:02 -0400
Message-Id: <4FE4AFFD020000780008B799@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 16:48:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>, "Tony Luck" <tony.luck@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
 <4FE475BE020000780008B624@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
 <4FE4A636020000780008B756@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F19323340@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19323340@ORSMSX104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.06.12 at 17:21, "Luck, Tony" <tony.luck@intel.com> wrote:
>>>> I think that we minimally need to retain the MCG_CAP register
>>>> as being of potentially variable content (and hence needing
>>>> saving/restoring on migration). To support this in a forward
>>>> compatible manner, we may have to have a way to tell the
>>>> hypervisor e.g. via command line option which extra MSRs
>>>> have to be treated read-as-zero/writes-ignored upon guest
>>>> accesses.
>>> 
>>> Seems unnecessary, reason as above.
>>
>> So going forward you see no possibility of additions to the
>> interface that might warrant allowing more bits to be set in
>> MCG_CAP than you define to be set here? That really looks
>> unrealistic to me.
> 
> More bits can be added to MCG_CAP - but this becomes a hard
> problem for migration because most OS guests only look at
> MCG_CAP at boot time (linux certainly does) ... so if you migrate
> and change MCG_CAP to match the new host, the guest will have
> no idea that things changed.

And it doesn't have to - respective events will just not occur
anymore. All we need to make sure is that if it accesses an MSR
that's no longer backed by anything in hardware, we don't
inject a #GP (but instead return e.g. all zeros to reads, and
drop all writes).

> MCG_SER_P bit is easy to deal with:
> 1) You already know about it
> 2) You can safely set it when the guest is running on a host that
> does not support software error recover ... the guest will just
> think that SRAO and SRAR events are possible, but they will never
> actually occur. Setting it does make sure that the guest will be
> ready should you migrate to a system that really does support it.

And so is likely going to be the case for at least some of the
additions to come.

> Future bits would have to be dealt with on a case by case basis.
> The same general model would apply ... set the bit everywhere ...
> but you might need some Xen changes to virtualize any new resources
> and capabilities that were described by the new bit. Side question:
> when a guest is migrated from one machine to another, does the version
> of Xen running on source and target have to be the same? This tactic
> will not work if you migrate a guest running on Xen version 99 that
> does have the code to virtualize some new capability to a machine
> running Xen version 98 that doesn't.

No, that's not a requirement, and hence we need to create a
model that will at least always allow upward (destination host
running higher version Xen than source) migration, and that
preserves as much functionality as possible when moved
between hosts with different MCA capabilities.

Jan

