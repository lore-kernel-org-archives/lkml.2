Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1CVBLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 21:11:06 -0400
Received: from smtp-out.google.com ([74.125.121.67]:46067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab1CVBLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 21:11:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=wzQ1p3DphAuw+WCLBwuXyK6/R1wAfwpeoag8HR3hjTifgRQNAmCczPbdXLWCPgX/+
	ThhslR1nQR0L+beHiUZsg==
From: Chad Talbott <ctalbott@google.com>
To: jaxboe@fusionio.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com,
        Chad Talbott <ctalbott@google.com>
Subject: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
Date: Mon, 21 Mar 2011 18:10:42 -0700
Message-Id: <1300756245-12380-1-git-send-email-ctalbott@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces fair cross-group preemption.  Right now, we
don't have strict isolation between processes in different cgroups.
For example: currently an RT ioprio thread in one group can preempt a
BE ioprio thread in another group.  We would like to have an
application specify the relative priorities of its threads, but still
allow strict isolation between applications.

With this patch series, we can configure an entire cgroup as needing
low-latency service.  Then that group will be able to preempt another
group.  To prevent a runaway application from starving other
applications, we allow this preemption only until it has exceeded its
fair share (as specified by its relative weight).  So a rate-limited,
but latency sensative application (like streaming audio or video) can
get front-of-the-line service without fear of it hogging a whole
disk's IO.

Note that this series is targeted to shallow-queue devices (e.g. a
single spinning disk).  Without hardware support, it is much more
difficult to provide low-latency on a device with a deep request
queue.

The following bash script demonstrates the feature:

cd /dev/cgroup
mkdir c1 c2

(
    echo '8:16 900' > c1/blkio.weight_device
    echo '8:16 2' > c1/blkio.class
    echo $BASHPID > c1/tasks
    dd if=/dev/sdb of=/dev/null bs=1M iflag=direct
) & 
(
    echo '8:16 100' > c2/blkio.weight_device
    echo '8:16 1' > c2/blkio.class
    echo $BASHPID > c2/tasks
    while : ; do dd if=/dev/sdb of=/dev/null bs=1M count=1 iflag=direct; sleep .1 ; done
) &
sleep 10
kill %1 %2

grep 8:16 c?/blkio*
# end

Since the c2 reader is "well behaved" and only reads 10MB/s, it will
be able to consistenly preempt c1, and therefore see low latency for
its requests.
