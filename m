Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0CYO1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:27:19 -0400
Received: from daytona.panasas.com ([67.152.220.89]:64607 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752649Ab0CYO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:27:17 -0400
Message-ID: <4BAB72C1.6090002@panasas.com>
Date: Thu, 25 Mar 2010 16:27:13 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <20100324185604.GT30031@ZenIV.linux.org.uk> <4BAB2F5A.30409@panasas.com> <20100325101231.GU30031@ZenIV.linux.org.uk> <20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com> <4BAB54B0.3080109@panasas.com> <20100325130610.GZ30031@ZenIV.linux.org.uk> <4BAB656E.8020204@panasas.com> <20100325133746.GA30031@ZenIV.linux.org.uk> <4BAB6911.5020009@panasas.com> <20100325140457.GB30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325140457.GB30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 14:27:16.0469 (UTC) FILETIME=[44DE4A50:01CACC27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2010 04:04 PM, Al Viro wrote:
> On Thu, Mar 25, 2010 at 03:45:53PM +0200, Boaz Harrosh wrote:
>>> Does open() of directory _without_ O_DIRECTORY work in e.g. vanilla 2.6.33?
>>> It certainly does for local filesystems and it does for NFSv3; does it work
>>> for NFSv4?
>>
>> In my tests. Every thing is the same safe the client with the above change.
>>
>> So I guess NFSv4 does something different when asked for directory lookup
>> as opposed to files lookup. I guess there is something added/removed to
>> the compound depending on that flag. But I wouldn't know, I am not familiar 
>> with this code. NFSv4 someone?
> 
> OK, what happens if you do the following:
> 
> mount the same fs from two clients
> on one client:
> mkdir /mnt/weird_name_69
> on another:
> echo 'main() {open("/mnt/weird_name_69", 0);}' >/tmp/a.c
> gcc /tmp/a.c
> strace ./a.out
> ls -l /mnt/weird_name_69
> strace ./a.out
> 
> Will the first strace show EISDIR and the second succeed?
> 
> From my reading of that code (2.6.33, before all that stuff got merged),
> we have different behaviour depending on which codepath do we hit.
> If we go through ->d_revalidate(), it sees that it's not S_ISREG() and
> doesn't try to play with atomic open.  If we go through ->lookup(), we
> tell the server to open it, and when it tells us to bugger off (it's a
> directory, NFSv4 doesn't support atomic open for those), -EISDIR is
> passed to caller.  Which leads to open() failing.
> 
> It definitely looks like a bug.  Masked by O_DIRECTORY in 2.6.33.  Bug
> in fs/namei.c patch has exposed that crap both for O_DIRECTORY and !O_DIRECTORY
> cases.
> 
> So immediate fix will need to be along the lines of "add LOOKUP_DIRECTORY
> even on the last step if we have *want_dir" (and I'd probably get rid of
> want_dir then and just abuse nd->flags), but there's a real NFS bug as
> well.

NFS bug, you mean by not being consistent when opening a directory from
cache or when having to fetch it for the first time? I guess...

But I still think it is a problem that the application, git in this case,
did an open(,O_DIRECTORY...) and because of code reuse some low-level did
not see that flag, relaying on the fact that in most systems they don't care.

The nd->flags things looks like the right thing to me. 

And about the NFS thing, let misbehaving applications byte there own bullets.
But a good app like git, does put an O_DIRECTORY on the directory open, and
therefore will receive consistent results, right?

Please push a fix, meanwhile I'm running with this one, but I will need it
in linux-next later.

Thanks for everything
Boaz

