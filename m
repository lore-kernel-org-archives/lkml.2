Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab0HFF4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:56:01 -0400
Received: from mail2.eads.net ([80.156.45.114]:44233 "EHLO mail.eads.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756261Ab0HFFz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:55:58 -0400
X-Greylist: delayed 819 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2010 01:55:58 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: FW: FW: mq_open
Date: Fri, 6 Aug 2010 07:42:15 +0200
Message-ID: <3388F73401504041BD8F7132BAE2C7D41F0812@GSX201B.mxchg.m.corp>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: FW: mq_open
Thread-Index: Acsy6pAdHUv03mJ8RMeiZbaB9SUvzgAErkJwAIrhCHA=
From: "Berger, Lutz (External)" <Lutz.Berger.External@eads.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Denninghoff, Sven Dr. (External)" 
	<Sven.Denninghoff.External@eads.com>,
        "Maehner, Herbert (External)" <Herbert.Maehner.External@eads.com>
X-OriginalArrivalTime: 06 Aug 2010 05:42:15.0452 (UTC) FILETIME=[20270DC0:01CB352A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hello gentleman,

we have a problem with 
mq_open, shm_open and sem_open

As stated in the manpage of "open(2)",  the
  permissions of the created file are (mode & ~umask).

But what is the use of the mode parameter, it it is not used like the programmers intention?
On HP Unix or TRU64 the mode parameter is not modified.

Could you please check, if this is a bug or a faulty system design on linux? 

Thanks in advance.


Mit freundlichen Grüßen / With best regards
Lutz Berger

EADS Deutschland GmbH
Military Air Systems
Integrated Team ASTA - MSF1
85077 Manching
Telephone: +49 (0) 8459.81-79443
Fax: +49 (0) 8459.81-66992
Mobile: +49 (0) 172.8223258
e-Mail: lutz.berger.external@eads.com

www.eads.com

EADS Deutschland GmbH
Registered Office: Ottobrunn
District Court of Munich HRB 107 648
Chairman of the Supervisory Board: Dr. Thomas Enders
Managing Directors: Dr. Stefan Zoller (chairman), Dr. Christoph Hoppe

NOTICE. This message, together with any attachments, may contain
privileged and/or confidential information. If you have received this
e-mail in error or are not an intended recipient, you may not use, reproduce,
disseminate or distribute it; do not open nor save any attachments,
delete it immediately from your system and notify the sender
promptly by e-mail that you have done so.

Thank you.

P Please consider the environment before printing this email


-----Original Message-----
From: Denninghoff, Sven Dr. (External) 
Sent: Tuesday, August 03, 2010 1:17 PM
To: Berger, Lutz (External); Breiter, Stephan (External); Maehner, Herbert (External)
Cc: Laine, Waldemar
Subject: FW: FW: mq_open

 FYI

-----Original Message-----
From: Jan Blunck [mailto:jblunck@suse.de]
Sent: Tuesday, August 03, 2010 11:02 AM
To: Denninghoff, Sven Dr. (External)
Subject: Re: FW: mq_open

On Thu, Jul 29, Denninghoff, Sven Dr. (External) wrote:

> Hallo Jan,
> 
> 
> ich habe hier immer noch ein Problem mit Semaphoren und den 
> Messagequeues. Leider kann ich Dich nicht erreichen, ich hätte auch 
> ein paar andere Fragen, z.B. bezüglich des HZ-paramters im Kernel.
> 

Sorry, dass ich im Moment so schlecht erreichbar bin. Welche Probleme habt ihr mit den HZ settings?

Hier mein Feedback zum mq_open() Problem:

As the manpage of mq_open(3) states, the mode argument is used as for open(2). As it is described in the manpage for open(2) the mode argument is affected by the umask:

 "The argument mode specifies the permissions to use in case a new file is
  created. It is modified by the process's umask in the usual way: the
  permissions of the created file are (mode & ~umask)."

So I would recommend the following code to create 0660 mode message queues:

mqdes = mq_open(...);
if (fchmod(mqdes, S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP) == -1)
   abort();

Changing the umask would affect the creation of all other files as well. Be aware that this (using fchmod() on the mq descriptor) is a Linux specific extension (as stated in mq_overview(7)). On other UNIX's you probably need to still change the umask.

Cheers,
Jan


> Grüße
> 
> Sven
> 
> > ______________________________________________ 
> > From: 	Denninghoff, Sven Dr. (External)  
> > Sent:	Tuesday, June 15, 2010 12:05 PM
> > To:	'Jan Blunck'
> > Subject:	FW: mq_open
> > 
> > Hallo Jan,
> > 
> > kannst Du das nachvollziehen? Soll ich damit einen Bugrequest beim Support machen?
> > 
> > Grüße
> > 
> > Sven
> > 
> > 
> > ______________________________________________ 
> > From: 	Berger, Lutz (External)  
> > Sent:	Tuesday, June 15, 2010 8:08 AM
> > To:	Denninghoff, Sven Dr. (External)
> > Cc:	Breiter, Stephan (External); Maehner, Herbert (External)
> > Subject:	mq_open
> > 
> > Hello Sven,
> > 
> > There is maybe a bug or a wrong understanding of mq_open:
> > 
> > #include <mqueue.h <http://linux.die.net/include/mqueue.h> > mqd_t 
> > mq_open(const char *name, int oflag);mqd_t mq_open(const char *name,
> > int oflag, mode_t mode,              struct mq_attr *attr);
> > 
> > if the paremeter "mode" is 0666, and "oflag" is "O_CREATE | O_RDWR" I expect that others users should be able to send message in this message queue. But then comes the error conde: permission denied.
> > If /dev/mqueue is mounted, the permissions on the created message queue are rw-r--r-- not as expected rw-rw-rw as expected according to the mode parameter. 
> > If the permisions are manualy changed on the filesystem, other use can send messages.
> > 
> > The behaviour is same in Open Suse 11.2 as on Suse Enterprise 11.0.
> > 
> > If required, a small sample program can be provided, but is has to be taken out from the RIG.
> > 
> > Thanks in advance.
> > 
> > 
> > Mit freundlichen Grüßen / With best regards Lutz Berger
> > 
> > EADS Deutschland GmbH
> > Military Air Systems
> > Integrated Team ASTA - MSF1
> > 85077 Manching
> > Telephone: +49 (0) 8459.81-79443
> > Fax: +49 (0) 8459.81-66992
> > Mobile: +49 (0) 172.8223258
> > e-Mail: lutz.berger.external@eads.com 
> > <mailto:lutz.berger.external@eads.com?subject=%23>
> > 
> > www.eads.com
> > 
> > EADS Deutschland GmbH
> > Registered Office: Ottobrunn
> > District Court of Munich HRB 107 648 Chairman of the Supervisory
> > Board: Dr. Thomas Enders Managing Directors: Dr. Stefan Zoller 
> > (chairman), Dr. Christoph Hoppe
> > 
> > NOTICE. This message, together with any attachments, may contain 
> > privileged and/or confidential information. If you have received 
> > this e-mail in error or are not an intended recipient, you may not 
> > use, reproduce, disseminate or distribute it; do not open nor save 
> > any attachments, delete it immediately from your system and notify 
> > the sender promptly by e-mail that you have done so.
> > 
> > Thank you.
> > 
> > P Please consider the environment before printing this email
> > 
> > 
Regards,
	Jan

--
Jan Blunck <jblunck@suse.de>
