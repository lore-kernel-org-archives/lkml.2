Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632Ab1AKTel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:34:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12115 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab1AKTei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:34:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 11 Jan 2011 11:34:11 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "'Pavel Machek'" <pavel@ucw.cz>
CC: "jj@chaosbits.net" <jj@chaosbits.net>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Tue, 11 Jan 2011 11:34:09 -0800
Subject: RE: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: AcuxGwRn/WeqLt+dTXi0ZloP0CKwbQAqANXA
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A008062@HQMAIL03.nvidia.com>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
 <20110110221624.GA16445@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
 <20110110230622.GB16759@core.coreip.homeip.net>
In-Reply-To: <20110110230622.GB16759@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All.

I have combined Pavel's and Dmitry's comments so I can address them as one issue.

Dmitry's comment

> On Mon, Jan 10, 2011 at 02:49:25PM -0800, Rakesh Iyer wrote:
> > > On Fri, Jan 07, 2011 at 09:45:07AM -0800, riyer@nvidia.com wrote:
> > > > +
> > > > +struct tegra_kbc {
> > > > +	void __iomem *mmio;
> > > > +	struct input_dev *idev;
> > > > +	int irq;
> > > > +	unsigned int wake_enable_rows;
> > > > +	unsigned int wake_enable_cols;
> > > > +	spinlock_t lock;
> > > > +	unsigned int repoll_time;
> > > > +	unsigned long cp_dly_jiffies;
> > > > +	int fifo[KBC_MAX_KPENT];
> > > > +	const struct tegra_kbc_platform_data *pdata;
> > > > +	int *plain_keycode;
> > > > +	int *fn_keycode;
> > >
> > > There should not be separate keycodes for FN and normal kys - FN is just
> > > a modifier, like SHIFT or CTRL or ALT are and shoudl be handled in upper
> > > layers.
> >
> > We had the same thought regarding Function as a modifier akin to Shift, Ctrl an Alt.
> > But this does not appear to be the case.
> >
> > This keyboard is used primarily for Laptop-like form factors where function keys are used
> to overload the existing keys.
> 
> So it is same SHIFT.
> 
> > In addition the Fn key mappings aren't identical in different keyboard layouts.
> 
> 
> Same as SHIFT - depending on layout used shifted KEY_1 produces either '!' or '1'.

The FN key modifiers are not identical to Shift Modifier. They map to totally different keys for this keyboard.
If you are suggesting that you weren't implying they map to the same thing, then I agree it can be treated as a modifier.
But the problem is the higher layers don't necessarily do so. 

The documentation I have read all suggest the Fn key isn't a valid modifier for the operating system, 
and that most keyboard hardware abstracts the Fn keypress and generates the modified key.
Maybe my understanding is incorrect regarding this so please feel free to give me the information.

Since our keyboard controller hardware (made for a SOC) is very simplistic the driver has to do this.


Pavel's comment

> > > +	int fifo[KBC_MAX_KPENT];
> > > +	const struct tegra_kbc_platform_data *pdata;
> > > +	int *plain_keycode;
> > > +	int *fn_keycode;
> > 
> > There should not be separate keycodes for FN and normal kys - FN is just
> > a modifier, like SHIFT or CTRL or ALT are and shoudl be handled in upper
> > layers.
> 
> We had the same thought regarding Function as a modifier akin to Shift, Ctrl an Alt.
> But this does not appear to be the case. 
> 
> This keyboard is used primarily for Laptop-like form factors where function keys are used to overload the existing keys. 
> In addition the Fn key mappings aren't identical in different keyboard layouts.
> 
> So at this point in order to function with the target hardware and
> the target operating system which is Chrome, this modifier
> keymap is necessary.

> Please find a way to do this cleanly. Other machines (zaurus) have
> similar keyboards...

With regards to Pavel's comment of handling this within the driver without another keymap, we have explored using a smaller 
key translation map, but we cannot use this as we support a varied number of keyboards depending on the OEM. 
Thus our keymaps and the resultant function modified keys are dependent on the target keyboard and hence the need for the 
Override keymaps.


Please let me know if you think the current approach is okay given our targeted configurations, or if there are alternative mechanisms.

Thanks and Regards
Rakesh
