Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0CYLMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 07:12:41 -0400
Received: from daytona.panasas.com ([67.152.220.89]:8611 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753093Ab0CYLMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 07:12:39 -0400
Message-ID: <4BAB4523.1010601@panasas.com>
Date: Thu, 25 Mar 2010 13:12:35 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com> <20100324180622.GS30031@ZenIV.linux.org.uk> <4BAA5955.4000001@gmail.com> <20100324185604.GT30031@ZenIV.linux.org.uk> <4BAB2F5A.30409@panasas.com> <20100325101231.GU30031@ZenIV.linux.org.uk> <4BAB3967.6000702@panasas.com> <20100325104924.GV30031@ZenIV.linux.org.uk> <4BAB4168.2090404@panasas.com> <20100325110031.GX30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325110031.GX30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 11:12:38.0847 (UTC) FILETIME=[147694F0:01CACC0C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2010, 13:00 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Mar 25, 2010 at 12:56:40PM +0200, Benny Halevy wrote:
>> -		if (*want_dir && !path->dentry->d_inode->i_op->lookup)
>> +		if (*want_dir && !path->dentry->d_inode->i_op->lookup) {
>> +			WARN_ON(1);
>>  			goto exit_dput;
>> +		}
>>  		path_to_nameidata(path, nd);
>>  		audit_inode(pathname, nd->path.dentry);
>>  		goto ok;
>>
>> but it is NOT tripping for this scenario.
>>
>> (for some reason I saw it tripping when building the kernel over nfs
>> but it's benign)
> 
> It's ENOTDIR, not EISDIR, anyway.  Happens if you ask to open foo/ or
> foo with O_DIRECTORY when foo is not a directory.

Hmm, not according to my strace (or am I blind today? :)

> > open(".git/objects/pack", O_RDONLY|O_NONBLOCK|O_DIRECTORY|0x80000) = -1 EISDIR (Is a directory)

The odd thing is the app incorrectly gets EISDIR despite
the fact that it is opening a directory with O_DIRECTORY.
