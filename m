Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1KJRgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:36:13 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:13279 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1KJRgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:36:12 -0500
Message-ID: <4EBC0B87.1030305@parallels.com>
Date: Thu, 10 Nov 2011 21:36:07 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110173009.GH27258@google.com>
In-Reply-To: <20111110173009.GH27258@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 09:30 PM, Tejun Heo wrote:
> Hello, Pavel.
> 
>>  	for (i = ns->level; i >= 0; i--) {
>> -		nr = alloc_pidmap(tmp);
>> +		nr = 0;
>> +		if (unlikely(want_pids != NULL)) {
>> +			if (get_user(nr, want_pids)) {
>> +				nr = -EFAULT;
>> +				goto out_free;
>> +			}
>> +
>> +			if (nr != 0) {
>> +				want_pids++;
>> +				nr = set_pidmap(tmp, nr);
>> +			} else
>> +				want_pids = NULL; /* optimize above */
>> +		}
>> +		if (nr == 0)
>> +			nr = alloc_pidmap(tmp);
> 
> Hmmm... is it necessary to be able to replicate pids on all
> namespaces? 

Not for us (I mean OpenVZ). But since we should (in theory) be able to
recreate the nested set of namespaces it would be good if the API allows
for this from the very beginning.

> Also, isn't it a bit weird to be able to request PIDs in
> the namespaces which is beyond the task which requested cloning?

It is, but the last_pid != 0 check will abort this request with EPERM :)
Do you think some other behavior would be better?

> Thanks.

Thanks,
Pavel
