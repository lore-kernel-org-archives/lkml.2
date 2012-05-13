Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2EMJ7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 05:59:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39618 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2EMJ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 05:59:28 -0400
Date: Sun, 13 May 2012 11:59:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] x86/mce: Only restart instruction after machine
 check recovery if it is safe
Message-ID: <20120513095913.GB28863@aftab.osrc.amd.com>
References: <cover.1336674796.git.tony.luck@intel.com>
 <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6fa674d2f4ded80201f733d06b234b21559f0fe.1336674796.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:01:20AM -0700, Tony Luck wrote:
> Section 15.3.1.2 of the software developer manual has this to say about the
> RIPV bit in the IA32_MCG_STATUS register:
> 
>   RIPV (restart IP valid) flag, bit 0 — Indicates (when set) that program
>   execution can be restarted reliably at the instruction pointed to by the
>   instruction pointer pushed on the stack when the machine-check exception
>   is generated.  When clear, the program cannot be reliably restarted at
>   the pushed instruction pointer.
> 
> We need to save the state of this bit in do_machine_check() and use it
> in mce_notify_process() to force a signal; even if memory_failure() says
> it made a complete recovery ... e.g. replaced a clean LRU page).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 66e1c51..3b8ebdc 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -947,9 +947,10 @@ struct mce_info {
>  	atomic_t		inuse;
>  	struct task_struct	*t;
>  	__u64			paddr;
> +	int			restartable;

Is it me or does this look like a flag, or a bitfield? Instead of
wasting a whole integer for a single bit of information.

It will probably end up the same size though due to compiler padding
since this struct is currently 4 + 2*8 byte without the ->restartable
thing.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
