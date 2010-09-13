Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0IMHz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:55:57 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48961 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab0IMHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:55:56 -0400
Date: Mon, 13 Sep 2010 09:55:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v2] x86/therm_throt.c: Fix error handling in 
 thermal_throttle_add_dev
Message-ID: <20100913095519.7ca7e22e@hyperion.delvare>
In-Reply-To: <20100910135657.GE20082@ericsson.com>
References: <1283905550-18571-1-git-send-email-fenghua.yu@intel.com>
	<20100910101937.373d8a16@hyperion.delvare>
	<20100910135657.GE20082@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Fri, 10 Sep 2010 06:56:57 -0700, Guenter Roeck wrote:
> On Fri, Sep 10, 2010 at 04:19:37AM -0400, Jean Delvare wrote:
> > On Tue,  7 Sep 2010 17:25:50 -0700, Fenghua Yu wrote:
> > > From: Fenghua Yu <fenghua.yu@intel.com>
> > > 
> > > When sysfs_add_file_to_group fails, thermal_throttle_add_dev removes the
> > > created group and returns with the error code and the driver cleans up and
> > > returns with the error code. Thus the driver either installs all devices
> > > successfully or doesn't install any device at all.
> > 
> > I don't think this makes any sense. While I generally agree with the
> > idea that a given device (actually, CPU feature) should either be fully
> > available or not available at all, I don't get the point of preventing
> > the driver from loading because one device couldn't be initialized for
> > whatever reason. I don't know of any other driver behaving this way.
> > 
> > What's the rationale? I think Ingo's wording was inaccurate and when he
> > wrote "we should either initialize a driver fully - or not intialize it
> > at all" he really meant "device" not "driver. Ingo?
> 
> Question is what happens if an error is returned from device initialization.
> If it causes the driver not to be loaded, it will have to clean up first.
> To avoid that, it would have to drop the error from individual device
> initializations, like it did before.
> 
> As such, it really comes down to philosophy and personal preference.
> Mine would be to return the error and fail driver installation (after all,
> something must really be wrong for that to happen), but then philosopy
> isn't really my field ... so I'll yield to others.

I beg to disagree. The Linux 2.6 device driver model focuses on clear
separation between device instantiation and driver initialization. When
you properly stick to the model, both steps are totally separate, and
even happen in different modules, so device instantiation and
initialization can have no effect on the driver, which can even
pre-exist.

The code we have here is different because there's no device instances
being created, and no device driver binding taking place. But following
the spirit of the model, device initialization should still not affect
the success of driver loading.

Note BTW: Fenghua's patch will have to be rebased, as the following fix
went in the way meanwhile:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=51e3c1b558b31b11bf5fc66d3c6f5adacf3573f7

-- 
Jean Delvare
