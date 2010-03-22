Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0CVVCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:02:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41143 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab0CVVCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:02:02 -0400
Subject: Re: [PATCHv2 0/6] pps: time synchronization over LPT
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>
In-Reply-To: <20100322234201.73ffc06a@tornado.gnet>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
	 <1f1b08da1003081925p61a810e4v96be56640287d61@mail.gmail.com>
	 <20100322234201.73ffc06a@tornado.gnet>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 14:01:50 -0700
Message-ID: <1269291710.3283.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-22 at 23:42 +0300, Alexander Gordeev wrote:
> Hi John,
> 
> Sorry for the delay...
> 
> В Mon, 8 Mar 2010 19:25:07 -0800
> john stultz <johnstul@us.ibm.com> пишет:
> 
> > On Wed, Feb 24, 2010 at 4:28 AM, Alexander Gordeev
> > <lasaine@lvk.cs.msu.su> wrote:
> > > This patchset is tested against the vanilla 2.6.32.9 kernel. But we
> > > are actually using it on 2.6.31.12-rt20 rt-preempt kernel most of
> > > the time. Also there is a version which should be applied on top of
> > > LinuxPPS out of tree patches (i.e. all clients and low-level irq
> > > timestamps stuff). Those who are interested in other versions of
> > > the patchset can find them in my git repository:
> > > http://lvk.cs.msu.su/~lasaine/timesync/linux-2.6-timesync.git
> > >
> > > There is one problem however: hardpps() works bad when used on top
> > > of 2.6.33-rc* with CONFIG_NO_HZ enabled. The reason for this is
> > > commit a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it
> > > hardpps() is able to sync to 1us precision in about 10 seconds.
> > > With it
> > 
> > Uh. Not sure I see right off why the logarithmic time accumulation
> > would give you troubles. Its actually there to try to fix a couple of
> > NTP issues that cropped up when the accumulation interval was pushed
> > out to 2HZ with CONFIG_NO_HZ.
> 
> Yes, I know. I guess (based on the commit log and other sources) that
> this change was added to make chrony work better on tickless kernel.
> So chrony corrects the time using only frequency corrections?

I'm not super familiar with chrony, but from talking with folks who work
on it, it doesn't use the doesn't use the kernel pll, and instead uses
old oneshot mode. 

So yea, the logarithmic accumulation did help chrony as well as other
users of adjtimex that expected to be able to make HZ granular
adjustments. 


> My approach is different: use time_offset t remove the phase error and
> adjust time_freq to remove frequency error.

This sounds much closer to how NTP does it.
So are you using the kernel PLL? or just singleshot for the offset?


> > Do you have any extra insight here as to whats going on with your
> > code?   The only thing I could guess would be second_overflow() is
> > happening closer to the actual overflow, but maybe less regularly? But
> > again, I'm not sure how this would be drastically different then
> > before with the 2HZ accumulation period.
> 
> I still can't find this out (partially because I'm too busy with other
> tasks). The new code seems ok to mee. time_offset is added at
> second_overflow as usual. Maybe the problem is with the frequency
> correction. I'm going to run some tests that should show where the
> problem is: in the phase or freq correction.

Yea, you can play with things on the kernel side by setting
NTP_INTERVAL_FREQ to 2 in include/linux/timex.h to move back to the
coarser granularity (while preserving the logarithmic accumulation).

Do let me know if you find anything here.

thanks
-john

