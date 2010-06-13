Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0FMWSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:18:46 -0400
Received: from core.signal11.us ([64.251.29.136]:38564 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0FMWSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:18:45 -0400
Message-ID: <4C155945.1030500@signal11.us>
Date: Sun, 13 Jun 2010 18:18:45 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>,
       "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
       Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/1] Bluetooth: hidp: Add support for hidraw HIDIOCGFEATURE  and HIDIOCSFEATURE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Jun 13 18:18:44 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c155944197461238993216
X-DSPAM-Factors: 27,
	reports, 0.01000,
	reports, 0.01000,
	Received*26+177, 0.01000,
	or, 0.01000,
	an, 0.01000,
	an, 0.01000,
	the+device, 0.01000,
	the+device, 0.01000,
	from, 0.01000,
	from, 0.01000,
	of, 0.01000,
	of, 0.01000,
	Received*ESMTP, 0.01000,
	To*suse.cz>, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	use, 0.01000,
	use, 0.01000,
	patch+adds, 0.01000,
	report, 0.01000,
	report, 0.01000,
	received, 0.01000,
	From*<alan, 0.01000,
	would, 0.01000,
	would, 0.01000,
	sent+and, 0.01000,
	To*Holtmann, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the bluetooth hidp module for getting and 
setting FEATURE reports from hidraw, as requested by Jiri Kosina. This 
patch depends on the patch named:

   [PATCH v2] HID: Add Support for Setting and Getting Feature Reports 
from hidraw

I have a couple of concerns with this patch, which I hope someone here 
can clarify and/or help me with.

1. Is it ok to use test_bit()/set_bit()/clear_bit() on session->flags, 
when other parts in the code may not be using these functions to access 
it? This currently isn't a problem because the other code which uses 
flags only sets bits at initialization time (and deletion time). best I 
can tell, flags is never actually used or read other than by my new code 
(using the *_bit() functions). The solution here may be to change the 
other code to use the *_bit() functions to access flags.

2. Is the loop in hidp_get_raw_report() sufficient without a mutex, 
since I'm synchronizing with the atomic call to test_bit() (and 
clear_bit())? I have convinced myself that in this case, with one 
reader, and one writer, to one pointer, synchronized with 
wait_event_interruptible_timeout() and atomic access through test_bit(), 
that a mutex is not needed.

3. A blocking, synchronous GET_REPORT transfer was easy when I 
implemented this for USB because data is both sent and received as part 
of a single control transfer. Because of the nature of Bluetooth 
however, where it is viewed more as an asynchronous network device, and 
with hidraw allowing multiple handles to a single device to exist, there 
could be a race when two handles call the hidp_get_raw_report() function 
concurrently, requesting the same report. I've convinced myself that 
this is not a problem, because since both callers requested the same 
report, the worst that could happen is that one could get a report which 
is slightly out of date.

Consider the following case:
     1. Client 1 requests report (Userspace call to HIDIOCGFEATURE)
     2. Client 2 requests report (Userspace call to HIDIOCGFEATURE)
     3. Client 1's report is returned, and delivered to BOTH clients
     4. Client 2's report is returned (and discarded)

Note here that Client 1's report and Client 2's report are the same 
report, ie: they reflect the state of the same data on the device, just 
at different times. In this case, they are indeed exactly the same data, 
but consider this case:
     1. Client 1 requests report (Userspace call to HIDIOCGFEATURE)
     2. Client 2 SETS report (Userspace call to HIDIOCSFEATURE)
     2. Client 2 requests report (Userspace call to HIDIOCGFEATURE)
     3. Client 1's report is returned, and delivered to Clients 1 and 2
     4. Client 2's report is returned

In this case, client 2 receives OLD data (since it set new data, and the 
call to write the reports is currently not synchronous). To make writes 
synchronous, we'd run into the same problem, of two writes happening 
concurrently, and the 2nd one receiving the ACK from the first one.

The questions here are:
1. Is this a problem? It's only an issues if two handles (in two 
separate threads) are reading and writing the device concurrently. I'd 
expect that there would be bigger problems in this case than receiving 
an old report.
2. If this is a problem, is there a way to synchronize on the control 
socket for the device (as opposed to just this session)? In this case 
GET_REPORT and SET_REPORT would lock access to the control socket (for 
all clients accessing the device) while they are active.

Your feedback is most appreciated,

Alan.








