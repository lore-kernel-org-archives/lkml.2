Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0DYWeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 18:34:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48192 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab0DYWeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 18:34:22 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004241037230.6848-100000@netrider.rowland.org>
References: <20100424055523.GC2290@elf.ucw.cz>
	 <Pine.LNX.4.44L0.1004241037230.6848-100000@netrider.rowland.org>
Date: Sun, 25 Apr 2010 15:34:20 -0700
Message-ID: <v2ld6200be21004251534y6c820e96l824f3288201a757d@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access 
	suspend blockers from user-space
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 24, 2010 at 7:44 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 24 Apr 2010, Pavel Machek wrote:
>
>> On Fri 2010-04-23 20:20:47, Arve Hj?nnev?g wrote:
>> > On Fri, Apr 23, 2010 at 9:43 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > > On Fri, 23 Apr 2010, Pavel Machek wrote:
>> > >
>> > >> Hi!
>> > >>
>> > >> > Add a misc device, "suspend_blocker", that allows user-space processes
>> > >> > to block auto suspend. The device has ioctls to create a suspend_blocker,
>> > >> > and to block and unblock suspend. To delete the suspend_blocker, close
>> > >> > the device.
>> > >> >
>> > >> > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
>> > >>
>> > >> > --- a/Documentation/power/suspend-blockers.txt
>> > >> > +++ b/Documentation/power/suspend-blockers.txt
>> > >> > @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
>> > >> >  else
>> > >> >     suspend_block(&state->suspend_blocker);
>> > >> >
>> > >> > +User-space API
>> > >> > +==============
>> > >> > +
>> > >> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
>> > >> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
>> > >> > +then call:
>> > >> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
>> > >>
>> > >>
>> > >> This seems like very wrong idea -- it uses different ioctl number for
>> > >> each length AFAICT.
>> > >
>> > > How about specifying the name by an ordinary write() call instead of
>> > > by an ioctl()?
>> > >
>> >
>> > I prefer using ioctls. We have three operations at the moment. Init,
>> > block and unblock. If we do init with write but block and unblock
>> > using ioctls, it would be pretty strange. Specifying a command and
>>
>> Why would it be "strange"?
>
> Why indeed?  Using write() is the natural way to pass a data buffer
> into the kernel, especially a variable-length buffer.
>
> Mixing ioctl() and write() might seem strange at first, but it has
> plenty of precedent.  Consider adjusting the settings for a serial
> port, for example.
>
That sound like to opposite situation to me. It uses ioctls for setup
and read/write access the data stream.

>> > argument in a string to write is more complicated to parse than using
>> > ioctls.
>>
>> More complicated to parse?
>
> It shouldn't be -- especially if you assume that the init action must
> always come first.  The first write would contain the suspend blocker's
> name; all following writes would have to be either "on" or "off".
> That's not hard to parse.
>

Why should I have to parse a string at all? We already have a control
interface, ioctl, where user space can pass a command with data. If we
later want to add other commands we can easily add them without
breaking existing command. With your interface, where the first write
is a name, adding more initialization data later becomes harder. I
also don't like that wring the same string twice has a different
meaning the second time. With the ioctl interface, you forget to
initialize the suspend blocker, it block and unblock operations will
fail. With your interface you create a suspend blocker call "on" or
"off".

-- 
Arve Hjønnevåg
