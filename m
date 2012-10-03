Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab2JCVLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:11:15 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57759 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2JCVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:11:13 -0400
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com> <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com> <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com> <20121003170907.GA23473@ZenIV.linux.org.uk> <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com> <20121003195059.GA13541@kroah.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20121003195059.GA13541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 03 Oct 2012 17:10:17 -0400
To: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Message-ID: <4a5bbed4-fe95-4feb-b229-4c658f72ac17@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-03_02:2012-10-03,2012-10-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1210030246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> wrote:

>On Wed, Oct 03, 2012 at 10:32:08AM -0700, Linus Torvalds wrote:
>> On Wed, Oct 3, 2012 at 10:09 AM, Al Viro <viro@zeniv.linux.org.uk>
>wrote:
>> >
>> > +       if (!S_ISREG(inode->i_mode))
>> > +               return false;
>> > +       size = i_size_read(inode);
>> >
>> > Probably better to do vfs_getattr() and check mode and size in
>kstat; if
>> > it's sufficiently hot for that to hurt, we are fucked anyway.
>> >
>> > +               file = filp_open(path, O_RDONLY, 0);
>> > +               if (IS_ERR(file))
>> > +                       continue;
>> > +printk("from file '%s' ", path);
>> > +               success = fw_read_file_contents(file, fw);
>> > +               filp_close(file, NULL);
>> >
>> > fput(file), please.  We have enough misuses of filp_close() as it
>is...
>> 
>> Ok, like this?
>
>This looks good to me.  Having udev do firmware loading and tieing it
>to
>the driver model may have not been such a good idea so many years ago.
>Doing it this way makes more sense.
>
>greg k-h
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

I agree that not calling out to userspace for firmware load is better.

Here is an old, unresolved bug about Oops on firmware loading race condition

https://bugzilla.kernel.org/show_bug.cgi?id=15294

The firmware loading timeout in the kernel was cleaning things up, just as udev what trying to say "I'm done loading the firmware" via sysfs; and then *boom*.

Regards,
Andy
