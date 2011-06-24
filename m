Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1FXT7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:59:40 -0400
Received: from smarthost1.mail.uk.easynet.net ([212.135.6.11]:49678 "EHLO
	smarthost1.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab1FXT7j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:59:39 -0400
Thread-Index: AcwyqVDBNWkOKRKuQ5ey1S+JTy2VHg==
References: <716908.39790.qm@web29004.mail.ird.yahoo.com>
In-Reply-To: <716908.39790.qm@web29004.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Message-ID: <BA417AD7-62AA-4442-AE5F-FB29EEFC3905@sonatest.com>
Content-Transfer-Encoding: 8BIT
Cc: <linux-kernel@vger.kernel.org>, <johnpol@2ka.mipt.ru>
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
Date: Fri, 24 Jun 2011 16:00:06 -0400
To: "Paul Parsons" <lost.distance@yahoo.com>
X-Mailer: Apple Mail (2.1084)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4841
Content-class: urn:content-classes:message
Importance: normal
X-OriginalArrivalTime: 24 Jun 2011 20:00:06.0888 (UTC) FILETIME=[50886680:01CC32A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 24, 2011, at 15:07, Paul Parsons wrote:

> Hi Jean-Francois,
> 
> I think I've found the problem.
> 
> On a hunch I restored the msleep() call that had been removed from ds1wm_reset() after 2.6.39:
> 
> --- clean-3.0-rc4/drivers/w1/masters/ds1wm.c	2011-06-21 04:25:46.000000000 +0100
> +++ linux-3.0-rc4/drivers/w1/masters/ds1wm.c	2011-06-24 19:58:03.340701823 +0100
> @@ -182,6 +182,8 @@ static int ds1wm_reset(struct ds1wm_data
> 		return 1;
> 	}
> 
> +	msleep(1);
> +
> 	if (!ds1wm_data->slave_present) {
> 		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
> 		return 1;
> 
> This has completely eliminated the "bus error, retrying" error messages, and the hx4700 seems to be functioning normally again.
The sleep I removed there only delays the time between the reset pulse and the function exiting, it doesn't populate the "slave_present" variable with a different value. The reset pulse and the wait that the ds1wm implements (by raising an interrupt at the end of it all) is spec'ed on the 1-wire specification, and the DS1WM_TIMEOUT is a really long time. So there should be plenty of time for the slaves to acknowledge the reset and participate in further communications.

So here's my hunch. We observed this here on our circuit too. It is possible that the pull-up resistor on your circuit is too resistive which would make the slave device fail to properly come back to life after the reset pulse (bus shorted to the ground) when the drain opens, and hence not able to cope well with the search that follows. The 1ms wait basically gives the slave(s) time to charge up again (with the drain open, the voltage is high).

The weird thing is that the ds1wm_reset function returns 0, since the while loop executes more than once, so it did find a slave (slave_present obtained from the PDR status bit), so the slave is kinda there... But the search fails somehow after that. Maybe there is something in your slave's spec sheet that could help, although the ds1wm reset timings. So I still think the debug trace and knowing if you have only one slave on the bus would help me figure this out. New question: what slave(s)? is it the DS2760?

PS: there are also controls in the DS1WM_CNTRL register that has to do with strong-pull-ups which are just not used by the driver yet. refer to: http://datasheets.maxim-ic.com/en/ds/DS1WM.pdf

> 
> Regards,
> Paul
> 
> --- On Fri, 24/6/11, Jean-François Dagenais <dagenaisj@sonatest.com> wrote:
> 
>> From: Jean-François Dagenais <dagenaisj@sonatest.com>
>> Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
>> To: "Paul Parsons" <lost.distance@yahoo.com>
>> Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
>> Date: Friday, 24 June, 2011, 17:15
>> Hi Paul,
>> 
>> Sorry to hear that. 2.6.39's ds1wm driver did not support
>> dynamically finding the slaves on the bus, it would limit
>> it's search to 1 and exit. My modifications implement the
>> hardware assisted search as documented by the ds1wm spec
>> sheet.
>> 
>> There are a couple of ways you can workaround the problem
>> (temporarily or permanently). You might disable the bus
>> scanning altogether (like I explain below) and insert your
>> slave manually (as documented in the kernel w1 docs). If
>> only one slave is present, the bus master will usually just
>> skip the ROM matching part of the communication by doing a
>> "SKIP ROM" which essentially says to the slave "whoever you
>> are, I am talking to you". You could also patch the
>> ds1wm_search function to make it look like it was in 2.6.39,
>> or just use the whole file if it worked fine for you.
>> 
>> Now, to find the real problem, could you try the
>> following:
>> - to limit trace noise, disable the w1 auto probe by
>> setting the search count to 0, either in "wire" module load
>> ("search_count=0" in /etc/modprobe.conf or the like) or int
>> /sys under your w1 master instance
>> - build the ds1wm with "#define DEBUG" at the top (before
>> headers), this will prints lots of debug about the
>> accelerated search algorithm progress. (you could also set
>> the retry count to something less than 100 to also limit
>> noise in the trace)
>> - once booted, trigger one search manually by writing 1 in
>> /sys/bus/w1/devices/w1\ bus\ master/w1_master_search
>> dmesg will contain a nice trace (although big)
>> 
>> Do you have more than one slave device on the ds1wm bus?
>> 
>> I will try to help as much as I can.
>> /jfd
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Jean-Francois Dagenais 
Software Architect - B.Sc.A


Experience the new veo phased array flaw detector at www.sonatestveo.com.


Sonatest AP
2900 chemin des Quatre-Bourgeois
Bureau 305
Quebec City Quebec G1V 1Y4

T| +1 (418) 683 6222 x106   F| +1 (418) 683 7032   M|    W| www.sonatest.com



This message (and any associated files) is intended only for the use of lost.distance@yahoo.com, linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru and may contain information that is confidential, subject to copyright or constitutes a trade secret. If you are not the above recipient(s) you are hereby notified that any dissemination, copying or distribution of this message, or files associated with this message, is strictly prohibited. If you have received this message in error, please notify us immediately by replying to the message and deleting it from your computer. Any views or opinions presented are solely those of the author and do not necessarily represent those of the company.

Think green - help the environment by not printing this email.
