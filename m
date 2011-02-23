Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1BWDGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:06:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1BWDGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:06:49 -0500
Message-ID: <4D6479E8.3030800@cn.fujitsu.com>
Date: Wed, 23 Feb 2011 11:07:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 14/14] rcu: Add boosting to TREE_PREEMPT_RCU
 tracing
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-14-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1298425183-21265-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 11:05:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 11:05:45,
	Serialize complete at 2011-02-23 11:05:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
>  	rcudir = debugfs_create_dir("rcu", NULL);
> -	if (!rcudir)
> +	if (IS_ERR_VALUE(rcudir))
>  		goto free_out;

if !defined(CONFIG_DEBUG_FS)
	debugfs_create_xxx() returns ERR_PTR(-ENODEV);
else
	debugfs_create_xxx() returns NULL when failed.

Since TREE_RCU_TRACE selects DEBUG_FS, "if (!rcudir)" is correct,
we don't need to change it.

>  
>  	retval = debugfs_create_file("rcudata", 0444, rcudir,
>  						NULL, &rcudata_fops);
> -	if (!retval)
> +	if (IS_ERR_VALUE(retval))
>  		goto free_out;
>  
>  	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
>  						NULL, &rcudata_csv_fops);
> -	if (!retval)
> +	if (IS_ERR_VALUE(retval))
> +		goto free_out;
> +
> +	retval = rcu_boost_trace_create_file(rcudir);
> +	if (retval)
>  		goto free_out;
>  
>  	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
> -	if (!retval)
> +	if (IS_ERR_VALUE(retval))
>  		goto free_out;
>  
>  	retval = debugfs_create_file("rcuhier", 0444, rcudir,
>  						NULL, &rcuhier_fops);
> -	if (!retval)
> +	if (IS_ERR_VALUE(retval))
>  		goto free_out;
>  
>  	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
>  						NULL, &rcu_pending_fops);
> -	if (!retval)
> +	if (IS_ERR_VALUE(retval))
>  		goto free_out;
>  	return 0;
>  free_out:

