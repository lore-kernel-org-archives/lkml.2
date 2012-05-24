Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698Ab2EXQUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:20:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933264Ab2EXQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:20:00 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=FyswP2SAAAAA:20 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=ix3PT8lw3aqYbi1l2T8A:9 a=XKTIGbT4SfAn4IUr6JQA:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=gxtKF3TY2Mdg78s8:21 a=6nlwj_kGq7IPqahj:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337876398.13348.178.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Thu, 24 May 2012 12:19:58 -0400
In-Reply-To: <20120524160146.GA6226@redhat.com>
References: <20120524160146.GA6226@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 12:01 -0400, Dave Jones wrote:
> Hit this while trying to configure the irq-tracer.
> I ran cat trace before doing a "echo 0 > tracing_on" by mistake.
> Shot myself in the foot, but it still shouldn't oops.
> 

Hi Dave,

Thanks for reporting. Could you try this patch to see if it fixes it for
you.

http://groups.google.com/group/linux.kernel/msg/4294e8d564d66997?dmode=source

Below is the patch again, as the one in the link has GPG tags that might
screw with patch.

-- Steve


commit 6a31e1f135d1abfb5137697f889c8cd5d72eb522
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed May 23 15:35:17 2012 -0400

    ring-buffer: Check for valid buffer before changing size
    
    On some machines the number of possible CPUS is not the same as the
    number of CPUs that is on the machine. Ftrace uses possible_cpus to
    update the tracing structures but the ring buffer only allocates
    per cpu buffers for online CPUs when they come up.
    
    When the wakeup tracer was enabled in such a case, the ftrace code
    enabled all possible cpu buffers, but the code in ring_buffer_resize()
    did not check to see if the buffer in question was allocated. Since
    boot up CPUs did not match possible CPUs it caused the following
    crash:
    
    BUG: unable to handle kernel NULL pointer dereference at 00000020
    IP: [<c1097851>] ring_buffer_resize+0x16a/0x28d
    *pde = 00000000
    Oops: 0000 [#1] PREEMPT SMP
    Dumping ftrace buffer:
       (ftrace buffer empty)
    Modules linked in: [last unloaded: scsi_wait_scan]
    
    Pid: 1387, comm: bash Not tainted 3.4.0-test+ #13                  /DG965MQ
    EIP: 0060:[<c1097851>] EFLAGS: 00010217 CPU: 0
    EIP is at ring_buffer_resize+0x16a/0x28d
    EAX: f5a14340 EBX: f6026b80 ECX: 00000ff4 EDX: 00000ff3
    ESI: 00000000 EDI: 00000002 EBP: f4275ecc ESP: f4275eb0
     DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
    CR0: 80050033 CR2: 00000020 CR3: 34396000 CR4: 000007d0
    DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
    DR6: ffff0ff0 DR7: 00000400
    Process bash (pid: 1387, ti=f4274000 task=f4380cb0 task.ti=f4274000)
    Stack:
     c109cf9a f6026b98 00000162 00160f68 00000006 00160f68 00000002 f4275ef0
     c109d013 f4275ee8 c123b72a c1c0bf00 c1cc81dc 00000005 f4275f98 00000007
     f4275f70 c109d0c7 7700000e 75656b61 00000070 f5e90900 f5c4e198 00000301
    Call Trace:
     [<c109cf9a>] ? tracing_set_tracer+0x115/0x1e9
     [<c109d013>] tracing_set_tracer+0x18e/0x1e9
     [<c123b72a>] ? _copy_from_user+0x30/0x46
     [<c109d0c7>] tracing_set_trace_write+0x59/0x7f
     [<c10ec01e>] ? fput+0x18/0x1c6
     [<c11f8732>] ? security_file_permission+0x27/0x2b
     [<c10eaacd>] ? rw_verify_area+0xcf/0xf2
     [<c10ec01e>] ? fput+0x18/0x1c6
     [<c109d06e>] ? tracing_set_tracer+0x1e9/0x1e9
     [<c10ead77>] vfs_write+0x8b/0xe3
     [<c10ebead>] ? fget_light+0x30/0x81
     [<c10eaf54>] sys_write+0x42/0x63
     [<c1834fbf>] sysenter_do_call+0x12/0x28
    
    This happens with the latency tracer as the ftrace code updates the
    saved max buffer via its cpumask and not with a global setting.
    
    Adding a check in ring_buffer_resize() to make sure the buffer being resized
    exists, fixes the problem.
    
    Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6420cda..1d0f6a8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1486,6 +1486,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size,
 	if (!buffer)
 		return size;
 
+	/* Make sure the requested buffer exists */
+	if (cpu_id != RING_BUFFER_ALL_CPUS &&
+	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
+		return size;
+
 	size = DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *= BUF_PAGE_SIZE;
 


