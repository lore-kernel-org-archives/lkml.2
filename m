Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2EVMxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2EVMxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:53:50 -0400
Message-ID: <4FBB8C40.6080304@redhat.com>
Date: Tue, 22 May 2012 15:53:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: NMI vs #PF clash
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes to NMI allow exceptions to take place in NMI
handlers, but I think that a #PF (say, due to access to vmalloc space)
is still problematic.  Consider the sequence

  #PF  (cr2 set by processor)
    NMI
      ...
      #PF (cr2 clobbered)
        do_page_fault()
        IRET
      ...
      IRET
    do_page_fault()
      address = read_cr2()
 
The last line reads the overwritten cr2 value.

I vaguely remember some discussion about this back in the day, but I
can't find anything in the code to save/restore cr2 in the NMI handler. 
Did I miss it?  Or perhaps the page fault handler ignores the incorrect
cr2 and IRETs, to fault back immediately?

-- 
error compiling committee.c: too many arguments to function

