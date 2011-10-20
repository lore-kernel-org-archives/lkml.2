Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab1JTSlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 14:41:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10624 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1JTSli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 14:41:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 20 Oct 2011 11:41:30 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Oct 2011 11:41:29 -0700
Subject: RE: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Topic: [PATCH 2/2] pinctrl: add a generic control interface
Thread-Index: AcyPLl3O9d8SAsFnQNqnOtcnoBcPTwAIE2zA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173D51C235@HQMAIL01.nvidia.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173D51C039@HQMAIL01.nvidia.com>
	<20111020024556.GD32007@S2100-06.ap.freescale.net>
 <CACRpkdbK6bmYQbUcwxBRoq6L3YJ9yq5fQuF7zEbrStbiCrYEQQ@mail.gmail.com>
In-Reply-To: <CACRpkdbK6bmYQbUcwxBRoq6L3YJ9yq5fQuF7zEbrStbiCrYEQQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Thursday, October 20, 2011 7:44 AM:
> On Thu, Oct 20, 2011 at 4:45 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> > We should not require device driver to call these APIs directly.  There
> > are so many pinctrl subsystem internal details left to its users.
> 
> As explained I already have drivers that need to do this. OK they
> are out-of-tree, but they do exist.
> 
> For U5500 we have a SIM card driver which sets pull down resistance
> and load capacitance in response to information retrieved from the
> card at runtime. This is not static or internal to pinctrl at all. How should
> I solve this if pin configuration is not exposed?

I think drivers should operate at a higher level than "set pin X's param
Y to value Z".

I imagine the set of states that the SIM card driver needs to set up are
defined by the SIM protocol.

So, the driver communicates with the SIM card, find out that it supports
Certain clock frequencies or capabilities etc., and then needs to program
the SIM card and associated SoC-side HW to operate in the selected mode.

The set of legal modes for the SIM card protocol is presumably pretty
small, so the SIM driver might want to request "basic" or "fast" operation
(note: I have zero knowledge of SIM cars, so those mode names are bogus).

Similarly, SD/MMC drivers might know about a mode name for each clock
frequency (or range) that an SD card is allowed to support by spec.

However, I still think it's a good idea for pinctrl drivers to expose
each of their available configuration options with as little veneer or
abstraction as possible.

To bridge these two levels of abstraction, I think the pinctrl core
needs to be provided with information or an API to map between them.

I imagine this could be implemented as a table rather similar to the
existing mux table, or even part of that mux table.

The table would be at least partially board-specific (since a given SD
instance might be mux'd onto a different set of pins between two boards,
and the values for each param might be determined during board
characterization), but for a given HW module (SIM, SD), at least some
of the data might be the same across any board that use that function,
irrespective of which set of pins is in use or independent of board
characterization. So, we might have to think about how the board and
SoC code (and/or DT board/SoC bindings) could interact to reduce
duplication of common settings, but we should probably defer that
discussion.

-- 
nvpublic

