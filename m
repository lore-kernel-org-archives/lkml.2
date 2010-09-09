Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab0IIIfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:35:07 -0400
Received: from web32407.mail.mud.yahoo.com ([68.142.207.200]:31346 "HELO
	web32407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752301Ab0IIIfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:35:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=WnMHyYXcAwEbHVbDaXpKj+cWOf2JIOCzEigycByDnAzvCtNY0XE79aeQFqZUJtiuX5HjbhCTdne5OlBZJkyIyUwBiRpnBrT9fFvJQVzTcM5GyAr6N3/VKqHWTMiikwqPHsRQ0A26GTRWmAvrb6tyXNnADb5q8WzhUhz55eB7Lc8=;
Message-ID: <534531.52796.qm@web32407.mail.mud.yahoo.com>
X-YMail-OSG: ZBz6nF8VM1kpVdAOXCnkhETKFi0cbEgwvSrJ414XDQJsnJD
 LTQgCRxGQUUKwObPE5ZdinKlkyNqQpHDjUo4VGBOcqYUNpuxUTY9xrug.ozZ
 bVvwCQt3hjfqOwDTF1EPP7jhO3jFAeKVwjFPcssuIzU0qbjUWECu0dODcvkK
 D2IHQEYMprknEZPuTfLSFXDiIAGozmt9gEX5yYhNCnMMStwjKnWGCEtwpR7C
 WBL4mJtrcEYf4VAqPMKUCaTWJHVz4OIudbacMr0NFyC3SJH305wXh1nfGqF9
 2qIo0BpcuxYO4zRpI_wYiEMJjjnN3t3gX5weQazwAe6gU3tLGs.eg_jCBPS0
 E197jTaVQ
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Thu, 9 Sep 2010 01:35:02 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: Re: scsi_cmnd data_buffer checksum
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20100909080028.GA4880@schmichrtp.mainz.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christof,

Thanks for the response.

I am running mkfs.ext3 command.

I am doing the following in the driver for write(10):

Queuecommand:

sg = scsi_sglist(cmd->scsi_cmd);
cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);
Calculate checksum for write_buf

Write Done:
Calculate checksum for cmd->write_buf

and checksums don't match. I am wondering how come OS changed the cmd->write_buf when I have not even unmapped the buffer. Is filesystem changing this cmd->write_buf pages when driver/HW is working on it?

Is there anyway I can avoid this. How about if we allocate a local buffer(kmalloc/pci_alloc_consistent) and memcpy kmap_atomic to that local buffer and then calculate checksum on that local buffer. Will this help?

--Anil

--- On Thu, 9/9/10, Christof Schmitt <christof.schmitt@de.ibm.com> wrote:

> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> Subject: Re: scsi_cmnd data_buffer checksum
> To: "Anil kumar" <anils_r@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Thursday, September 9, 2010, 4:00 AM
> On Wed, Sep 08, 2010 at 08:36:32PM
> -0700, Anil kumar wrote:
> > 
> > I am writing a checksum calculation of scsi_cmnd data
> buffer in the driver. 
> > 
> > I calculate the checksum of the scsi_cmd data
> buffer(request_buffer) in driver queuecommand.
> > 
> > Now when the command is completed from the hardware
> and before driver sends it back to mid-layer, I calculate
> the checksum again of the same scsi_cmd data_buffer again.
> > 
> > Sometimes the checksums don't match. I mean somehow
> looks like OS changed the scsi_cmd
> data_buffer(request_buffer) in the meantime when driver is
> working on the command.
> > I print the address of the scsi_cmd data_buffer
> (virtual address) and its same and the contents of the
> buffer is also same during both the calculations.
> > 
> > Can this happen?
> 
> Yes. While a write I/O is being processed in Linux or in
> flight, the
> data buffers can change. This causes problems for other
> checksums as
> well; i ran into this when looking at the DIF/DIX checksums
> for SCSI
> commands.
> 
> At the moment, this problem can be avoided e.g. by running
> only direct
> I/O on the xfs filesystem. There have been discussions
> about this, a
> short summary is here, look for "stable pages":
> http://lwn.net/Articles/399148/
> 
> Christof
> 


      
