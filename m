Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2BMXwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 18:52:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37237 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2BMXwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 18:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <201202120028.23364.rjw@sisk.pl>
References: <1327112659-31145-1-git-send-email-arve@android.com>
	<201202120028.23364.rjw@sisk.pl>
Date: Mon, 13 Feb 2012 15:52:14 -0800
Message-ID: <CAMP5XgfrG=3qeFasg4prBu88-Ox59_PtFw-rpgb=PN=uo6VPuw@mail.gmail.com>
Subject: Re: [PATCH] Input: Add ioctl to block suspend while event queue is
 not empty.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-input@vger.kernel.org, linux-pm@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/11 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> On Saturday, January 21, 2012, Arve Hjønnevåg wrote:
>> Add an ioctl, EVIOCSSUSPENDBLOCK, to block suspend while the event
>> queue is not empty. This allows userspace code to process input
>> events while the device appears to be asleep.
>
> I have two questions to start with, if you don't mind:
>
> (1) Does Android user space use an analogous interface right now or is it
>    a prototype?
>

Yes (for the next version), but with a wakelock based implementation.

> (2) What exactly are the use cases for it (ie. what problem does it address
>    that cannot be addressed in a different way)?
>

The reason for adding an ioctl versus the old android version with
used a wakelock for all input events, is that not all input events are
wakeup events. Specifically some sensors generate input events at such
a high rate that they prevent suspend while the sensor is on even
though the driver has a suspend hook that turns the sensor off.

If you are asking why input events need to block suspend at all, this
was the example used in the suspend blocker documentation:
- The Keypad driver gets an interrupt. It then calls suspend_block on the
  keypad-scan suspend_blocker and starts scanning the keypad matrix.
- The keypad-scan code detects a key change and reports it to the input-event
  driver.
- The input-event driver sees the key change, enqueues an event, and calls
  suspend_block on the input-event-queue suspend_blocker.
- The keypad-scan code detects that no keys are held and calls suspend_unblock
  on the keypad-scan suspend_blocker.
- The user-space input-event thread returns from select/poll, calls
  suspend_block on the process-input-events suspend_blocker and then calls read
  on the input-event device.
- The input-event driver dequeues the key-event and, since the queue is now
  empty, it calls suspend_unblock on the input-event-queue suspend_blocker.
- The user-space input-event thread returns from read. If it determines that
  the key should be ignored, it calls suspend_unblock on the
  process_input_events suspend_blocker and then calls select or poll. The
  system will automatically suspend again, since now no suspend blockers are
  active.


-- 
Arve Hjønnevåg
