Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab1HLVwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:52:01 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:33150 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab1HLVv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:51:58 -0400
X-SENDER-IP: [85.230.168.63]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmxnAHWfRU5V5qg/PGdsb2JhbABBiQ+eaQsBAQEBNzKBQAEBBAEnExwjBQsIAw44FCUKGogCArsXDoVaXwSYKotZ
X-IronPort-AV: E=Sophos;i="4.67,364,1309730400"; 
   d="scan'208";a="211340902"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 12 Aug 2011 23:52:53 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 6/8 v3] Input: synaptics - process finger (<=3)
 transitions
Message-ID: <20110812215253.GB9124@polaris.bitmath.org>
References: <1313169407-4358-1-git-send-email-djkurtz@chromium.org>
 <1313169407-4358-7-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313169407-4358-7-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Synaptics image sensor touchpads track 5 fingers, but only report 2.
> This patch attempts to deal with some idiosyncrasies of these
> touchpads:

I appreciate the complexity of the protocol at hand, and the patch is
doing an excellent job documenting it. However, it does constitute a
fair deal of code... What about the statements below:

1. When two subsequent sgm packets report the same number of fingers
(and unless told otherwise in some other fashion?), the sgm and the
previous agm contains data for the same fingers as the previous (agm,
sgm) pair, i.e., there is no transition.

2. There is no general way to know which fingers are being reported
after a transition.

If both points above are true, how about something like this:

a) Always report slots zero and one (for two or more fingers)

b) Keep a global number, trackid

c) Parse are buffer agm

d) Parse sgm

e) If a transition occured, increase trackid by two

f) Set TRACKING_ID to trackid in slot zero and trackid+1 in slot one.

It seems to me the above will result in contiuous handling of two
unknown contacts in between transitions, and during transitions, new
contacts will be generated.

The algorithm above could possibly be improved for the 2->1
transition, but from what I gather, 1->2 and 2->3 as well as 3->2 does
not seem to be generally solvable, hence resulting in the above
anyways.

If any of points 1 and 2 are wrong, I am sure you will
enlighten/remind me. ;-)

Cheers,
Henrik
