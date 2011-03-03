Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab1CCROY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:14:24 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:38250 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464Ab1CCROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:14:23 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D6FCC99.6090202@cam.ac.uk>
Date: Thu, 03 Mar 2011 17:15:05 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Moving staging:iio over to threaded interrupts.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Given the timing of the writing of most of the IIO core was 
prior to threaded interrupts hitting the mainstream we didn't
use them originally. I suspect that the large numbers of old style
interrupts that we have is going to be a bit of a blocker when we
move out of staging so have been thinking about what to do about it.

This email is intended to get some initial thoughts from others
(some of whom are hopefully more familiar with the ins and outs
of threaded interrupts than I am!)

As I understand it, the primary point of threaded interrupts is
to replace bottom half handlers (conventionally done on using
work queues) with kernel threads that are woken on the interrupt.
The reason is that kernel threads can be pre empted whereas work
queue items can not.

We have two common types of interrupt in IIO.

* Event interrupts (threshold detectors etc). I think these should
  be trivial to convert to threaded irq's.  For those that need
  timestamps we will still need a top half handler to grab that
  but it should be easy enough to do.  There are nasty cases where
  a given physical line can do both this and the next case.  With
  care we can probably avoid this being an issue by careful switching
  of the interrupt handlers according to what can occur in a given
  configuration of the device.

* Trigger interrupts - These are more complex.

For those not that familiar with the IIO trigger infrastructure let
me run through its intent and give an outline of how it currently works.

Our current triggers fall into two classes:
1) Those associated with a device - data ready signals typically
2) Those independent of a device - gpio, timer, userspace.

For simplicity we treat both of these classes the same.

Any trigger can have a number of devices registered with it.  This
allows for, as near a possible, simultaneous reading from a set of
devices.  Which devices these are can be configured / changed at
runtime.

There are two activation lists and each device driver instance can register
in one or both of these. The first 'fast' queue is intended for devices that
have a 'latch' or 'capture' signal typically consisting of a gpio
linked pin.  (no in tree users, but hardware with this
is common enough). Basically the intent is this list launches true
top half elements.

The second 'slow' queue currently queues up work queue items to read
from each of the devices.  It's this part that would ideally be threaded.

Currently the infrastructure is nice and clean and more or less looks
the same as drivers doing their own handling of the relevant interrupts.

The problem lies in the fact each actual interrupt can effectively
call multiple bottom halves.

So to my mind two solutions exist.
1) A single thread per trigger.  Everything prior to the work queue
calls is moved into a handler that goes in the 'fast' list which stays
in our top half handler.  The work queue bits are called one after
another in the bottom half.

2) Allow each consumer to attach it's own thread to the trigger
controller and basically implement our own variant of the core threaded
interrupt code that allows for a list of threads rather than a single one.

I rather like the idea of 2.  It might even end up with different
devices being queried from different processor cores simultaneously
which is quite cute.  The question is whether a simple enough
implementation is possible that the originators of the threaded interrupt
code would be happy with it (as it bypasses or would mean additions to their
core code).

I originally sort opinions from IIO developers on this, but as no
one has been forthcoming with opinions am reposting to a wider
audience to get suggestions on how to handle this.

Thanks and please cc anyone who might want to offer opinions on this.

Thanks,

Jonathan

