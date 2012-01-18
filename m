Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2ARLRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:17:44 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:36192 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751370Ab2ARLRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:17:42 -0500
thread-index: AczV0hNUq5XBwdJkRlaG7VtMkqbyFw==
Thread-Topic: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame? Yep
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: [ANNOUNCE] 3.0.14-rt31 - ksoftirq running wild - FEC ethernet driver to blame? Yep
Date: Wed, 18 Jan 2012 12:11:44 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "Tim Sander" <tstone@iss.tu-darmstadt.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Clark Williams" <williams@redhat.com>,
        "John Kacur" <jkacur@redhat.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com> <201201171527.19165.tstone@iss.tu-darmstadt.de> <1326822011.7386.40.camel@marge.simson.net>
In-reply-to: <1326822011.7386.40.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201181211.45011.tim.sander@hbm.com>
X-OriginalArrivalTime: 18 Jan 2012 11:12:32.0982 (UTC) FILETIME=[1341A760:01CCD5D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike and others

Thanks for your reply Mike.

Am Dienstag, 17. Januar 2012, 18:40:11 schrieb Mike Galbraith:
> I have a patchlet lying about that will show the likely culprit, but if
> ksoftirqd is eating CPU, someone has to raising softirqs at a frightful
> rate, and the culprit it shows would almost certainly be ksoftirqd.  I
> mean, what else is running during boot that is RT other than kernel
> threads.  Nada.
Well thanks for your patch. It didn't apply cleanly due to some moved lines, 
but nothing to serious. I now have a machine where top just shows me the
culprit:
sirq-net-tx/0 

It seems to be triggered not as often as the mainline rt kernel though. But
after some starts and stops of "connmand" and "ifconfig eth0 down" i got back
this errornous behaviour. The only question is what next? Still i have some 
more observations which might help to nail down this bug:
* ifconfig does not return when sirq-net-tx/0 eats all cpu
* sometimes sirq-net-tx/0 sits on the cpu for a couple of seconds and goes 
away, somtimes it just stays there when "ifconfig eth0 up" is issued.
* There are suspicious "FEC: MDIO read timeout" kernel log messages from the 
ethernet driver.
* The ethernet phy uses polling since i do not know how to set the phy irq in 
the board definition. I tried using "phy_register_fixup_for_uid" and then 
setting the phy_dev->irq int the fixup routine but that seems to be to late and 
the interrupt is deregisterd but has not been registered when the network 
device is shut down. 
I also didn't found a example in the source and there has been no word in the 
phy.txt documentation about it? So input on how to set the phy irq in the 
board config of the pcm043 would be really nice.

> You can find out easy easy enough, just edit kernel/softirq.c, comment
> out ksoftirqd_set_sched_params() in run_ksoftirqd().  If the throttle
> doesn't kick in (because ksoftirqd is now not RT), box boots but
> ksoftirqd still chewing up a CPU, you have the same info the throttle
> hacklet would show.
> 
> If that's it, you can apply the below, do the same edit, and see which
> thread is grinding away.  From there, I'd set a trap.  Let sirq threads
> detect that they are being awakened too fast (hey, I can't go to sleep,
> the sirq I just processed is busy again, N times in a row) and leave a
> note for wakeup_softirqd().  There, WARN_ON(ksoftirqd)[i].help_me) or
> such, to see who is flogging which softirq mercilessly.
I didn't use this tricks, since top was already doing its job good enough :-).

Best regards
Tim

Please ignore:


Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
