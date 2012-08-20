Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2HTKSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 06:18:37 -0400
Received: from relay.parallels.com ([195.214.232.42]:43738 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2HTKSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 06:18:34 -0400
Message-ID: <50320EE5.10307@parallels.com>
Date: Mon, 20 Aug 2012 14:18:13 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "bfields@redhat.com" <bfields@redhat.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH 0/5] net: socket bind to file descriptor introduced
References: <20120815161141.7598.16682.stgit@localhost.localdomain> <87y5lf7d37.fsf@xmission.com>
In-Reply-To: <87y5lf7d37.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16.08.2012 07:03, Eric W. Biederman пишет:
> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
>
>> This patch set introduces new socket operation and new system call:
>> sys_fbind(), which allows to bind socket to opened file.
>> File to bind to can be created by sys_mknod(S_IFSOCK) and opened by
>> open(O_PATH).
>>
>> This system call is especially required for UNIX sockets, which has name
>> lenght limitation.
>>
>> The following series implements...
>
> Hmm.  I just realized this patchset is even sillier than I thought.
>
> Stanislav is the problem you are ultimately trying to solve nfs clients
> in a container connecting to the wrong user space rpciod?
>

Hi, Eric.
The problem you mentioned was the reason why I started to think about this.
But currently I believe, that limitations in unix sockets connect or bind should 
be removed, because it will be useful it least for CRIU project.

> Aka net/sunrpc/xprtsock.c:xs_setup_local only taking an absolute path
> and then creating a delayed work item to actually open the unix domain
> socket?
>
> The straight correct and straight forward thing to do appears to be:
> - Capture the root from current->fs in xs_setup_local.
> - In xs_local_finish_connect change current->fs.root to the captured
>    version of root before kernel_connect, and restore current->fs.root
>    after kernel_connect.
>
> It might not be a bad idea to implement open on unix domain sockets in
> a filesystem as create(AF_LOCAL)+connect() which would allow you to
> replace __sock_create + kernel_connect with a simple file_open_root.
>

I like the idea of introducing new family (AF_LOCAL_AT for example) and new 
sockaddr for connecting or binding from specified root. The only thing I'm 
worrying is passing file descriptor to unix bind or connect routine. Because 
this approach doesn't provide easy way to use such family and sockaddr in kernel 
(like in NFS example).

> But I think the simple scheme of:
> struct path old_root;
> old_root = current->fs.root;
> kernel_connect(...);
> current->fs.root = old_root;
>
> Is more than sufficient and will remove the need for anything
> except a purely local change to get nfs clients to connect from
> containers.
>

That was my first idea. And probably it would be worth to change all fs_struct 
to support sockets with relative path.
What do you think about it?

> Eric
>


-- 
Best regards,
Stanislav Kinsbursky
