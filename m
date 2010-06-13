Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0FMXKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 19:10:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57556 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0FMXKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 19:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=A1y73tOdKamrBU7R0GG6Zc5KRf3TNN+uCYucVQhtq90tCTgB0iGorzgMk4mqsI1uV1
         dluIA7mb21dE0sl0hEObzmYBGavKlMA6mtb6anP10Kg9Pf6uxFLh/OALzu0GLjRMTlIz
         VQYsj0dKXQtFOc8KU28KgRU2FzWUNrLCflNW8=
MIME-Version: 1.0
In-Reply-To: <20100613224752.GA2069@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
	<AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
	<20100613224752.GA2069@dastard>
Date: Sun, 13 Jun 2010 19:10:30 -0400
X-Google-Sender-Auth: sTsrjJNEjS2_Cw_TtywoeesLZPs
Message-ID: <AANLkTikA2d44tZF1TWZAjCqXkhsw0mzsAIaeCosZLqVq@mail.gmail.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Roman Kononov <roman@binarylife.net>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 13, 2010 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jun 12, 2010 at 01:00:52AM -0400, Ilia Mirkin wrote:
>> Sorry to pick up an old-ish thread, but I have a similar situation:
>>
>> On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
>> >> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
>> >> > Can you find out what the application is triggering this?
>>
>> I noticed this happening with mysql and xtrabackup -- the latter opens
>> up mysql's files while mysql is still running (and modifying its own
>> files) and backs them up in a (hopefully) safe way.
>
> That's not safe at all - there's no guarantee you'll end up with a
> consistent database image doing backups like this. Have you ever
> tried to restore and use one of these backups?

Yep, works great. [Used it to initialize a slave, did the full
checksums, so it's unlikely to have randomly corrupt data.] It's the
only credible way to backup a sizeable mysql db, since it works online
with InnoDB; the other options involve either only using MyISAM
(non-transactional) or locking the db for the duration (we couldn't
wait that long, but attempting to do it on a backup machine looked
like it was going to take somewhere between 3 and 7 days, although we
gave up after 24 hours... not something we can afford to do with any
kind of regularity).

>>
>> Would it be safe to remove the warning at
>> fs/xfs/linux-2.6/xfs_lrw.c:651 (which looks like it has moved to
>> xfs_file.c in 2.6.34)? It seems undesirable to get a long stream of
>> these (51 in this particular instance) every time we run a backup...
>
> You can if you want, but then you won't know when your backup or
> database might have been corrupted, right?

No, but I wouldn't know that without the warnings either -- for all I
know xtrabackup could be buggy in all kinds of ways. The only real way
to check is to use the backup data in some way.

>
>> IOW, is the warning purely something along the lines of "Userspace is
>> doing something wonky, but the underlying FS will still be fine no
>> matter what" kind of deal, or could there be an actual problem with
>> the XFS metadata itself?
>
> Nothing wrong with the filesystem metadata will occur - as I said
> eariler in the thread that this is a warning to tell us that data
> corruption is possible due to userspace doing something stupid, not
> a filesystem bug.

OK, thanks for the clarification. Ideally these wouldn't taint the
kernel either -- perhaps these can be downgraded to a message that
explicitly suggests that nothing is wrong with kernel-space things,
only user-space? The backtrace doesn't really get you much, so really
all you want to show is the offending process...

Thanks,

Ilia Mirkin
imirkin@alum.mit.edu
