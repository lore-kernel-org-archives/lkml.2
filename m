Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1E1VcE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 17:32:04 -0400
Received: from host171.canaca.com ([67.55.55.225]:55034 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1E1VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 17:32:00 -0400
Message-ID: <fd06492f61f15697eb1c8400e29ec7bd.squirrel@host171.canaca.com>
In-Reply-To: <201105282037.22888.michael@m-bauer.org>
References: <201105282037.22888.michael@m-bauer.org>
Date: Sat, 28 May 2011 17:31:58 -0400
Subject: Re: [PATCH] hid: Fix Logitech Driving Force Pro wheel
From: simon@mungewell.org
To: "Michael Bauer" <michael@m-bauer.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jiri Kosina" <jkosina@suse.cz>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael and all,

> As there are significant differences in the descriptor (original
> descriptor
> "hides" the separate axes in a  24 bit FF00 usagepage, new descripter
> replaces
> that with two individual 8 bit desktop.y and desktop.rz usages) I provided
> a
> complete replacement descriptor instead trying to patch the original one.
> Patching the descriptor seems not feasible as the new one is much larger.

I think there a couple problems with your replacement descriptor, although
I don't have a wheel to test with).

1). There is no 'NULL state' on the hatswitch
2). The original does Y then 3 others, the replacement does Y + RZ then 1
other.

When I was looking at doing a similar thing for another wheel I recall
that there was a way of doing a 1 byte NOP, but can't remember how at the
moment.

So you might want to try just patching the original as follows.

> + * 0x95, 0x01,         //          Report Count (1),
> + * 0x75, 0x08,         //          Report Size (8),
> + * 0x26, 0xFF, 0x00,   //          Logical Maximum (255),
> + * 0x46, 0xFF, 0x00,   //          Physical Maximum (255),
> + * 0x09, 0x31,         //          Usage (Y),
> + * 0x81, 0x02,         //          Input (Variable),
> + * 0x06, 0x00, 0xFF,   //          Usage Page (FF00h), -> NOP +
ReportCount(3)
> + * 0x09, 0x00,         //          Usage (00h),        -> usage(Z)
> + * 0x95, 0x03,         //          Report Count (3),   -> usage(Rx)
> + * 0x75, 0x08,         //          Report Size (8),    -> usage(Ry)
> + * 0x81, 0x02,         //          Input (Variable),
> + * 0xC0,               //      End Collection,

Most settings roll over between sections, so don't need to be redefined. I
don't think the exact 'usage()' is important as Linux will just see them
as axis.

Cheers,
Simon

