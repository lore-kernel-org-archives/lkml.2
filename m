Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0I1Mc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:32:28 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:38497 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752696Ab0I1Mc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:32:26 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: PhbAPzoVM1lc._fDYqZsujbsZKlBldU3HaXZahpO1a5wTmk
 Ijs9XL4Z372EAnFsB3sGrTiZyEsC33yf0GFwFDgQJUkLoOfTCtMLk_gbIhRA
 vgg_AKO.mDJOSC4D7QQPKh78NI3S6FF_Y7RppY2caEraLpB041yhkyBZ2m7l
 TtZRvgwAjaLHjPQltZOgRWu9Z8t7L2wd5Ty3OPSqcchO2iQiPeDX_veZzJD.
 7Yl9SxtxUbHsliAyyw7kMs_F9ZYc0pMnLskO4SGbL9XpaFJT3X3ab4GmUrWp
 4k_lLjM4Wsg7TxDQKTitbOHM-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4CA1E051.9030904@schaufler-ca.com>
Date: Tue, 28 Sep 2010 05:32:17 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov, jengelh@medozas.de,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>	 <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>	 <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>	 <1285606896.2815.36.camel@localhost.localdomain>	 <1285612156.4935.16.camel@sifl> <1285615525.2815.76.camel@localhost.localdomain>
In-Reply-To: <1285615525.2815.76.camel@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/27/2010 12:25 PM, Eric Paris wrote:
> On Mon, 2010-09-27 at 14:29 -0400, Paul Moore wrote:
>> On Mon, 2010-09-27 at 13:01 -0400, Eric Paris wrote:
>>> On Mon, 2010-09-27 at 10:50 +1000, James Morris wrote:
>>>> On Fri, 24 Sep 2010, Eric Paris wrote:
>>>> For the reasons above, I think the secctx string needs to be exported in 
>>>> addition to this rather than instead of.
>>> I won't argue, I don't agree with your reasoning, but I'm not opposed to
>>> this result.  We have 3 competing suggestions:
>>>
>>> Jan suggested we:
>>> completely eliminate secmark from procfs+netlink and only export secctx
>>> in netlink.
>>>
>>> Eric suggested we:
>>> completely eliminate secmark from procfs+netlink and then export secctx
>>> in procfs+netlink
>>>
>>> sounds like James suggested we:
>>> continue to export meaningless and confusing secmark from procfs+netlink
>>> and then export secctx in procfs+netlink as well.
>>>
>>> I'm going to implement James' idea and resend the patch series.  Any
>>> strong objections?
>> I apologize for not getting a chance to look at these patches sooner.
>> In general they look fine to me and my only real concern was addressed
>> by Pablo already (breaking userspace due to #define changes).
>>
>> As far as exporting the 32bit secid/secmark to userspace, I think that
>> is a mistake.  James correctly points out that it does map to a LSM
>> specific value, e.g. SELinux and Smack security labels, but I don't
>> think he makes it clear that in the two LSMs that currently use secids
>> the mapping between the secid and the secctx is not constant; the secids
>> are transient values that will change with each boot in a manner that
>> userspace can not predict.  For this reason, I think exporting the
>> secids is only going to cause users/admins grief, whereas exporting the
>> associated secctx should be a much more stable value and is likely what
>> the user/admin is expecting anyway.
> So it sounds to me like Paul agrees with me that exporting the SELinux
> sid as 'secmark=' was a bad idea.  It's the whole reason this thread
> started, someone wanted to be able to translate and use that field (and
> instantly realized it was useless.)
>
> I see it as having 3 options.  lets assume was have a packet with
> selinux sid=121 and selinux context=packet_t.  We can
>
> 1) secmark=121 secctx=packet_t
> 	This continues to send secmark like we do and people might continue to
> be baffled by the 121.
>
> 2) secmark=1 secctx=packet_t
> 	This sends a secmark field to userspace so if an application which
> reads this exists (I doubt such an application actually exists in in the
> real world) it will still get all of the information it got before but
> noone will be baffled by what the number means.  1/0 is pretty obvious.
>
> 3) secctx=packet_t
> 	Smallest easiest, what my patches actually do.  Could theoretically
> break some script that expected the field to be there, but any such
> script is already broken since that field can be easily compiled
> out......
>
> James, if you are adamant about #1 I'll resend, otherwise I'm sticking
> with #3.....

The Smack Project leadership recommends #3.

