Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab1BWXa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:30:26 -0500
Received: from vs1.gondor.com ([78.47.100.202]:52678 "EHLO
	mail.moria.gondor.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754856Ab1BWXaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:24 -0500
Date: Thu, 24 Feb 2011 00:30:22 +0100
From: Jan Niehusmann <jan@gondor.com>
To: linux-kernel@vger.kernel.org
Subject: memory corruption when (un)plugging VGA cable
Message-ID: <20110223233022.GA3439@x61s.reliablesolutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a Thinkpad x61s, I noticed some memory corruption when
plugging/unplugging the external VGA connection.

Symptoms:
---------

4 bytes at the beginning of a page get overwritten by zeroes. 
The address of the corruption varies when rebooting the machine, but
stays constant while it's running (so it's possible to repeatedly write
some data and then corrupt it again by plugging the cable).

Some example addresses I observed were:
0x998da000
0xb4e6a000
0xb4854000
0xb4843000
(locations in /dev/mem - this is physical memory, right?)

Environment:
------------

2.6.37.1, x86_64, Thinkpad x61s, Intel GM965 with integrated graphics,
6GB of RAM (this may be triggering the problem, as officially, only 4GB
are supported).

I first observed the issue in November 2010, running 2.6.36, and then
again in January, with 2.6.37. Obviously, it doesn't get triggered too
often in day-to-day use (or just isn't noticed), so I'm not sure since
when it actually happened.

How to trigger:
---------------

I first noticed the problem after suspend-to-ram. Later I noticed it's
also possible to trigger the issue by just plugging the VGA cable, so I
guess suspending/resuming only triggers it because it also dis/enables
the VGA output.

Today I spent some time to actively reproduce the issue, successfully.

To reliably detect the problem, I filled up a tmpfs mount with a big
file (3GB) with known content, which makes the corruption hit part of
that file very often. That way, I can reproduce & detect the corruption
within a few minutes (usually after 1-2 reboots).

When plugging the cable while displaying a text console, the backlight
of the internal display goes darker a few moments after actually plugging
the cable. That seems to be the moment when the corruption occurs.


I tried to find the cause by setting a dataw breakpoint with kdb. 
The breakpoint works (verified by writing to the affected file), but
doesn't trigger when the corruption occurs. Not sure what that means.


Suggestions on what I could try to find the cause are very welcome!

