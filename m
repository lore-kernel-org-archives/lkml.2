Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1DDVhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:37:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab1DDVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VXQ7Qrhv/F9XW4tb2J4XsnIVUpMUQiCLDsPKo4SzFaz5UAgpEoTq5UUB9PTXWJ2K7n
         na0/BBAK2mBzqm4ig4e7QdofhcyngOnS5ncfR99LfTEU/2xFExKiKyxtoYCzJqpPCrE7
         XZFHtarSrYl9CugwD1gdVRNGx6d8eTKNdTSzU=
Date: Mon, 4 Apr 2011 14:36:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeff Brown <jeffbrown@android.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] input: evdev: Make device readable only when it
 contains a complete packet.
Message-ID: <20110404213659.GC984@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-4-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301727259-5185-4-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 11:54:19PM -0700, Jeff Brown wrote:
> This patch modifies evdev so that it only becomes readable when
> the buffer contains an EV_SYN event other than SYN_MT_REPORT.

I think we should target SYN_REPORT directly. SYN_CONFIG is unused and
SYN_DROPPED is not interesting till next SYN_REPORT anyway. Given the
changes to the previous patch I have the following:


Input: evdev - only signal polls on full packets

From: Jeff Brown <jeffbrown@android.com>

This patch modifies evdev so that it only becomes readable when
the buffer contains an EV_SYN/SYN_REPORT event.

On SMP systems, it is possible for an evdev client blocked on poll()
to wake up and read events from the evdev ring buffer at the same
rate as they are enqueued.  This can result in high CPU usage,
particularly for MT devices, because the client ends up reading
events one at a time instead of reading complete packets.

We eliminate this problem by making the device readable only when
the buffer contains at least one complete packet.  This causes
clients to block until the entire packet is available.

Signed-off-by: Jeff Brown <jeffbrown@android.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/evdev.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index f1c0910..5398761 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -41,6 +41,7 @@ struct evdev {
 struct evdev_client {
 	unsigned int head;
 	unsigned int tail;
+	unsigned int last_syn;	/* position of the last EV_SYN/SYN_REPORT */
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
@@ -72,12 +73,16 @@ static void evdev_pass_event(struct evdev_client *client,
 		client->buffer[client->tail].type = EV_SYN;
 		client->buffer[client->tail].code = SYN_DROPPED;
 		client->buffer[client->tail].value = 0;
+
+		client->last_syn = client->tail;
 	}
 
 	spin_unlock(&client->buffer_lock);
 
-	if (event->type == EV_SYN)
+	if (event->type == EV_SYN && event->code == SYN_REPORT) {
+		client->last_syn = client->head;
 		kill_fasync(&client->fasync, SIGIO, POLL_IN);
+	}
 }
 
 /*
@@ -387,12 +392,12 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 	if (count < input_event_size())
 		return -EINVAL;
 
-	if (client->head == client->tail && evdev->exist &&
+	if (client->last_syn == client->tail && evdev->exist &&
 	    (file->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 
 	retval = wait_event_interruptible(evdev->wait,
-		client->head != client->tail || !evdev->exist);
+		client->last_syn != client->tail || !evdev->exist);
 	if (retval)
 		return retval;
 
@@ -421,7 +426,7 @@ static unsigned int evdev_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &evdev->wait, wait);
 
 	mask = evdev->exist ? POLLOUT | POLLWRNORM : POLLHUP | POLLERR;
-	if (client->head != client->tail)
+	if (client->last_syn != client->tail)
 		mask |= POLLIN | POLLRDNORM;
 
 	return mask;

Thanks.

-- 
Dmitry
