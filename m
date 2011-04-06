Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1DFOuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:50:18 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:36961 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963Ab1DFOuQ (ORCPT
	<rfc822;groupwise-jlee@novell.com:8:1>);
	Wed, 6 Apr 2011 10:50:16 -0400
Message-Id: <4D9D0A45020000230002AEF7@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Wed, 06 Apr 2011 08:50:13 -0600
From: "Joey Lee" <jlee@novell.com>
To: <ospite@studenti.unina.it>
Cc: <gmzhuo@gmail.com>, <marek.vasut@gmail.com>,
        <openezx-devel@lists.openezx.org>,
        <broonie@opensource.wolfsonmicro.com>, <johannes@sipsolutions.net>,
        <lrg@slimlogic.co.uk>, <linville@tuxdriver.com>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: Regulator consumer driver for rfkill
References: <1302081679-812-1-git-send-email-ospite@studenti.unina.it>
 <1302082178.3811.7.camel@jlt3.sipsolutions.net>
 <20110406160654.e629dfde.ospite@studenti.unina.it>
 <1302098968.4090.0.camel@jlt3.sipsolutions.net>
 <20110406162431.cbcb0fd6.ospite@studenti.unina.it>
In-Reply-To: <20110406162431.cbcb0fd6.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antonio, 

於 三，2011-04-06 於 16:24 +0200，Antonio Ospite 提到：
> On Wed, 06 Apr 2011 16:09:28 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Wed, 2011-04-06 at 16:06 +0200, Antonio Ospite wrote:
> > 
> > > > > +	if (regulator_is_enabled(vcc)) {
> > > > > +		dev_dbg(&pdev->dev, "Regulator already enabled\n");
> > > > > +		rfkill_data->reg_enabled = 1;
> > > > > +	}
> > > > > +	rfkill_init_sw_state(rf_kill, !rfkill_data->reg_enabled);
> > > > > +
> > > > > +	ret = rfkill_register(rf_kill);
> > > > 
> > > > We recently had a thread about how rfkill_init_sw_state() isn't quite
> > > > working the right way. Also, it is indented to be used for devices that
> > > > keep their state over resume. I think you should remove it here and rely
> > > > on rfkill to sync you after registration.
> > > > 
> > > > Cf. the long thread here:
> > > > http://thread.gmane.org/gmane.linux.acpi.devel/49577
> > > >
> > > 
> > > Ok, but I still need to replace that call with a rfkill_set_sw_state()
> > > to expose the initial status of the regulator to the rfkill system,
> > > right?
> > 
> > Well, you could, but if you don't do that then the rfkill subsystem will
> > simply call set_block() shortly after registration to put it into the
> > state that it thinks it should be in, which is usually more useful.
> > 
> 
> I see, let's just drop rfkill_init_sw_state() then.
> 
> Regards,
>    Antonio
> 

Like Johannes's comment, the rfkill_init_sw_state is a bit tricky
especially when RFKILL_INPUT enabled. The rfkill_init_sw_state will
replicate the state to device global state, then rfkill will replicate
it to other killswitch.

If you want to use rfkill_init_sw_state to set rfkill initial state when
driver probed, then I suggest you need test it when:
	- RFKILL_INPUT enabled
	and
	- when device initial state is disabled(BLOCKED)

If you want to maintain the rfkill initial state by your self, you can
reference this patch:
http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=commitdiff;h=8215af019040ce9182728afee9642d8fdeb17f59

The patch set intial state by rfkill_set_sw_state after rfkill register,
and don't touch the BIOS (firmware?) state in set_block until driver
probe finished.


Thank's a lot!
Joey Lee

