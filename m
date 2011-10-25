Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1JYHGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:06:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43070 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab1JYHGf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:06:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAGZ=bqJNRCiiT6KvQBkZ5fs6b=RQG92xtmf1cGe1s9mdcbcDFA@mail.gmail.com>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-6-git-send-email-Kyle.D.Moffett@boeing.com>
 <201110201710.17519.vapier@gentoo.org> <201110201714.36533.vapier@gentoo.org> <CAGZ=bqJNRCiiT6KvQBkZ5fs6b=RQG92xtmf1cGe1s9mdcbcDFA@mail.gmail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 25 Oct 2011 03:06:15 -0400
X-Google-Sender-Auth: 4mz-nABLPhjhSqZLFBZogndRUr0
Message-ID: <CAJaTeTpZ4s3s1Xiy1Ng-hMiuGVTmJepRUHD-Cx4ruxBf+X7MzA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/17] phy_driver: Make .read_status()/.config_aneg() optional
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Baruch Siach <baruch@tkos.co.il>, Thorsten Schubert <tshu@msc-ge.com>,
        David Decotigny <decot@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 01:13, Kyle Moffett wrote:
> On Thu, Oct 20, 2011 at 17:14, Mike Frysinger wrote:
>> On Thursday 20 October 2011 17:10:12 Mike Frysinger wrote:
>>> On Thursday 20 October 2011 17:00:12 Kyle Moffett wrote:
>>> > Approximately 90% of the PHY drivers follow the PHY layer docs and
>>> > simply use &genphy_read_status and &genphy_config_aneg.  There would
>>> > seem to be little point in requiring them all to manually specify those
>>> > functions.
>>>
>>> well, it does make sense if you think about the compile vs build time
>>> overhead.  yes, your patch does make things much nicer to read, and a
>>> little easier to maintain the source.  however, it adds runtime overhead
>>> (checking the func pointers) while the func pointer storage is unchanged
>>> (it's now a NULL pointer instead of pointing to the genphy funcs).
>>> personally, i think the savings in runtime and smaller compiled code is
>>> more important.  so i'm going to NAK this.  sorry.
>>
>> ah, sorry, i was thinking this was u-boot since we were just having
>> conversations there.
>>
>> since this is Linux, and i don't have real standing in the general netdev
>> community, i can't really NAK here.  but i think my comment still stands in
>> that this patch makes things much worse than the minor code style improvement.
>
> I would argue that the PHY layer itself is not remotely a hot-path,
> especially not to the level of caring about an extra if statement.  A
> single phy_read() is a sleeping call which goes over a slow serial
> bus, so code maintainability is much more important.

i disagree.  ignoring that, what you ultimately desire can be
accomplished without bloating the kernel.

option 1: this can be done in the registration func just like the mtd
layer.  if (!func_pointer) func_pointer = default;

option 2: introduce a new macro in the common phy header similar to:
  #define PHY_DRIVER_DEFAULT_FUNCS \
    .config_aneg = genphy_config_aneg, \
    .read_status = genphy_read_status
and then use that in the phy_driver init structs:
  struct phy_driver bcm5411_driver = {
    PHY_DRIVER_DEFAULT_FUNCS,
    .config_aneg = bcm5411_config_aneg,
    ...

however, imo, these func pointer arrays really should be in the
.rodata section with proper const markers.  this would require
breaking out into a new phy_driver_opts struct since the phy_driver
struct has read/write fields (like the list structure).  option 2
should allow this to work.
-mike
