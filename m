Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1AYFHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 00:07:33 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:30732 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198Ab1AYFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 00:07:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAH/pPU1Ld/sX/2dsb2JhbAAMhAfMYpBigSSDOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,372,1291611600"; 
   d="scan'208";a="89131682"
Message-ID: <4D3E5A91.30207@teksavvy.com>
Date: Tue, 25 Jan 2011 00:07:29 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3C5F73.2050408@teksavvy.com> <20110124175456.GA17855@core.coreip.homeip.net> <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net> <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net> <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net> <4D3E59CA.6070107@teksavvy.com>
In-Reply-To: <4D3E59CA.6070107@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-25 12:04 AM, Mark Lord wrote:
> On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
>> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> ..
>>> This results in (map->size==10) for 2.6.36+ (wrong),
>>> and a much larger map->size for 2.6.35 and earlier.
>>>
>>> So perhaps EVIOCGKEYCODE has changed?
>>>
>>
>> So the utility expects that all devices have flat scancode space and
>> driver might have changed so it does not recognize scancode 10 as valid
>> scancode anymore.
>>
>> The options are:
>>
>> 1. Convert to EVIOCGKEYCODE2
>> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
> 
> or 3. Revert/fix the in-kernel regression.
> 
> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
> (but value) keycodes, and only return -EINVAL when the keycode itself
> is out of range.
> 
> That's how it worked in all kernels prior to 2.6.36,
> and now it is broken.  It now returns -EINVAL for any unmapped keycode,
> even though keycodes higher than that still have mappings.
> 
> This is a bug, a regression, and breaks userspace.
> I haven't identified *where* in the kernel the breakage happened,
> though.. that code confuses me.  :)

Note that this device DOES have "flat scancode space",
and the kernel is now incorrectly signalling an error (-EINVAL)
in response to a perfectly valid query of a VALID (and mappable)
keycode on the remote control

The code really is a valid button, it just doesn't have a default mapping
set by the kernel (I can set a mapping for that code from userspace and it works).

This is a BUG.  Returning -EINVAL here is entirely wrong.

Cheers
