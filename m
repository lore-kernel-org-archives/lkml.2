Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1FYMyJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 08:54:09 -0400
Received: from smarthost3.mail.uk.easynet.net ([212.135.6.13]:42076 "EHLO
	smarthost3.mail.uk.easynet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab1FYMyG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 08:54:06 -0400
thread-index: AcwzNwe2Yl2JEBs1TOS3ta5nBypKMA==
Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
In-Reply-To: <29629.64539.qm@web29014.mail.ird.yahoo.com>
Date: Sat, 25 Jun 2011 08:54:01 -0400
Cc: <linux-kernel@vger.kernel.org>, <johnpol@2ka.mipt.ru>
Content-Transfer-Encoding: 8BIT
Message-ID: <53BB78ED-FEDC-471F-A371-2B902A359B65@sonatest.com>
References: <29629.64539.qm@web29014.mail.ird.yahoo.com>
To: "Paul Parsons" <lost.distance@yahoo.com>
X-Mailer: Apple Mail (2.1084)
Content-Class: urn:content-classes:message
Importance: normal
X-OriginalArrivalTime: 25 Jun 2011 12:54:32.0705 (UTC) FILETIME=[07630710:01CC3337]
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4841
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-24, at 17:32, Paul Parsons wrote:

> Here's the debug output from ds1wm_search():
> 
> ds1wm ds1wm: search begin
> ds1wm ds1wm: pass: 1 r : 0x0000000000000000 writing SEARCH_ROM
> ds1wm ds1wm: pass: 1 entering ASM
> ds1wm ds1wm: pass: 1 begining nibble loop
> ds1wm ds1wm: pass: 1 r': 0xd300001085da8430 d:0x0000000000000000
> ds1wm ds1wm: pass: 1 nibble loop complete, exiting ASM
> ds1wm ds1wm: pass: 1 resetting bus
> ds1wm ds1wm: pass: 1 found 0xd300001085da8430
> ds1wm ds1wm: pass: 1 complete, preparing next pass
> ds1wm ds1wm: pass: 1 new d:0x0000000000000000 MS discrep bit:-1
> ds1wm ds1wm: pass: 1 total: 1 search done ms d bit pos: -1
> 
> The hx4700 does indeed have a ds2760 connected to the ds1wm. I believe the ds1wm is integrated into the HTC ASIC3, but my knowledge of the hardware is almost zero.
> 
> Regards,
> Paul
Hi again Paul,

This seems to be the output after you have restored the msleep. Could you provide it without so we can get a better idea as to what happened. If indeed this is a major regression for many devices, we'll have to submit a patch to the main branch.
/jfd
> 
> --- On Fri, 24/6/11, Jean-François Dagenais <dagenaisj@sonatest.com> wrote:
>> The sleep I removed there only delays the time between the
>> reset pulse and the function exiting, it doesn't populate
>> the "slave_present" variable with a different value. The
>> reset pulse and the wait that the ds1wm implements (by
>> raising an interrupt at the end of it all) is spec'ed on the
>> 1-wire specification, and the DS1WM_TIMEOUT is a really long
>> time. So there should be plenty of time for the slaves to
>> acknowledge the reset and participate in further
>> communications.
>> 
>> So here's my hunch. We observed this here on our circuit
>> too. It is possible that the pull-up resistor on your
>> circuit is too resistive which would make the slave device
>> fail to properly come back to life after the reset pulse
>> (bus shorted to the ground) when the drain opens, and hence
>> not able to cope well with the search that follows. The 1ms
>> wait basically gives the slave(s) time to charge up again
>> (with the drain open, the voltage is high).
>> 
>> The weird thing is that the ds1wm_reset function returns 0,
>> since the while loop executes more than once, so it did find
>> a slave (slave_present obtained from the PDR status bit), so
>> the slave is kinda there... But the search fails somehow
>> after that. Maybe there is something in your slave's spec
>> sheet that could help, although the ds1wm reset timings. So
>> I still think the debug trace and knowing if you have only
>> one slave on the bus would help me figure this out. New
>> question: what slave(s)? is it the DS2760?
>> 
>> PS: there are also controls in the DS1WM_CNTRL register
>> that has to do with strong-pull-ups which are just not used
>> by the driver yet. refer to: http://datasheets.maxim-ic.com/en/ds/DS1WM.pdf
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
