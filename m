Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0IIJJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:09:33 -0400
Received: from web32402.mail.mud.yahoo.com ([68.142.207.195]:46434 "HELO
	web32402.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751290Ab0IIJJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:09:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=Qf7fei5vbn1wcWHohJapp9tOfLUL8+dFkrqL/6XJaS00a5RNqrzYCwZs8i4kqlwPbqT8ypGdxwSFylNmvLIe+lIMblGIdpVVuWbDTpARZ59+fNpkqxG1K0t6smtr3+y11h7e+vyPkN1GLe7ynvzuG8mfDhdexMVJDlDrXkU36CI=;
Message-ID: <215508.92384.qm@web32402.mail.mud.yahoo.com>
X-YMail-OSG: 26_Aer0VM1kgD8jv3XAQ8f8J22n0L.Wyfnxht5Rp7M6KwxH
 47EfhNqWJ4Tnep8cngIzXNegIs53RGcSqmAU_tRuHJr7Znn3LbZznu.0a2b.
 13C7pIJwjSZUOAeJ3jNc43Vw1d6FkrNxaWYaZB1Qlao28e98KMC5bEqHYcsg
 5YsI23j0fm2dN1sYoLmKsG8CzK2ziXwfGeI2n3iu8aT5LQj7jd_wjcd5ZTgq
 txl6lTrOEsn5_mrTMvYhTJiMRfy8pldrGIuw3KgfC4M5qUSF.UlFiy9VMo8h
 b9e6MwA7wnIPSh3KOUDIBMHnM9O3lUH787y7uYjtkaQ--
X-Mailer: YahooMailClassic/11.4.7 YahooMailWebService/0.8.105.279950
Date: Thu, 9 Sep 2010 02:09:28 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: Re: scsi_cmnd data_buffer checksum
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20100909085142.GA15327@schmichrtp.mainz.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I quickly tried copying the data buffer to local buffers as follows:

In Queuecommand:

cmd->local_write_buf = pci_alloc_consistent(...);
cmd->write_buf = (u8 *)(kmap_atomic(sg->page, KM_IRQ0) + sg->offset);

memcpy(cmd->local_write_buf, cmd->write_buf, scsibufflen(scsi_cmnd));

Now I calculate checksums of cmd->write_buf and my local cmd->local_write_buf

and the checksum fails. Am I doing something wrong here?

--- On Thu, 9/9/10, Christof Schmitt <christof.schmitt@de.ibm.com> wrote:

> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> Subject: Re: scsi_cmnd data_buffer checksum
> To: "Anil kumar" <anils_r@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
> Date: Thursday, September 9, 2010, 4:51 AM
> On Thu, Sep 09, 2010 at 01:35:02AM
> -0700, Anil kumar wrote:
> > Hi Christof,
> > 
> > Thanks for the response.
> > 
> > I am running mkfs.ext3 command.
> > 
> > I am doing the following in the driver for write(10):
> > 
> > Queuecommand:
> > 
> > sg = scsi_sglist(cmd->scsi_cmd);
> > cmd->write_buf = (u8 *)(kmap_atomic(sg->page,
> KM_IRQ0) + sg->offset);
> > Calculate checksum for write_buf
> > 
> > Write Done:
> > Calculate checksum for cmd->write_buf
> > 
> > and checksums don't match. I am wondering how come OS
> changed the cmd->write_buf when I have not even unmapped
> the buffer. Is filesystem changing this cmd->write_buf
> pages when driver/HW is working on it?
> 
> Yes, the driver has direct access to the data. Usually, the
> data is
> not copied for I/O requests. The driver gets one sg list
> that points
> to the data pages of file system (or whatever the data
> source is).
> When the filesystem decides to change the data, this single
> data
> buffer is changed.
> 
> > Is there anyway I can avoid this. How about if we
> allocate a local buffer(kmalloc/pci_alloc_consistent) and
> memcpy kmap_atomic to that local buffer and then calculate
> checksum on that local buffer. Will this help?
> 
> Sure, you can create copies of data buffers in the driver,
> calculate
> the checksum of the copy and submit the data copy with the
> checksum to
> the hardware controller. This is usually not done for
> performance
> reasons, and you probably should keep a mempool to be able
> to issue
> I/Os when memory is low.
> 
> Christof
> 


      
