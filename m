Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1J0XVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 19:21:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61716 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab1J0XVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 19:21:34 -0400
MIME-Version: 1.0
In-Reply-To: <201110272206.26848.grabner@icg.tugraz.at>
References: <CAJSP0QWV9V7JzCcJROF9_Psib3kC0f67c2OwZzJbxPmZn9SBJg@mail.gmail.com>
	<20111027090507.GA5213@suse.de>
	<CAJSP0QWJOODix7xR9JjUsB9XpYinwJ1Mk+GfO9649HGUd92dzQ@mail.gmail.com>
	<201110272206.26848.grabner@icg.tugraz.at>
Date: Fri, 28 Oct 2011 00:21:32 +0100
Message-ID: <CAJSP0QV1WgUZNO4ps3PvoTTsyJQ_xFprdyA=J622n0L6XF8QxQ@mail.gmail.com>
Subject: Re: staging: line6 driver status
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: devel@linuxdriverproject.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 9:06 PM, Markus Grabner <grabner@icg.tugraz.at> wrote:
> On Thursday 27 October 2011 11:43:21 you wrote:
>> On Thu, Oct 27, 2011 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
>> > On Thu, Oct 27, 2011 at 09:28:59AM +0100, Stefan Hajnoczi wrote:
>> >> What is the status of the line6 staging driver?  There is no TODO file
>> >> so I'm not sure what is blocking it from leaving staging.
>> >
>> > That's a good question.  I don't really know the status of the driver at
>> > the moment, does anyone else?
>>
>> I have one question about the design of the driver:
>>
>> Do we really need the sysfs attributes which boil down to MIDI
>> commands?  I think a userspace library provides a better interface
>> because the MIDI commands/values vary between device models and bloat
>> the driver.  Generic sound recording and MIDI software would talk to
>> the driver.  Utilities to control the device could link against the
>> userspace library.
>>
>> By splitting the code into the kernel MIDI/pcm driver and a userspace
>> control library which uses MIDI we can slim down the kernel driver and
>> leave the large variation of MIDI commands/values to a library that
>> the community can improve for specific device models.
>>
>> This will make the driver smaller and easier for review.
> I actually already started to work on this, but progress is slow since I'm
> quite busy with other things. As soon as there is a convenient way to access
> device parameters via user space code, I agree that the corresponding sysfs
> attributes should be removed from the driver.

I am working on Pod HD300 support.  Because this device doesn't
support all MIDI messages that previous models do I am eager to
eliminate the hardcoded MIDI messages in the driver.

Do you have a development git tree that I could send patches against?

The current issue with Pod HD300 is that 48 kHz S24_3LE pcm does not
work reliably.  gnome-sound-recorder and audacity can record and
playback using the device, captured audio is in tune.

However after some time recording the sound suddenly changes - almost
like the sampling rate has been changed, so everything is high-pitch
and tinny.  Another symptom is that audacity simply freezes up its GUI
and stops recording.

I'm still trying to figure out the cause for this pcm capture problem
with the following in syslog:

pulseaudio[3342]: [alsa-sink] alsa-sink.c: ALSA woke us up to write
new data to the device, but there was actually nothing to write!
pulseaudio[3342]: [alsa-sink] alsa-sink.c: Most likely this is a bug
in the ALSA driver 'line6usb'. Please report this issue to the ALSA
developers.
pulseaudio[3342]: [alsa-sink] alsa-sink.c: We were woken up with
POLLOUT set -- however a subsequent snd_pcm_avail() returned 0 or
another value < min_avail.
pulseaudio[3342]: [alsa-sink] alsa-util.c: Could not recover from
POLLERR|POLLNVAL|POLLHUP with snd_pcm_prepare(): File descriptor in
bad state

and

pulseaudio[3342]: [alsa-sink] protocol-native.c: Failed to push data into queue

It's probably my changes that have broken the driver but are you aware
of any existing pcm stability issues with gnome-sound-recorder,
audacity, or ardour2 (jack)?

Stefan
