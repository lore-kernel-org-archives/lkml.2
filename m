Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2AEPQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:16:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2AEPP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:15:58 -0500
Date: Thu, 5 Jan 2012 16:10:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Chris Yeoh <yeohc@au1.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: cross memory attach && security check
Message-ID: <20120105151012.GA25671@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just noticed the new file in mm/ ;) A couple of questions.

process_vm_rw_core() does

	task_lock(task);
	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
		task_unlock(task);
		rc = -EPERM;
		goto put_task_struct;
	}
	mm = task->mm;

this is racy, task_lock() can't help. And I don't think you should
use it directly.

execve() does exec_mmap() first, this switches to the new ->mm.
After that install_exec_creds() changes task->cred. The window
is not that small.

I guess you need ->cred_guard_mutex, please look at mm_for_maps().




Another question, process_vm_rw_pages() does get_user_pages() without
FOLL_FORCE. Is this on purpose? This limits the usage of the new
syscalls.




Hmm. And could you please explain the change in rw_copy_check_uvector()?
Why process_vm_rw() does
rw_copy_check_uvector(READ, rvec, check_access => 0) ?

Oleg.

