Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1LESJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:09:44 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54726 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624Ab1LESJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:09:42 -0500
Message-ID: <4EDD08D0.9030401@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 23:39:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Woody Suwalski <terraluna977@gmail.com>, Jeff Layton <jlayton@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>, linux-cifs@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, davem@davemloft.net
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
References: <4ED56C12.1040708@gmail.com> <4ED5C047.6040500@linux.vnet.ibm.com> <20111130062502.68d9db59@tlielax.poochiereds.net> <4ED81077.2080305@gmail.com> <4ED8C940.20509@linux.vnet.ibm.com> <20111205174126.GF627@google.com>
In-Reply-To: <20111205174126.GF627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120508-0260-0000-0000-0000002B4D18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 11:11 PM, Tejun Heo wrote:

> Hello, Srivatsa.
> 
> On Fri, Dec 02, 2011 at 06:19:04PM +0530, Srivatsa S. Bhat wrote:
>> So how about solving this problem more fundamentally, such as defining a
>> freezable wrapper over kernel_recvmsg like:
>>
>> #define kernel_recvmsg_freezable(sock, msg, vec, num, size, flags)      \
>> ({                                                                      \
>>         kernel_recvmsg(sock, msg, vec, num, size, flags)                \
>> 	try_to_freeze();                                                \
>> })
>>
>> and using it instead of kernel_recvmsg(), throughout the kernel?
>>
>> But kernel_recvmsg is an exported symbol. So if we are very very unwilling
>> to change the kernel ABI, we could probably think about adding try_to_freeze()
>> inside kernel_recvmsg itself,like this (but see below about my thoughts about
>> which one is better):
> 
> I don't necessarily object to introducing the wrapper but I don't
> really think we should be doing s//g over the source tree without
> understanding where it's actually necessary.  For kernel threads and
> user threads out of the signal delivery path, try_to_freeze() is an
> exceptional event which introduces behavior which can be difficult to
> reproduce track down and spreading it without actually knowing what
> the surrounding code is doing doesn't sound like a good idea to me.
> 


Yeah, I agree. But I remember seeing almost _exactly_ the same code
as CIFS loop in some other place. I'll see if I can track it down and
also understand if it might cause problems. If I find it to be worth it
to use the same solution as above, I'll try adding the wrapper and using
it there. Else, better to keep it as it is, as you mentioned. Thank you.

Regards,
Srivatsa S. Bhat

