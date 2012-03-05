Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2CERtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:49:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:56896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab2CERts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:49:48 -0500
Message-ID: <1330969747.11248.250.camel@twins>
Subject: Re: [PATCH v2 x86 1/2]  fix page faults by nmiaction in nmi if
 kmemcheck is enabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, Vegard Nossum <vegardno@ifi.uio.no>,
        Don Zickus <dzickus@redhat.com>, tony.luck@intel.com, bp@amd64.org,
        robert.richter@amd.com, lenb@kernel.org, minyard@acm.org,
        wim@iguana.be, linux-edac@vger.kernel.org, oprofile-list@lists.sf.net,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        linux-watchdog@vger.kernel.org
Date: Mon, 05 Mar 2012 18:49:07 +0100
In-Reply-To: <1330941917.24353.63.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329735648.2293.307.camel@twins> <1329788560.3448.45.camel@ThinkPad-T61>
	 <1329819437.2293.382.camel@twins> <1329990828.19165.36.camel@ThinkPad-T61>
	 <1330340324.11248.60.camel@twins> <1330941917.24353.63.camel@ThinkPad-T61>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 18:05 +0800, Li Zhong wrote:
> +static struct nmiaction arch_trigger_all_cpu_bt_nmiaction = {
> +       .handler        = arch_trigger_all_cpu_backtrace_handler,
> +       .name           = "arch_bt",
> +};
> +
>  static int __init register_trigger_all_cpu_backtrace(void)
>  {
> -       register_nmi_handler(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler,
> -                               0, "arch_bt");
> +       register_nmi_handler(NMI_LOCAL, &arch_trigger_all_cpu_bt_nmiaction);
>         return 0;
>  } 

If you look at things like cpu_notifier() you can shorten this still:

#define nmi_notifier(t, fn, n)				\
do {							\
	static struct nmiaction fn##_na = {		\
		.handler = (fn),			\
		.name = (n),				\
	};						\
	register_nmi_handler((t), &fn##_na);		\
} while (0)

The whole thing then becomes:

  nmi_notifier(NMI_LOCAL, arch_trigger_all_cpu_backtrace_handler, "arch_bt");


