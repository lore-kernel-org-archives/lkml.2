Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0JCNoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 09:44:10 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49349 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0JCNoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 09:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=DJlXhLhTIXhlPFtuIfCVoImPbHNGwjLHXwOGqqf1w/uNzN/9BKta7KoJjkBXMB4hcg
         kPhwsjf+qYEWRzcSuFgvd+D6eUGRbG5lupVg7f1gXCtqoLk7hH1U8RZD0emoZ3hLX4rq
         79Ygc/CqtiAy0iz24N4QLSAfj0MILywGhSRZ4=
Subject: Re: [PATCH 8/8] net: Implement socketat.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <4CA7A07C.5030504@free.fr>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com>
	 <1285240797.5036.5.camel@bigi>  <4C9B3B06.900@parallels.com>
	 <1285242055.5036.9.camel@bigi> <4C9B3F9C.8080506@parallels.com>
	 <4CA7A07C.5030504@free.fr>
Content-Type: text/plain
Date: Sun, 03 Oct 2010 09:44:01 -0400
Message-Id: <1286113441.3812.229.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Thanks for clarifying this ..

On Sat, 2010-10-02 at 23:13 +0200, Daniel Lezcano wrote:
> Just to clarify this point. You enter the namespace, create the socket
> and go back to the initial namespace (or create a new one). Further 
> operations can be made against this fd because it is the network 
> namespace stored in the sock struct which is used, not the current 
> process network namespace which is used at the socket creation only.
> 
> We can actually already do that by unsharing and then create a
> socket. 
> This socket will pin the namespace and can be used as a control socket
> for the namespace (assuming the socket domain will be ok for all the 
> operations).
>
> Jamal, I don't know what kind of application you want to use but if I 
> assume you want to create a process controlling 1024 netns, 

At the moment i am looking at 8K on a Nehalem with lots of RAM. They
will mostly be created at startup but some could be created afterwards.
Each will have its own netdevs etc. also created at startup (and some
other config that may happen later). 
Because startup time may accumulate, it is clearly important to me
to pick whatever scheme that reduces the number of calls...

> let's try to identificate what happen with setns and with socketat :
> 
> With setns:
> 
>      * open /proc/self/ns/net (1)
>      * unshare the netns
>      * open /proc/self/ns/net (2)
>      * setns (1)
>      * create a virtual network device
>      * move the virtual device to (2) (using the set netns by fd)
>      * unshare the netns
>      ...
> 
> With socketat:
> 
>      * open a socket (1)
>      * unshare the netns
>      * open a netlink with socketat(1) => (2)
>      * create a virtual device using (2) (at this point it is
> init_net_ns)
>      * move the virtual device to the current netns (using the set
> netns 
> by pid)
>      * open a socket (3)
>      * unshare the netns
>      ...
> 
> We have the same number of file descriptors kept opened. Except, with 
> setns we can bind mount the directory somewhere, that will pin the 
> namespace and then we can close the /proc/self/ns/net file descriptors
> and reopen them later.
> 

Ok, so a wrapper such as: create_socket_on(namespaceid)
will have generally less system calls with socketat()

> If your application has to do a lot of specific network processing, 
> during its life cycle, in different namespaces, the socketat syscall 
> will be better because it will reduce the number of syscalls but at
> the cost of keeping the file descriptors opened (potentially a big
> number). Otherwise, setns should fit your needs.

Makes sense. 

One thing still confuses me...
The app control point is in namespace0. I still want to be able to
"boot" namespaces first and maybe a few seconds later do a socketat()...
and create devices, tcp sockets etc. I suspect create_ns(namespace-name)
would involve:
     * open /proc/self/ns/net (namespace-name)
     * unshare the netns
Is this correct?

cheers,
jamal

