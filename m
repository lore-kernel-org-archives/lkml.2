Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0FNLpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:45:08 -0400
Received: from core.signal11.us ([64.251.29.136]:58733 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0FNLpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:45:05 -0400
Message-ID: <4C16163C.4080606@signal11.us>
Date: Mon, 14 Jun 2010 07:45:00 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>,
       "David S. Miller" <davem@davemloft.net>, Jiri Kosina <jkosina@suse.cz>,
       Michael Poole <mdpoole@troilus.org>, Bastien Nocera <hadess@hadess.net>,
       Eric Dumazet <eric.dumazet@gmail.com>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] Bluetooth: hidp: Add support for hidraw HIDIOCGFEATURE  and HIDIOCSFEATURE
References: <4C155945.1030500@signal11.us>
In-Reply-To: <4C155945.1030500@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jun 14 07:45:03 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c16163f277955084914554
X-DSPAM-Factors: 27,
	To*Michael, 0.01000,
	could, 0.01000,
	could, 0.01000,
	but, 0.01000,
	reports, 0.01000,
	Received*26+177, 0.01000,
	an, 0.01000,
	an, 0.01000,
	the+device, 0.01000,
	the+device, 0.01000,
	from, 0.01000,
	of, 0.01000,
	of, 0.01000,
	User-Agent*Mozilla/5.0, 0.01000,
	Received*ESMTP, 0.01000,
	User-Agent*rv+1.9.1.9), 0.01000,
	requests, 0.01000,
	requests, 0.01000,
	To*suse.cz>, 0.01000,
	To*troilus.org>, 0.01000,
	Received*(c+76, 0.01000,
	Received*242.hsd1.fl.comcast.net+[76.26.177.242]), 0.01000,
	Date*Mon, 0.01000,
	User-Agent*US+rv, 0.01000,
	report, 0.01000,
	report, 0.01000,
	received, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 06:18 PM, Alan Ott wrote:
> 3. A blocking, synchronous GET_REPORT transfer was easy when I 
> implemented this for USB because data is both sent and received as 
> part of a single control transfer. Because of the nature of Bluetooth 
> however, where it is viewed more as an asynchronous network device, 
> and with hidraw allowing multiple handles to a single device to exist, 
> there could be a race when two handles call the hidp_get_raw_report() 
> function concurrently, requesting the same report. I've convinced 
> myself that this is not a problem, because since both callers 
> requested the same report, the worst that could happen is that one 
> could get a report which is slightly out of date.
>
> Consider the following case:
>     1. Client 1 requests report (Userspace call to HIDIOCGFEATURE)
>     2. Client 2 requests report (Userspace call to HIDIOCGFEATURE)
>     3. Client 1's report is returned, and delivered to BOTH clients
>     4. Client 2's report is returned (and discarded)
>
> Note here that Client 1's report and Client 2's report are the same 
> report, ie: they reflect the state of the same data on the device, 
> just at different times. In this case, they are indeed exactly the 
> same data, but consider this case:
>     1. Client 1 requests report (Userspace call to HIDIOCGFEATURE)
>     2. Client 2 SETS report (Userspace call to HIDIOCSFEATURE)
>     2. Client 2 requests report (Userspace call to HIDIOCGFEATURE)
>     3. Client 1's report is returned, and delivered to Clients 1 and 2
>     4. Client 2's report is returned
>
> In this case, client 2 receives OLD data (since it set new data, and 
> the call to write the reports is currently not synchronous). To make 
> writes synchronous, we'd run into the same problem, of two writes 
> happening concurrently, and the 2nd one receiving the ACK from the 
> first one.
>
> Alan.
>

I just remembered to look at the hidraw.c source, to see that the call 
to the hid_get_raw_report() function pointer (which points to 
hidp_get_raw_report()) is called with a global mutex held. I believe 
this will prevent the race mentioned in #3 above in the case that all 
clients are communicating with the device using hidraw. Of course, the 
situation above could still occur if one of the clients represents an 
actual driver (which isn't subject to the hidraw mutex).


