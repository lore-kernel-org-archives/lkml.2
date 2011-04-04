Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1DDVdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:33:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58858 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1DDVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UunHsV9E3ulP5bGU9JYLI9+fiH7NW4y0Da+q5NPGqzlIO3t3WxaHxK30lSvDXS0Qot
         b+ZxknqUcDVR4dE7vUKGwUCbbIXwlGCxrmBh4B93L+VQ221ucYr4kVfJ8rbPaMEGh2CW
         ne0t7mU/9wDHCnV1AEFJOY58BYV/+2evRhVF4=
Date: Mon, 4 Apr 2011 14:33:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jeff Brown <jeffbrown@android.com>
Cc: rydberg@euromail.se, djkurtz@google.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Brown <jeffbrown@google.com>
Subject: Re: [PATCH v2 3/4] input: evdev: Indicate buffer overrun with
 SYN_DROPPED.
Message-ID: <20110404213338.GB984@core.coreip.homeip.net>
References: <1301727259-5185-1-git-send-email-jeffbrown@android.com>
 <1301727259-5185-3-git-send-email-jeffbrown@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301727259-5185-3-git-send-email-jeffbrown@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

On Fri, Apr 01, 2011 at 11:54:18PM -0700, Jeff Brown wrote:
>  	/*
>  	 * Interrupts are disabled, just acquire the lock.
> -	 * Make sure we don't leave with the client buffer
> -	 * "empty" by having client->head == client->tail.
> +	 * When the client buffer is full, drain the buffer and enqueue a
> +	 * SYN_DROPPED event to let the client know that events were dropped
> +	 * and the last packet was incomplete.  We then consume all remaining
> +	 * events from the dropped packet until the next packet begins.

I do not think we (kernel) should be doing this. Clients should take
care and not allow overruns but if they happen the pain should be on the
client to restore the context. It has to query the device to get its
current state and it can drop the events till next sync as well.

Therefore I intend to apply the patch in the form below.

Thanks!

-- 
Dmitry


Input: evdev - indicate buffer overrun with SYN_DROPPED

From: Jeff Brown <jeffbrown@google.com>

Add a new EV_SYN code, SYN_DROPPED, to inform the client when input
events have been dropped from the evdev input buffer due to a
buffer overrun.  The client should use this event as a hint to
reset its state or ignore all following events until the next
packet begins.

Signed-off-by: Jeff Brown <jeffbrown@android.com>
[dtor@mail.ru: Implement Henrik's suggestion and drop old events in
 case of overflow.]
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 Documentation/input/event-codes.txt |    6 ++++++
 drivers/input/evdev.c               |   33 +++++++++++++++++++++------------
 include/linux/input.h               |    1 +
 3 files changed, 28 insertions(+), 12 deletions(-)


diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
index d6732a4..e0326a0 100644
--- a/Documentation/input/event-codes.txt
+++ b/Documentation/input/event-codes.txt
@@ -79,6 +79,12 @@ defined only by when they are sent in the evdev event stream.
   - Used to synchronize and separate touch events. See the
     multi-touch-protocol.txt document for more information.
 
+* SYN_DROPPED:
+  - Used to indicate buffer overrun in the evdev client's event queue.
+    Client should ignore all events up to and including next SYN_REPORT
+    event and query the device (using EVIOCG* ioctls) to obtain its
+    current state.
+
 EV_KEY:
 ----------
 EV_KEY events take the form KEY_<name> or BTN_<name>. For example, KEY_A is used
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7f42d3a..f1c0910 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -39,13 +39,13 @@ struct evdev {
 };
 
 struct evdev_client {
-	int head;
-	int tail;
+	unsigned int head;
+	unsigned int tail;
 	spinlock_t buffer_lock; /* protects access to buffer, head and tail */
 	struct fasync_struct *fasync;
 	struct evdev *evdev;
 	struct list_head node;
-	int bufsize;
+	unsigned int bufsize;
 	struct input_event buffer[];
 };
 
@@ -55,16 +55,25 @@ static DEFINE_MUTEX(evdev_table_mutex);
 static void evdev_pass_event(struct evdev_client *client,
 			     struct input_event *event)
 {
-	/*
-	 * Interrupts are disabled, just acquire the lock.
-	 * Make sure we don't leave with the client buffer
-	 * "empty" by having client->head == client->tail.
-	 */
+	/* Interrupts are disabled, just acquire the lock. */
 	spin_lock(&client->buffer_lock);
-	do {
-		client->buffer[client->head++] = *event;
-		client->head &= client->bufsize - 1;
-	} while (client->head == client->tail);
+
+	client->buffer[client->head++] = *event;
+	client->head &= client->bufsize - 1;
+
+	if (unlikely(client->head == client->tail)) {
+		/*
+		 * This effectively "drops" all unconsumed events, leaving
+		 * EV_SYN/SYN_DROPPED plus the newest event in the queue.
+		 */
+		client->tail = (client->head - 2) & (client->bufsize - 1);
+
+		client->buffer[client->tail].time = event->time;
+		client->buffer[client->tail].type = EV_SYN;
+		client->buffer[client->tail].code = SYN_DROPPED;
+		client->buffer[client->tail].value = 0;
+	}
+
 	spin_unlock(&client->buffer_lock);
 
 	if (event->type == EV_SYN)
diff --git a/include/linux/input.h b/include/linux/input.h
index f3a7794..71d3651 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -167,6 +167,7 @@ struct input_keymap_entry {
 #define SYN_REPORT		0
 #define SYN_CONFIG		1
 #define SYN_MT_REPORT		2
+#define SYN_DROPPED		3
 
 /*
  * Keys and buttons
