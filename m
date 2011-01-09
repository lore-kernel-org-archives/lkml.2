Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1AIJAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 04:00:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33134 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1AIJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 04:00:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=shJxfGnzCKdiRlv4U0PRIfh0OkcuwXe+rZ+6WAgYEOW2RamNbaJhMI4znC6ZrBByZW
         3mh11tHya2s/cNRjM3+O00vg4Fq5XeLjxCX0AWcFD2uYq6CgDsCfAVTtdQqBYWgq9MG/
         UVumwtPogRBw5zslXJAapaEhzDgA3wi6ZCg0c=
MIME-Version: 1.0
Date: Sun, 9 Jan 2011 01:00:21 -0800
X-Google-Sender-Auth: XYDbqM2P4gSwEJeUH6r39jZ7Vng
Message-ID: <AANLkTimqzWuGUvMo+8znuVbYocsnsJe7Heo+xY5jRrXv@mail.gmail.com>
Subject: [RFC] New console keyboard mode OFF
From: Arthur Taylor <art@ified.ca>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The current console keyboard situation can be improved by introducing
an "OFF" mode. All available modes for the console keyboard (RAW,
MEDIUMRAW, XLATE, and UNICODE) buffer key events in the current vt's
tty input. As recent Xorg releases no longer read input from the vt
there are two problems:

1) The tty input buffer eventually overflows because nothing is
reading it, triggering an infinite flush_to_ldisc() kworker loop.
2) If the vt's mode isn't changed to RAW or MEDIUMRAW, key events
remain translated by the kernel, causing shenanigans like pressing
Ctrl+C in Xterm would send SIGTERM to the X server.

Xorg fixed these problems in 2008 by always setting the vt to RAW mode
and making a handler call tcflush per keystroke if the
"AllowEmptyInput" option is enabled. I stumbled upon this issue when I
set my X server to not use AllowEmptyInput and manually defined input
devices using evdev. After a set amount of key presses in an X session
my system would experience 1000 wakeups/s, eating no real cpu time but
consuming three extra watts. While I appreciate that this is an
uncommon setup, the current solution is still sort-of hacky as it
means per-keystroke a key is simultaneously reported to userspace via
input device files as well as by the vt keyboard code, through the tty
and line descriptor until it gets to userspace where it is then
flushed by Xorg.

The addition of a new console keyboard mode "OFF" would remove the
need for the tcflush handler hack in Xorg and has the added benefit of
less code being run and less trips to userspace per key event. It is
simple to implement, either by returning early in the console input
handler's key event callback or by unregistering the console's input
handler while in the OFF mode VT. I have tried both methods with
success. Remember of course that the console keyboard mode is a per vt
setting.

The only complication is the way shift keys are handled (or modifiers
in X parlance.) As shift key up/down events are counted to get the
current shift state across all vts, disabling the input handler with a
shift key down makes things get out of sync with reality. Thus, the
key_down array (from which shift_down is calculated) should be cleared
when disabling the input handler. The other method of returning early
must still count shift key events. Note that neither SysRq, which uses
it's own input event handler, nor the Caps-Lock state, which is a
per-console thing, are affected by these changes.

The flush_to_ldisc() infinite kworker loop issue exists independent of
Xorg. It can be triggered by changing to a vt where nothing is reading
from it's input, like a log display, and mashing your keyboard for a
few minutes. Unlikely, but still present.

The Xorg commits I mentioned:
http://cgit.freedesktop.org/xorg/xserver/commit/?id=d936a4235c9625bd41569cef3452dd086284e0d7
http://cgit.freedesktop.org/xorg/xserver/commit/?id=446d9443cea31e493d05c939d0128a8116788468

Cheers
-Art


-- 
Arthur Taylor
art@ified.ca
taylora@uvic.ca
