Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1D0XLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:11:05 -0400
Received: from mail.solarflare.com ([216.237.3.220]:48071 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab1D0XLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:11:03 -0400
Subject: Re: [PATCHv2 3/4] ethtool: Use the full 32 bit speed range in
 ethtool's set_settings
From: Ben Hutchings <bhutchings@solarflare.com>
To: david@decotigny.fr
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <4DB89315.6070105@google.com>
References: <1303001651-4074-1-git-send-email-decot@google.com>
	 <1303929290-21037-4-git-send-email-decot@google.com>
	 <1303932477.2875.130.camel@bwh-desktop>  <4DB89315.6070105@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Thu, 28 Apr 2011 00:10:58 +0100
Message-ID: <1303945858.2875.164.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Apr 2011 23:11:02.0715 (UTC) FILETIME=[60C760B0:01CC0530]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--21.684100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 15:05 -0700, David Decotigny wrote:
> Hi,
> 
> On 04/27/11 12:27, Ben Hutchings wrote:
> >> diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
> >> index b13c6b0..f8d26bf 100644
> >> --- a/drivers/net/tulip/de2104x.c
> >> +++ b/drivers/net/tulip/de2104x.c
> >> @@ -1549,10 +1549,11 @@ static int __de_set_settings(struct de_private *de, struct ethtool_cmd *ecmd)
> >>  {
> >>  	u32 new_media;
> >>  	unsigned int media_lock;
> >> +	u32 speed = ethtool_cmd_speed(ecmd);
> >>  
> >> -	if (ecmd->speed != SPEED_10 && ecmd->speed != 5 && ecmd->speed != 2)
> >> +	if (speed != SPEED_10 && speed != 5 && speed != 2)
> >>  		return -EINVAL;
> >> -	if (de->de21040 && ecmd->speed == 2)
> >> +	if (de->de21040 && speed == 2)
> >>  		return -EINVAL;
> >>  	if (ecmd->duplex != DUPLEX_HALF && ecmd->duplex != DUPLEX_FULL)
> >>  		return -EINVAL;
> > [...]
> > 
> > This implementation is absolute crap - it's using speed values as
> > mnemonics for different physical ports!  Please change it to report and
> > accept only speed = 10.  (Both get_settings and set_settings have to be
> > changed at the same time.)
> 
> Well, I am really not sure about this. At first I thought you meant that
> these non standard throughputs were a weird way to switch between
> different ports because of some limitation in the ethtool API at the
> time the driver was written. But looking at the history, this behavior
> is there right from the very first revision of the driver checked in in
> v2.5.0.9
> (http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=b1507c9acd944c8703612c0e38ac580bf9064e8a),
> and the ports could be switched the normal way with ecmd->port.

ethtool was quite new then.  It's not that surprising that people found
odd ways to implement the API - though a little surprising that Jeff did
so, since he was also maintaining ethtool...

> So this
> leads me to think that these speeds are actual speeds and make sense as
> such, they are not a work-around over some ancient ethtool API
> limitation.
[...]

If you care to dig out the datasheets for these chips (DEC 21040 and
21041) you'll see they support 10BASE-T, 10BASE-2 and 10BASE-5.  There's
no such thing as 2M or 5M Ethernet (not counting 'wireless Ethernet').

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

