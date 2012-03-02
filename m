Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2CBJWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:22:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab2CBJWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:22:36 -0500
Message-ID: <4F509150.5060904@redhat.com>
Date: Fri, 02 Mar 2012 17:22:24 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Glauber Costa <glommer@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCHv 2] tcp: properly initialize tcp memory limits part 2
 (fix nfs regression)
References: <1330675173-18968-1-git-send-email-slyich@gmail.com>
In-Reply-To: <1330675173-18968-1-git-send-email-slyich@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 03:59 PM, Sergei Trofimovich wrote:
> From: Sergei Trofimovich<slyfox@gentoo.org>
>
> The commit c43b874d5d7 introduced NFS file transfer hangup (proved by bisection).
>> Commit 4acb4190 tries to fix the using uninitialized value
>> introduced by commit 3dc43e3,  but it would make the
>> per-socket memory limits too small.
>>
>> This patch fixes this and also remove the redundant codes
>> introduced in 4acb4190.
> The change looks like a typo (division flipped to multiplication):
>> limit = nr_free_buffer_pages() / 8;
>> limit = nr_free_buffer_pages()<<  (PAGE_SHIFT - 10);

Hi, thanks for the reporting. It's not a typo. It was previously: 
sysctl_tcp_mem[1] << (PAGE_SHIFT -  7). Looks like we need to do the 
limit check before shift the value. Please try the following patch, thanks.

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 22ef5f9..4035aab 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3299,8 +3299,8 @@ void __init tcp_init(void)

         tcp_init_mem(&init_net);
         /* Set per-socket limits to no more than 1/128 the pressure 
threshold */
-       limit = nr_free_buffer_pages() << (PAGE_SHIFT - 10);
-       limit = max(limit, 128UL);
+       limit = nr_free_buffer_pages() / 8;
+       limit = max(limit, 128UL) << (PAGE_SHIFT - 7);
         max_share = min(4UL*1024*1024, limit);

         sysctl_tcp_wmem[0] = SK_MEM_QUANTUM;


