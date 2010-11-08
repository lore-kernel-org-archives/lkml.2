Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0KHO6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:58:21 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59565 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754603Ab0KHO6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:58:20 -0500
Message-ID: <4CD80FCB.20903@euromail.se>
Date: Mon, 08 Nov 2010 15:57:15 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD724BC.8020702@seas.upenn.edu>
In-Reply-To: <4CD724BC.8020702@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFTA0-0002Gl-9k.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PFTA0-0002Gl-9k ad338f1fbd4118e740b5dba0210706e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 11:14 PM, Rafi Rubin wrote:

> On 11/07/2010 03:18 PM, Henrik Rydberg wrote:
>> The synaptics patches are currently cooking at Bagwell's, and we
>> already discussed the API a bit. Something ntrig-ish is cooking at
>> Rubin's, and there is also the ntrig driver in Ubuntu 10.10 to
>> consider. All-in-all, it is my hope that posting this patch will
>> simplify the synchronization of our efforts.
> 
> Since Henrik brought it up, here's the tracking code I've been working on.  I
> have not run performance tests.  My goals for this code are perhaps a little
> different.
> 
> - efficient for the common case where contact ordering stays consistent
> - arbitrary number of contacts
> - motion estimation to improve tracking
> - leveraging tracking for error filtering
> 
> Also for fun, I was playing with smoothing in this particular version of the code.
> 
> For now, I'm sending this just for review and discussion.


Hi Rafi,

what tree does this patch apply to?

I think the situation with this driver is slightly cumbersome. Perhaps there is
a small conflict of interest here, but I hope we will be able to resolve it
quickly. I see little benefit in duplicating the tracking efforts. Since greedy
matching algorithms are not provably suited to the task, I think any such
algorithm should first be tested and benchmarked thoroughly, preferably in the
mtdev context.

Regarding the ntrig driver, fact is it does not work very well. Contacts are
occasionally dropped, and spurious ghosts make multitouch gestures not work
properly. There are also many parameters in the driver, which are difficult to
use in practice. Therefore, in the Ubuntu 10.10 kernel, a rather large ntrig
patch has been applied, improving those issues.

The way the data is extracted in 2.6.36 leads to many dropped contacts. The
ubuntu patch remedies this problem, so no particular logic for drops is needed.
Instead, more effort is put into removing ghost contacts, which greatly improves
the actual experience with multitouch gestures.

In order for ghost removal to work, the contacts need to be tracked. Because of
the deficiencies of the ntrig firmware, this needs to be done in software. The
ubuntu patch contains a simple greedy tracking mechanism, which did not seem
good enough to upstream, so I never upstreamed it.

With the proposed matcher (http://lkml.org/lkml/2010/11/7/122), the situation is
different. The ubuntu patch can be modified to use the matcher, which I believe
will make it ready for upstream. Since the patch also removes all parameters
from the driver, the usability aspect is improved.

With the above said, it seems to me that the simplest way forward is to modify
and upstream the ubuntu patches. Would you agree?

Regarding support for more than four fingers, there is a single device which
reports six contacts from the firmware. Getting four good contacts out of it
will be a major improvement, and IMO good enough. It seems likely that future
firmware will handle tracking properly, so this should all be a stop-gap measure
anyways.

We talked earlier about the possibility to perform automatic calibration of the
driver. This would be the last major step towards a fully functional,
maintenance-free driver.

I hope we will be able to agree on the direction of this driver, such that
duplicated work is minimized and the focus stays with the user experience of the
ntrig devices.

Thanks,
Henrik
