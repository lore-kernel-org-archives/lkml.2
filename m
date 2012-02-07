Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2BGAN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:13:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:10535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2BGANY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:13:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="104717940"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, "steweg@ynet.sk" <steweg@ynet.sk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Topic: [patch v1, kernel version 3.2.1] rtnetlink workaround around
 the skb buff size issue
Thread-Index: AQHM4tRzTeNX1pwK8UWzJpDyRUwPApYvSQxggAHLngD//37SQA==
Date: Tue, 7 Feb 2012 00:13:19 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F81413@ORSMSX106.amr.corp.intel.com>
References: <5422254.3711328278789768.JavaMail.root@5-MeO-DMT.ynet.sk>
	 <10521320.3761328279061644.JavaMail.root@5-MeO-DMT.ynet.sk>
	 <20120203.192933.510206531351047222.davem@davemloft.net>
	 <C5551D9AAB213A418B7FD5E4A6F30A0702F7F86F@ORSMSX106.amr.corp.intel.com>
 <1328572230.12637.18.camel@deadeye>
In-Reply-To: <1328572230.12637.18.camel@deadeye>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q170DYBI024231

> -----Original Message-----
> From: Ben Hutchings [mailto:bhutchings@solarflare.com]
> Sent: Monday, February 06, 2012 3:51 PM
> To: Rose, Gregory V
> Cc: David Miller; steweg@ynet.sk; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org
> Subject: RE: [patch v1, kernel version 3.2.1] rtnetlink workaround around
> the skb buff size issue
> 
> On Mon, 2012-02-06 at 04:41 +0000, Rose, Gregory V wrote:
> [...]
> > > This is not how we're going to fix this.  I already stated the desired
> > > way to fix this, which is to make the existing dump request have a way
> > > for the requestor to enable extended parts of the device dump.
> > >
> > > This is just like netlink diag socket dumps, where the dump request
> > > specifies what the user wants to see.
> > >
> > > In this case we'd add a netlink attribute to the dump request which
> > > is just a u32 bitmask or similar.
> > >
> > > The Intel engineer who added the VF dump support said he would work on
> > > this fix so why don't you just wait patiently for him to do the work?
> >
> > The patch below is what I've got so far.  Right now the bit mask array
> > is global so if you enable display of VF (n) on one interface it will
> > enable display of the same VF on other interfaces.  I intend to move
> > the bit mask array into the net_device structure so we can set the
> > display mask for each interface independently.
> 
> I don't think this can work.  Using an application that requests VF
> information and uses large buffers (e.g. the updated 'ip') will break
> another application that doesn't (e.g. current Network Manager), won't
> it?

It's my understanding that the problem isn't with the application buffer size but with the kernel buffer size, which is limited to a page.

> 
> The filter should be per-request and not persistent (and I think it
> could just be a boolean or a limit value rather than a bitmask).

Why?

I think having the ability to specify one or more discrete VFs for the info dump is useful.

> 
> > The command to set the filter mask is "set only", I see no reason to
> > add it to the info dump.  If other folks see it differently then I can
> > do that too.
> >
> > Anyway, it will allow the user to control which VFs are getting
> > displayed during the info dump.  They all default to off so initially
> > no VF info gets displayed.
> >
> > I've also whipped up a patch for the iproute2 ip command.  It'll work
> > like this:
> >
> > 'ip link set <dev> vf (n) filter [on|off]'
> 
> Well there's no need for a persistent filter.  And I think that the
> default behaviour of 'ip' should be to show all the VFs, as it does now.

Dave asked me to make the default behavior to not show the VFs.  Take it up with him.

> 
> [...]
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -62,6 +62,9 @@ struct rtnl_link {
> >  static DEFINE_MUTEX(rtnl_mutex);
> >  static u16 min_ifinfo_dump_size;
> >
> > +/* VF info display filter - Number of VFs max is 256 */
> > +static unsigned long show_vfinfo_filter[256 / sizeof(unsigned long)];
> [...]
> 
> This array is 8 times too large; use BITS_TO_LONGS.

Oops... yeah, that'll be fixed in the actual patch.

- Greg

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
