Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1AJXGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:06:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38325 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab1AJXGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qaJs75hwa0rnikiMaU6eUMY2zGu+VxOwlo8kwYlUqzA5U39rjGpmQ80efF1+vAMmj6
         hibtkn2WFw4A1Mq9BiYJoOYWjTbiSBhBjVI2p/GDqt1BaNSJsVo0FCf02tZm5jghYVBB
         sO1d7/t+QBjLd73glbEYUOMCdJuCEK6kYHwPU=
Date: Mon, 10 Jan 2011 15:06:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "jj@chaosbits.net" <jj@chaosbits.net>,
        "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110110230622.GB16759@core.coreip.homeip.net>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com>
 <20110110221624.GA16445@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A00805F@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 02:49:25PM -0800, Rakesh Iyer wrote:
> > On Fri, Jan 07, 2011 at 09:45:07AM -0800, riyer@nvidia.com wrote:
> > > +
> > > +struct tegra_kbc {
> > > +	void __iomem *mmio;
> > > +	struct input_dev *idev;
> > > +	int irq;
> > > +	unsigned int wake_enable_rows;
> > > +	unsigned int wake_enable_cols;
> > > +	spinlock_t lock;
> > > +	unsigned int repoll_time;
> > > +	unsigned long cp_dly_jiffies;
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

So it is same SHIFT.

> In addition the Fn key mappings aren't identical in different keyboard layouts.


Same as SHIFT - depending on layout used shifted KEY_1 produces either '!' or '1'.

> 
> So at this point in order to function with the target hardware and the target operating system which is Chrome, this modifier keymap is necessary.
> 
> Let me know what you think.
> 

I think that since FN in your example behaves similarly to the SHIFT
key it should be handled in the same fashion.

> > 
> > Also you should wire up keycode/keycodemax/keycodesize in input_dev
> > structuire so that keymap can be retrieved via EVIOCGKEYCODE and
> > modified via EVIOGSKEYCODE.
> 
> I will proceed to do this.
> 
> >  Also, because keymap is modifiable, the
> > original keymap should be copied in per-device structure, leaving
> > original intact. It (the original) also should be marked as const.
> I did not get the significance to preserving a copy of the original keymap.
> In what situation would we use that.

Unbinding and rebinding the device (via sysfs for example) should
restore device's pristine state. If you modify the shared keymap then it
will not be the case.

> 
> 
> > Since this papears to be a matrix keypad consider using definitions from
> > linux/input/matrix_keypad.h
> >
> 
> I looked at the linux/input/matrix_keypad.h and noticed it shares a decent amount of structure with the tegra keyboard.
> But the tegra kbc hardware differences from the matrix_keypad are significant enough to warrant its own structure.

I was only referring to using struct matrix_keymap_data, KEY(),
MATRIX_SCAN_CODE() and matrix_keypad_build_keymap() definitions. I
understand that matrix_keypad_platform_data might not be directly
applicable.

Thanks.

-- 
Dmitry
