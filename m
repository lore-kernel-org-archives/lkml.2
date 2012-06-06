Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2FFJc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:32:29 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:43640 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFJc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:32:26 -0400
Date: Wed, 6 Jun 2012 17:32:14 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Rob Landley <rob@landley.net>,
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
Message-ID: <20120606093213.GB10953@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1338888372-3555-1-git-send-email-liwp.linux@gmail.com>
 <20120605152845.8b633881.akpm@linux-foundation.org>
 <4FCF0740.1040204@panasas.com>
 <4FCF08BE.3040801@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCF08BE.3040801@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 10:37:34AM +0300, Boaz Harrosh wrote:
>On 06/06/2012 10:31 AM, Boaz Harrosh wrote:
>
>> On 06/06/2012 01:28 AM, Andrew Morton wrote:
>> 
>>> On Tue,  5 Jun 2012 17:26:11 +0800
>>> Wanpeng Li <liwp.linux@gmail.com> wrote:
>>>
>>> So perhaps the solution is to give up on the generic proc_obsolete()
>>> idea, and just add a handler specifically for nr_pdflush_threads, whcih
>>> uses printk_once().
>>>
>> 
>> 
>> If there are many users than a self made print once is worth it
>> we can use the ctl_table->data pointer for this, some thing like:
>> 
>> int nr_pdflush_was_printed;
>> 
>> @@ -1095,11 +1095,9 @@ static struct ctl_table vm_table[] = {
>>  		.extra1		= &zero,
>>  	},
>>  	{
>> -		.procname	= "nr_pdflush_threads",
>> -		.data		= &nr_pdflush_threads,
>> -		.maxlen		= sizeof nr_pdflush_threads,
>> -		.mode		= 0444 /* read-only*/,
>> -		.proc_handler	= proc_dointvec,
>> +		.data		= &nr_pdflush_was_printed,
>> +		.procname       = "nr_pdflush_threads",
>> +		.mode           = 0444 /* read-only */,
>> +		.proc_handler   = proc_obsolete,
>>  	},
>> 
>> 
>> +/* notice associated proc deprecated */
>> +int proc_deprecated(struct ctl_table *table, int write,
>> +		    void __user *buffer, size_t *lenp, loff_t *ppos, )
>> +{
>> +	if (*ctl_table->data) {
>
>
>+	if(!*ctl_table->data) {
    if(!*table->data) {
>
>> +		printk(KERN_WARNING "%s exported in /proc is deprecated\n",
>> +			table->procname);
>> +		*ctl_table->data = 0;
>
>
>+		*ctl_table->data = 1;
        *table->data = 1;

Regards,
Wanpeng Li

>
>stupid me, time for coffee
>
>Boaz
>
>> +	}
>> +	return -ENOSYS;
>> +}
>
>
