Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0DEU0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:26:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49534 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab0DEUZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:25:59 -0400
Message-ID: <4BBA473D.9040004@zytor.com>
Date: Mon, 05 Apr 2010 13:25:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@redhat.com,
       x86@kernel.org
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if CONFIG_VGA_CONSOLE
 is undefined
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com> <1270497725.1477.488.camel@groeck-laptop>
In-Reply-To: <1270497725.1477.488.camel@groeck-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 01:02 PM, Guenter Roeck wrote:
>>
>> You didn't answer my question (c).
>>
>> I want to know how you ended up with
>> boot_params.screen_info.orig_video_isVGA == 1 on a system with no VGA,
>> which seems like it would have resolved this.
>>
>> I am *not* inclined to add a compile-time test for what should have been
>> handed with a runtime test already.
>>
> Sorry, I thought I did answer it.
>

You didn't.  You still haven't!

> The problem is that early_printk() can be called prior to the call to
> setup_early_printk(). Since early_console is currently pre-initialized
> with early_vga_console, output can be written to VGA memory space even
> if there is no VGA controller in the system (and even if
> boot_params.screen_info.orig_video_isVGA == 0). This happens for all
> early_printk() calls executed prior to the call to setup_early_printk().

If boot_params.screen_info.orig_video_isVGA == 0, at least this bit of
your patch has no effect:

> > -		if (!strncmp(buf, "vga", 3) &&
> > +		if (have_vga_console && !strncmp(buf, "vga", 3) &&
> >  		    boot_params.screen_info.orig_video_isVGA == 1) {

Now, we have at least two ways to report a non-VGA console at runtime:

boot_params.screen_info.orig_video_isVGA != 1
boot_params.screen_info.orig_video_lines == 0

The former is zero for CGA/MDA/EGA, but early_vga_write() doesn't work
right for MDA at least, so keying on isVGA is probably right.

early_printk() being called before setup_early_printk() is a problem,
and it's not immediately obvious to me how to fix it.  We can of course
make early_vga_write() simply return if boot_params.screen_info.isVGA ==
0, of course, but it really is a bigger problem than that in many ways.

	-hpa
