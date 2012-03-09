Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2CIKTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:19:12 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38012 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2CIKTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:19:10 -0500
Message-ID: <1331287938.13274.38.camel@ThinkPad-T420>
Subject: Re: [PATCH v2] x86,nmi: Fix page faults by nmiaction if kmemcheck
 is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Mar 2012 05:12:18 -0500
In-Reply-To: <1331240549-13120-1-git-send-email-dzickus@redhat.com>
References: <1331240549-13120-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12030910-8878-0000-0000-0000019882E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 16:02 -0500, Don Zickus wrote:
> From: Li Zhong <zhong@linux.vnet.ibm.com>
> 
> This patch tries to fix the problem of page fault exception caused by
> accessing nmiaction structure in nmi if kmemcheck is enabled.
> 
> If kmemcheck is enabled, the memory allocated through slab are in pages
> that are marked non-present, so that some checks could be done in the
> page fault handling code ( e.g. whether the memory is read before
> written to ).
> As nmiaction is allocated in this way, so it resides in a non-present
> page. Then there is a page fault while the nmi code accessing the
> nmiaction structure, which would then cause a warning by
> WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().
> 
> v2: as Peter suggested, changed the nmiaction to use static storage.
> 
> v3: as Peter suggested, use macro to shorten the codes. Also keep the
> original usage of register_nmi_handler, so users of this call doesn't
> need change.
> 
> [simplified wrappers -dcz]
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  arch/x86/include/asm/nmi.h |   20 ++++++++++++-
>  arch/x86/kernel/nmi.c      |   65 ++++---------------------------------------
>  2 files changed, 24 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index fd3f9f1..2a17e57 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -35,8 +35,24 @@ enum {
> 
>  typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
> 
> -int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
> -			 const char *);
> +struct nmiaction {
> +	struct list_head list;
> +	nmi_handler_t handler;
> +	unsigned int flags;
> +	const char *name;
> +};
> +
> +#define register_nmi_handler(t, fn, fg, n)		\
> +({							\
> +	static struct nmiaction fn##_na = {		\
> +		.handler = (fn),			\
> +		.name = (n),				\
> +		.flags = (fg),				\
> +	};						\
> +	__register_nmi_handler((t), &fn##_na);	\
> +})

Thank you, Don. 

As flags is moved into the macro, it may cause following compile error, 
drivers/watchdog/hpwdt.c: In function 'hpwdt_init_nmi_decoding':
drivers/watchdog/hpwdt.c:737: error: initializer element is not constant
drivers/watchdog/hpwdt.c:737: error: (near initialization for
'hpwdt_pretimeout_na.flags')

So following fix might be needed: 

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 3c166d3..e1161ea 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -734,9 +734,12 @@ static int __devinit hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	 * die notify list to handle a critical NMI. The default is to
 	 * be last so other users of the NMI signal can function.
 	 */
-	retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
-					(priority) ? NMI_FLAG_FIRST : 0,
-					"hpwdt");
+	if (priority)
+		retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
+					NMI_FLAG_FIRST, "hpwdt");
+	else
+		retval = register_nmi_handler(NMI_UNKNOWN, hpwdt_pretimeout,
+					0, "hpwdt");
 	if (retval != 0) {
 		dev_warn(&dev->dev,
 			"Unable to register a die notifier (err=%d).\n",


