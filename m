Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1KKKCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:02:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22164 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1KKKCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:02:10 -0500
Message-ID: <4EBCF299.9020905@parallels.com>
Date: Fri, 11 Nov 2011 14:02:01 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/3] pids: Make alloc_pid return error
References: <4EBC0696.9030103@parallels.com> <4EBC06B3.2000802@parallels.com> <20111110180021.GA31156@redhat.com>
In-Reply-To: <20111110180021.GA31156@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 10:00 PM, Oleg Nesterov wrote:
> On 11/10, Pavel Emelyanov wrote:
>>
>> @@ -281,7 +281,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>>  {
>>  	struct pid *pid;
>>  	enum pid_type type;
>> -	int i, nr;
>> +	int i, nr = -ENOMEM;
>>  	struct pid_namespace *tmp;
>>  	struct upid *upid;
> 
> This doesn't look right at first glance... I mean, if
> the first kmem_cache_alloc(ns->pid_cachep) fails, this -ENOMEM
> won't be returned as ERR_PTR().

Yikes! Will fix, thanks!

>> @@ -321,7 +321,7 @@ out_free:
>>  		free_pidmap(pid->numbers + i);
>>
>>  	kmem_cache_free(ns->pid_cachep, pid);
>> -	pid = NULL;
>> +	pid = ERR_PTR(nr);
>>  	goto out;
> 
> Off-topic, but with or withoit this patch this "goto out" looks
> strange imho. Why not a simple
> 
> 	-	pid = NULL;
> 	-	goto out;
> 	+	return ERR_PTR(nr);
> 
> instead? But this is minor and subjective, I won't insist.

Hm... OK, I will brush up the error paths a little bit more :)

> Oleg.
> 
> .
> 

