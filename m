Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab1G1X6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:58:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42479 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab1G1X6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:58:34 -0400
MIME-Version: 1.0
In-Reply-To: <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk>
	<201105171050.38903.florian@openwrt.org>
	<37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk>
	<201107061815.36294.florian@openwrt.org>
	<5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk>
Date: Thu, 28 Jul 2011 19:58:32 -0400
X-Google-Sender-Auth: kd1ORu3H5HtZII8AOmuY6mHEscQ
Message-ID: <CADkLE3XRg6N2cWHXH_JsU56tfw5v5XmJJLfLBM_RtWJRMcZWtA@mail.gmail.com>
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
From: Colin Walters <walters@verbum.org>
To: Tony Ibbs <tibs@tonyibbs.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Quick background: I work on GNOME mainly, and have contributed various
bits of code to DBUS and made some releases historically (though that
is now in more capable hands).  I should also note I have no patches
in the Linux kernel (but I'm trying to follow it more and participate,
so here I am).

So, what I think your description of this project lacks is high-level
technical requirements and goals; you mention basically just
"deterministic ordering" and "easy API" (the latter being fairly
subjective).  You don't mention what your performance requirements are
(if any) for example.

If you had a high-level requirements list it might be easier to
compare with other things.  For example, you might ask "Why not SYSV
IPC"?  Or  "why not drop files in a temporary directory and use
inotify" etc.

My feeling as a DBus developer is that by far its most important
feature is providing a dynamic naming service (the RequestName call).
I don't know how one could sanely do a general-purpose operating
system without a way for loosely-coupled components to find each other
at runtime.  Things like Debian or Fedora where one can assemble
arbitrary sets of packages basically demand the ability do to this -
think things like X being able to talk to HAL, or Firefox being able
to find NetworkManager.

KBUS seems not to provide this (or at least, I'm not seeing it).

The other key feature is signals, where userspace can multicast to
userspace.  KBUS does provide this.

DBus *does* have deterministic ordering too - I'm not sure why you say we don't.

DBus does have some flaws - for example, the resource controls were
poorly thought out and basically useless.  If we were designing them
today, we'd probably have DBus connections tied to Linux cgroups
somehow.  Currently the system bus is limited to a configured amount
of RAM in the XML config (and we don't even attempt to look at system
memory size to limit it); if you have less than 1G (if i remember
correctly) of phys+swap, you can make the bus OOM.

KBUS from what I can see shares this flaw, except that users allocate
arbitrary amounts of kernel memory rather than in userspace in the
system bus:

static ssize_t kbus_write() {
...
		this->msg = kmalloc(sizeof(*(this->msg)), GFP_KERNEL);
		if (!this->msg) {
			retval = -ENOMEM;
			goto done;
		}
...
}

A somewhat weaker but still useful part of DBus is that it has
mandatory security controls; the policy can restrict which uids can
talk to a given service on the bus, and also allows userspace to check
the credentials of messages they receive (think SO_PEERCRED).  By
having KBUS based on files you seem to lose this which you'd get from
a socket API.

On a different topic, I find myself really unconvinced by the length
to which you go to claim the API is simple and easy to use.  I mean, I
really can't imagine it'd be hard to write a userspace C library
implementing the semantics you have here, and have it be as easy or
easier.    Oh you actually do have a "libkbus" here:
http://code.google.com/p/kbus/source/browse/libkbus/kbus.h

You never mention what tradeoffs you might see from having that in
userspace or whether you tried it for that matter.
