Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab1HPVrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:47:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39813 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1HPVq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:46:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=wg7VStyZqtXyATnY4oxO771AQXrkSjVxUc+i/hlNxoq9dxQH9MAvTAQOEhcFO7jMu
	mkolyi90FLc5IuyaeuNDw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH v2 0/5] Add dynamic updates to trace ring buffer
Date: Tue, 16 Aug 2011 14:46:14 -0700
Message-Id: <1313531179-9323-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
References: <1311721194-12164-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are in response to the fact that sometimes there is higher
rate of events generated on some CPUs as compared to others. This makes
it inefficient to have equal memory size allocated to each of the
per-cpu ring buffers.

This patch series adds 3 things to achieve this:
* Add a way to measure the rate of events generated on a CPU. This is a
  part of patch#2 which makes the 'stats' files print out the number of
  bytes in the ring buffer, the oldest time stamp ("head ts"), and the
  current time stamp ("now ts"). The rate is measured as: bytes /
  (now-head)

* The next patch#3 adds the flexibility to assign different sizes to
  individual per-cpu ring buffers. This is done by adding a
  "buffer_size_kb" debugfs file entry under per_cpu/* directories.

* The final two patches provide a way to change the size of ring
  buffer concurrent to events being added to the ring buffer. Patch#4
  adds functionality to remove pages from the ring buffer and patch#5
  adds functionality to add pages to the ring buffer.

Patch#1 adds a debugfs entry "buffer_total_size_kb" which provides the
total memory allocated for the ring buffer.

This makes it easy for a user process to monitor the rate at which the
ring buffers are being filled up and update the individual per-cpu ring
buffer sizes in response to it.

Changelog v2-v1:
* This changes the logic of page removal from the ring buffer, based on
  comments from Steven Rostedt about the racey behavior of earlier code.
* Some other changes to the functionality and variable names as asked by
  Steven Rostedt.

Vaibhav Nagarnaik (5):
  trace: Add a new readonly entry to report total buffer size
  trace: Add ring buffer stats to measure rate of events
  trace: Add per_cpu ring buffer control files
  trace: Make removal of ring buffer pages atomic
  trace: Make addition of pages in ring buffer atomic

 include/linux/ring_buffer.h |    8 +-
 kernel/trace/ring_buffer.c  |  543 ++++++++++++++++++++++++++++++-------------
 kernel/trace/trace.c        |  247 +++++++++++++++-----
 kernel/trace/trace.h        |    2 +-
 4 files changed, 583 insertions(+), 217 deletions(-)

-- 
1.7.3.1

