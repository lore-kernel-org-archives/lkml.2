Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1DHNaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:30:05 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38971 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab1DHNaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:30:03 -0400
Message-ID: <4D9F0DB9.9040202@parallels.com>
Date: Fri, 8 Apr 2011 08:29:29 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <containers@lists.linux-foundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Tim Spriggs <tims@uahirise.org>, Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 1/3] Add network context to struct nfs_client and make
 NFSv3 use it.
References: <4D94318A.5050202@parallels.com> <20110405025228.GA6764@hallyn.com>
In-Reply-To: <20110405025228.GA6764@hallyn.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.54.86.208]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 09:52 PM, Serge E. Hallyn wrote:
> Quoting Rob Landley (rlandley@parallels.com):
>> From: Rob Landley <rlandley@parallels.com>
>>
>> This patch:
>>
>>   Adds struct net *cl_net to struct nfs_client.
>>   Intializes it from mount process context.
>>   Copies it down through nfs_client_initdata and similar.
>>   Replaces existing init_net uses with cl_net.
>>   Adds net_eq() checks to nfs_match_client() and nfs_compare_super_address().
>>
>> Remount copies the existing network context rather than any associated with
>> the new mount process.  NFSv4 is still using init_net.  Reference counting
>> for struct net follows the struct nfs_client object lifetimes (pinned by
>> task context outside of that).
>>
>> Signed-off-by: Rob Landley <rlandley@parallels.com>
> 
> Sorry for the delay.  Took me two long readings to feel like I've got
> it.
> 
> Acked-by: Serge Hallyn <serge.hallyn@ubuntu.com>
> 
> Do you have any testcases coded up for this?

Not coded up, just stuff I ran from the command line, as described in
the 0/3 patch:

  http://www.spinics.net/lists/linux-nfs/msg20307.html

Here's a blog entry describing the two different types of test cases in
more detail:

  http://landley.livejournal.com/55534.html

The "occlusion" test case (which can only reach an IP address from one
network context because a local interface intercepts it otherwise, and
prevents it from routing out) works fine, and filtering at the NFS
server (giving different source IP addresses different NFS flags, such
as making it read only for one and read/write for another) worked fine
for me too.

The "redirection" test case (where the same IP address routes out from
both contexts, but reaches different destinations) seems to screw up the
Linux arp cache or something, so that the _host_ can no longer access
that address for a bit once the container has done so (and vice versa).
 But that doesn't seem to be an NFS-specific issue, or a new bug I
introduced.  (I'm still working on that one, it's obscure, reproducible,
and confusing.  But these patches don't make it worse, so...)

Rob
