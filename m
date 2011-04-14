Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1DNTBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:01:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab1DNTBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:01:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=H89vahQYk4G222rW4cYXfux3WfqVsoafPTVLaNYQreDy/EIxLRQFcd/cbnKzkdpuY5
         8fb4VcW5ND8wbTamgVsw==
MIME-Version: 1.0
In-Reply-To: <20110413102947.3bf1cc88@lxorguk.ukuu.org.uk>
References: <1302641290-30212-1-git-send-email-natg@google.com>
 <1302641387-30264-1-git-send-email-natg@google.com> <20110413070259.GE4070@infomag.iguana.be>
 <20110413102947.3bf1cc88@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Apr 2011 14:00:49 -0500
Message-ID: <BANLkTinR53LO7HWMWoquKY5D+Aprs2OEWw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] Use "request_muxed_region" in it87 watchdog drivers
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>, Nat Gurumoorthy <natg@google.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 4:29 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 13 Apr 2011 09:03:00 +0200
> Wim Van Sebroeck <wim@iguana.be> wrote:
>
>> Hi Nat,
>>
>> > +   (void) request_muxed_region(REG, 2, NAME);
>>
>> Why do we need to typecast this? Can't we just use
>> +     request_muxed_region(REG, 2, NAME);
>
> We really ought to use
>
>        if ()
>
> in theory the request can fail if someone has hogged the resource and not
> muxed it. I'm not clear what the right thing to do in that case is -
> given it should never happen I guess log an error and bail out but that's
> a rather bigger change and perhaps should be a follow up patch ?
>

request_muxed_region() is sorta gross:  it's essentially acting like a
lock, meant to be used for short periods of time, but it can fail if
someone else decides it should.

Would it make more sense to have drivers that need to use the current
request_muxed_region() be able to force a region into a mux-only state
at driver init?  That would lead to much less contorted code to handle
the off-chance that the request_muxed_region() fails.

Ie:

Driver init:

if (!request_muxed_region(base, size, DRV_NAME))
   goto cleanup_driver_init_failed;

Driver cleanup

release_muxed_region(base, size); /* returns void */

And then within drivers:

use_muxed_region(base, size); /* sleeps until region is usable --
returns void */
/* Do stuff */
unuse_muxed_region(base, size); /* returns void */



I realize the above example re-uses the 'request_muxed_region()' name,
but at least this would be much more consistent with how
request_region is used in other drivers.
