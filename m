Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab0DHNEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 09:04:06 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:48582 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab0DHNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 09:04:01 -0400
Message-ID: <4BBDD3B1.6030808@euromail.se>
Date: Thu, 08 Apr 2010 15:01:37 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: introduce MT event slots
References: <1270685590-2204-1-git-send-email-rydberg@euromail.se>	<87tyrmiqw2.fsf@troilus.org> <4BBDA555.1020003@euromail.se> <87mxxei33o.fsf@troilus.org>
In-Reply-To: <87mxxei33o.fsf@troilus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.129.72
X-Scan-Result: No virus found in message 1NzrMZ-00043m-Ab.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1NzrMZ-00043m-Ab 3d0d4d72ce27ded3c595d19e08458fdf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Poole wrote:
[...]
> 
> For hardware with touch tracking support, what does a slot ID provide
> for user-space that the tracking ID doesn't?  (TRACKING_ID is already
> supposed to be unique for the life of the touch.)

The purpose of the slot is twofold. Firstly, it reintroduces the ability for the
kernel to filter ABS_MT events, which reduces the number of events emitted from
the input core by a large factor. Secondly, it allows the driver to send partial
information without breaking the protocol.

The current MT protocol is designed for anonymous contacts, which dictates that
all data for all fingers has to be sent between every synchronization point.
Although this is fine for a handful of fingers, it does not play well with a
larger scenario. The slot concept allows for a minimum of information to be
emitted from the input core, without breaking compatibility with the current MT
protocol. If a single attribute of a single finger of a single user is changed,
the event sequence will simply be:

SYN_MT_SLOT <slot-in-use>
ABS_MT_ATTRIBUTE <some-value>

If the contact gets destroyed and replaced by another one, there is not even a
need to send that information explicitly, but this sequence would suffice:

SYN_MT_SLOT <slot-in-use>
ABS_MT_USER_ID <replacing-user>
ABS_MT_TRACKING_ID <replacing-tracking-id>
ABS_MT_ATTRIBUTE1 <some-value>
ABS_MT_ATTRIBUTE2 <some-value>
...


One might argue that a similar sequence could be implemented within the existing
 MT protocol. However, it would at least require a different semantic usage of
the SYN_MT_REPORT event, without the ability to detect what semantics to use.
Besides, a larger amount of events would be needed than with the proposed slot
concept.

> For hardware without
> touch tracking, is the driver expected to implement the Euclidean
> bipartite matching in order to assign touch reports to slots?

This is a possible scenario, yes. The driver would of course use a common kernel
library for the matching task. Whether or not this will happen depends somewhat
on how well userspace works with the current MT protocol.

> 
> (Pardon me if I'm being dense -- I'm more familiar with the kernel
> driver side, not the X server's implementation or dispatch of multitouch
> events.)

Thank you for your questions, the discussion is very much appreciated.

Cheers,
Henrik

