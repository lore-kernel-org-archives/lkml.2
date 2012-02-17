Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2BQI0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 03:26:01 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:31788 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2BQI0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 03:26:00 -0500
Message-ID: <4F3E0F09.8020200@parallels.com>
Date: Fri, 17 Feb 2012 12:25:45 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.26) Gecko/20120131 Lightning/1.0b2 Thunderbird/3.1.18
MIME-Version: 1.0
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH] SUNRPC: connect local transports synchronously
References: <20120216150507.19081.28659.stgit@localhost6.localdomain6> <1329405232.4279.4.camel@lade.trondhjem.org>
In-Reply-To: <1329405232.4279.4.camel@lade.trondhjem.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.02.2012 19:13, Myklebust, Trond пишет:
> On Thu, 2012-02-16 at 19:06 +0400, Stanislav Kinsbursky wrote:
>> Local tranports uses UNIX sockets and connecting of these sockets is done in
>> context of file system namespace (i.e. task file system root).
>> Currenly, all sockets connect operations are performed by rpciod work queue,
>> which actually means, that any service will be registered in the same rpcbind
>> instance regardless to process file system root.
>> This is not containers, which usually have it's own nested root. There are 2
>> approaches, how to solve the problem. First one is to store proper root in
>> tranport and switch to it in rpciod workqueue function for connect operations.
>> But this looks ugly. The second one is to connect to unix sockets
>> synchronously. This aptch implements the last one.
>
> That approach can fall afoul of the selinux restrictions on the process
> context. Processes that are allowed to write data, may not be allowed to
> create sockets or call connect(). That is the main reason for doing it
> in the rpciod context, which is a clean kernel process context.
>

Thanks for explanation, Trond.
So, this connect have to be done in kernel process context.
Now I can see 2 ways how to meet this requirement and reach the goal:

1) Change the fs root for rpciod while connecting.
2) Do not touch rpciod and launch special "connect" kernel thread to perform 
connect operations for unix sockets.

What do you think about this 2 ways above? Which one is less worse from your POW?
Maybe you have even a better solution for the problem?

-- 
Best regards,
Stanislav Kinsbursky
