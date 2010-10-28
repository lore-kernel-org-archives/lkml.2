Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934544Ab0J1VJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:09:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab0J1VJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:09:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2] preempt: fix kernel build with !CONFIG_BKL
Date: Thu, 28 Oct 2010 23:08:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
References: <20101028095910.GA15970@shutemov.name> <201010281612.33732.arnd@arndb.de> <20101028194703.GA19183@shutemov.name>
In-Reply-To: <20101028194703.GA19183@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010282308.55941.arnd@arndb.de>
X-Provags-ID: V02:K0:LcRlJTf+lqFea9fQnq3JgLjR/i+Ny7d0CFkjdYzBlmx
 AAO05aOj+SQfkabrqDD/wbJk+g8hQ/JGqYzv4LyAUx/GQgYZYV
 yLyss9kL4ocg9QGrUGsAW9QtUS6puO3OM+fSA77ycMbvbp6ocR
 HcjsDfmuNHhJAe9hZIA3sq9Dd+34olCMXh6fZKkCMWnoDE5/ZK
 6zv8YapG7SGy10g2kdIvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 October 2010, Kirill A. Shutemov wrote:
> On Thu, Oct 28, 2010 at 04:12:33PM +0200, Arnd Bergmann wrote:
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: Kirill Shutemov <kirill@shutemov.name>
> >
> > > > Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> > > 
> > > Remove quotes, please.
> > 
> > That would make it an invalid email address because of the dot. I left out
> > the middle initial now, if that's better.
> 
> Hm... You are right. But this wasn't a problem before (see git log).
> Let's leave it with quotes.

Git doesn't care. Only if someone uses a tool to extract email addresses
out of git and send you a message, it may confuse the email system.
 
> > 
> > > I've got a lot of __schedule_bug. Log attached.
> > 
> > Ok. I really don't understand the preempt code all that well, let's
> > hope that this one is right.
> > 
> > Thanks for your patience and for your testing!
> 
> It's usable now.

Ok, good!

> I'm not sure if it connected or not:
> 
> [ 6001.589151] INFO: task awesome:26743 blocked for more than 120 seconds.
> [ 6001.589159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 6001.589166] awesome       D 00000555  7040 26743   3789 0x00000000
> [ 6001.589182]  f19afe3c 00000046 5e569d25 00000555 c16ac7c0 f1ae0d40 c16ac7c0 c16ac7c0
> [ 6001.589206]  f1ae0fc0 00000000 c16ac7c0 00000000 00000555 f1ae0d40 f4d46dc0 f19aff00
> [ 6001.589228]  7fffffff f1ae0d40 f19afe9c c1317ea5 00000002 00000001 00000000 c131c57b
> [ 6001.589251] Call Trace:
> [ 6001.589271]  [<c1317ea5>] schedule_timeout+0x27/0xb8
> [ 6001.589284]  [<c131c57b>] ? sub_preempt_count+0x9/0x8e
> [ 6001.589298]  [<c105290d>] ? get_parent_ip+0xb/0x31
> [ 6001.589307]  [<c131c5f3>] ? sub_preempt_count+0x81/0x8e
> [ 6001.589318]  [<c13174d2>] wait_for_common+0xa0/0xef
> [ 6001.589329]  [<c1057c3c>] ? default_wake_function+0x0/0x12
> [ 6001.589339]  [<c13175c0>] wait_for_completion+0x17/0x19
> [ 6001.589352]  [<c109a136>] stop_one_cpu+0x59/0x7f
> [ 6001.589361]  [<c10579e6>] ? migration_cpu_stop+0x0/0x2d
> [ 6001.589373]  [<c1317463>] ? wait_for_common+0x31/0xef
> [ 6001.589384]  [<c1052e69>] sched_exec+0xa7/0xbb
> [ 6001.589395]  [<c1101e09>] do_execve+0xb7/0x24a
> [ 6001.589407]  [<c1030b84>] sys_execve+0x31/0x54
> [ 6001.589418]  [<c102b3ba>] ptregs_execve+0x12/0x18
> [ 6001.589429]  [<c1319d00>] ? syscall_call+0x7/0xb
> [ 6001.589438] 1 lock held by awesome/26743:
> [ 6001.589444]  #0:  (&sig->cred_guard_mutex){......}, at: [<c1100d1e>] prepare_bprm_creds+0x25/0x5a
> 
> I probably saw it previously on pre-2.6.37-rc1 with CONFIG_BKL=y.

No idea. If you saw it with CONFIG_BKL=y, it's probably unrelated. Anyway, I'm off to Boston,
and won't be able to forward the patch in the next two days if we decide it's good.

Could someone who understands the code I pached take care of getting the fix upstream?

	Arnd
