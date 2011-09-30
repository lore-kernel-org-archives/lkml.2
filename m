Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab1I3Ttx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:49:53 -0400
Received: from masquerade.micron.com ([137.201.242.130]:41569 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab1I3Ttv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:49:51 -0400
Message-ID: <4E861D4A.9030009@micron.com>
Date: Fri, 30 Sep 2011 13:49:30 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <4E69D519.8070802@fusionio.com>
In-Reply-To: <4E69D519.8070802@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--12.130500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/2011 2:58 AM, Jens Axboe wrote:
> On 2011-09-09 10:54, Christoph Hellwig wrote:
>> On Mon, Aug 22, 2011 at 02:28:11PM -0700, Sam Bradshaw (sbradshaw) wrote:
>>> New patch for mtip32xx driver based on feedback from
>>> Jens Axboe, Christoph Hellwig, and Alan Cox.
>>
>> A few comments that need addressing:
>>
>>  - the ioctl handler always returns 0 for the BLKFLSBUF ioctl, without
>>    doing anything.  Given that the ioctl is supposed to flush all kinds
>>    of higher level cached data this is a serious data integrity issue.
>>    It must simply do the default -ENOTTY return for it and let the block
>>    layer do the right thing.
>>  - handling of REQ_FUA / REQ_FLUSH requests is completely broken.
>>    There is a weird barrier flag to mtip_hw_submit_io which set the
>>    hwardware FUA bit if the FLUSH bit is set on a request.
>>    Please take a look at how this should be handled, the
>>    Documentation/block/writeback_cache_control.txt file is the canonical
>>    resource.  Implementing your driver at the make_request layer
>>    unfortunately means you will have to do all the hard work yourself.
>>  - also the call to blk_queue_flush(queue, 0); from ->make_request for
>>    a non-data request is completely wrong.
> 
> I noticed both of these flush/fua problems too and have fixed them up.
> 
>>  - the 64-bit case in fill_command_sg will blow up on big endian
>>    systems, please use your current 32-bit case unconditionally
>>  - mtip_block_getgeo should just use sector_div instead of the ifdef
>>    mess.
>>  - please check the driver using sparse, and most importantly the
>>    optional endianess checking pass of it.  Currently the driver
>>    uses plain unsigned int and similar types for little endian
>>    hardware structures.  Take a look at Documentation/sparse.txt
>>    on how to use it.
>>  - the mtip_check_surprise_removal check should be unconditional, not
>>    under #ifdef CONFIG_HOTPLUG
> 
> In general, the dependency on HOTPLUG_PCI_PCIE is odd as well.

For the device to support surprise removal and surprise insertion
(SRSI), need pciehp module loaded.


-- 
Regards,
Asai Thambi
