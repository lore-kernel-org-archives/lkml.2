Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228Ab2FVLjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:39:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:45037 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab2FVLjc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Jun 2012 07:39:32 -0400
Message-Id: <4FE475BE020000780008B624@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 22 Jun 2012 12:40:14 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: RE: [vMCE design RFC] Xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
 <4FE362C0020000780008B2CD@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.06.12 at 12:40, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> Jan Beulich wrote:
>>>>> On 20.06.12 at 18:13, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
>>> Recently we design xen vMCE as attached.
>>> Please kindly help me to review it, any comments/suggestions are
>>> appreciated.
>> 
>> The concept looks quite okay, provided no OS has a problem with
>> the limitations imposed (most notably the restriction to a single
>> reporting bank, particularly in the context of e.g. Linux partly
>> ignoring the first bank under some conditions iirc).
> 
> 'bank0 skipping' quirks is only for older model cpus, I think we have 2 
> options:
> 1). still use 1 bank and simply ignore this issue. I mean, even if guest 
> runs at bank0 quirks platform, when hypervisor inject vMCE# to guest, guest 
> skip bank0, then guest MCE logic would think it detect a spurious mce, then 
> kill itself. Considering bank0 quirks is only for old cpus, this is 
> acceptable;
> 2). use 32 banks
> 
> In fact, a third option is, use 1 bank, but hypervisor kill guest when it 
> detect bank0 quirks. This would be same effect as option 1, so I prefer let 
> guest kill itself.

Out of these, I'd actually favor using 32 banks. Using 2 banks
instead of 1 might be another option.

>> As to not needing any migration specific adjustments - what if
>> a migration is in progress when an event needs to be delivered?
> 
> If a migration is in progress while an event delivered, we abort the 
> migration.

Is there a way the hypervisor can tell the tools to abort a
migration? Or are you meaning to say such functionality would
need to be added?

One other concern that occurred to me after long having sent
the original response: Your proposal aims at a fixed,
unmodifiable vMCE interface. How is that going to be forward
compatible? I.e. consider you had made that proposal before
the SRAO/SRAR changes went in - would the same interface (with
the same set of capability bits set/clear) still be suitable?

I think that we minimally need to retain the MCG_CAP register
as being of potentially variable content (and hence needing
saving/restoring on migration). To support this in a forward
compatible manner, we may have to have a way to tell the
hypervisor e.g. via command line option which extra MSRs
have to be treated read-as-zero/writes-ignored upon guest
accesses.

Jan

