Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934636Ab1IOTnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:43:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52706 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:43:54 -0400
Date: Thu, 15 Sep 2011 14:43:48 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Leopold Palomo-Avellaneda <leo@alaxarxa.net>, linux-kernel@vger.kernel.org,
        Adam Baker <linux@baker-net.org.uk>, linux-parport@lists.infradead.org,
        Nicos Gollan <gollan@informatik.uni-kl.de>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>, jan@lvr.com
Subject: Re: [PATCH/RFC] parport_pc: remove ancient, overeager quirk that
 disables EPP support on many chipsets
Message-ID: <20110915194348.GC19450@elie>
References: <201109151441.15015.leo@alaxarxa.net>
 <CAE2SPAatxqkFUExiNc3EAP3T4EiHQiPxVcd7vPZG23xycy4QLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE2SPAatxqkFUExiNc3EAP3T4EiHQiPxVcd7vPZG23xycy4QLw@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien ROUCARIES wrote:

> Why not check dmi years for this test and do the test only for board
> before 2000 ? Better safe than sorry

That would just leave the code broken on boards before 2000.

Here's a reference to the problem the test was supposed to fix:

 http://lkml.indiana.edu/hypermail/linux/kernel/9901.2/1285.html

It says:

| A small number of IO chipsets do not have the EPP timeout function hence if 
| there is no EPP device then the CPU is permantly in the HALT state and nothing 
| happens LITERALLY! <CNTL><ALT><DEL> does not even function! The bulk (if not 
| all) the IO chipsets in this category fail the bug check test, as a result it 
| is assumed there is no EPP (or to dangerous to use). This may prevent some 
| valid chipsets working properly.

It sounds like the test removed by [1] has false positives and false
negatives.

Jan Axelson's "Parallel Port Complete" recommends:

 - first check for ECP as described in Microsoft's "Extended
   Capabilities Port Protocol and ISA Interface Standard" document:

   . First check for the presence of the ECR register, by checking
     that bits 0 and 1 act like "empty" and "full" bits (so they
     start out set and cleared respectively and after writing 0x34 you
     can read back 0x35).

     parport_ECR_present() does this and save the result to priv->ecr.

   . Put the port in configuration mode by writing 0xf4 to the ECR,
     etc (parport_ECP_supported() does these checks).

 - if the above fails, then check for EPP.  There are a couple of
   choices suggested for that:

   A) Write some values to one of the EPP registers and then read them
      back.  If nothing is plugged in there, that should provoke a
      timeout; the spec doesn't say what you read back, but she found
      that it would always read back what you wrote and that in practice
      it worked for discovering EPP ports.

   B) Check that the timeout bit (ECR bit 0) is set when a timeout occurs,
      and then clear it.  On some ports, just trying a transfer with
      nothing plugged in will provoke a timeout, while on others ECR bit 7
      needs to be set first.  And of course there's more than one way to
      clear it.

      Intel's 82091 data sheet does not mention the timeout bit at all.
      Maybe it doesn't implement it.

      http://www.lvr.com/jansfaq.htm also mentions "Beware #1: on
      SMC's chips (& maybe others), a set timeout bit can make the
      port unusable in any mode, until a hard reset (or clearing the
      bit)!"  So one does have to make sure to clear the bit.

Would it make sense to switch to doing (A)?  If not, is there some
test that can be used to detect an 82091 specifically (or are there
other chipsets that don't have the timeout bit)?  Cc-ing Jan for
advice (thanks for your work in documenting what makes parallel ports
tick, Jan!).

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.linux.kernel/1191591
