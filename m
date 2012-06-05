Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2FEW2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:28:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2FEW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:28:47 -0400
Date: Tue, 5 Jun 2012 15:28:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] remove no longer use of pdflush interface
Message-Id: <20120605152845.8b633881.akpm@linux-foundation.org>
In-Reply-To: <1338888372-3555-1-git-send-email-liwp.linux@gmail.com>
References: <1338888372-3555-1-git-send-email-liwp.linux@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Jun 2012 17:26:11 +0800
Wanpeng Li <liwp.linux@gmail.com> wrote:

> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
> 
> ------------------
> 
> Change in v2:
> 
> * add printk warning
> * add description in Documentation
> 

This is not a changelog.  The patch should be accompanied by text
explaining the reasons for the removal, the back-compatibility issues,
how they were addressed, etc.

I do agree with the intent of the patch and the creation of
proc_deprecated() seems a good idea - something we can use in the
future.

> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1095,11 +1095,9 @@ static struct ctl_table vm_table[] = {
>  		.extra1		= &zero,
>  	},
>  	{
> -		.procname	= "nr_pdflush_threads",
> -		.data		= &nr_pdflush_threads,
> -		.maxlen		= sizeof nr_pdflush_threads,
> -		.mode		= 0444 /* read-only*/,
> -		.proc_handler	= proc_dointvec,
> +		.procname       = "nr_pdflush_threads",
> +		.mode           = 0444 /* read-only */,
> +		.proc_handler   = proc_deprecated,
>  	},
>  	{
>  		.procname	= "swappiness",
> @@ -2505,6 +2503,15 @@ int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int write,
>  
>  #endif /* CONFIG_PROC_SYSCTL */
>  
> +/* notice associated proc deprecated */
> +int proc_deprecated(struct ctl_table *table, int write,
> +		    void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	printk(KERN_WARNING "%s exported in /proc is deprecated\n",
> +			table->procname);
> +	return -ENOSYS;
> +}

I see a couple of things here.

Firstly, I'd change the text from "deprecated" to "is scheduled for
removal".  Which implies that the function should be called
proc_obsolete().


Secondly, this code will permit unprivileged users to flood the logs,
by repeatedly reading /proc/sys/vm/nr_pdflush_threads.  We try to avoid
this, as it is a form of denial-of-service attack.

This is a bit hard to fix.  The typical way of addressing this is to
use printk_once(), so the message only appears once per boot.  But that
doesn't work for a generic function - we'd need to add one bit of state
to the ctl_table to do this.  We can of course do that, but it's not
obvious that it's _worth_ doing that just for handling obsolete
entries.

So perhaps the solution is to give up on the generic proc_obsolete()
idea, and just add a handler specifically for nr_pdflush_threads, whcih
uses printk_once().

