Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2HNOfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:35:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:7422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab2HNOfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:35:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,766,1336374000"; 
   d="scan'208";a="180556656"
Message-ID: <502A6248.6090709@intel.com>
Date: Tue, 14 Aug 2012 07:35:52 -0700
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: viro@ZenIV.linux.org.uk, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [net PATCH v2 2/2] net: netprio: fd passed in SCM_RIGHTS datagram
 not set correctly
References: <20120814024320.6983.92222.stgit@jf-dev1-dcblab> <20120814024326.6983.97403.stgit@jf-dev1-dcblab> <20120814125523.GA18731@hmsreliant.think-freely.org>
In-Reply-To: <20120814125523.GA18731@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2012 5:55 AM, Neil Horman wrote:
> On Mon, Aug 13, 2012 at 07:43:27PM -0700, John Fastabend wrote:
>> A socket fd passed in a SCM_RIGHTS datagram was not getting
>> updated with the new tasks cgrp prioidx. This leaves IO on
>> the socket tagged with the old tasks priority.
>>
>> To fix this add a check in the scm recvmsg path to update the
>> sock cgrp prioidx with the new tasks value.
>>
>> Thanks to Al Viro for catching this.
>>
>> CC: Neil Horman <nhorman@tuxdriver.com>
>> Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
>> Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
>> ---
>>

[...]

>> @@ -281,6 +283,9 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>>   		}
>>   		/* Bump the usage count and install the file. */
>>   		get_file(fp[i]);
>> +		sock = sock_from_file(fp[i], &err);
>> +		if (sock)
>> +			sock->sk->sk_cgrp_prioidx = prioidx;
> nit: You can replace the prioidx variable above and this set with a call to
> sock_update_netprioidx
>
> Neil
>

OK but then I should also make sock_update_netprioidx inline and drop
the in_interrupt() call. I'll send a v3 with this change and also a
third patch to fix a race between write_priomap and cgrp_create (also
spotted by Al Viro).

