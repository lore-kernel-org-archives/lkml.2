Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab2BFR3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:29:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:9667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab2BFR3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:29:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="104592762"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: =?iso-8859-2?Q?=A9tefan_Gula?= <steweg@ynet.sk>
CC: David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Topic: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Index: AQHM4tRzTeNX1pwK8UWzJpDyRUwPApYvSQxggADQ/QCAAAhUQA==
Date: Mon, 6 Feb 2012 17:29:09 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F806E3@ORSMSX106.amr.corp.intel.com>
References: <5422254.3711328278789768.JavaMail.root@5-MeO-DMT.ynet.sk>
 <10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
 <20120203.192933.510206531351047222.davem@davemloft.net>
 <C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
 <CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
In-Reply-To: <CAGsizzLFoXdUQrA-WtdRq4FDdnDNnevyK6HCRmrT2joUV=ZRXg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: steweg@gmail.com [mailto:steweg@gmail.com] On Behalf Of ©tefan Gula
> Sent: Monday, February 06, 2012 12:53 AM
> To: Rose, Gregory V
> Cc: David Miller; linux-kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [patch v1, kernel version 3.2.1] rtnetlink workaround around
> the skb buff size issue
> 
> 2012/2/6 Rose, Gregory V <gregory.v.rose@intel.com>:
> >
> > The patch below is what I've got so far.  Right now the bit mask array
> is global so if you enable display of VF (n) on one interface it will
> enable display of the same VF on other interfaces.  I intend to move the
> bit mask array into the net_device structure so we can set the display
> mask for each interface independently.
> >
> > The command to set the filter mask is "set only", I see no reason to add
> it to the info dump.  If other folks see it differently then I can do that
> too.
> >
> > Anyway, it will allow the user to control which VFs are getting
> displayed during the info dump.  They all default to off so initially no
> VF info gets displayed.
> >
> > I've also whipped up a patch for the iproute2 ip command.  It'll work
> like this:
> >
> > 'ip link set <dev> vf (n) filter [on|off]'
> >
> > So if you have 128 VFs on the device you could enable info dumps for
> arbitrary VFs, e.g. VFs 3, 9, 16, 21, and 31.  Only the info for those VFs
> would display.  This method has the advantage of not breaking scripts
> which parse the current VF info display.  Of course, one could also script
> up something to sequentially enable the display of a single VF, dump the
> info for it, and then move on to the next.
> As this patch will allow one to filter some information and possible
> lower the need on skb buffer size, the general idea is ok. On the
> other hand it will not eliminate the problem. e.g.:
> - assume that one didn't know the limits behind it and put all options
> enabled
> - it also doesn't fix the need to fill relevant info by interface
> bigger than buffer size, e.g. my macvlan interface mac address list.
> If I try to request for it, it will eventually fail with a lot of
> records even with filtering...
> 
> So I would rather see a proper general method for requesting some
> information in cycles inside the single interface like sending request
> to kernel per VF for particular device or per MAC address from macvlan
> associated lists. This approach is I believe slightly more scalable as
> it can be potentially reused on other types of network devices as
> well.
> 
> My original idea was to have these methods:
> 1st kernel method will return some info about the absolute number of
> cycles needed per given interface - this can be done in standard
> GETLINK operation with some associated IFLA_* value.
> 2nd user-space method will based on that number sends netlink request
> per records or reasonable page of records (e.g. 10) and parse the
> output in the user-space.
>  - this is needed to overcome another issue when kernel generates so
> many netlink messages with NLM_F_MULTI that netlink socket will not be
> able to hold and further write/read code will fail.
> 3rd kernel method, which will allocated, fill, and send required info
> per record -> this one can be done by ops/command netlink association
> (in my proposal it is DEVDUMP)
> 
> To sum up, I believe that both approaches (using cycles and filtering)
> should be allowed to coexists in kernel, but they should be considered
> separately as they are doing different jobs.

Stefan,

That is exactly my approach.  We currently have a *bug* in the kernel that this patch is addressing.  The kernel is attempting to provide too much information for the netlink interface to handle and it's breaking things.  So what I want to do is fix the immediate problem while still providing a way for folks to get the information they need.  I've accomplished this by doing exactly what Dave asked me to do, provide a filter that defaults to off and then provide a way for the user to request discrete chunks of information in the dump that won't exceed the netlink buffer limits.

The patch is fairly unobtrusive and simple to understand.

I appreciate that it doesn't do all that you'd like to see done and I see no reason why you couldn't go on and develop the extended features that you would like to see, correct?  There's nothing in my patch that would prevent that so far as I can tell, although I'm not that familiar with your requirements or proposals yet.

- Greg

> 
> I can provide whole example of code (not just rtnetlink part), if the
> list is interested to see live example.
