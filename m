Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab1AYF3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:29:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36048 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1AYF3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:29:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L440PKzIkNrWT6qpzzpWmSMYSZrdvIUR2AXbU0HBqvT4vl23ynu4fwVDM+1RItITE5
         L6RGVcNCIO15a74KOEpHUT/LbgNkUYHG7KtW+u/GQLYx7pnVY1EUPih8sDQFijI3J5B/
         mIPX4A5TRjtMDPkrDoTM2p8py4Ub+RE4HtSCg=
Date: Mon, 24 Jan 2011 21:29:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125052902.GC7850@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
 <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E59CA.6070107@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:04:10AM -0500, Mark Lord wrote:
> On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
> > On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> ..
> >> This results in (map->size==10) for 2.6.36+ (wrong),
> >> and a much larger map->size for 2.6.35 and earlier.
> >>
> >> So perhaps EVIOCGKEYCODE has changed?
> >>
> > 
> > So the utility expects that all devices have flat scancode space and
> > driver might have changed so it does not recognize scancode 10 as valid
> > scancode anymore.
> > 
> > The options are:
> > 
> > 1. Convert to EVIOCGKEYCODE2
> > 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
> 
> or 3. Revert/fix the in-kernel regression.
> 
> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
> (but value) keycodes, and only return -EINVAL when the keycode itself
> is out of range.

You are inventing rules.  You are requesting a scancode->keycode
mapping. If scancode is unknown/invalid for the device ioctl returns
-EINVAL.

> 
> That's how it worked in all kernels prior to 2.6.36,
> and now it is broken.  It now returns -EINVAL for any unmapped keycode,
> even though keycodes higher than that still have mappings.

For unmapped - yes, either KEY_RESERVED or KEY_UNKNOWN should be
returned. For invalid scancodes -EINVAL shoudl be returned. Scancodes
are not guaranteed to be continuous (and never have been for all devices
although there are still plenty of devices with continuous scancodes,
like atkbd).

> 
> This is a bug, a regression, and breaks userspace.
> I haven't identified *where* in the kernel the breakage happened,
> though.. that code confuses me.  :)
> 

-- 
Dmitry
