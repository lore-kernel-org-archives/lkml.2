Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0CTV7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 17:59:41 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36503 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597Ab0CTV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 17:59:40 -0400
Message-ID: <4BA54541.5030900@euromail.se>
Date: Sat, 20 Mar 2010 22:59:29 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Henrik Rydberg <rydberg@enmesh.se>,
       linux-input <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: input: mt: Software finger tracking in the kernel?
References: <4BA358DB.20708@enmesh.se> <20100320194424.GC28402@core.coreip.homeip.net>
In-Reply-To: <20100320194424.GC28402@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1Nt6hi-0007PQ-Ai.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1Nt6hi-0007PQ-Ai 792bf8d631e7e47dd88ef50a57f4b993
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Henrik
[...]
> I am not sure if input core itself is the proper place to do such
> thing, I'd envisioned something more like a library providing common
> code that drivers could opt in to use, like we hane ff-memless for
> memory-less force-feedback devices.
> 
> Does it make any sense? I guess post the skeleton of the code and we can
> discuss further.

Yes, input core as in input*.c might be wrong. The big thing is that the events
most likely have to be deferred to the bottom half. Otherwise, the scheme would
have fit rather nicely on top of the current filtering in input_device. The
ideas I am currently looking at are:

1. Expand on the new event filtering mechanism, providing a sort of rewrite
functionality which can schedule events for later injection into the event stream.

2. Add additional logic to evdev so that it buffers MT events and flushes the
reworked events directly onto the clients.

3. Add a new multitouch handler, mtdev, which by default does event deferral,
only emitting events by scheduling them upon SYN_REPORT requests.

To my untrained eye, all three options could be made to work with acceptable
latency. Number three probably means applications (read X) have to keep open
both evdev and mtdev, which might be confusing. Number one is quite general, but
probably contains hidden (to me) difficulties. Number two sounds pretty
straight-forward, although tapping into the code somewhat through the back door.

Henrik
