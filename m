Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab2INOjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:39:06 -0400
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:46660 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab2INOjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:39:03 -0400
Message-ID: <50534184.1050208@akamai.com>
Date: Fri, 14 Sep 2012 09:39:00 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com> <5050857F.5060207@akamai.com> <20120912153016.GA12103@aftab.osrc.amd.com> <5050AC2E.3050408@akamai.com> <20120912154943.GB12103@aftab.osrc.amd.com> <5050B708.5020308@akamai.com> <20120912164843.GC12103@aftab.osrc.amd.com> <5050BF1F.1080503@akamai.com> <20120912170629.GD12103@aftab.osrc.amd.com> <20120912172351.GE12103@aftab.osrc.amd.com> <50532940.10201@akamai.com>
In-Reply-To: <50532940.10201@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 07:55 AM, Josh Hunt wrote:
>
> Thanks to your help I was able to test your branch, but it still does
> not resolve the problem. Removal of the "factor=1" workaround fixes the
> memory size reporting on boot, but the sysfs values are still incorrect.
>

Please disregard what I said earlier about the shift still being wrong. 
Looking at the dmesg more I see now that the # of pages are correctly 
reported (262144), however sysfs is still wrong.

[   25.837588] EDAC DEBUG: init_csrows: MC node: 0, csrow: 0
[   25.837589] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 0, channel: 0, 
DBAM idx: 2
[   25.837591] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.837592] EDAC amd64: CS0: Unbuffered DDR2 RAM
[   25.837724] EDAC DEBUG: init_csrows: Total csrow0 pages: 262144
[   25.837725] DBG: init_csrows: channel_count:2
[   25.837856] DBG: init_csrows: channel_count:2
[   25.837988] EDAC DEBUG: init_csrows: MC node: 0, csrow: 1
[   25.837989] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 1, channel: 0, 
DBAM idx: 2
[   25.837991] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.837992] EDAC amd64: CS1: Unbuffered DDR2 RAM
[   25.838157] EDAC DEBUG: init_csrows: Total csrow1 pages: 262144
[   25.838158] DBG: init_csrows: channel_count:2
[   25.838289] DBG: init_csrows: channel_count:2
[   25.838421] EDAC DEBUG: init_csrows: MC node: 0, csrow: 2
[   25.838422] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 2, channel: 0, 
DBAM idx: 2
[   25.838424] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.838425] EDAC amd64: CS2: Unbuffered DDR2 RAM
[   25.838556] EDAC DEBUG: init_csrows: Total csrow2 pages: 262144
[   25.838558] DBG: init_csrows: channel_count:2
[   25.838689] DBG: init_csrows: channel_count:2
[   25.838820] EDAC DEBUG: init_csrows: MC node: 0, csrow: 3
[   25.838822] EDAC DEBUG: amd64_csrow_nr_pages: csrow: 3, channel: 0, 
DBAM idx: 2
[   25.838823] EDAC DEBUG: amd64_csrow_nr_pages: nr_pages/channel: 262144
[   25.838824] EDAC amd64: CS3: Unbuffered DDR2 RAM
[   25.838957] EDAC DEBUG: init_csrows: Total csrow3 pages: 262144

I looked into this and see that sysfs is doing the double counting b/c 
it loops over the # of channels:

[  131.423949] DBG: csrow_size_show: i:0 nr_pages:262144 nr_channels:2
[  131.424112] DBG: csrow_size_show: i:1 nr_pages:524288 nr_channels:2

I verified this in init_csrows:
[   25.838958] DBG: init_csrows: channel_count:2

Since I don't know the details of the hardware here it's hard for me to 
suggest a fix, but it would seem that k8_early_channel_count() needs to 
be modified to only return 1 in this case?

Josh



