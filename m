Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab2CYWBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 18:01:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184Ab2CYWBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 18:01:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] firmware_class: Fix problems with usermodehelper test
Date: Mon, 26 Mar 2012 00:00:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203191225.00199.rjw@sisk.pl> <201203200000.43316.rjw@sisk.pl>
In-Reply-To: <201203200000.43316.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201203260000.34377.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The following series of patches fixes two problems with
request_firmware() and request_firmware_nowait() resulting from commit
a144c6a6c924aa1da04dd77fb84b89927354fdff

    PM: Print a warning if firmware is requested when tasks are frozen

The first problem is that request_firmware_nowait() may fail if it happens
to run in parallel with system suspend.  It should't fail in such situations
and that is addressed by the first three patches (that code has been discussed
with Linus at al already).

The second issue is that request_firmware() may be called in a thread which
isn't related to system suspend and if suspend happens exactly at that time,
request_firmware() will fail (and print a scary warning), although it shouldn't.
This problem is addressed by the remaining three patches, which are new.

[1/6] - Rework the usermodehelper check in _request_firmware().
[2/6] - Split _request_firmware() into three functions.
[3/6] - If firmware is to be loaded asynchronously, wait for usermodehelper_disabled
        to be unset instead of failing the operation.
[4/6] - Unify the hibernation/suspend code's usage of usermodehelper_disable().
[5/6] - Move usermodehelper_disable() into freeze_processes().
[6/6] - Make freezable threads calling request_firware() avoid the race with the
        freezer.

Thanks,
Rafael

