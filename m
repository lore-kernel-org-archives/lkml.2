Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2KMXNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:13:32 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63433 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2KMXNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:13:31 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 00/12] printk() fixes, optimizations, and clean ups
Date: Wed, 14 Nov 2012 00:12:57 +0100
Message-Id: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, hi Kay, and all other interested people.

This series aims at cleaning up and fixing some bugs around printk().
Patches 9 and 11 might require some discussion, see below.

(This is not to be confused with the printk.c reorganization that Joe 
Perches currently does [1]. This series is really focused around printk().)

Let's get straight to the individual patches (series is currently against
v3.7-rc5, but applies to next-20121113 as well):

1. printk: drop ambiguous LOG_CONT flag

	This is the only patch that was previously posted [2]. Compared to
	the previous version, a small bug got fixed. With this patch,
	independent continuation records are no longer incorrectly merged.

2. printk: use saved timestamp for temporarily buffered message
3. printk: reclaim cont buffer immediately for fully printed messages
4. printk: reuse reclaimed continuation buffer immediately
5. printk: move wake_klogd-check out of the loop

	These four patches fall into the optimization category. The only
	measurable effect is probably that continuation records are more often
	merged than before (patches 3+4).

6. printk: reorganize storage of continuation buffer
7. printk: let cont_print_text() reuse existing code

  	These two reduce replicated code within printk.c and fix an actual bug
	in the console output of logged messages.

8. printk: refactor locking in console_unlock()

  	Another bugfix. And due to the refactored locking, I hopefully closed
	all the smaller time-windows where the same race could have happened.
	(This patch does not fix all issues within console_unlock() that I am
	aware of, see patch description.) 

9. printk: avoid glitches in console output

	This one has a notable effect on the console output when there are
	concurrent printk()s. Personally, I think it improves the readability,
	but there could be a reason I'm not aware of why such a change is
	not acceptable. Please discuss.

10. printk: retain unknown log-level until log_store()
11. printk: track previously logged message in log_store()
12. printk: drop now useless tracking of previous message flags

	The change due to these three patches is only noticeable for a user in
	a few corner cases. OTOH, it improves source readability by removing
	some of the historical growth (patch 12) that only makes sense when
	you have actually read the history.


Regards
Jan

[1] http://lkml.org/lkml/2012/10/24/748
[2] http://lkml.org/lkml/2012/9/26/392

Jan H. Schönherr (12):
  printk: drop ambiguous LOG_CONT flag
  printk: use saved timestamp for temporarily buffered message
  printk: reclaim cont buffer immediately for fully printed messages
  printk: reuse reclaimed continuation buffer immediately
  printk: move wake_klogd-check out of the loop
  printk: reorganize storage of continuation buffer
  printk: let cont_print_text() reuse existing code
  printk: refactor locking in console_unlock()
  printk: avoid glitches in console output
  printk: retain unknown log-level until log_store()
  printk: track previously logged message in log_store()
  printk: drop now useless tracking of previous message flags

 kernel/printk.c | 368 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 209 insertions(+), 159 deletions(-)

-- 
1.8.0.316.g291341c.dirty

