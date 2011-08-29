Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1H2Rfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:35:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1H2Rff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:35:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:date:message-id:subject:from:to:
	content-type:x-system-of-record;
	b=QFoN6j+tK/ohb3iegvB+6XBImC4rGUpNC82w3bT4quVFl6dwxG+1GPJ2PfkKutth2
	JmWL+oo9FrN2cKb/t7Ecw==
MIME-Version: 1.0
Date: Mon, 29 Aug 2011 10:33:24 -0700
Message-ID: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
Subject: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linux AIO interface (io_submit, io_getevents, etc) is useful in
allowing multiple requests to through the I/O stack without requiring
a userspace or even kernel thread per pending request. This is really
great for maxing out high-performance devices like SSDs. However, it
seems incomplete to me because io_submit sometimes blocks for a couple
filesystem-related reasons. I'm wondering if this could be fixed, or
if there is an inherent need for this sort of blocking.

- Blocking due to reading metadata.
Proposed solution:
Add a per-ioctx work queue to do metadata reads. It will be triggered
from the dio code: if in async mode, then get_block will be called
with an additional flag, meaning something like O_NONBLOCK on sockets.
File systems' get_block functions can implement this flag and return
-EAGAIN if a read from the underlying device would be necessary. (If
we're worried that EAGAIN might be used for other purposes in the
future, we could make a new errno for this purpose.) From a quick
glance at the code, it looks like this would not be too difficult to
add to ext4 for extent-based files, and support in other file systems
could be added gradually. If -EAGAIN is returned, then the struct dio
will be put on the work queue together with a description of what kind
of processing it was doing. The work queue only serves the metadata
request, and the rest of the request is served on the existing path.

- Blocking for appends and writes to file holes due to the need for a
metadata write after the data write
Proposed solution:
Maintain a work queue for all appends and writes to file holes, which
executes the current code.

Has anything like this been discussed or implemented? What I'm talking
about isn't optimal in terms of parallelism; it just matches the
parallelism of the current approach (with the minor caveat that
multiple threads on the same core calling io_submit on the same ioctx
don't get to run their metadata/append I/O requests concurrently), but
allows the io_submit system call to return to userspace much faster.
I've read about other proposals for general asynchronous syscalls, but
this would be lighter weight in not requiring a kernel task per I/O
request.

Thanks,
Dan
