Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0IAImg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 04:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274Ab0IAIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 04:42:34 -0400
Message-ID: <4C7E11E5.1040402@redhat.com>
Date: Wed, 01 Sep 2010 11:42:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
CC: kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ftrace/perf_event leak
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  I recently added perf_event support to kvm_stat, to display kvm 
tracepoints as statistics (I'd like to fold this to tools/perf 
eventually, but that's another story).  However I'm seeing a resource 
leak - after I quit the tool, there are quite a few references into the 
kvm module:

   kvm_intel              43655  0
   kvm                   272984  269 kvm_intel

The tool is just a python script that reads 
/sys/kernel/debug/tracing/events/kvm to find out which events are 
available, uses perf_event_open() to create one group per cpu to which a 
lot of events are attached.  The only special thing I can think of is 
that we use an ioctl to attach a filter to many perf_event descriptors.

You can find the source at 
http://git.kernel.org/?p=virt/kvm/qemu-kvm.git;a=blob_plain;f=kvm/kvm_stat;hb=5bd5f131b50cb373ff4e2a3632c6dad00a1f0b55.  
All it needs are the kvm modules loaded; no need to actually run a 
guest.  Run as root.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

