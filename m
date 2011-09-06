Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1IFOkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:40:53 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:22641 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1IFOkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:40:46 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Tue, 6 Sep 2011 15:40:44 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcxsR3qVsma9kNrcQci6tuL3n+jr+gAR4xXgAATVpSA=
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B73@gretna.indigovision.com>
References: <20110525094127.GF10146@htj.dyndns.org>
 <4DF20E03.9030502@teksavvy.com> <20110610140155.GJ15235@htj.dyndns.org>
 <4DF25526.9010800@teksavvy.com> <20110611121957.GA7980@mtj.dyndns.org>
 <4DF4F30B.70702@teksavvy.com> <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org> 
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Is it attempting to wake the scsi_eh_3 thread while scsi_error_handler
> is still processing an EH, which then calls scsi_restart_operations and
> puts the scsi_eh_3 thread back to sleep again?

It does look to me as if there is a potential race between the scsi_eh thread
and the wake-up mechanism.

host_eh_scheduled is read here in scsi_error_handler:

        set_current_state(TASK_INTERRUPTIBLE);
        while (!kthread_should_stop()) {
                if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||

For scheduling an EH, scsi_schedule_eh takes the shost->host_lock, increments
shost->host_eh_scheduled, and then wakes the EH thread.  If this happens
between the scsi_eh thread reading host_eh_scheduled and sending itself to
sleep, then nothing will wake up the thread and host_eh_scheduled will not
be inspected again.

Is there some mechanism that I've missed to prevent this from happening?


Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
