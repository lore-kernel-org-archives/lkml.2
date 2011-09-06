Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1IFDp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 23:45:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41916 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1IFDpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 23:45:52 -0400
Date: Tue, 6 Sep 2011 12:45:44 +0900
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110906034544.GB18425@mtj.dyndns.org>
References: <20110525094127.GF10146@htj.dyndns.org>
 <4DF20E03.9030502@teksavvy.com>
 <20110610140155.GJ15235@htj.dyndns.org>
 <4DF25526.9010800@teksavvy.com>
 <20110611121957.GA7980@mtj.dyndns.org>
 <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 02, 2011 at 05:22:38PM +0100, Bruce Stenning wrote:
> Unfortunately it has so far been quite difficult to reproduce when specifically
> attempting to.  In normal use cases I reproduced it twice by unplugging a drive
> from a RAID array with redundancy intact.  This was out of around a dozen
> cycles of waiting until redundancy was restored while the unit was under load,
> popping the disk, reinserting, and triggering a RAID rebuild.

Hmm... that's unfortunate.

> I have only twice managed to trigger a lockup deliberately.  In both cases the
> tracing showed a scheduled EH which was subsequently not enacted.
> 
> How long could it take for the EH to be enacted?  In the lockups that I
> have reproduced it did not seem to have recovered minutes later, but perhaps
> if I had waited longer...?  I have noticed that error recovery sometimes backs
> off for 8s and even 33s, but it always warns when that sort of delay is coming
> up.

It should happen pretty quickly.  In such cases, fastdrain is
activated and all pending commands are aborted if they complete in 3
secs and then EH should kick in.  The backoff is from reset path only
to give breathing time for devices which take long time to spin up and
doesn't apply in this case.

> I shall continue to try to track down why the scheduled EH does not happen.

Can you please add some debug printk's to scsi_schedule_eh() and see
whether scsi_eh_wakeup() is invoked from there?  It seems likely that
the problem is caused by race conditions around
SHOST_[CANCEL_]RECOVERY flags.

Thanks.

-- 
tejun
