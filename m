Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1FGLCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 07:02:33 -0400
Received: from mail-bw0-f66.google.com ([209.85.214.66]:53702 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1FGLCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 07:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=CtvjUUGKzz4U/2Kuy+nMJSeFqEGB+7JmYan85h9nILVBIxOtJf39plqBS0DrNS64Ru
         jvIk6leDpRRKfRZ+Y9oloCYIVe3TiFL4QQmetyWx+jGH2TtDIO/bSB/x0sRG5Lx8NxMk
         jB2N4FWENJndNOA/R5AfdA74xxbN3IqSMZrQI=
MIME-Version: 1.0
In-Reply-To: <1307439469.2322.235.camel@twins>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
	<alpine.LFD.2.02.1106071033350.11814@ionos>
	<4DEDF1F2.2080204@steinhoff.de>
	<1307439469.2322.235.camel@twins>
Date: Tue, 7 Jun 2011 13:02:30 +0200
X-Google-Sender-Auth: gzUkJkSUY8o6i_Kh_BS02xKpdTQ
Message-ID: <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
From: Remy Bohmer <linux@bohmer.net>
To: Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec5430dfafc440b04a51d27b3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5430dfafc440b04a51d27b3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,

2011/6/7 Peter Zijlstra <peterz@infradead.org>:
> On Tue, 2011-06-07 at 11:40 +0200, Armin Steinhoff wrote:
>> Hi,
>>
>> when I read all these confusing statements here ( in german it looks
>> like an "Eiertanz") =A0... I can only say:
>>
>> - do the basic stuff in a minimal kernel driver
>> - use UIO (or VFIO for PCI devices)
>
> I see no requirement for any of those horrid things to be used. You can
> write a full on proper kernel driver, it just cannot set kernel thread
> priorities to a sane value (let them all default to 50 or so).
>
> Then have a user space script or whatever set the kthread priorities.
>> and you get clean control about your real-time priorities.
>> I think changing the priorities of "interrupt threads" inside the kernel
>> could lead to strange race conditions in the kernel.

Well, I 100% agree that it must be under full userspace control to be
able to set the priorities. But, the kernel default assumption of
starting everything at 50 is wrong as well.
Imagine the following situation:
* Realtime application is running and has threads active in the range
of prios 20 - 90.
* Now bring up a network device, it immediately starts spamming the
system at prio 50 _before_ you have the chance to set it below 20 by
means of chrt.
* RT behaviour is gone!

So, in that case and in many other hotplug cases, you ruin the RT
behaviour of the system just by the
default-50-is-probably-right-assumption of the kernel.
For systems where you have everything under control as a user/system
designer, hotplug can also be under control as well.

To solve this we have the patchset in use as attached to this mail. It
is a newer version of the old set mentioned earlier in this mail
thread.
The opinion of Thomas about this subject is quite clear so I will not
post it as a cleaned up patchset, although I believe we reworked all
his previous major remarks about this set.

For everyone else who can do something useful with it: go ahead. It
should apply to 2.6.33.9-rt31
It creates entries in /proc/irq for you to setup the priorities after
booting. (/proc/irq/hirq-prio and /proc/irq/sirq-prio), but also per
driver in /proc/irq/<irq-id>/<name>/irqprio
In /proc/irq/[hs]irq-prio you can, for example, enter the following text:
* at91_udc:22,ohci_hcd:usb1:22,atmel_spi:22,33

This results in:
* starting the at91_udc at prio 22
* starting ohci:usb1 also at prio 22
* atmel_spi at 22
* overall default moved from 50 to 33

Kind regards,

Remy

--bcaec5430dfafc440b04a51d27b3
Content-Type: application/x-gzip; name="irqprio-patches.tar.gz"
Content-Disposition: attachment; filename="irqprio-patches.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gomqnw9w0

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
--bcaec5430dfafc440b04a51d27b3--
