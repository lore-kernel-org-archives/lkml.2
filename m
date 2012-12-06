Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424565Ab2LFRGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:06:46 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:64690 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2LFRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:06:44 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 00/14] printk() fixes, optimizations, and clean ups
Date: Thu,  6 Dec 2012 18:05:57 +0100
Message-Id: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, hi Kay, and all other interested people.

This is the second iteration of my try to clean up and fix some bugs around
printk(). A few things got fixed and improved. But I'm still waiting for the
usual beating, that I changed too much. ;)

(This is not to be confused with the printk.c reorganization that Joe 
Perches currently does [1]. My series is really focused around printk().)

A summary of changes compared to v1 [3] can be found below the now following
high-level description. This series is currently against v3.7-rc8, but it
applies to next-20121206 as well.

Patches 11 and 12 might require some discussion, see below.

1. printk: drop ambiguous LOG_CONT flag

	This patch started everything [2]. It fixes incorrect merges of
	independent continuation records. With all the other patches on top,
	there is not much left of it, but it still serves as a clean up
	and a backup solution if the changes of patches 9-14 are considered
	over the limit.

2. printk: use saved timestamp for temporarily buffered message
3. printk: reclaim cont buffer immediately for fully printed messages
4. printk: do not add unnecessary newlines to the continuation buffer
5. printk: reuse reclaimed continuation buffer immediately
6. printk: move wake_klogd-check out of the loop

	These five patches fall mostly into the optimization category. The
	only measurable effect is probably that continuation records are more
	often merged than before (patches 3+4+5). Patch 4 also fixes a
	potential problem resulting in not merged continuation records.

7. printk: let cont_print_text() reuse existing code

	Code clean-up. Fixes a bug when printing multiline message to the 
	console.

8. printk: refactor locking in console_unlock()

	Fix a problem with the order of printed messages due to locking race
	conditions.

9. printk: retain unknown log-level until cont_add()/log_store()
10. printk: track previously logged message in log_store()
11. printk: avoid glitches in console output
12. printk: encode formatting in message flags
13. printk: drop now useless tracking of previous message flags

	Patches 9 and 10 are preparations for patches 11 and 12.

	Patch 11 has a notable effect on the console output when there are
	concurrent printk()s. Personally, I think it improves the readability,
	but there could be a reason I'm not aware of why such a change is
	not acceptable. Please discuss.

	Patch 12 also changes behavior, but only in a few corner cases. OTOH,
	it improves source readability by removing some of the historical
	growth (patch 13) that only makes sense when you have actually read
	the history. Comments?

14. printk: refactor continuation buffer handling

	Cure four minor issues with continuation messages by doing some
	code reorganization.


If patches 9-14 are too much, applying just the more straight-forward 
patches 1-8 for now is fine, too. 


Changes of v2 compared to v1 (see per-patch changes for additional details):

- fixed a bug (pointed out by Kay) when a single newline is printed
- fixed two bugs that could mismerge continuation records

- added patch 4 (making patch 3 efficient again after fixing the single
  newline bug)
- added a check for the cont buffer for the retry loop to patch 8
- added patch 14

- realized patch 7 differently, in a more readable way
- reorganized the patches towards the end due to patch 14 and the bug-fixes


Remaining issues (which also existed before applying this series) from my
point of view:

1. console_unlock() could use a rewrite to be more readable. (See comment in
   patch 8.)

2. After patch 14 it would be relatively simple to add support for multiple
   cont buffers. Is someone interested in this?

3. The cont buffer should be flushed automatically after some time, so that
   its contents become available to syslog. Currently flushing can be delayed
   indefinitely. (See comment in patch 14.)

I'll probably do #1 one day. #2 only when someone asks. And I currently don't
know The Right Way to do #3.

Regards
Jan

[1] Joe Perches' printk reorganization: http://lkml.org/lkml/2012/10/24/748
[2] first version of patch 1: http://lkml.org/lkml/2012/9/26/392
[3] v1 of this series: http://lkml.org/lkml/2012/11/13/678



Jan H. Schönherr (14):
  printk: drop ambiguous LOG_CONT flag
  printk: use saved timestamp for temporarily buffered message
  printk: reclaim cont buffer immediately for fully printed messages
  printk: do not add unnecessary newlines to the continuation buffer
  printk: reuse reclaimed continuation buffer immediately
  printk: move wake_klogd-check out of the loop
  printk: let cont_print_text() reuse existing code
  printk: refactor locking in console_unlock()
  printk: retain unknown log-level until cont_add()/log_store()
  printk: track previously logged message in log_store()
  printk: avoid glitches in console output
  printk: encode formatting in message flags
  printk: drop now useless tracking of previous message flags
  printk: refactor continuation buffer handling

 kernel/printk.c | 481 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 292 insertions(+), 189 deletions(-)

-- 
1.8.0.1.20.g7c65b2e.dirty

