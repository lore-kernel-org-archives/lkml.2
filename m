Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1FXVcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:32:07 -0400
Received: from nm10.bullet.mail.ird.yahoo.com ([77.238.189.39]:26655 "HELO
	nm10.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751436Ab1FXVcE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:32:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 133600.76971.bm@omp1005.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=XTX1IbXotZ32DvF3kBF6GVBcflSLP6xcYENKf9gYiqyijOeqJcElY+Q1680X6MPOhBkVY4SEZ5aakYhEPVRV25LdUiadzJd8BrYuemASoNK6hooRwf9KarxCXOfZOT6BbYbvGPxl342NU82IjT6oSJspSnbiWyf5rgNz1HJIE5k=;
Message-ID: <29629.64539.qm@web29014.mail.ird.yahoo.com>
X-YMail-OSG: l3T3HkUVM1m3GZeMNNVdPpzqdsMd_iXsPuSMsZiS0aKO1..
 rCG9d70xGMGwevO0ys2TMbpHpvH7xjE7QpSyRKw4KRGoteS3KJwd0FYULXSZ
 RYXnc.ccmyspFGpq89ACHiQODusZLbmwts7pZ6B2cVBPgQKp5AU7LCgD33IS
 L8byzQrUp6Q3DCNSlF2M4YkeRJaUfjQFztJS.JO_3NTSYcuznqd2foCdwTmV
 qW8_XJhetyShdJ0dq2Hkj_UV1IQ.2Z3_Lb1Chg.1WRjC4UgbSntd9Wft1zEn
 JUROu2sSYjXIiRVAzk0LTEeMKPkRg37C7HK82MFFtKVv22gKbRz6TYpqWIsJ
 aKySvyb.6GBR7LNPdNGgHfPpIXeNen98Pzj0gQ84I2sFKBMWff4g.aNkgVhA
 BX8WXK3XNITSE2AhrejjcvN2O9cOHJzS_FYCWNoDlmanC3P.agDdrIGmL4aL
 X
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.111.304355
Date: Fri, 24 Jun 2011 22:32:01 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
To: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
In-Reply-To: <BA417AD7-62AA-4442-AE5F-FB29EEFC3905@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the debug output from ds1wm_search():

ds1wm ds1wm: search begin
ds1wm ds1wm: pass: 1 r : 0x0000000000000000 writing SEARCH_ROM
ds1wm ds1wm: pass: 1 entering ASM
ds1wm ds1wm: pass: 1 begining nibble loop
ds1wm ds1wm: pass: 1 r': 0xd300001085da8430 d:0x0000000000000000
ds1wm ds1wm: pass: 1 nibble loop complete, exiting ASM
ds1wm ds1wm: pass: 1 resetting bus
ds1wm ds1wm: pass: 1 found 0xd300001085da8430
ds1wm ds1wm: pass: 1 complete, preparing next pass
ds1wm ds1wm: pass: 1 new d:0x0000000000000000 MS discrep bit:-1
ds1wm ds1wm: pass: 1 total: 1 search done ms d bit pos: -1

The hx4700 does indeed have a ds2760 connected to the ds1wm. I believe the ds1wm is integrated into the HTC ASIC3, but my knowledge of the hardware is almost zero.

Regards,
Paul

--- On Fri, 24/6/11, Jean-François Dagenais <dagenaisj@sonatest.com> wrote:
> The sleep I removed there only delays the time between the
> reset pulse and the function exiting, it doesn't populate
> the "slave_present" variable with a different value. The
> reset pulse and the wait that the ds1wm implements (by
> raising an interrupt at the end of it all) is spec'ed on the
> 1-wire specification, and the DS1WM_TIMEOUT is a really long
> time. So there should be plenty of time for the slaves to
> acknowledge the reset and participate in further
> communications.
> 
> So here's my hunch. We observed this here on our circuit
> too. It is possible that the pull-up resistor on your
> circuit is too resistive which would make the slave device
> fail to properly come back to life after the reset pulse
> (bus shorted to the ground) when the drain opens, and hence
> not able to cope well with the search that follows. The 1ms
> wait basically gives the slave(s) time to charge up again
> (with the drain open, the voltage is high).
> 
> The weird thing is that the ds1wm_reset function returns 0,
> since the while loop executes more than once, so it did find
> a slave (slave_present obtained from the PDR status bit), so
> the slave is kinda there... But the search fails somehow
> after that. Maybe there is something in your slave's spec
> sheet that could help, although the ds1wm reset timings. So
> I still think the debug trace and knowing if you have only
> one slave on the bus would help me figure this out. New
> question: what slave(s)? is it the DS2760?
> 
> PS: there are also controls in the DS1WM_CNTRL register
> that has to do with strong-pull-ups which are just not used
> by the driver yet. refer to: http://datasheets.maxim-ic.com/en/ds/DS1WM.pdf
