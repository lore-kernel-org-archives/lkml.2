Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2DQPqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:46:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab2DQPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:46:30 -0400
From: Doug Ledford <dledford@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, kosaki.motohiro@gmail.com,
        Doug Ledford <dledford@redhat.com>
Subject: [Patch 0/8] Fix POSIX mqueue open issue
Date: Tue, 17 Apr 2012 11:46:17 -0400
Message-Id: <cover.1334676645.git.dledford@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 05:38 PM, Andrew Morton wrote:
> On Wed, 14 Mar 2012 17:28:33 -0400
> Doug Ledford <dledford@redhat.com> wrote:
> 
>> This has obviously fallen through the cracks.
> 
> It sure has.  Please dig out whatever is the currently favored
> patchset, refresh, retest and resend, with changelogging which fully
> covers the reasoning and decision process?

Done.

>> so that if there are any apps out there that have been coded to expect
>> this behavior, then there is a workaround path for them until they get
>> coded
> 
> We'll be especially interested in the implications of this part.

The implications are this.  Since commit b231cca4381 on Oct 18, 2008,
calls to mq_open() that did not pass in an attribute struct and expected
to get default values for the size of the queue and the max message
size now get the system wide maximums instead of hardwired defaults
like they used to get.

This was uncovered when one of the earlier patches in this patch set
increased the default system wide maximums at the same time it increased
the hard ceiling on the system wide maximums (a customer specifically
needed the hard ceiling brought back up, the new ceiling that commit
b231cca4381 introduced was too low for their production systems).  By
increasing the default maximums and not realising they were tied to
any attempt to create a message queue without an attribute struct, I
had inadvertently made it such that all message queue creation attempts
without an attribute struct were failing because the new default
maximums would create a queue that exceeded the default rlimit for
message queue bytes.

As a result, the system wide defaults were brought back down to their
previous levels, and the system wide ceilings on the maximums were
raised to meet the customer's needs.  However, the fact that the
no attribute struct behavior of mq_open() could be broken by changing
the system wide maximums for message queues was seen as fundamentally
broken itself.  So we hardwired the no attribute case back like it
used to be.  But, then we realized that on the very off chance that
some piece of software in the wild depended on that behavior, we
could work around that issue by adding two new knobs to /proc that
allowed setting the defaults for message queues created without an
attr struct separately from the system wide maximums.

What is not an option IMO is to leave the current behavior in place.
No piece of software should ever rely on setting the system wide
maximums in order to get a desired message queue.  Such a reliance
would be so fundamentally multitasking OS unfriendly as to not really
be tolerable.  Fortunately, we don't know of any software in the
wild that uses this except for a regression test program that caught
the issue in the first place.  If there is though, we have made
accommodations with the two new /proc knobs (and that's all the
accommodations such fundamentally broken software can be allowed)..

Doug Ledford (5):
  ipc/mqueue: cleanup definition names and locations
  ipc/mqueue: switch back to using non-max values on create
  ipc/mqueue: enforce hard limits
  ipc/mqueue: update maximums for the mqueue subsystem
  selftests: add mq_open_tests

KOSAKI Motohiro (3):
  mqueue: revert bump up DFLT_*MAX
  mqueue: don't use kmalloc with KMALLOC_MAX_SIZE
  mqueue: separate mqueue default value from maximum value v2

 Documentation/sysctl/fs.txt                    |    7 +
 include/linux/ipc_namespace.h                  |   42 ++-
 ipc/mq_sysctl.c                                |   49 ++--
 ipc/mqueue.c                                   |   26 +-
 tools/testing/selftests/Makefile               |    2 +-
 tools/testing/selftests/mqueue/Makefile        |    8 +
 tools/testing/selftests/mqueue/mq_open_tests.c |  492 ++++++++++++++++++++++++
 7 files changed, 590 insertions(+), 36 deletions(-)
 create mode 100644 tools/testing/selftests/mqueue/Makefile
 create mode 100644 tools/testing/selftests/mqueue/mq_open_tests.c

-- 
1.7.7.6

