Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab1FWLf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:35:29 -0400
Received: from ix03.ka.hist.no ([158.38.48.167]:49738 "EHLO ix03.ka.hist.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256Ab1FWLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:35:27 -0400
Message-ID: <4E0322B0.8030102@hist.no>
Date: Thu, 23 Jun 2011 13:25:36 +0200
From: Helge Hafting <helge.hafting@hist.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110606 Icedove/3.1.10
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Suresh Jayaraman <sjayaraman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
References: <4DE6103E.6010100@hist.no>	<4DE8B449.2000008@suse.de>	<4DE8F989.50208@hist.no>	<20110609182845.1ebfc678@tlielax.poochiereds.net> <20110622163612.45744bc2@tlielax.poochiereds.net>
In-Reply-To: <20110622163612.45744bc2@tlielax.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2011 11:25:36.0936 (UTC) FILETIME=[4631CA80:01CC3198]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22. juni 2011 22:36, Jeff Layton wrote:
> On Thu, 9 Jun 2011 18:28:45 -0400
> Jeff Layton<jlayton@redhat.com>  wrote:
>
>> On Fri, 03 Jun 2011 17:11:05 +0200
>> Helge Hafting<helge.hafting@hist.no>  wrote:
>>
>>> On 03. juni 2011 12:15, Suresh Jayaraman wrote:
>>>> [Cc linux-cifs@vger.kernel.org]
>>>>
>>>> On 06/01/2011 03:41 PM, Helge Hafting wrote:
>>>>> At work I use cifs for accessing a windows server. This has worked fine
>>>>> for a long time, up to and including Debian's 2.6.38-2.
>>>>>
>>>>> I just installed Debians's 2.6.39-1, and had to give up on it.
>>>>> Mounting CIFS works, and I can see the files. But if I
>>>>> try to make a new file (with cp), I get a long delay.
>>>>
>>>> What is the security mechanism you are using? If you seeing the problem
>>>> with ntlm, could you try using ntlmv2 and see whether the problem is
>>>> reproducible?
>>>
>>> In the beginning, I did not specify the mechanism. So, whatever the
>>> default is.
>>>
>>> The fstab entry was like this:
>>> \\servername\resource /mountpoint cifs
>>> domain=MYDOMAIN,credentials=/etc/fstabcred,rw,noauto,iocharset=utf8,uid=username,gid=group,sockopt=TCP_NODELAY,users,file_mode=0640,dir_mode=0750,relatime
>>> 0 0
>>>
>>> I looked at cifs options, and tried to add "sign" and "sec=ntlmv2i". It
>>> made no difference. Still failure with 2.6.39, and mounting with these
>>> new options works fine with 2.6.38
>>>
>>
>> I think we need to understand what's happening on the wire. Are you
>> still able to reproduce this? If so, can you turn up debug logging and
>> reproduce this?. Instructions for how to do that are here:
>>
>>      http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
>>
>> Also, it looks like someone opened a bug at kernel.org too:
>>
>>      https://bugzilla.kernel.org/show_bug.cgi?id=36952
>>
>> ...so if you can attach the resulting log there, that would be great.
>>
>
> I think that this is probably due to the change that added the
> page_mkwrite function to cifs.ko. Prior to that, cifs did single-page
> writes on signed connections. Now we do multi-page writes and windows
> servers apparently reject large write calls on signed connections.
>
> One way to test this theory would be to set the wsize to something
> smaller when you mount. For instance:
>
>      wsize=16384
>
> ...assuming that doesn't go over the server's MaxBufferSize, then that
> should act as a workaround. Can you try that and let me know if it
> helps?


Yes, that seemed to fix it. I added wsize=16384 and mounted using 
debians 2.6.39-1-amd64 kernel.

I tried a recursive copy of 26MB from one directory tree to another on 
that mount. It completed in 24s with no error messages. 1MB/s is not 
much, but there may be 40 other users.

The server runs windows 2008r2, 64-bit.

Helge Hafting
