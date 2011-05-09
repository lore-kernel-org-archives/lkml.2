Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab1EINXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 09:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1EINXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 09:23:47 -0400
Message-ID: <4DC7EAD7.9070606@redhat.com>
Date: Mon, 09 May 2011 09:23:35 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] fs: kill default_llseek
References: <1304605677-1882-1-git-send-email-josef@redhat.com> <201105081623.39876.arnd@arndb.de>
In-Reply-To: <201105081623.39876.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2011 10:23 AM, Arnd Bergmann wrote:
> On Thursday 05 May 2011 16:27:57 Josef Bacik wrote:
>> Looking at this llseek stuff I noticed that default_llseek is the exact same as
>> generic_file_llseek, so kill default_llseek.  I patched this using spatch with
>> just a simple
>>
>> @@
>> @@
>>
>> - default_llseek
>> + generic_file_llseek
>>
>> and then I manually removed the default_llseek definitions.  I've built and
>> booted this and it works fine.  Thanks,
>>
>> Signed-off-by: Josef Bacik<josef@redhat.com>
>
> Good idea in principle, but you missed the fact that generic_file_llseek
> checks (offset>  inode->i_sb->s_maxbytes), which default_llseek
> does not.
>

Right, I didn't miss it, I probably should have said this in my commit, 
but anybody who gets a super gets it from sget, which does alloc_super, 
which automatically sets s_maxbytes to MAX_NON_LFS, which is ((1UL<<31) 
- 1), plenty of size.

> This makes a huge difference on file systems that do not initialize
> s_maxbytes, leaving it at zero. In particular, it doesn't work for
> character devices, IIRC they will use whatever s_maxbytes is set for
> the file system that stores the dentry and for debugfs and other
> virtual file systems, it is not set at all.
>
> The proper fix should be to make sure all file systems set an appropriate
> s_maxbytes, and then add a special case for character devices to
> generic_file_llseek. The main reason I didn't do it last year was to
> avoid possible regressions when missing some other special cases, but
> please continue to push this once you are sure to have a correct version
> of the patch.
>

So every sb has s_maxbytes set to something, is this not acceptable for 
character devices?  I guess some can let you seek well past this point 
so we should just do some if (S_ISCHR()) return or whatever?  Thanks,

Josef
