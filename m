Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1AGEg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 23:36:29 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65381 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1AGEg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 23:36:28 -0500
MIME-Version: 1.0
In-Reply-To: <20110107032459.GA17959@mcarlson.broadcom.com>
References: <AANLkTikKkAesHc4Fi4SwAkV0e65D0TQRztrRYoDNu3MP@mail.gmail.com>
	<20101206222703.32fbe852@xenia.leun.net>
	<AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
	<20101213224510.GB17400@mcarlson.broadcom.com>
	<AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
	<20101214191500.GD19951@mcarlson.broadcom.com>
	<20101215012430.120fd47f@xenia.leun.net>
	<20101215013431.GA21173@mcarlson.broadcom.com>
	<20101215081606.18e12fc9@xenia.leun.net>
	<AANLkTi=hGRW+DwoKQzxPAZao6-y_tvn6nNXS-tj_-Y6T@mail.gmail.com>
	<20110107032459.GA17959@mcarlson.broadcom.com>
Date: Thu, 6 Jan 2011 23:36:27 -0500
Message-ID: <AANLkTi=N6jFE7T1=W-WLo_eHYWeE=oB6n8C8zPGoBNQF@mail.gmail.com>
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not used
From: Jesse Gross <jesse@nicira.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Leun <lkml20101129@newton.leun.net>,
        Michael Chan <mchan@broadcom.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 10:24 PM, Matt Carlson <mcarlson@broadcom.com> wrote:
> On Sat, Dec 18, 2010 at 07:38:00PM -0800, Jesse Gross wrote:
>> On Tue, Dec 14, 2010 at 11:16 PM, Michael Leun
>> <lkml20101129@newton.leun.net> wrote:
>> > OK - all tests done on that DL320G5:
>> >
>> > For completeness, 2.6.37-rc5 unpatched:
>> >
>> > eth0, no vlan configured: totally broken - see double tagged vlans
>> > without tag, single or untagged packets missing at all
>>
>> Random behavior?  This one is somewhat hard to explain - maybe there
>> are some other factors.  eth0 has ASF on, so it always strips tags.  I
>> would expect it to behave like the vlan configured case.
>>
>> >
>> > eth0, vlan configured: see packets without vlan tag (see double tagged
>> > packets with one vlan tag)
>>
>> Both ASF and vlan group configured cause tag stripping to be enabled.
>> Missing tag.
>>
>> >
>> > eth1 same as originally reported:
>> > without vlan configured see vlan tags (single and double tagged as
>> > expected)
>>
>> No ASF and no vlan group means tag stripping is disabled.  Have tag.
>>
>> > with vlan configured: see packets without vlan tag (see double tagged
>> > packets with one vlan tag)
>>
>> Configuring vlan group causes stripping to be enabled.  Missing tag.
>>
>> >
>> >
>> > 2.6.37-rc5, your tg3 use new vlan-code patch:
>> >
>> > eth0, no vlan configured: ?see packets without vlan tag (see double
>> > tagged packets with one vlan tag)
>>
>> ASF enables tag stripping.  Missing tag.
>>
>> > eth1, no vlan configured: see vlan tags (single and double tagged as
>> > expected)
>>
>> No ASF, no vlan group means no stripping.  Have tag.
>>
>> >
>> >
>> > eth0, vlan configured: as without vlan
>>
>> ASF enables stripping.  Missing tag.
>>
>> > eth1, vlan configured: as without vlan
>>
>> With this patch vlan stripping is only enabled when ASF is on, so no
>> stripping.  Have tag.
>>
>> >
>> > 2.6.37-rc5, your tg3 use new vlan-code patch with test patch ontop
>> >
>> > eth1 no vlan configured: see packets without vlan tag (see double tagged
>> > packets with one vlan tag)
>>
>> With the second patch, vlan stripping is always enabled.  Missing tag.
>>
>> > eth1 with vlan: the same
>>
>> Stripping still always enabled.  Missing tag.
>>
>> The bottom line is whenever vlan stripping is enabled we're missing
>> the outer tag.  It might be worth adding some debugging in the area
>> before napi_gro_receive/vlan_gro_receive (depending on version).  My
>> guess is that (desc->type_flags & RXD_FLAG_VLAN) is false even for
>> vlan packets on this NIC.
>>
>> You said that everything works on the 5752?  Matt, is it possible that
>> the 5714 either has a problem with vlan stripping or a different way
>> of reporting it?
>
> I don't think this is a 5714 specific issue.  I think the problem is
> rooted in the fact that the VLAN tag stripping is enabled.

It's definitely related to vlan stripping being enabled.  Other cards
using tg3 seem to work fine with stripping though, which is why I
thought it might be specific to the 5714.

>
> Your RXD_FLAG_VLAN idea sounds unlikely to me, but it's worth a check.
>
> The patch here is using __vlan_hwaccel_put_tag(), which informs the
> stack a VLAN tag is present.  If this is indeed a reporting problem, I'm
> not sure what else the driver should be doing.

The code to hand off the tag to the stack looks OK to me.  Michael was
seeing this on older versions of the kernel as well with this NIC,
which predates both this patch and the larger vlan changes so it
doesn't seem like a problem with passing the tag to the network stack.
 It's hard to know exactly what is going on though without seeing what
the hardware is reporting.
