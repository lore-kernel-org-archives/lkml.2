Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab2KNKLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:11:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23777 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161008Ab2KNKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:11:12 -0500
Message-ID: <50A36E2A.8040302@parallels.com>
Date: Wed, 14 Nov 2012 14:10:50 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into inotify_inode_mark
References: <20121112101440.665694060@openvz.org> <20121112101845.839702715@openvz.org> <20121112165540.2ec39f50.akpm@linux-foundation.org> <20121113072057.GC6511@moon> <20121112234001.009b2ae3.akpm@linux-foundation.org> <20121113080032.GF6511@moon> <20121113143808.8d198bfe.akpm@linux-foundation.org> <20121114064615.GB16685@moon>
In-Reply-To: <20121114064615.GB16685@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:46 AM, Cyrill Gorcunov wrote:
> On Tue, Nov 13, 2012 at 02:38:08PM -0800, Andrew Morton wrote:
>> On Tue, 13 Nov 2012 12:00:32 +0400
>> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>>
>>>> Dumb question: do we really need inotify_inode_mark.fhandle at all? 
>>>> What prevents us from assembling this info on demand when ->show_fdinfo() is
>>>> called?
>>>
>>> exportfs requires the dentry to be passed as an argument while inotify works
>>> with inodes instead and at moment of show-fdinfo the target dentry might be
>>> already deleted but inode yet present as far as I remember.
>>
>> How can the c/r restore code reestablish the inode data if the dentry
>> isn't there any more?
> 
> By "deleted" I meant deleted from dcache, thus when we call for
> open_by_handle_at with fhandle, the kernel reconstruct the path
> and we simply read the /proc/self/fd/ link, and then pass this
> path to inotify_add_watch.

No we don't do readlink as the path we'd see would be empty. Instead after
we called the open_by_handle_at, we pass the "/proc/self/fd/<fd>" _path_ itself
to inotify_add_watch. The path resolution code follows the link properly and
adds the target inode into the watch list.

> .
> 
