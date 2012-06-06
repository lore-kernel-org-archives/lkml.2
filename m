Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2FFNmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:42:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:13922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab2FFNmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:42:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161707228"
Date: Wed, 6 Jun 2012 21:26:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W.Biederman" <ebiederm@xmission.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "David S. Miller" <davem@davemloft.net>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, IngoMolnar <mingo@elte.hu>,
        Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] remove no longer use of pdflush interface
Message-ID: <20120606132621.GA7066@localhost>
References: <1338888372-3555-1-git-send-email-liwp.linux@gmail.com>
 <20120605152845.8b633881.akpm@linux-foundation.org>
 <4FCF0740.1040204@panasas.com>
 <20120606105552.GC10953@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606105552.GC10953@kernel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 06:55:52PM +0800, Wanpeng Li wrote:
> On Wed, Jun 06, 2012 at 10:31:12AM +0300, Boaz Harrosh wrote:
> >
> >If there are many users than a self made print once is worth it
> >we can use the ctl_table->data pointer for this, some thing like:
> >
> >int nr_pdflush_was_printed;
> >
> >@@ -1095,11 +1095,9 @@ static struct ctl_table vm_table[] = {
> > 		.extra1		= &zero,
> > 	},
> > 	{
> >-		.procname	= "nr_pdflush_threads",
> >-		.data		= &nr_pdflush_threads,
> >-		.maxlen		= sizeof nr_pdflush_threads,
> >-		.mode		= 0444 /* read-only*/,
> >-		.proc_handler	= proc_dointvec,
> >+		.data		= &nr_pdflush_was_printed,
> >+		.procname       = "nr_pdflush_threads",
> >+		.mode           = 0444 /* read-only */,
> >+		.proc_handler   = proc_obsolete,
> > 	},
> >
> >
> >+/* notice associated proc deprecated */
> >+int proc_deprecated(struct ctl_table *table, int write,
> >+		    void __user *buffer, size_t *lenp, loff_t *ppos, )
> >+{
> >+	if (*ctl_table->data) {
> >+		printk(KERN_WARNING "%s exported in /proc is deprecated\n",
> >+			table->procname);
> >+		*ctl_table->data = 0;
> >+	}
> >+	return -ENOSYS;
> >+}
> 
> But this time you add another variable nr_pdflush_was_printed. 
> So remove variable nr_pdflush_threads does not make sense.

Yes that's exactly what we want: to warn about current
nr_pdflush_threads users for some releases, then to actually remove
the interface after the warning window passed. This allows potential
users to take action before the scheduled interface removal date.

Thanks,
Fengguang
