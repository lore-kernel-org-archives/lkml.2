Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1A0RVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 12:21:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63197 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1A0RVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 12:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gm44S678GzKO2mAR+AwweDNa04dgsx+m29jBhi7W5G5vHEnQHfFJFlrdc6TqrLq4zo
         gLEu2Duxp9jCqQvWg8Ed17Sn5FKPJiBl32YkTayRriKlW7O+TONyd09MoxvacawXRXDN
         YuZrfRjmrtBaJIJ8oPOoDYSEZRaEUpzVDWzNU=
Date: Thu, 27 Jan 2011 09:21:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110127172128.GA19672@core.coreip.homeip.net>
References: <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
 <20110127063815.GA29924@core.coreip.homeip.net>
 <4D414928.80801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D414928.80801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 08:30:00AM -0200, Mauro Carvalho Chehab wrote:
> 
> On my tests here, this is working fine, with Fedora and RHEL 6, on my
> usual test devices, so I don't believe that the tool itself is broken, 
> nor I think that the issue is due to the fix patch.
> 
> I remember that when Kay added a persistence utility tool that opens a V4L
> device in order to read some capabilities, this caused a race condition
> into a number of drivers that use to register the video device too early.
> The result is that udev were opening the device before the end of the
> register process, causing OOPS and other problems.

Well, this is quite possible. The usev ruls in the v4l-utils reads:

ACTION=="add", SUBSYSTEM=="rc", RUN+="/usr/bin/ir-keytable -a /etc/rc_maps.cfg -s $name"

So we act when we add RC device to the system. The corresponding input
device has not been registered yet (and will not be for some time
because before creating input ddevice we invoke request_module() to load
initial rc map module) so the tool runs simultaneously with kernel
registering input device and it could very well be it can't find
something it really wants.

This would explain why Mark sees the segfault only when invoked via
udev but not when ran manually.

However I still do not understand why Mark does not see the same issue
without the patch. Like I said, maybe if Mark could recompile with
debug data and us a core we'd see what is going on.

BTW, that means that we need to redo udev rules. Maybe we should split
the utility into 2 parts - one dealing with rcX device and for keymap
setting reuse udev's existing utility that adjusts maps on ann input
devices, not for RCs only.

-- 
Dmitry
