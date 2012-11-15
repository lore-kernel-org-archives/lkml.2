Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab2KOVWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:22:30 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:48734 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2KOVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:22:27 -0500
Message-ID: <50A55CFE.3030107@cs.tu-berlin.de>
Date: Thu, 15 Nov 2012 22:22:06 +0100
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120919 Thunderbird/10.0.7
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] printk() fixes, optimizations, and clean ups
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de> <1352995520.26800.2.camel@rig.fritz.box>
In-Reply-To: <1352995520.26800.2.camel@rig.fritz.box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.11.2012 17:05, schrieb Kay Sievers:
> This with all your patches applied:
> [    1.032804] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
> [    1.063915] List of all partitions:
> [    1.065521] 0800       117220824 sda  driver: sd
> [    1.067444]   0801         1048576 sda1 1fcbc57f-4bfc-4c2b-91a3-9c84fbcd9af1  0802        30720000 sda2 084917b7-8be2-4e86-838d-f771a9902e08  0803        15360000 sda3 180053b6-6697-4f4c-b331-4925773197ff  0804        54730752 sda4 b67dfc6e-d06f-4b11-bd52-96c09163aca9  0805        15360000 sda5 6d0d537c-3107-4057-a57b-5379a0cd8e31No filesystem could mount root, tried:  btrfs
> [    1.077120] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)
> 
> 
> Something seems broken in the patches regarding the console or newline logic.

(Just to mention it: I did do quite some testing, but this case must have
escaped me.)

Hmm... the code in question does only continuation prints, without any PREFIX.
Especially, it issues a single

	printk("\n");

at the end of each line (and does not start the next line with a KERN_ prefix).

This newline gets lost on the console.

This is due to patch 3, which reclaims a fully printed cont buffer
immediately. It does only a length check, without considering the LOG_NEWLINE
flag. So we never come around to print it. (And then, patch 9 has a similar
check -- which, btw, is necessary already in patch 7 I think...)

Please, try the patch below on top of everything. If this works, I'll prepare
a -v2 where everything is sorted into the correct patches.

(Though that makes patch 3 less efficient as we add newlines very late in two 
places via cont_flush(). OTOH, the newlines are not strictly needed, I think.)
(And another note: the longer I look at all the code, the more I want to try 
the alternative mentioned in patch 6, might be easier to read overall.)

Regards
Jan

diff --git a/kernel/printk.c b/kernel/printk.c
index d27da0a..51da981 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1434,7 +1434,8 @@ static void cont_flush(enum log_flags flags)
 	 * If no fragment of this line ever reached the console or everything
 	 * has been printed, free the buffer. Otherwise keep it available.
 	 */
-	if (!cont.cons || cont.cons == cont.msg.text_len)
+	if (!cont.cons || (cont.cons == cont.msg.text_len &&
+			   !(cont.msg.flags & LOG_NEWLINE)))
 		cont.msg.text_len = 0;
 	else
 		cont.flushed = log_next_seq - 1;
@@ -1475,14 +1476,17 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 
 static size_t cont_print_text(char *text, size_t size)
 {
-	size_t textlen;
+	size_t textlen = 0;
 	enum log_flags flags = cont.msg.flags;
 	u64 seq = cont.flushed ? cont.flushed : log_next_seq;
 
 	if (cont.msg.text_len == cont.cons) {
-		if (cont.flushed)
-			cont.msg.text_len = 0;
-		return 0;
+		/* Not even a newline to print? */
+		if (!(cont.msg.flags & LOG_NEWLINE))
+			goto out;
+		/* Newline already printed due to other messages? */
+		if (console_printed_seq != 0)
+			goto out;
 	}
 
 	/* Avoid a break, when we continuously print the cont buffer */
@@ -1505,6 +1509,7 @@ static size_t cont_print_text(char *text, size_t size)
 	console_prev = cont.msg.flags;
 	console_printed_seq = cont.flushed;
 
+out:
 	if (cont.flushed)
 		cont.msg.text_len = 0;
 
