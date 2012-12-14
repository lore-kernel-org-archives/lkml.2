Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2LNThZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:37:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36701 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2LNThY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <1355155456-21577-1-git-send-email-ajax@redhat.com>
References: <1355155456-21577-1-git-send-email-ajax@redhat.com>
Date: Fri, 14 Dec 2012 11:37:20 -0800
Message-ID: <CAFDufb9DK5J0NeAh=pd1SyykKSfcE8otKRjUbVnZhmNWOWW=4A@mail.gmail.com>
Subject: Re: [PATCH] vt: Add VC_MUTE (v2)
From: Arthur Taylor <art@ified.ca>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The "don't enqueue stuff" semantics of K_OFF shouldn't be a function of
> the keyboard map state; we should be able to switch among cooked/raw/
> unicode without changing whether events are delivered.  Otherwise - if
> changing to K_UNICODE undoes K_OFF - then suddenly Alt-F2 under
> Gnome will switch VT instead of summoning the "run command" dialog.

A patch to disable the muting should be added to the SysRq handler for
the "unRaw" action.

I do not think that KBMODE is only about the keyboard map. The
behaviours that KBMODE influences are:
-Whether input is generated.
-Whether input is buffered by line.
-Whether key events are put through the keymap and translated by
modifiers or sent as raw keyup/down events.
-Whether the keymap is unicode.
-Whether special keys are interpreted by the kernel.

The meaning of KBMODE is a bit overloaded It does make sense to split
the generate / don't generate input into its own ioctl. However, IMO
this change is part of an incomplete fix to a user space problem.

The issue creating a need for moving the generate / don't generate
input to its own ioctl was that through some plumbing, when changing
the keymap setting in an X graphical environment session systemd is
told to switch the console keymap. As part of switching the keymap, if
unicode is selected, systemd blindly calls KDSKBMODE with K_UNICODE.
This currently messes up X, which this change attempts to address.

I'm not sure if letting systemd freely meddle with KBMODE and moving
the important-for-X behaviour to another ioctl is such a wise idea.
systemd already changes the kernel default KBMODE to/from unicode by a
module parameter. Further, this will only work with newer or patched X
servers.

Depending on the input configuration and drivers used by X, either the
input system is used directly and the virtual console keyboard is
ignored, or X uses the virtual console keyboard for input and switches
it into RAW mode.

In both modes X does not want the kernel to interpret special keys. In
the former mode X doesn't want the kernel to generate input (as
otherwise it needs to periodically flush a buffer it never reads to
stop it from overflowing and causing a kworker to go nuts), in the
later mode X wants raw key up/down events which are not line buffered.

Setting the console to K_UNICODE is none of these things and causes
one of many possible problems.

KBMODE (like the console keymap) is a virtual console setting which is
stored in the virtual terminal and saved/restored from the console
upon a VT switch.

X is usually run on a VT it allocates and then closes on exit, but you
can also specify a VT for X to run on which could already have been
open by another process (say getty.) In either case, X saves the
KBMODE of the VT during initialization and restores it upon exit.

systemd calling KDSKBMODE on a VT which X is running either has no
affect or a negative affect on X. In the rare case that X is started
on a VT with another text mode cooked input process, KBMODE is
unaffected after X exits.

-Art
