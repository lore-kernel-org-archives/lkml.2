Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1FXTHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:07:45 -0400
Received: from nm19.bullet.mail.ird.yahoo.com ([77.238.189.76]:37781 "HELO
	nm19.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754881Ab1FXTHo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:07:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 808394.65237.bm@omp1017.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Mqdqpp5VC1guV5M+s0xdkhWIS/hi8vGpnpdUrklTrrCWiR0bkwmXLtvrbRfEsNVKzGMApnc11Vh5pzdZIBPYSGi0NcO/komzEw+SmosKZoMC1r629GLwVEjobNCyDO91Gmw7aWN4ucveasdnxBC/vKqbIWBlDB+5cQXf+1vyNBg=;
Message-ID: <716908.39790.qm@web29004.mail.ird.yahoo.com>
X-YMail-OSG: SJtUrzkVM1k0nB8p5To3OdcJ0SlWQVLncLpkNJtlY8.j288
 QAQAzx1ixttMsecVJBx8rg9gX7xPRL67rm8o1XysIAGfSH3p7r1NbXHffw5a
 cZO8MksAcEE8q4gyKQtebQpNqiY0igERzHd0EFP12F5XYin00KShO2fc8PZK
 uwlNirV5Fg78dTAGmgJlEAW2lt55MInDPdKDHjJ.Z78m4ZZrkA5ugxH0O5P7
 q_iv8_WOq7GWRr.0Ggc2ht4RiZowBvwFFIVHbbPqg8wTapeSR6RnZa8qEMOo
 9K.8iqoT7xuQH4IbUpsim5t5Ym5Zt0FnXhdiRQfKcok17SuBCY9EkSDVHEpC
 ObaF2EQS5iB3pNX79hHMGvfERPXE-
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.111.304355
Date: Fri, 24 Jun 2011 20:07:42 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
To: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <dagenaisj@sonatest.com>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
In-Reply-To: <31ED5B2F-3AEC-45EC-8D2A-2E3EB313665F@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Francois,

I think I've found the problem.

On a hunch I restored the msleep() call that had been removed from ds1wm_reset() after 2.6.39:

--- clean-3.0-rc4/drivers/w1/masters/ds1wm.c	2011-06-21 04:25:46.000000000 +0100
+++ linux-3.0-rc4/drivers/w1/masters/ds1wm.c	2011-06-24 19:58:03.340701823 +0100
@@ -182,6 +182,8 @@ static int ds1wm_reset(struct ds1wm_data
 		return 1;
 	}
 
+	msleep(1);
+
 	if (!ds1wm_data->slave_present) {
 		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
 		return 1;

This has completely eliminated the "bus error, retrying" error messages, and the hx4700 seems to be functioning normally again.

Regards,
Paul

--- On Fri, 24/6/11, Jean-François Dagenais <dagenaisj@sonatest.com> wrote:

> From: Jean-François Dagenais <dagenaisj@sonatest.com>
> Subject: Re: w1/ds1wm regression after 2.6.39: "bus error, retrying"
> To: "Paul Parsons" <lost.distance@yahoo.com>
> Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru
> Date: Friday, 24 June, 2011, 17:15
> Hi Paul,
> 
> Sorry to hear that. 2.6.39's ds1wm driver did not support
> dynamically finding the slaves on the bus, it would limit
> it's search to 1 and exit. My modifications implement the
> hardware assisted search as documented by the ds1wm spec
> sheet.
> 
> There are a couple of ways you can workaround the problem
> (temporarily or permanently). You might disable the bus
> scanning altogether (like I explain below) and insert your
> slave manually (as documented in the kernel w1 docs). If
> only one slave is present, the bus master will usually just
> skip the ROM matching part of the communication by doing a
> "SKIP ROM" which essentially says to the slave "whoever you
> are, I am talking to you". You could also patch the
> ds1wm_search function to make it look like it was in 2.6.39,
> or just use the whole file if it worked fine for you.
> 
> Now, to find the real problem, could you try the
> following:
> - to limit trace noise, disable the w1 auto probe by
> setting the search count to 0, either in "wire" module load
> ("search_count=0" in /etc/modprobe.conf or the like) or int
> /sys under your w1 master instance
> - build the ds1wm with "#define DEBUG" at the top (before
> headers), this will prints lots of debug about the
> accelerated search algorithm progress. (you could also set
> the retry count to something less than 100 to also limit
> noise in the trace)
> - once booted, trigger one search manually by writing 1 in
> /sys/bus/w1/devices/w1\ bus\ master/w1_master_search
> dmesg will contain a nice trace (although big)
> 
> Do you have more than one slave device on the ds1wm bus?
> 
> I will try to help as much as I can.
> /jfd

