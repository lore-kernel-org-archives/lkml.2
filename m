Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2A2XMB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 18:12:01 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19112 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2A2XMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 18:12:00 -0500
X-SpamScore: -9
X-BigFish: PS-9(zz1dbaL1418Mzz1202hzzz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT002.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F25CEB5.8070704@ixiacom.com>
Date: Sun, 29 Jan 2012 14:56:53 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in
 procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org> <4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org> <4F1D8F37.6020806@ixiacom.com>
In-Reply-To: <4F1D8F37.6020806@ixiacom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT002.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT002.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are interested in fixing this properly with a tiny buffer
> reachable from struct file I think this can be worth fixing.  I think
> this is doable by using seq_file in proc_sys_read.

I've looked into making proc_sys_read() use seq_file, but there are a few
issues to work through.

I'm assuming that the existing kernel modules must continue to use the
ctl_table/proc_dointvec/etc interface without requiring patching.

The two main consequences of this are:

a. The existing struct ctl_table interface should be preserved.
   Kernel modules use this to publish into procfs.

b. The existing proc_dointvec(), etc, functions must be preserved
   because they are exported via EXPORT_SYMBOL. Kernel modules
   may rely on these symbols in arbitrary ways.

I tried use seq_file in proc_sys_read, and it comes close to solving
the problem. The issue is that proc_dointvec() requires a __user pointer.

A seq_file has an internal buffer that could be filled by proc_dointvec() -- but that
seq_file buffer is in kernel space.

This is not a problem isolated to the seq_file implementation. I think that
any approach involving a small local buffer would mean that that buffer is
in kernel space, and that buffer cannot be passed to proc_dointvec() as it
stands now because proc_dointvec() requires a __user buffer.


One approach that might work is to add a new field to struct ctl_table :

struct ctl_table
{
	...
	proc_seq_handler *proc_seq_handler;
};

Existing modules can continue to use proc_dointvec() etc and fixed
code can use the new proc_seq_handler interface using the new
proc_seq_dointvec() etc.


Although this preserves the old interface, it seems to me that this
approach is flawed in that kernel modules using struct ctl_table and proc_dointvec()
continue to be broken -- they are not fixed.


So, perhaps breaking assumption (b) might be a reasonable thing to do ?

If we accept that proc_dointvec() etc are only or mainly used in the
context of filling out struct ctl_table, and that other kernel modules
don't use proc_dointvec() in other contexts, then we can change the
call signature of proc_dointvec() to stop using a __user pointer:

1. Change signature of proc_dointvec() etc to stop using __user pointer for reads
2. Change definition of typedef proc_call_handler to stop using __user pointer for reads
3. In kernel/sysctl.c don't use copy_to_user() for reads

Then proc_sys_read() can use proc_dointvec() etc to fill seq_file.


For writes, the existing behaviour needs to be preserved. One approach
that would solve this would be to add:

	union proc_buffer {
		void __user *uptr;
		void *kptr;
	};

	typedef int proc_handler (struct ctl_table *ctl, int write,
                          union proc_buffer buffer, size_t *lenp, loff_t *ppos);

I think this would be preferable to either casting away __user for reads, or
adding two pointers to the proc_handler signature (one with __user, one without).

If write is indicated, use buffer.uptr, and if not the handlers would use buffer.kptr.


But this is not perfect.  Kernel modules containing their _own_ proc_handler
definitions would now be broken severely.


And now I circle back to the proc_seq_handler approach.  Each ctl_table client
must be fixed individually (ie switch from proc_handler to proc_seq_handler).


What do you think ?


Earl

