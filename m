Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2CBEDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 23:03:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49178 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2CBEDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 23:03:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F504645.5040708@jp.fujitsu.com>
Date: Fri, 02 Mar 2012 13:02:13 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
References: <1330445487-15020-1-git-send-email-bp@amd64.org> <1330445487-15020-2-git-send-email-bp@amd64.org> <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab> <4F4E145E.4040901@redhat.com> <20120229121914.GD21224@aftab> <4F4E22B1.6020505@redhat.com> <20120229133741.GF21224@aftab> <4F4EDD9A.4050900@jp.fujitsu.com> <20120301114023.GB32410@aftab> <3908561D78D1C84285E8C5FCA982C28F040ACC@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F040ACC@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/02 3:28), Luck, Tony wrote:
>>> My concern is; on Sandy Bridge, is it safe to gather info about the DIMM
>>> location in/from machine check context in a reasonable time span?
>>
>> Well, what amd64_edac does is "buffer" the required lookup info so
>> whenever you get an error, you simply lookup the channel and chip select
>> - all ops which can be done in atomic context.
> 
> Yes - we could pre-read all the config space registers ahead of time and
> save them in memory (none of the values should change - except if the platform
> supports hot-plug for memory). Total is only a few Kbytes. Then decode in
> machine check context is both safe, and fast.

To sort out my thought:

 - First of all, OS gathers info about physical location of DIMMs from
   DMI/ACPI/PCI etc., before enabling MCE mechanism.
 - Make a kind of "physical memory location table" on memory buffer,
   to ease mapping a physical address to the location of a DIMM module
   and/or chip which have the memory cell pointed by the address.
    - It would be better to have a well organized table rather than
      having a raw copy of config space etc.
    - Likewise it will also nice if we can map logical processor numbers
      to the location of physical sockets on motherboard.
    - Happy if user can refer the table via sysfs.
    - Allow updating the table if the platform supports hot-plug.
 - Once MCE is enabled, handler can refer the table on memory to
   determine an erroneous device which should be replaced.

This storyline up to here is reasonable and acceptable, I think.

Then now it is clear that the last point where I feel uneasy about is
putting a string into the ring buffer instead of binary bits like index
of location table.  Please use binary (or "binary + string") to tell
the error location to userland.


Thanks,
H.Seto

