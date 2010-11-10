Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0KJBm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:42:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52086 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0KJBm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:42:27 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1011092013290.13911@xanadu.home>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-29-git-send-email-gregkh@suse.de>
 <AANLkTinVp4C9bRW6=EMHwh1UyeadFbOXKe1aDsxknJf8@mail.gmail.com> <alpine.LFD.2.00.1011092013290.13911@xanadu.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 02:42:10 +0100
Message-ID: <AANLkTinfLT0WYDHek8+QjYKfGC0rtJ3ZFhoZj2fD8-Ri@mail.gmail.com>
Subject: Re: [PATCH 29/49] vcs: add poll/fasync support
To: Nicolas Pitre <nicolas.pitre@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:26, Nicolas Pitre
<nicolas.pitre@canonical.com> wrote:
> On Wed, 10 Nov 2010, Kay Sievers wrote:
>
>> On Fri, Oct 22, 2010 at 20:21, Greg Kroah-Hartman <gregkh@suse.de> wrote:
>> > From: Nicolas Pitre <nico@fluxnic.net>
>> >
>> > The /dev/vcs* devices are used, amongst other things, by accessibility
>> > applications such as BRLTTY to display the screen content onto refreshable
>> > braille displays.  Currently this is performed by constantly reading from
>> > /dev/vcsa0 whether or not the screen content has changed.  Given the
>> > default braille refresh rate of 25 times per second, this easily qualifies
>> > as the biggest source of wake-up events preventing laptops from entering
>> > deeper power saving states.
>> >
>> > To avoid this periodic polling, let's add support for select()/poll() and
>> > SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
>> > data availability whenever the corresponding vt has seen some update after
>> > the last read() operation.  The application still has to lseek() back
>> > as usual in order to read() the new data.
>>
>> Shouldn't it raise POLLPRI/POLLERR then, when it's not about new data
>> to read? We do this for several files in the kernel where we just want
>> to wakup someone, but the pretty well-defined semantics of poll()
>> don't apply.
>
> Hmmm...  Maybe POLLPRI, but POLLERR makes no sense.

I have no opinion about that, but it's what others do:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=31b07093c44a7a442394d44423e21d783f5523b8
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4508a7a734b111b8b7e39986237d84acb1168dd0

The POLLIN should definitely go, it's POSIX defined. What we do here
is more like an error that wakes up than a stream data to read. :)

Kay
