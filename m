Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1LOHgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:36:54 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:50186 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab1LOHgw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:36:52 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, NeilBrown <neilb@suse.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Joe Woodward <jw@terrafix.co.uk>, Chris Ball <cjb@laptop.org>
Date: Wed, 14 Dec 2011 23:35:03 -0800
Subject: RE: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Thread-Topic: [PATCH] mmc/sdio: don't allow interface to runtime-suspend
 until probe is finished.
Thread-Index: Acy31tqp10Nt2ugBQGueuSawrS+kHADHmk9w
Message-ID: <477F20668A386D41ADCC57781B1F704308185E330B@SC-VEXCH1.marvell.com>
References: <20111205125416.6093ecd8@notabene.brown>
 <CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
 <20111206060654.0e8bebe0@notabene.brown>
 <CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
 <20111210181546.6da7099a@notabene.brown>
 <CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
In-Reply-To: <CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
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

Hi Ohad,

> >  But shortly there after the extra tracing I put in shows that mmc_power_off
> >  is called,
> 
> Probably right after libertas' if_sdio_probe() returns ?
> 
> > then mmc_sdio_power_restore calls mmc_send_io_op_cond
> 
> Is that as a result of libertas' if_sdio_power_restore() being called
> (i.e. someone/something called 'ifconfig up') ?
> 
> > which again
> >  returns -110, but now it isn't a problem and the wifi chip keeps working.
> 
> if_sdio_power_restore doesn't check the return value of
> pm_runtime_get_sync, so it won't error out, but I wonder how come the
> chip still works.
> 
> >  So maybe the fact that we error-out in the first case is a problem??
> 
> It might be nice if Marvell could comment on this, though we can
> probably empirically deduce this too.

We will get CMD5 R4 only after a PDn (power down line) or RESETn (reset line) toggling.

Was it timed out on CMD5 or CMD52? The 2nd enumeration will result CMD5 timeout if SD8686 has been initialized (with CMD5,5,3,7 sequence) already. The 2nd CMD5 timeout should not cause any side effect though.

> 
> >  I found that if I pull the reset line down and then let it back up then it
> >  all works.
> 
> Nice. Joe, did this work out for you too ?
> 
> > So I have run out of ideas.  I can make it work by reseting the chip during
> > mmc_power_up but I have no idea what is causing the chip to need a reset.
> 
> I wonder why the sdio reset command isn't helpful for you - it did
> seem to resolve some issues for Daniel. Maybe you have two different
> hardware revisions of the 8686 which behave differently in this
> respect ?

CMD52 Card Reset (writing bit3=1 to CCCR 0x06) may not reset the SD8686 properly for some systems. The reliable way to reset SD8686 is via RESETn toggling.

Regards,
Bing

> 
> > However for now I think I'll go with my 'remux' hack.
> 
> Feel free to post it so we can take a look.
> 
> Thanks,
> Ohad.
