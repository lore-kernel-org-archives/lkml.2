Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1DRPjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:39:37 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:44191 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1DRPj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:39:29 -0400
X-MDAV-Processed: mail.academy.zt.ua, Mon, 18 Apr 2011 18:39:31 +0300
X-Spam-Processed: mail.academy.zt.ua, Mon, 18 Apr 2011 18:39:29 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTinB-9h=bZg9zg219i2wi3zUCA6mcw@mail.gmail.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	 <201104171938.12834.arnd@arndb.de>
	 <BANLkTim6iCAsViJQS4XrY-XObs8pp-BiQQ@mail.gmail.com>
	 <201104181619.35115.arnd@arndb.de>
	 <BANLkTinB-9h=bZg9zg219i2wi3zUCA6mcw@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 18 Apr 2011 18:35:40 +0300
Message-Id: <1303140940.31595.45.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > You mean the hardware has two sets of registers containing the same
> > information, one of them the standard registers, and one with broadcom
> > specific ones?
> >
> > Why don't you just use the standard ones then?
> 
> No. Did you read my first mail in this thread?
> 
> There is pair of cores for every device. First is AMBA-specific called
> agent/wrapper and second one is Broadcom-specific.
> 
> AMBA specific core called agent/wrapper has AMBA specific registers:
> CID and PID. However we do not ever read that in Broadcom driver,
> because that are useless for us. On AMBA specific core we use only
> some Broadcom specific registers to manage (enable/disable) *second*
> (Broadcom-specific) core.
> 
Actually there could be two wrappers per agent (wrappers and agents
ain't the same, wrapper could be part of agent or core, for broadcom
ssb/axi buses seems we have wrappers in agents only).

Earlier at ssb-times we had wrappers built into agent, separate agent
per core connection for each broadcom core. Connections are implied with
bus usage by core - core can act as bus initiator (starting transfers to
bus regions, those SBTMxxx registers used for control/state), bus target
(accepting transfers from external bus regions, those SBIMxxx registers)
or both.
Currently for broadcom on axi bus we have the same (might implied by
cores circuitry designed to be OCP-compliant) - cores being able to act
both as initiators and targets have two wrappers built into agent, all
other have either slave or master wrapper.

Unlike ssb, where we used wrappers differently, for axi we use them just
for reset and control/state queries and we never reset/query chipcommon
therefore can silently ignore its agent wrappers. For pcie in device
mode we might need to reset both wrappers for clean initialization (at
least I see both master and slave wrappers' reset during 4716 pci device
mode startup in number of GPL'ed sourcecodes) but here I dont know for
sure. For all other single-role cores we have either target or initiator
wrapper for agent control and as those seems to feature same dmp
register's layout therefore we see no difference in wether we reset
agent master or slave.

Unfortunately still have just one axi-based box to play with. Will be
much appreciated if you could share EROM dumps from your boards to get
better understanding of agents/wrappers coupling and relations.

As for amba bus usage I think we could get back to this idea later at
some point if/when broadcom implement some different agents and/or erom
core with other layout or if we spot broadcom-on-axi bus with some
useful native axi peripherals without DMP wrappers (they are actually
already there on the bus but we have no clue how to control them and
actualy have no need to do that anyways) which won't fit into our
coure->agent model but for now I think there is no benefit in doing
that.

Have nice day,
George


