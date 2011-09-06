Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab1IFQmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:42:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43624 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1IFQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:42:32 -0400
Date: Wed, 7 Sep 2011 01:42:21 +0900
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110906164221.GH18425@mtj.dyndns.org>
References: <4DF25526.9010800@teksavvy.com>
 <20110611121957.GA7980@mtj.dyndns.org>
 <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B00@gretna.indigovision.com>
 <20110906163355.GG18425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906163355.GG18425@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 01:33:55AM +0900, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 06, 2011 at 01:19:44PM +0100, Bruce Stenning wrote:
> > ata4: EH complete
> > Waking error handler thread
> > scsi_eh_wakeup: succeeded
> > scsi_schedule_eh: succeeded
> > scsi_restart_operations: waking up host to restart
> > Error handler scsi_eh_3 sleeping
> 
> I think the following should fix the problem.  The code there is from
> the time when libata shared scsi_host->host_lock.  libata no longer
> does that so, in the current state, host_eh_scheduled can be cleared
> with actual pending EH condition.

Hmmm... maybe not.  Such race condition exists iff host_eh_scheduled
is incremented outside of ap->lock, which I can't see how.  Weird.
Can you please instrument the followings?

* print the caller of scsi_eh_wakeup().  "%pF" w/ (void *)_RET_IP_
  should do it.

* print why scsi_eh is going back to sleep immediately.
  ie. shost->host_failed, host_eh_scheduled, host_busy in
  scsi_error_handler().  It would also be nice to add some printks
  around schedule() and enable PRINTK_TIME.

Thanks.

-- 
tejun
