Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab2JATbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:31:11 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:38038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2JATbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:31:09 -0400
Message-ID: <1349119899.10330.53.camel@jlt4.sipsolutions.net>
Subject: Re: iwlwifi can't connect to router after resuming from suspend.
From: Johannes Berg <johannes@sipsolutions.net>
To: Kevin Cruz <skate_ops@yahoo.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Intel Wireless <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 01 Oct 2012 21:31:39 +0200
In-Reply-To: <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com> (sfid-20121001_184314_573998_F50474BE)
References: <1348086305.81224.YahooMailNeo@web164004.mail.gq1.yahoo.com>
	 <20120928121917.GF5368@mwanda>
	 <1348870515.1973.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	 <20120929072527.GA13767@mwanda>
	 <1349102641.41622.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	 <20121001150913.GC13767@mwanda>
	 <1349109750.55372.YahooMailNeo@web164005.mail.gq1.yahoo.com>
	 (sfid-20121001_184314_573998_F50474BE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dan, Kevin,

[...]
[suspend/resume]

> [   58.835223] wlan0: authenticate with 30:46:9a:68:a9:52
> [   58.864519] wlan0: send auth to 30:46:9a:68:a9:52 (try 1/3)
> [   59.067596] wlan0: send auth to 30:46:9a:68:a9:52 (try 2/3)
> [   59.271484] wlan0: send auth to 30:46:9a:68:a9:52 (try 3/3)
> [   59.475356] wlan0: authentication with 30:46:9a:68:a9:52 timed out

Yeah ... we saw this in the lab at some point, but somehow we couldn't
reproduce it again later. The issue is that we stop the queues, and
never restart them, and if it's the same issue then it's definitely the
driver's fault.

To confirm, when you get this, can you please do

sudo cat /sys/kernel/debug/ieee80211/phy*/queues

(assuming you have mac80211 debugfs compiled)

If it's really the same bug, the first four queues (0-3) will show
something like
00: 0x00000001/7
01: 0x00000001/0
02: 0x00000001/0
03: 0x00000001/0
[...]

If this is the case, then I'd appreciate if you could do tracing. To do
that, make sure CONFIG_IWLWIFI_DEVICE_TRACING is set in your kernel
config (which requires CONFIG_EVENT_TRACING, you can use the / key in
menuconfig to search for items).

When you have that, grab the trace-cmd tool (ubuntu ships it now I
believe) and start tracing *before* you suspend:

sudo bash -c "echo global > /sys/kernel/debug/tracing/trace_clock"
sudo trace-cmd record -e mac80211 -e iwlwifi -e iwlwifi_msg

then suspend and resume while it's running, and ctrl-c later after it
failed to connect after resuming. Then you get a file "trace.dat",
compress it and send it to me privately (it's large, and may contain
information you might consider private, like your AP name/BSSID/etc.)

Thanks!
If that's too much effort, let me know and I'll try to reproduce, but
I'll probably need to have more info on your setup etc. as I haven't
been able to reproduce this in mine yet, but I also have issues with
suspend/resume anyway quite frequently :-(

johannes

