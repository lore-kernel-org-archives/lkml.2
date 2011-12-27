Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1L0Fwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 00:52:45 -0500
Received: from usul.saidi.cx ([204.11.33.34]:45304 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750954Ab1L0Fwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 00:52:39 -0500
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 00:52:39 EST
Date: Mon, 26 Dec 2011 21:31:40 -0800
From: Philip Langdale <philipl@overt.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, tglx@linutronix.de
Subject: Linux 3.1.5/6 regression: fails to resume from suspend (bisected)
Message-ID: <20111226213140.0308612f@fido5>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After upgrading to 3.1.5, and still in 3.1.6, I found myself unable to
resume from suspend. I did a bisect and identified the following change
as the cause:

commit aeed6baa702a285cf03b7dc4182ffc1a7f4e4ed6
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Dec 2 16:02:45 2011 +0100

    clockevents: Set noop handler in clockevents_exchange_device()
    
    commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.
    
    If a device is shutdown, then there might be a pending interrupt,
    which will be processed after we reenable interrupts, which causes
    the original handler to be run. If the old handler is the
    (broadcast) periodic handler the shutdown state might hang the
    kernel completely. 
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index e4c699d..13dfaab 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -286,6 +286,7 @@ void clockevents_exchange_device(struct
clock_event_device *old,
         * released list and do a notify add later.
         */
        if (old) {
+               old->event_handler = clockevents_handle_noop;
                clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);
                list_del(&old->list);
                list_add(&old->list, &clockevents_released);

If I undo this change in my 3.1.6 tree, I am then able to resume as
before.

This was also reported upstream at fedora but was not fully
diagnosed:

https://bugzilla.redhat.com/show_bug.cgi?id=767248

I wouldn't be surprised if it's related to the nvidia binary drivers
in some way (I use them and so does the fedora bug reporter), but it's
not practical to avoid them.

--phil
