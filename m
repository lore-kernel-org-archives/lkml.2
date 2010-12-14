Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab0LNWMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:12:50 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53389 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0LNWMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BplNmOmmUTMrZO8ws+OZYma2W5rFGcbEfPEbIRYg7+qhLCx316iMpXPV5bsgV0oGdW
         puTYOVfZQYwfMVa70DD1folIg7HAUPVwe3lhscdIqey74rlEiRX7LlP60jMpF5lHq05u
         lDscS3vRfzsfwwOLZWGN2GLSWUy44e0mQe2kc=
Date: Tue, 14 Dec 2010 14:12:41 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
Message-ID: <20101214221241.GA11519@core.coreip.homeip.net>
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Tue, Dec 14, 2010 at 01:21:08PM -0800, Chase Douglas wrote:
> Hello all,
> 
> I was left somewhat dissatisfied by the MT_TOOL_ENVELOPE addition, so I decided
> to try to propose a different solution for the problem. As a recap, the problem
> can best be defined by Synaptics hardware that provide two touch coordinates
> (X1, Y1) and (X2, Y2). Unfortunately, the real touches may be at (X1, Y2) and
> (X2, Y1). Further, three touches may be recognized, but only two coordinates are
> reported.
> 
> Following this are four patches. The first merely reverts the MT_TOOL_ENVELOPE
> addition. The second adds documentation for evdev codes to the Documentation
> directory. It was hastily created, so it has some ommissions and may have some
> mistakes. My hope is that we keep this or a similar document up to date whenever
> non-obvious codes are added to evdev.

This is great, thank you.

> The third patch adds the following EV_ABS
> codes:
> 
> ABS_RECT_MIN_X
> ABS_RECT_MIN_Y
> ABS_RECT_MAX_X
> ABS_RECT_MAX_Y
> 
> The purpose of these codes is to provide for devices that at best report a
> rectangular bounding box of touches. Instead of using the MT evdev protocol,
> this approach uses ST protocol semantics.
> 
> Finally, the last patch adds support for the above codes to the synaptics
> driver.
> 
> It is my belief that this is a better interface than MT_TOOL_ENVELOPE for the
> following reasons:
> 
> * The code meanings are more readily graspable from the names
> * The codes behave with ST semantics, which is useful because we likely cannot
>   split properties like pressure and orientation among the touches
> * ST semantics are easier to comprehend than MT semantics, and MT isn't required
>   to solve this problem
> * The codes provide only the max and min values, none in between. This is in
>   contrast with MT_TOOL_ENVELOPE, which provides all touches as presented by the
>   hardware. However, we don't trust all the coordinate pairings, so providing
>   faulty pairings may induce incorrect userspace usage of the events.
> * A clear distinction is made here that full multitouch devices should use the
>   MT protocol, while lesser devices should use the ST protocol.
> 

No, I do not agree with this proposal. This would introduce new _axes_
(with potentially different min, max, resolution, etc) for the working
surface of the devices instead of merely saying that the device may
report more than simple singular contact within the standard axes.

I believe that MT protocol _is_ the correct vehicle to transmit semi-MT
device state to userspace.

As to reporting more than 2 contacts with MT_TOOL_ENVELOPE - I think we
should not do that. Instead we should only report 2 outermost points of
the bounding rectangle as MT_TOOL_ENVELOPE and convey number of contacts
with BTN_TOOL_xxxTAP (so up to 4 contacts, at least for now).

Thanks.

-- 
Dmitry
