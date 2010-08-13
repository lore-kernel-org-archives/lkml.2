Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076Ab0HMTHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 15:07:20 -0400
Received: from ns2.cypress.com ([157.95.67.5]:45898 "EHLO ns2.cypress.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0HMTHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 15:07:15 -0400
Subject: Re: EXPORT_SYMBOL(fat_get_block)
From: David Cross <david.cross@cypress.com>
Reply-To: david.cross@cypress.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Greg KH <gregkh@suse.de>, hirofumi@mail.parknet.co.jp,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100813185005.GA21112@infradead.org>
References: <1281721539.5839.4.camel@odc-laptop>
	 <20100813175402.GA15024@suse.de> <1281724992.12189.16.camel@odc-laptop>
	 <20100813185005.GA21112@infradead.org>
Content-Type: text/plain
Organization: Cypress
Date: Fri, 13 Aug 2010 12:06:56 -0700
Message-Id: <1281726416.16672.11.camel@odc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-Tracker: AAAAAA==
X-MailScanner: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-13 at 14:50 -0400, Christoph Hellwig wrote:
> On Fri, Aug 13, 2010 at 11:43:12AM -0700, David Cross wrote:
> > OK, I am trying to answer all questions on this topic that I am getting,
> > but honestly I have not gotten a lot so far. 
> 
> Seriously, I think there is absolutely no point in even arguing this.
> A driver has absolutely no business looking into any filesystem layout.
I think you misunderstand, the driver is not looking into the file
system layout. The driver is requesting that the file system allocate a
file and tell it where it allocated it to. This is the reason for the
fat_get_block call.
> 
> > 1) receive all data, buffer it, then write the file. This is typically a
> > slow process USB->Processor->SDRAM->Processor/DMA engine->Media
> > 2) pre-allocate the file as soon as it knows that it is coming and how
> > big it is, and then send the block addresses to an external DMA engine
> > and let it transfer the data from the MTP host directly
> > 
> > The West Bridge driver goes for option two for performance reasons. In
> > doing this, it needs to get information from the file system on where to
> > store the file.
> 
> And what if someone else changes the layout undernath you?
I am not sure I understand the question. The point of making the call
into the filesytem rather than reading sectors and "looking into the
file system layout" is to make sure that the filesystem is the arbiter
of all storage requests. How would someone change the layout underneath
me? 

> Or uses
> a different filesystem?
That is a good question, I think it is the same one that Greg KH had. To
restate the answer in the last email, I don't know how to handle this
case. I am sure that it is possible to develop a method to pre-allocate
using other filesystems, but I have not looked into it yet as the driver
was developed for systems which have removable storage. Removable
storage needs to work with card readers, as such it uses FAT. 

> Basically you will have to introduce operations to the VFS to lock down
> a file against layout changes and do DMA transfers.  It's fine if you
> only implement it for fat in the beginning, and just return an error
> for others, although in general the implementation would be easily
> extendable to other filesystems using generic code and the get_blocks
> callbacks.
So, your basic concern is whether or not someone else tries to write to
the same file while the transfer is ongoing, correct? I understand the
implementation idea you are proposing to get around this issue, but it
seems that the simplest solution is to punt to the application handling
the transfer (ie don't access the pre-allocated file until you know the
transfer is complete). This is the basic idea of how it has been done in
previous implementations, so I am not sure why this is not a potential
solution in this case.

Thanks,
David


---------------------------------------------------------------
This message and any attachments may contain Cypress (or its
subsidiaries) confidential information. If it has been received
in error, please advise the sender and immediately delete this
message.
---------------------------------------------------------------

