Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab2KEIiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:38:18 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39710 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2KEIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:38:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121105082228.GB3730@kroah.com>
References: <20120928201501.208384923@linuxfoundation.org>
	<20120928201506.526781717@linuxfoundation.org>
	<CAMbhsRRP5ui-10hMEFYk2Rh93XrvKeircsZXsySE7YXF92qigQ@mail.gmail.com>
	<20121105082228.GB3730@kroah.com>
Date: Mon, 5 Nov 2012 00:38:15 -0800
Message-ID: <CAMbhsRQOpnUX_qszZftPSVR+g92Ja-Q1aky8D1SpFP=t==ADXg@mail.gmail.com>
Subject: Re: [ 044/218] Staging: Android alarm: IOCTL command encoding fix
From: Colin Cross <ccross@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, "Dae S. Kim" <dae@velatum.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 12:22 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Nov 03, 2012 at 12:33:07AM -0700, Colin Cross wrote:
>> On Fri, Sep 28, 2012 at 1:14 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > 3.4-stable review patch.  If anyone has any objections, please let me know.
>> >
>> > ------------------
>> >
>> > From: "Dae S. Kim" <dae@velatum.com>
>> >
>> > commit 6bd4a5d96c08dc2380f8053b1bd4f879f55cd3c9 upstream.
>> >
>> > Fixed a bug. Data was being written to user space using an IOCTL
>> > command encoded with _IOC_WRITE access mode.
>> >
>> > Signed-off-by: Dae S. Kim <dae@velatum.com>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >
>> > ---
>> >  drivers/staging/android/android_alarm.h |    4 +++-
>> >  1 file changed, 3 insertions(+), 1 deletion(-)
>> >
>> > --- a/drivers/staging/android/android_alarm.h
>> > +++ b/drivers/staging/android/android_alarm.h
>> > @@ -110,10 +110,12 @@ enum android_alarm_return_flags {
>> >  #define ANDROID_ALARM_WAIT                  _IO('a', 1)
>> >
>> >  #define ALARM_IOW(c, type, size)            _IOW('a', (c) | ((type) << 4), size)
>> > +#define ALARM_IOR(c, type, size)            _IOR('a', (c) | ((type) << 4), size)
>> > +
>> >  /* Set alarm */
>> >  #define ANDROID_ALARM_SET(type)             ALARM_IOW(2, type, struct timespec)
>> >  #define ANDROID_ALARM_SET_AND_WAIT(type)    ALARM_IOW(3, type, struct timespec)
>> > -#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOW(4, type, struct timespec)
>> > +#define ANDROID_ALARM_GET_TIME(type)        ALARM_IOR(4, type, struct timespec)
>> >  #define ANDROID_ALARM_SET_RTC               _IOW('a', 5, struct timespec)
>> >  #define ANDROID_ALARM_BASE_CMD(cmd)         (cmd & ~(_IOC(0, 0, 0xf0, 0)))
>> >  #define ANDROID_ALARM_IOCTL_TO_TYPE(cmd)    (_IOC_NR(cmd) >> 4)
>> >
>>
>> This patch breaks Android userspace by changing the ioctl ABI to
>> /dev/alarm.  It's definitely not a bug fix, as the IOW vs. IOR flag is
>> only ever used by drivers, and is not used by alarm-dev.c.
>
> But shouldn't Android userspace work fine if it's rebuilt with the fixed
> header file?

Sure, but it's an ABI change, so any existing userspace won't work
with a new kernel.

> And isn't this the correct fix that the kernel needs, to properly check
> this ioctl data access works correctly?

No, the ioctl syscall never checks the direction bits anywhere I can
see.  Many of the hardcoded VFS ioctls in do_vfs_ioctl have no
direction bits in their ioctl numbers.  The direction bits are just
helpful to allow ioctl handlers to use a pattern like:
if (_IOC_DIR(cmd) & _IOC_WRITE)
   copy_from_user(...);
switch(cmd) {
...
}
if (_IOC_DIR(cmd) & _IOC_READ)
   copy_to_user(...);

The alarm-dev.c ioctl handler does not use this pattern, so the
direction bits are meaningless.  I agree that the
ANDROID_ALARM_GET_TIME ioctl should have been marked IOR originally,
but it's an actively used ABI now and shouldn't be changed for a
purely cosmetic reason.

>> I would have commented sooner, but the original patch was not sent to
>> any lists I am on, nor any lists that Google can find.
>
> Odd, I don't have access to my email archive, so I don't remember where
> it came from originally, sorry.  Possibly the driverdevel mailing list?
>
> thanks,
>
> greg k-h
