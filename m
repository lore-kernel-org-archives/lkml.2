Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0LPJjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:39:45 -0500
Received: from daytona.panasas.com ([67.152.220.89]:12953 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0LPJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:39:42 -0500
Message-ID: <4D09DE59.8080006@panasas.com>
Date: Thu, 16 Dec 2010 11:39:37 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andreas Dilger <adilger.kernel@dilger.ca>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Julia Lawall <julia@diku.dk>,
        Al Viro <viro@ZenIV.linux.org.uk>, P??draig Brady <P@draigBrady.com>,
        Am??rico Wang <xiyou.wangcong@gmail.com>, wharms@bfs.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca> <20101114092533.GB5323@albatros> <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack> <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca> <4CECECA2.6070301@draigBrady.com> <20101124110535.GD5139@cr0.nay.redhat.com> <4CECFB19.1090003@draigBrady.com> <20101215094953.GG19804@ZenIV.linux.org.uk> <0BAF9CFC-72BF-49A1-93D3-BF60B892389B@dilger.ca> <Pine.LNX.4.64.1012152133010.29684@ask.diku.dk> <1292446368.2603.13.camel@edumazet-laptop> <7F573072-2CA4-4EE9-84AA-4AC6C7013CCA@dilger.ca>
In-Reply-To: <7F573072-2CA4-4EE9-84AA-4AC6C7013CCA@dilger.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Dec 2010 09:39:41.0385 (UTC) FILETIME=[29EAEB90:01CB9D05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 12:19 AM, Andreas Dilger wrote:
> On 2010-12-15, at 13:52, Eric Dumazet wrote:
>> Le mercredi 15 décembre 2010 à 21:33 +0100, Julia Lawall a écrit :
>>> On Wed, 15 Dec 2010, Andreas Dilger wrote:
>>>> I thought my proposed solution was reasonable - add explicit padding fields where there are holes in the structure, which would be unused by the kernel, but since they are defined fields the compiler is obligated to initialize them.
>>>
>>> Is the presence of holes always apparent at the source code level?
>>> Or is it dependent on the compiler or target architecture?
>>

If you let the compiler have the driving sit. But if you take matter
to your own hand, and one should when dealing with external interfaces
that might get accessed from different compilers/languages.

so:
struct export_foo {
	u32 m1;
	u32 padding1;
	u64 m2
	....
} __attribute__((aligned(8),packed))

will make sure that even other compilers/versions will do the same
thing. Also the same rule for on the wire structures.

Just choose the biggest type you have in the structure and
specify that, which will make good code for most cases.

At the end this things depend on if sizeof(long) is 8 or 4

>> It depends on target architecture.
>>
>> This means doing a full review to add a named padding only for arches
>> that need it.
> 
> There are automated tools like "pahole" (IIRC) that will report the presence
> of these structure holes.  However, the memset(0) won't add itself to the code
> either (i.e. it needs an audit to determine if it is needed).
> 

I agree. It is always good practice for public structures to be
considered more delicately. All padding should be spelled out.
Not only for security but for future compatibility and maintenance.

> Cheers, Andreas
> 
> 

Thanks
Boaz
