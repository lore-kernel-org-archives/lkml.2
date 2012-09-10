Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2IJRnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:43:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55288 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab2IJRnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:43:22 -0400
X-Sasl-enc: 5I3gL8bKKC00aYonmPYxWXMWRjObkO++ZsdQHL93HrdI 1347299001
Message-ID: <504E267A.8060307@ladisch.de>
Date: Mon, 10 Sep 2012 19:42:18 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: shuah.khan@hp.com, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sf.net, shuahkhan@gmail.com
Subject: Re: [RFC] DMA mapping error check analysis
References: <1346595257.4377.5.camel@lorien2>	<1347033200.2603.19.camel@lorien2>	<504D9C70.5000102@ladisch.de>	<1347290775.3071.1.camel@lorien2> <20120910191739.77d59f65@stein>
In-Reply-To: <20120910191739.77d59f65@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On Sep 10 Shuah Khan wrote:
>>>> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
>>>
>>>> File Name                  # of calls  Status 	
>>>> drivers/firewire/core-iso.c   1        Unmap Broken
>>>> drivers/firewire/ohci.c       1        Unmap Broken
>>>
>>> In ohci.c, ar_context_release() takes care of cleanup.
>>>
>>> In core-iso.c, on failure, the callers are responsible to call
>>> fw_iso_buffer_destroy() eventually.  (ioctl_create_iso_context()
>>> doesn't do this correctly if it's called multiple times.)
>>
>> Thanks. I updated the page with your comments. I moved ohci.c to Good
>> status and left core-iso.c in Unmap Broken in case
>> ioctl_create_iso_context() case is worth fixing.
>
> I don't see what could go wrong if ioctl_create_iso_context() is called
> multiple times.

fw_iso_buffer_map_dma() maps as many pages as it can, and saves in
->page_count_mapped how many pages need unmapping.

When fw_iso_buffer_map_dma() fails, ioctl_create_iso_context() does _not_
call fw_iso_buffer_destroy() but takes care to not change the cdev's
state in any other way.  So ioctl_create_iso_context() can be called
again and will then call fw_iso_buffer_map_dma(), which will happily
map the pages a second time, overwriting the previous mapped addresses.


Regards,
Clemens
