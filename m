Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0FND2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 23:28:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64365 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab0FND2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 23:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UM7qZbeXd912Fi0XGXNKFV5F4Ur+Wikxu8uGDRLsShTAy0t8W/xDJIj9bdCvxOfL82
         5z1o3BoOWRppyVqUISsTCXEO9oWI9ms/EvbGeNFxOG0rsJfopcENg3M/ZvamdzZjrCQ8
         f2/tPZvhgCix+SREnmInmBO5m0vUclw4RAP+g=
MIME-Version: 1.0
In-Reply-To: <20100614012933.GB6590@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
	<AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
	<20100614012933.GB6590@dastard>
Date: Sun, 13 Jun 2010 23:27:59 -0400
X-Google-Sender-Auth: 5mJr9-OUf7xUK9yLZLA4q3U9Dm0
Message-ID: <AANLkTilqrYxnRzB3FNNE3k3hX2Sp1U63gyTo3T4CIzWV@mail.gmail.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Roman Kononov <roman@binarylife.net>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 9:29 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Jun 13, 2010 at 07:10:30PM -0400, Ilia Mirkin wrote:
>> On Sun, Jun 13, 2010 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Jun 12, 2010 at 01:00:52AM -0400, Ilia Mirkin wrote:
>> >> Sorry to pick up an old-ish thread, but I have a similar situation:
>> >>
>> >> On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
>> >> >> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
>> >> >> > Can you find out what the application is triggering this?
>> >>
>> >> I noticed this happening with mysql and xtrabackup -- the latter opens
>> >> up mysql's files while mysql is still running (and modifying its own
>> >> files) and backs them up in a (hopefully) safe way.
>> >
>> > That's not safe at all - there's no guarantee you'll end up with a
>> > consistent database image doing backups like this. Have you ever
>> > tried to restore and use one of these backups?
>>
>> Yep, works great. [Used it to initialize a slave, did the full
>> checksums, so it's unlikely to have randomly corrupt data.]
>
> You were lucky, I'd say.  xtrabackup is supposed to be tightly
> integrated with mysql, so perhaps it should be using the same IO
> methods that the admin has selected for their database. Maybe you
> need to talk to the xtrabackup folks to get them to add a "backup
> via direct IO" method if the mysql database is using direct IO so
> that other uses don't have the same issues.

Maybe. We've been using this technique, although on a different
physical machine and with ext3, for quite some time (and we verify all
backups). I did notice that there is a minor difference in
configuration, esp wrt direct IO, so I'll check it out in more detail.
[We're now setting innodb_flush_method to O_DIRECT whereas we weren't
before... although based on the documentation and a cursory
understanding of how xtrabackup works, this shouldn't be harmful.]

> And from a "I read it on the interwebs so it must be true"
> perspective, without a loud obnoxious warning we'll never hear about
> problems until someone flames us about silent data corruption on a
> random blog that gets slashdotted and then referenced for the next
> 10 years as the next canonical "XFS eats my data!" reference for the
> clueless....

Instead it will be "mysql works fine on ext3, but with xfs it spams
the logs with warnings, therefore xfs must be broken". I don't think
there's anything realistically that you can do about uninformed users
and FUD. Although I wasn't suggesting to get rid of the warning,
rather to make it more explicit as to what it's warning about. I
interpret a WARN as a BUG that can be recovered but where the
underlying system needs a careful look; my first inclination after
seeing a fs-related WARN would be to take the system down and run an
fsck. What's happening here seems more akin to getting a WARN when
calling an ioctl with invalid parameters.

---
Ilia Mirkin
imirkin@alum.mit.edu
